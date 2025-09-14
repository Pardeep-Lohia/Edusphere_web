from flask import Flask, request, jsonify
import random
import requests
from bs4 import BeautifulSoup
from database import store_user_history, get_user_history

app = Flask(__name__)

import time

import time

def fetch_web_results(query):
    search_url = f"https://www.google.com/search?q={query.replace(' ', '+')}"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    }
    
    response = requests.get(search_url, headers=headers)
    soup = BeautifulSoup(response.text, "html.parser")

    web_results = []
    for link in soup.find_all("a"):
        href = link.get("href")
        if href and "/url?q=" in href:
            url = href.split("/url?q=")[1].split("&")[0]
            if url.startswith('http'):
                web_results.append(url)
    
    time.sleep(2)  # Add delay to avoid blocking
    return web_results[:5]

def fetch_youtube_results(query):
    search_url = f"https://www.youtube.com/results?search_query={query.replace(' ', '+')}"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    }
    
    response = requests.get(search_url, headers=headers)
    soup = BeautifulSoup(response.text, "html.parser")

    youtube_results = []
    for link in soup.find_all("a"):
        href = link.get("href")
        if href and href.startswith("/watch?v="):
            youtube_results.append(f"https://www.youtube.com{href}")

    time.sleep(2)  # Add delay to avoid blocking
    return youtube_results[:5]

def fetch_youtube_results(query):
    search_url = f"https://www.youtube.com/results?search_query={query.replace(' ', '+')}"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    }
    
    response = requests.get(search_url, headers=headers)
    soup = BeautifulSoup(response.text, "html.parser")

    youtube_results = []
    for link in soup.find_all("a"):
        href = link.get("href")
        if href and href.startswith("/watch?v="):
            youtube_results.append(f"https://www.youtube.com{href}")

    time.sleep(2)  # Add delay to avoid blocking
    return youtube_results[:5]

def get_recommendations(user_id, query):
    history = get_user_history(user_id)
    
    if len(history) >= 5:
        past_queries = [h[0] for h in history]
        similar_query = random.choice(past_queries)
        web_results = fetch_web_results(similar_query)[:3]
        youtube_results = fetch_youtube_results(similar_query)[:3]
    else:
        web_results = fetch_web_results(query)[:3]
        youtube_results = fetch_youtube_results(query)[:3]

    for link in web_results: 
        store_user_history(user_id, query, "website", link)
    
    for link in youtube_results:
        store_user_history(user_id, query, "video", link)

    return {"web_results": web_results, "youtube_results": youtube_results}

@app.route('/recommendations', methods=['GET'])
def recommendations():
    user_id = request.args.get('user_id')
    query = request.args.get('query')

    if not user_id or not query:
        return jsonify({"error": "Missing user_id or query parameter"}), 400

    results = get_recommendations(user_id, query)
    return jsonify(results)

if __name__ == "__main__":
    app.run(debug=True)
