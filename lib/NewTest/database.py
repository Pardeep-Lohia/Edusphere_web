from pymongo import MongoClient

# MongoDB connection
client = MongoClient("mongodb://localhost:27017/")  # Replace with your MongoDB connection string
db = client["recommendation_db"]  # Database name
collection = db["user_history"]  # Collection name

def store_user_history(user_id, query, content_type, link):
    # Insert user history into the MongoDB collection
    document = {
        "user_id": user_id,
        "query": query,
        "content_type": content_type,
        "link": link,
    }
    collection.insert_one(document)

def get_user_history(user_id):
    # Retrieve user history from MongoDB
    history = []
    cursor = collection.find({"user_id": user_id})
    for doc in cursor:
        history.append([doc["query"], doc["link"], doc["content_type"]])
    return history
