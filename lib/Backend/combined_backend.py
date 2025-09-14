# ===============================================
# Vercel-Ready Combined Flask App
# ===============================================

import os
import re
import json
import uuid
from flask import Flask, request, jsonify
from flask_cors import CORS
import google.generativeai as genai
from youtube_transcript_api import YouTubeTranscriptApi
import firebase_admin
from firebase_admin import credentials, auth, firestore

# ==================== ENVIRONMENT ====================
GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")
FIREBASE_JSON = os.getenv("FIREBASE_CRED")  # renamed for consistency
BASE_URL = os.getenv("BASE_URL", "https://edusphere-ruby-two.vercel.app")

if not GOOGLE_API_KEY:
    raise ValueError("Set GOOGLE_API_KEY in Vercel environment variables")
if not FIREBASE_JSON:
    raise ValueError("Set FIREBASE_CRED in Vercel environment variables")

# ==================== CONFIGURE AI ====================
genai.configure(api_key=GOOGLE_API_KEY)
ai_model = genai.GenerativeModel("gemini-1.5-flash")

# ==================== FLASK APP ====================
app = Flask(__name__)
CORS(app)

# ==================== FIREBASE ====================
if not firebase_admin._apps:
    # Ensure private_key newlines are fixed
    cred_dict = json.loads(FIREBASE_JSON)
    cred_dict["private_key"] = cred_dict["private_key"].replace("\\n", "\n")
    cred = credentials.Certificate(cred_dict)
    firebase_admin.initialize_app(cred)

db = firestore.client()



# ===============================================
# Healthcheck Route
# ===============================================
@app.route("/", methods=["GET"])
def health():
    return jsonify({"status": "ok"})

# ===============================================
# 1️⃣ Chatbot / YouTube Summarizer
# ===============================================
def chatbot_response(user_input):
    response = ai_model.generate_content(user_input)
    return response.text.strip()

def extract_video_id(video_url):
    pattern = r"(?:v=|\/embed\/|\/\d\/|\/vi\/|\/v\/|youtu\.be\/|\/e\/|watch\?v=|&v=|^youtu\.be\/|watch\?.*?&v=)([^#\&\?]*)"
    match = re.search(pattern, video_url)
    return match.group(1) if match else None

def get_transcript(video_id, language="en"):
    try:
        transcript_list = YouTubeTranscriptApi.list_transcripts(video_id)
        try:
            transcript = transcript_list.find_transcript([language])
        except:
            transcript = transcript_list.find_generated_transcript(
                transcript_list._manually_created_transcripts + transcript_list._generated_transcripts
            )
        if transcript.language_code != "en":
            transcript = transcript.translate("en")
        return " ".join([t["text"] for t in transcript.fetch()])
    except Exception as e:
        return f"Error fetching transcript: {str(e)}"

def summarize_youtube(video_url):
    video_id = extract_video_id(video_url)
    if not video_id:
        return "Error: Invalid YouTube URL"
    transcript_text = get_transcript(video_id)
    if "Error" in transcript_text:
        return transcript_text
    return chatbot_response(f"Summarize this transcript: {transcript_text}")

@app.route("/chatbot", methods=["POST"])
def chatbot_api():
    data = request.get_json()
    message = data.get("message", "")
    if not message:
        return jsonify({"error": "Message is required"}), 400
    return jsonify({"bot_response": chatbot_response(message)})

@app.route("/summarize", methods=["POST"])
def summarize_api():
    data = request.get_json()
    video_url = data.get("video_url", "")
    if not video_url:
        return jsonify({"error": "Video URL is required"}), 400
    return jsonify({"summary": summarize_youtube(video_url)})
    
@app.route("/hey", methods=["GET"])
def hey_high():
    return jsonify({"message": "hello!"})

    

# ===============================================
# 2️⃣ AI Roadmap Generator (Firestore-based)
# ===============================================
def generate_roadmap_for_days(topic, start_day, end_day):
    prompt = f"Generate a learning roadmap for '{topic}' covering days {start_day} to {end_day} in JSON format."
    response = ai_model.generate_content(prompt)
    try:
        json_match = re.search(r"\{.*\}", response.text, re.DOTALL)
        if json_match:
            return json.loads(json_match.group(0)).get("progress", [])
    except:
        pass
    return []

@app.route("/generate_roadmap", methods=["POST"])
def generate_roadmap_api():
    data = request.get_json()
    topic = data.get("topic")
    duration = data.get("duration", 30)
    user_id = data.get("user_id")

    if not topic or not user_id:
        return jsonify({"error": "Topic and user_id are required"}), 400

    roadmap = []
    chunk_size = 10
    for start_day in range(1, duration + 1, chunk_size):
        end_day = min(start_day + chunk_size - 1, duration)
        roadmap.extend(generate_roadmap_for_days(topic, start_day, end_day))

    roadmap_doc = {
        "user_id": user_id,
        "topic": topic,
        "duration": duration,
        "progress": roadmap
    }
    db.collection("user_roadmaps").add(roadmap_doc)
    return jsonify(roadmap_doc)

