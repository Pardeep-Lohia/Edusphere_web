from flask import Flask, request, jsonify
from flask_cors import CORS
import firebase_admin
from firebase_admin import credentials, firestore
import uuid

# Initialize Firebase
cred = credentials.Certificate("C:\\Users\\parde\\Downloads\\learnsphere-9987f-firebase-adminsdk-fbsvc-ce44c5fe65.json")  
firebase_admin.initialize_app(cred)

db = firestore.client()

app = Flask(__name__)
CORS(app)  # Allow cross-origin requests

BASE_URL = "http://127.0.0.1:5500"  # Change for production deployment

# ✅ Create a new community
@app.route('/create_community', methods=['POST'])
def create_community():
    data = request.json
    name = data.get("name")
    description = data.get("description")
    creator = data.get("creator")

    if not name or not description or not creator:
        return jsonify({"error": "Missing required fields"}), 400

    community_id = str(uuid.uuid4())  # Generate unique community ID
    community_data = {
        "community_id": community_id,
        "name": name,
        "description": description,
        "creator": creator,
        "members": [creator]  # Creator is the first member
    }
    db.collection("communities").document(community_id).set(community_data)

    return jsonify({"message": "Community created successfully!", "community_id": community_id})

# ✅ Generate an invite link for a community
@app.route('/generate_invite_link/<community_id>', methods=['GET'])
def generate_invite_link(community_id):
    community_ref = db.collection("communities").document(community_id)
    community = community_ref.get()

    if community.exists:
        invite_link = f"{BASE_URL}/join_community/{community_id}"
        return jsonify({"invite_link": invite_link})
    
    return jsonify({"error": "Community not found!"}), 404

# ✅ Join a community using community_id
@app.route('/join_community', methods=['POST'])
def join_community():
    data = request.json
    community_id = data.get("community_id")
    user_id = data.get("user_id")

    if not community_id or not user_id:
        return jsonify({"error": "Missing required fields"}), 400

    community_ref = db.collection("communities").document(community_id)
    community = community_ref.get()

    if community.exists:
        members = community.to_dict().get("members", [])
        if user_id not in members:
            members.append(user_id)
            community_ref.update({"members": members})
            return jsonify({"message": "User added to community!"})
        return jsonify({"message": "User already in community!"}), 400
    
    return jsonify({"error": "Community not found!"}), 404

# ✅ Get all communities a user is a part of
@app.route('/user_communities/<user_id>', methods=['GET'])
def user_communities(user_id):
    communities = db.collection("communities").where("members", "array_contains", user_id).stream()
    community_list = [{"community_id": c.id, **c.to_dict()} for c in communities]
    
    if community_list:
        return jsonify(community_list)
    return jsonify({"message": "User is not part of any community"}), 404

# ✅ Get community details
@app.route('/community/<community_id>', methods=['GET'])
def get_community(community_id):
    community = db.collection("communities").document(community_id).get()
    
    if community.exists:
        return jsonify(community.to_dict())
    
    return jsonify({"error": "Community not found!"}), 404

if __name__ == '__main__':
    app.run(debug=True,port=5500)
