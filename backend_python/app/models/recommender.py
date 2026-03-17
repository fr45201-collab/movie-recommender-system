import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

# 🔥 Load dataset
df = pd.read_csv("app/data/movies.csv")

df = df.drop_duplicates(subset='title').reset_index(drop=True)



# 🔥 Clean data
df['title'] = df['title'].fillna("")
df['overview'] = df['overview'].fillna("")

# ✅ Combine
df['combined'] = df['title'] + " " + df['overview']

# ✅ CREATE TFIDF FIRST
tfidf = TfidfVectorizer(stop_words='english')

# ✅ THEN transform
matrix = tfidf.fit_transform(df['combined'])

# 🔥 Similarity matrix
cosine_sim = cosine_similarity(matrix, matrix)

# 🔥 Reset index
df = df.reset_index(drop=True)


# 🔥 SMART SEARCH
def find_movie_index(query):
    query = query.lower()

    for i, title in enumerate(df['title']):
        if query in title.lower():
            return i

    return None


# 🔥 MAIN FUNCTION
def get_recommendations(movie_name):
    idx = find_movie_index(movie_name)

    if idx is None:
        return []

    # ✅ ADD THIS BACK
    scores = list(enumerate(cosine_sim[idx]))

    # ✅ SORT
    scores = sorted(scores, key=lambda x: x[1], reverse=True)

    # ✅ REMOVE FIRST (same movie)
    scores = scores[1:]

    # ✅ UNIQUE FILTER
    seen = set()
    movie_indices = []

    for i, score in scores:
        title = df.iloc[i]['title']

        if title not in seen:
            seen.add(title)
            movie_indices.append(i)

        if len(movie_indices) == 5:
            break

    result = df.iloc[movie_indices][['title']].to_dict(orient='records')

    return result