@app.route("/get_roadmaps/<user_id>", methods=["GET"])
def get_user_roadmaps(user_id):
    roadmaps = db.collection("user_roadmaps").where("user_id", "==", user_id).stream()
    return jsonify([r.to_dict() for r in roadmaps])

# ===============================================
# 3️⃣ MCQ Generator
# ===============================================
def generate_mcq_gemini(topic, num_questions=5):
    prompt = f"""
    Generate {num_questions} multiple-choice questions on '{topic}'.
    Return strictly in valid JSON: {{ "questions": [{{"question": "", "options": ["A","B","C","D"], "answer": ""}}] }}
    """
    mcq_model = genai.GenerativeModel("gemini-1.5-flash")
    response = mcq_model.generate_content(prompt)
    try:
        json_string = re.search(r"\{.*\}", response.text, re.DOTALL).group(0)
        return json.loads(json_string).get("questions", [])
    except:
        return {"error": "Failed to parse MCQ"}

@app.route("/generate_mcq", methods=["POST"])
def generate_mcq_api():
    data = request.get_json()
    topic = data.get("topic", "general knowledge")
    num_questions = data.get("num_questions", 5)
    return jsonify({"topic": topic, "questions": generate_mcq_gemini(topic, num_questions)})

# ===============================================
# 4️⃣ Community Management
# ===============================================
@app.route('/create_community', methods=['POST'])
def create_community():
    data = request.get_json()
    name = data.get("name")
    description = data.get("description")
    creator = data.get("creator")
    if not name or not description or not creator:
        return jsonify({"error": "Missing required fields"}), 400

    community_id = str(uuid.uuid4())
    community_data = {
        "community_id": community_id,
        "name": name,
        "description": description,
        "creator": creator,
        "members": [creator]
    }
    db.collection("communities").document(community_id).set(community_data)
    return jsonify({"message": "Community created", "community_id": community_id})

@app.route('/generate_invite_link/<community_id>', methods=['GET'])
def generate_invite_link(community_id):
    community = db.collection("communities").document(community_id).get()
    if community.exists:
        invite_link = f"{BASE_URL}/join_community/{community_id}"
        return jsonify({"invite_link": invite_link})
    return jsonify({"error": "Community not found"}), 404

@app.route('/join_community', methods=['POST'])
def join_community():
    data = request.get_json()
    community_id = data.get("community_id")
    user_id = data.get("user_id")
    if not community_id or not user_id:
        return jsonify({"error": "Missing required fields"}), 400
    community = db.collection("communities").document(community_id).get()
    if community.exists:
        members = community.to_dict().get("members", [])
        if user_id not in members:
            members.append(user_id)
            db.collection("communities").document(community_id).update({"members": members})
            return jsonify({"message": "User added to community"})
        return jsonify({"message": "User already in community"}), 400
    return jsonify({"error": "Community not found"}), 404

@app.route('/user_communities/<user_id>', methods=['GET'])
def user_communities(user_id):
    communities = db.collection("communities").where("members", "array_contains", user_id).stream()
    community_list = [{"community_id": c.id, **c.to_dict()} for c in communities]
    if community_list:
        return jsonify(community_list)
    return jsonify({"message": "User is not part of any community"}), 404

@app.route('/community/<community_id>', methods=['GET'])
def get_community(community_id):
    community = db.collection("communities").document(community_id).get()
    if community.exists:
        return jsonify(community.to_dict())
    return jsonify({"error": "Community not found"}), 404

# ===============================================
# 5️⃣ User Auth
# ===============================================
@app.route("/signup", methods=["POST"])
def signup():
    data = request.get_json()
    email = data.get("email")
    password = data.get("password")
    if not email or not password:
        return jsonify({"error": "Email and password are required"}), 400
    try:
        user = auth.create_user(email=email, password=password)
        return jsonify({"uid": user.uid}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    email = data.get("email")
    password = data.get("password")
    if not email or not password:
        return jsonify({"error": "Email and password are required"}), 400
    try:
        user = auth.get_user_by_email(email)
        return jsonify({"uid": user.uid}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400

# ==================== SAMPLE ROUTE ====================
@app.route("/hey", methods=["GET"])
def hey():
    return jsonify({"message": "hey high"})

# ==================== VERCEL EXPORT ====================
# Important: expose "app" for Vercel
if __name__ == "__main__":
    app.run(debug=True)