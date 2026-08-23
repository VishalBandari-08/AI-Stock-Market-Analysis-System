from datetime import datetime, timezone

DEMO_STOCKS = {
    "TCS": {"name": "Tata Consultancy Services", "market": "India", "sector": "IT", "price": 3420.0, "change": 1.42, "ai_score": 78, "risk": "Medium", "sentiment": "Positive", "momentum": "Strong", "pe": 28.4, "roe": 46.2},
    "INFY": {"name": "Infosys Limited", "market": "India", "sector": "IT", "price": 1812.0, "change": 0.84, "ai_score": 74, "risk": "Medium", "sentiment": "Positive", "momentum": "Positive", "pe": 25.1, "roe": 31.8},
    "RELIANCE": {"name": "Reliance Industries", "market": "India", "sector": "Energy", "price": 2988.5, "change": -0.38, "ai_score": 69, "risk": "Medium", "sentiment": "Neutral", "momentum": "Stable", "pe": 24.8, "roe": 9.7},
    "HDFCBANK": {"name": "HDFC Bank", "market": "India", "sector": "Banking", "price": 1680.2, "change": 0.62, "ai_score": 76, "risk": "Low", "sentiment": "Positive", "momentum": "Positive", "pe": 19.3, "roe": 16.1},
    "AAPL": {"name": "Apple Inc.", "market": "US", "sector": "Technology", "price": 227.4, "change": 0.91, "ai_score": 82, "risk": "Medium", "sentiment": "Positive", "momentum": "Strong", "pe": 35.2, "roe": 157.4},
    "MSFT": {"name": "Microsoft Corp.", "market": "US", "sector": "Technology", "price": 421.6, "change": 1.12, "ai_score": 85, "risk": "Low", "sentiment": "Positive", "momentum": "Strong", "pe": 34.1, "roe": 35.8},
    "NVDA": {"name": "NVIDIA Corporation", "market": "US", "sector": "Technology", "price": 128.9, "change": -1.24, "ai_score": 79, "risk": "High", "sentiment": "Positive", "momentum": "Strong", "pe": 49.8, "roe": 119.5},
    "TSLA": {"name": "Tesla Inc.", "market": "US", "sector": "Automobile", "price": 342.1, "change": -2.15, "ai_score": 61, "risk": "High", "sentiment": "Neutral", "momentum": "Weak", "pe": 92.3, "roe": 20.4},
}


def stock(symbol: str) -> dict | None:
    item = DEMO_STOCKS.get(symbol.upper())
    if not item:
        return None
    return {"symbol": symbol.upper(), **item, "demo": True, "last_updated": datetime.now(timezone.utc).isoformat()}


def history(symbol: str) -> list[dict]:
    item = stock(symbol)
    if not item:
        return []
    base = item["price"]
    offsets = [-4.2, -2.5, -3.1, 0.6, 1.8, 0.9, 2.7, 1.4, 3.2, 2.1, 4.0, 5.4]
    return [{"label": f"D{i + 1}", "price": round(base * (1 + offset / 100), 2), "volume": 100 + i * 7} for i, offset in enumerate(offsets)]


def technical(symbol: str) -> dict:
    item = stock(symbol)
    if not item:
        return {}
    score = item["ai_score"]
    return {"rsi": 62 if item["change"] >= 0 else 43, "macd": "Bullish" if item["change"] >= 0 else "Bearish", "sma_50": "Above", "ema_200": "Above", "volatility": item["risk"], "support": round(item["price"] * 0.94, 2), "resistance": round(item["price"] * 1.06, 2), "score": score, "breakdown": {"trend": min(99, score + 4), "momentum": max(0, score - 2), "volume": max(0, score - 7), "volatility": max(0, score - 10)}}
