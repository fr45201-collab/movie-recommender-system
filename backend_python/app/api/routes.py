from fastapi import APIRouter
from app.services.ml_service import recommend_movies

router = APIRouter()

@router.get("/recommend")
def recommend(movie: str):
    return recommend_movies(movie)