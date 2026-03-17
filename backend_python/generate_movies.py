import csv
import random

titles = [
    # Marvel / DC
    "Avengers", "Iron Man", "Thor", "Hulk", "Doctor Strange",
    "Spider-Man", "Black Panther", "Captain America", "Guardians Galaxy",
    "Batman", "The Dark Knight", "Joker", "Superman", "Flash",

    # Popular Movies
    "Interstellar", "Inception", "Titanic", "Gladiator", "Matrix",
    "John Wick", "Mission Impossible", "Fast Furious", "Mad Max",

    # Animation
    "Frozen", "Toy Story", "Shrek", "Cars", "Up", "Coco", "Moana",
    "Inside Out", "Kung Fu Panda", "Finding Nemo",

    # Horror
    "Conjuring", "Insidious", "Annabelle", "It", "The Nun",
    "Hereditary", "Smile", "The Ring", "Paranormal Activity",

    # Anime
    "Naruto", "One Piece", "Attack on Titan", "Death Note",
    "Demon Slayer", "Jujutsu Kaisen", "Your Name", "Spirited Away",

    # Random Popular
    "Harry Potter", "Lord of the Rings", "Twilight",
    "Hunger Games", "Dune", "Avatar"
]

genres = [
    "action", "romance", "thriller", "horror", "mystery",
    "animation", "comedy", "adventure", "fantasy", "sci-fi"
]

descriptions = [
    "A mind-bending journey",
    "A thrilling adventure",
    "A dark and mysterious story",
    "A heartwarming tale",
    "A terrifying horror experience",
    "An emotional journey",
    "A futuristic sci-fi mission",
    "A heroic battle to save the world",
    "A legendary saga unfolds",
    "A story of love and sacrifice"
]


def generate_movies(n=1500):
    movies = []

    for i in range(n):
        # ✅ FIXED ORDER
        title = random.choice(titles) + f" ({random.randint(2000, 2024)})"

        genre = random.choice(genres)

        overview = f"{random.choice(descriptions)}. A {genre} movie released in {random.randint(2000, 2024)}."

        rating = round(random.uniform(6.0, 9.8), 1)

        poster = f"https://picsum.photos/300/450?random={i}"

        movies.append([title, overview, poster, rating])

    return movies


if __name__ == "__main__":
    movies = generate_movies(1500)

    with open("app/data/movies.csv", "w", newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(["title", "overview", "poster", "rating"])
        writer.writerows(movies)

    print("🔥 movies.csv with 1500 movies generated!")