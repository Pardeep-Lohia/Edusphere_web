from flask import Flask, request, jsonify, Blueprint
import google.generativeai as genai
import pyttsx3
import os
import json
import re
from youtube_transcript_api import YouTubeTranscriptApi
from dotenv import load_dotenv
from flask_cors import CORS
from pymongo import MongoClient
import firebase_admin
from firebase_admin import credentials, auth

from flutter_application_1.lib.Backend.RoadmapGenerator import generate_roadmap_for_days

# Load environment variables
load_dotenv()

# Get API key from .env file
api_key = os.getenv("GOOGLE_API_KEY")
if not api_key:
    raise ValueError("API Key not found. Set GOOGLE_API_KEY in .env file")

# Configure the API
genai.configure(api_key=api_key)

# Initialize Flask App
app = Flask(__name__)
CORS(app)

# Initialize Firebase Admin SDK
cred = credentials.Certificate("C:\\Users\\parde\\Downloads\\learnsphere-9987f-firebase-adminsdk-fbsvc-ce44c5fe65.json")
firebase_admin.initialize_app(cred)

# MongoDB Connection
client = MongoClient("mongodb://localhost:27017/")
db = client["EduHaven"]
user_collection = db["users"]  # Collection for user data

# Initialize AI Model
model = genai.GenerativeModel("gemini-1.5-flash")

# Initialize text-to-speech
engine = pyttsx3.init()

# User API Endpoints
@app.route('/register', methods=['POST'])
def register():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({"error": "Email and password are required"}), 400

    try:
        user = auth.create_user(email=email, password=password)
        user_collection.insert_one({"uid": user.uid, "email": email})
        return jsonify({"message": "User registered successfully", "uid": user.uid}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({"error": "Email and password are required"}), 400

    try:
        user = auth.get_user_by_email(email)
        return jsonify({"message": "User logged in successfully", "uid": user.uid}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/user/<uid>', methods=['GET'])
def get_user(uid):
    user_data = user_collection.find_one({"uid": uid})
    if user_data:
        return jsonify(user_data), 200
    return jsonify({"error": "User not found"}), 404

@app.route('/user/<uid>', methods=['PUT'])
def update_user(uid):
    data = request.json
    user_collection.update_one({"uid": uid}, {"$set": data})
    return jsonify({"message": "User updated successfully"}), 200

@app.route('/user/<uid>', methods=['DELETE'])
def delete_user(uid):
    user_collection.delete_one({"uid": uid})
    return jsonify({"message": "User deleted successfully"}), 200

# Chatbot Functionality
def chatbot_response(user_input):
    response = model.generate_content(user_input)
    return response.text.strip()

@app.route("/chatbot", methods=["POST"])
def chatbot():
    data = request.get_json()
    user_message = data.get("message", "")
    if not user_message:
        return jsonify({"error": "Message is required"}), 400
    response = chatbot_response(user_message)
    return jsonify({"bot_response": response})

@app.route("/summarize", methods=["POST"])
def summarize():
    data = request.get_json()
    video_url = data.get("video_url", "")
    if not video_url:
        return jsonify({"error": "Video URL is required"}), 400
    summary = summarize_youtube(video_url)
    return jsonify({"summary": summary})

def extract_video_id(video_url):
    pattern = r"(?:v=|\/embed\/|\/\d\/|\/vi\/|\/v\/|youtu\.be\/|\/e\/|watch\?v=|&v=|^youtu\.be\/|watch\?.*?&v=)([^#\&\?]*)"
    match = re.search(pattern, video_url)
    return match.group(1) if match else None

def get_transcript(video_id, language="en"):
    try:
        transcript_list = YouTubeTranscriptApi.list_transcripts(video_id)
        transcript = transcript_list.find_transcript([language])
        return " ".join([t["text"] for t in transcript.fetch()])
    except Exception as e:
        return f"Error fetching transcript: {str(e)}"

def summarize_youtube(video_url):
    video_id = extract_video_id(video_url)
    transcript_text = get_transcript(video_id)
    summary_prompt = f"Summarize this YouTube transcript: {transcript_text}"
    summary = chatbot_response(summary_prompt)
    return summary

# Roadmap Generation Functionality
ROADMAP_FILE = "roadmap_output.json"

@app.route('/generate_roadmap', methods=['POST'])
def generate_roadmap():
    data = request.json
    topic = data.get("topic")
    duration = data.get("duration", 30)

    if not topic:
        return jsonify({"error": "Topic is required"}), 400

    roadmap = []
    chunk_size = 10

    for start_day in range(1, duration + 1, chunk_size):
        end_day = min(start_day + chunk_size - 1, duration)
        roadmap.extend(generate_roadmap_for_days(topic, start_day, end_day))

    roadmap_data = {
        "topic": topic,
        "duration": duration,
        "progress": roadmap
    }
    
    with open(ROADMAP_FILE, "w", encoding="utf-8") as file:
        json.dump(roadmap_data, file, indent=4)

    return jsonify(roadmap_data)

@app.route('/get_roadmap', methods=['GET'])
def get_roadmap():
    try:
        with open(ROADMAP_FILE, "r", encoding="utf-8") as file:
            roadmap_data = json.load(file)
        return jsonify(roadmap_data)
    except FileNotFoundError:
        return jsonify({"error": "No roadmap found. Generate one first!"}), 404

@app.route('/update_progress', methods=['POST'])
def update_progress():
    data = request.json
    day = data.get("day")

    if day is None:
        return jsonify({"error": "Day parameter is required"}), 400

    try:
        with open(ROADMAP_FILE, "r", encoding="utf-8") as file:
            roadmap_data = json.load(file)

        for item in roadmap_data["progress"]:
            if item["day"] == day:
                item["completed"] = True
                break
        else:
            return jsonify({"error": "Day not found in roadmap"}), 404

        with open(ROADMAP_FILE, "w", encoding="utf-8") as file:
            json.dump(roadmap_data, file, indent=4)

        return jsonify({"message": f"Progress updated for Day {day}"}), 200

    except FileNotFoundError:
        return jsonify({"error": "No roadmap found. Generate one first!"}), 404
    except json.JSONDecodeError:
        return jsonify({"error": "Corrupted roadmap file"}), 500

if __name__ == '__main__':
    app.run(debug=True, port=6000)
