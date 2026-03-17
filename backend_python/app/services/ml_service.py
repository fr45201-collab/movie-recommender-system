import requests
import os
import re
from dotenv import load_dotenv
from app.models.recommender import get_recommendations

# 🔥 Load env
load_dotenv()
OMDB_API_KEY = os.getenv("OMDB_API_KEY")


# 🔥 Clean title
def clean_title(title):
    title = re.sub(r"\(\d{4}\)", "", title)  # remove (2014)
    title = re.sub(r"\s+", " ", title)       # keep single spaces
    return title.strip()


# 🔥 Fetch from OMDb
def fetch_movie_details(title):
    try:
        print("🔥 Fetching:", title)
        url = "http://www.omdbapi.com/"
        params = {
            "apikey": OMDB_API_KEY,
            "t": clean_title(title)
        }

        res = requests.get(url, params=params)
        data = res.json()

        print("🔥 OMDb Response:a", data)

        if data.get("Response") == "True":
            poster = data.get("Poster")

            if poster == "N/A":
                poster = ""

            return {
                "title": data.get("Title"),
                "poster": poster,
                "overview": data.get("Plot"),
                "rating": float(data.get("imdbRating", 0)) if data.get("imdbRating") != "N/A" else 0
            }

        return None

    except Exception as e:
        print("Error:", e)
        return None


# 🔥 YOUR MERGE FUNCTION (clean & safe)
def merge_movie(m, details):
    return {
        "title": details.get("title") if details else m["title"],
        "poster": details.get("poster") if details and details.get("poster") else m.get("poster", ""),
        "overview": details.get("overview") if details and details.get("overview") else m.get("overview", ""),
        "rating": details.get("rating") if details and details.get("rating") is not None else m.get("rating", 0)
    }


# 🔥 MAIN FUNCTION
def recommend_movies(movie: str):
    results = get_recommendations(movie)

    enriched = []

    for m in results:
        details = fetch_movie_details(m["title"])

        # ✅ use merge function
        enriched.append(merge_movie(m, details))

    return enriched