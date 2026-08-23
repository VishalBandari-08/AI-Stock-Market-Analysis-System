from .market_data import stock, technical


def stock_analysis(symbol: str) -> dict:
    item = stock(symbol)
    indicators = technical(symbol)
    if not item:
        return {}
    positive = ["Positive momentum", "Price above 50-day average", "Improving sentiment"] if item["change"] >= 0 else ["Support level is nearby", "Valuation remains established"]
    risks = ["Increased volatility", "Resistance level nearby"] if item["risk"] != "Low" else ["Market-wide conditions can change quickly"]
    return {"symbol": item["symbol"], "overall_score": item["ai_score"], "market_view": "Moderately Bullish" if item["ai_score"] >= 70 else "Neutral", "risk_level": item["risk"], "confidence": min(94, item["ai_score"] + 6), "prediction": "Bullish" if item["change"] >= 0 else "Bearish", "probability": min(88, item["ai_score"] + 2), "important_factors": ["Momentum", "Volume", "RSI", "Market trend", "Sentiment"], "positive_factors": positive, "risk_factors": risks, "explanation": f"{item['name']} is showing a {item['momentum'].lower()} pattern. The price is { 'above' if item['change'] >= 0 else 'below' } its recent trend, while current volatility is {item['risk'].lower()}. This is educational analysis, not financial advice.", "technical": indicators}


def portfolio_analysis() -> dict:
    return {"health": 74, "diversification": 68, "risk": "Moderate", "volatility": "Medium", "sector_concentration": "High", "explanation": "Your demo portfolio is concentrated in technology stocks, so diversification is moderate and risk exposure is higher than a broadly diversified portfolio."}
