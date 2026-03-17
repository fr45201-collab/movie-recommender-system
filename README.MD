🎬 Movie Recommender System

A full-stack Movie Recommender System built using Machine Learning (TF-IDF) and a Flutter-based frontend, designed with a modern Netflix-style UI.

---

🚀 Features

- 🔍 Smart movie search (case-insensitive & cleaned titles)
- 🤖 ML-based recommendations using TF-IDF + Cosine Similarity
- 🎥 Real movie posters & metadata
- 🧠 Content-based filtering system
- 🎨 Beautiful Netflix-style UI (Flutter)
  - Horizontal scrolling rows
  - Hero banner
  - Hover animations
- ⚡ Fast and lightweight backend (Python)

---

🏗️ Tech Stack

🔹 Backend

- Python
- Pandas
- Scikit-learn (TF-IDF, Cosine Similarity)
- FastAPI / Flask (API layer)

🔹 Frontend

- Flutter (Web / App UI)

🔹 Data

- CSV dataset (~1500+ movies)
- Cleaned titles & combined features (title + overview)

---

🧠 How It Works

1. Movie dataset is loaded and cleaned
2. Titles & overviews are combined into a single feature
3. TF-IDF vectorization converts text → numerical vectors
4. Cosine similarity finds similar movies
5. Top 5 unique recommendations are returned

---

📁 Project Structure

movie_recommender_system/
│
├── backend_python/
│   ├── app/
│   │   ├── data/
│   │   │   └── movies.csv
│   │   ├── models/
│   │   │   └── recommender.py
│   │   ├── services/
│   │   ├── api/
│   │   └── core/
│   ├── main.py
│   ├── generate_movies.py
│   └── .env
│
├── frontend_flutter/
│   ├── lib/
│   ├── web/
│   └── ...
│
├── .gitignore
├── README.md
└── requirements.txt

---

⚙️ Installation & Setup

1️⃣ Clone the repository

git clone https://github.com/YOUR_USERNAME/movie-recommender-system.git
cd movie-recommender-system

---

2️⃣ Backend Setup

cd backend_python
pip install -r ../requirements.txt
python main.py

---

3️⃣ Frontend Setup (Flutter)

cd frontend_flutter
flutter pub get
flutter run -d chrome

---

📸 Screenshots

«Add your UI screenshots here (recommended)»

---

🔐 Environment Variables

Create a ".env" file inside "backend_python/":

API_KEY=your_api_key_here

⚠️ ".env" is ignored using ".gitignore" for security.

---

✨ Future Improvements

- 🎯 User-based recommendations
- ⭐ Watchlist & favorites system
- 🌐 Deployment (Render / Vercel / Firebase)
- 🤖 AI chatbot for movie suggestions
- 📊 Advanced filtering (genre, year, rating)

---

🙌 Acknowledgements

- TMDB (for movie data inspiration)
- Scikit-learn documentation
- Flutter community

---

📌 Author

Faizan Raza
💡 Passionate about AI, ML & Full Stack Development

---

⭐ Show Your Support

If you like this project:

- ⭐ Star the repo
- 🍴 Fork it
- 🚀 Share it

---

«“Where Data Meets Entertainment 🎬”»