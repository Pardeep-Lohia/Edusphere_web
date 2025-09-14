# import os
# import json
# import google.generativeai as genai
# from dotenv import load_dotenv
# from flask import Flask, jsonify, request
# from flask_cors import CORS

# # Load environment variables
# load_dotenv()

# # Get API key from .env file
# api_key = os.getenv("GOOGLE_API_KEY", "AIzaSyCX5dXv2A8cuUn11G5GZEDM50yw_xiEZR0")

# if not api_key:
#     raise ValueError("API Key not found. Set GOOGLE_API_KEY in .env file")

# # Configure the API
# genai.configure(api_key=api_key)

# # Initialize Flask App
# app = Flask(__name__)
# CORS(app)

# # Initialize AI Model for Chatbot
# model = genai.GenerativeModel(
#     model_name="gemini-1.5-pro",
#     system_instruction="You are a helpful AI chatbot that assists users with various queries."
# )

# @app.route('/chatbot', methods=['POST'])
# def chatbot():
#     data = request.json
#     user_message = data.get("message", "")

#     if not user_message:
#         return jsonify({"error": "Message is required"}), 400

#     print(f"User: {user_message}")

#     # Generate AI Response
#     response = model.generate_content(user_message)
#     response_text = response.text.strip() if response and response.text else "I'm not sure how to respond."

#     print(f"Bot: {response_text}")
    
#     return jsonify({"bot_response": response_text})

# if __name__ == '__main__':
#     app.run(debug=True)
from flask import Flask, request, jsonify
import google.generativeai as genai
import pyttsx3
import os
from youtube_transcript_api import YouTubeTranscriptApi
from dotenv import load_dotenv
from flask_cors import CORS

# Load API Key from .env file
load_dotenv()
api_key = os.getenv("GOOGLE_API_KEY")
if not api_key:
    raise ValueError("API Key not found. Set GOOGLE_API_KEY in .env file")


# Configure Gemini AI
genai.configure(api_key=api_key)
model = genai.GenerativeModel("gemini-1.5-flash")

# Initialize Flask App
app = Flask(__name__)
CORS(app)

# Initialize text-to-speech
engine = pyttsx3.init()

def chatbot_response(user_input):
    """Handles AI response using Gemini API"""
    response = model.generate_content(user_input)
    return response.text.strip()

import re

def extract_video_id(video_url):
    """Extracts the video ID from a YouTube URL."""
    pattern = r"(?:v=|\/embed\/|\/\d\/|\/vi\/|\/v\/|youtu\.be\/|\/e\/|watch\?v=|&v=|^youtu\.be\/|watch\?.*?&v=)([^#\&\?]*)"
    match = re.search(pattern, video_url)
    return match.group(1) if match else None

from youtube_transcript_api import YouTubeTranscriptApi

def get_transcript(video_id, language="en"):
    """Fetches transcript for a given video ID in the specified language."""
    try:
        # Get available transcripts
        transcript_list = YouTubeTranscriptApi.list_transcripts(video_id)
        
        # Try fetching English transcript
        try:
            transcript = transcript_list.find_transcript([language])
        except:
            # If English is not available, get any available transcript
            transcript = transcript_list.find_generated_transcript(transcript_list._manually_created_transcripts + transcript_list._generated_transcripts)
        
        # Translate to English if needed
        if transcript.language_code != "en":
            transcript = transcript.translate("en")
        
        return " ".join([t["text"] for t in transcript.fetch()])
    
    except Exception as e:
        return f"Error fetching transcript: {str(e)}"

def summarize_youtube(video_url):
    """Extract transcript and generate summary."""
    try:
        video_id = extract_video_id(video_url)
        if not video_id:
            return "Error: Invalid YouTube URL"

        transcript_text = get_transcript(video_id)
        if "Error" in transcript_text:
            return transcript_text  # Return error message if transcript fetch fails

        summary_prompt = f"Summarize this YouTube transcript: {transcript_text}"
        summary = chatbot_response(summary_prompt)
        return summary

    except Exception as e:
        return f"Error fetching summary: {str(e)}"

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

@app.route("/speak", methods=["POST"])
def speak():
    data = request.get_json()
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text is required"}), 400
    engine.say(text)
    engine.runAndWait()
    return jsonify({"message": "Speech synthesis completed"})

if __name__ == "__main__":
    app.run(debug=True)
