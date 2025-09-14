import os
import json
import google.generativeai as genai
from dotenv import load_dotenv
from flask import Flask, jsonify, request
import re
from flask_cors import CORS

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

# Initialize AI Model
model = genai.GenerativeModel(
    model_name="gemini-1.5-flash",
    system_instruction="You're a Roadmap generator for Tools, Technology, and Programming languages."
)

ROADMAP_FILE = "roadmap_output.json"


def generate_roadmap_for_days(topic, start_day, end_day):
    """
    Generates a roadmap covering a specific range of days.
    """
    prompt_message = f"""
    Generate a learning roadmap for "{topic}" covering days {start_day} to {end_day}.
    Divide the learning evenly across these days.
    Each day must have a structured learning task and quiz question.
    Return only valid JSON output.
    
    Example JSON format:
    {{
        "progress": [
            {{
                "day": {start_day},
                "task": "Detailed learning topic for {start_day}...",
                "quiz": [
                    {{
                        "question": "Sample question?",
                        "options": ["A", "B", "C", "D"],
                        "answer": "A"
                    }}
                ],
                "completed": false
            }}
        ]
    }}
    """

    print(f"\nGenerating Roadmap for Days {start_day} to {end_day}...\n")
    response = model.generate_content(prompt_message)
    response_text = response.text

    try:
        # Extract JSON using regex
        json_match = re.search(r"\{.*\}", response_text, re.DOTALL)
        if json_match:
            json_string = json_match.group(0)
            return json.loads(json_string).get("progress", [])
        else:
            print("No JSON found in AI response.")
            print(f"AI Response: {response_text}")
            return []
    except json.JSONDecodeError as e:
        print(f"JSON Decode Error: {e}")
        print(f"AI Response: {response_text}")
        return []


@app.route('/generate_roadmap', methods=['POST'])
def generate_roadmap():
    data = request.json
    topic = data.get("topic")
    duration = data.get("duration", 30)  # Default to 30 days if not specified

    if not topic:
        return jsonify({"error": "Topic is required"}), 400

    roadmap = []
    chunk_size = 10  # Generate in chunks of 10 days to ensure full coverage

    for start_day in range(1, duration + 1, chunk_size):
        end_day = min(start_day + chunk_size - 1, duration)
        roadmap.extend(generate_roadmap_for_days(topic, start_day, end_day))

    # Ensure we have a full roadmap of required duration
    if len(roadmap) < duration:
        additional_days_needed = duration - len(roadmap)
        roadmap.extend(generate_roadmap_for_days(topic, len(roadmap) + 1, len(roadmap) + additional_days_needed))

    # Save roadmap to a file
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

        # Find the day and update completion status
        for item in roadmap_data["progress"]:
            if item["day"] == day:
                item["completed"] = True
                break
        else:
            return jsonify({"error": "Day not found in roadmap"}), 404

        # Save the updated roadmap
        with open(ROADMAP_FILE, "w", encoding="utf-8") as file:
            json.dump(roadmap_data, file, indent=4)

        return jsonify({"message": f"Progress updated for Day {day}"}), 200

    except FileNotFoundError:
        return jsonify({"error": "No roadmap found. Generate one first!"}), 404
    except json.JSONDecodeError:
        return jsonify({"error": "Corrupted roadmap file"}), 500


if __name__ == '__main__':
    app.run(debug=True,port=3000)
