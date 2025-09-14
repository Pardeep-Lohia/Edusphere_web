from flask import Flask, request, jsonify
from flask_cors import CORS
import firebase_admin
from firebase_admin import credentials, auth, firestore

# Initialize Flask app
app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})



# Initialize Firebase Admin SDK
cred = credentials.Certificate("c:\\Users\\parde\\Downloads\\learnsphere-9987f-firebase-adminsdk-fbsvc-ce44c5fe65.json")  # Update with your service account key path
firebase_admin.initialize_app(cred)

# Firestore database reference
db = firestore.client()

# User Signup
@app.route("/signup", methods=["POST"])
def signup():
    data = request.json
    email = data.get("email")
    password = data.get("password")

    if not email or not password:
        return jsonify({"error": "Email and password are required"}), 400

    try:
        user = auth.create_user(email=email, password=password)
        return jsonify({"uid": user.uid}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

# User Login
@app.route("/login", methods=["POST"])
def login():
    data = request.json
    email = data.get("email")
    password = data.get("password")

    if not email or not password:
        return jsonify({"error": "Email and password are required"}), 400

    try:
        user = auth.get_user_by_email(email)
        # Here you would typically verify the password with your own logic
        return jsonify({"uid": user.uid}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400

# CRUD Operations for Roadmaps
@app.route("/roadmaps", methods=["POST"])
def add_roadmap():
    data = request.json
    user_id = data.get("user_id")
    roadmap_data = data.get("roadmap")

    if not user_id or not roadmap_data:
        return jsonify({"error": "User ID and roadmap data are required"}), 400

    db.collection("roadmaps").add({
        "user_id": user_id,
        "roadmap": roadmap_data
    })
    return jsonify({"message": "Roadmap added successfully"}), 201

@app.route("/roadmaps/<user_id>", methods=["GET"])
def get_roadmaps(user_id):
    roadmaps = db.collection("roadmaps").where("user_id", "==", user_id).stream()
    return jsonify([roadmap.to_dict() for roadmap in roadmaps]), 200

@app.route("/roadmaps/<roadmap_id>", methods=["PUT"])
def update_roadmap(roadmap_id):
    data = request.json
    roadmap_data = data.get("roadmap")

    if not roadmap_data:
        return jsonify({"error": "Roadmap data is required"}), 400

    db.collection("roadmaps").document(roadmap_id).update({
        "roadmap": roadmap_data
    })
    return jsonify({"message": "Roadmap updated successfully"}), 200

@app.route("/roadmaps/<roadmap_id>", methods=["DELETE"])
def delete_roadmap(roadmap_id):
    db.collection("roadmaps").document(roadmap_id).delete()
    return jsonify({"message": "Roadmap deleted successfully"}), 200

# Run Flask Server
if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=6000)

