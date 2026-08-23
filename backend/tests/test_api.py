from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_health_and_demo_mode():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["mode"] == "demo"


def test_stock_analysis_contains_explainable_factors():
    response = client.get("/api/stocks/TCS/ai-analysis")
    body = response.json()
    assert response.status_code == 200
    assert body["demo"] is True
    assert body["overall_score"] == 78
    assert body["positive_factors"]
    assert body["risk_factors"]


def test_unknown_stock_is_not_found():
    assert client.get("/api/stocks/UNKNOWN").status_code == 404
