from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

from .services.analysis import portfolio_analysis, stock_analysis
from .services.market_data import DEMO_STOCKS, history, stock, technical

app = FastAPI(title="AI MarketLens API", version="0.1.0", description="Educational market analysis API. Demo data is clearly marked.")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])

class ChatRequest(BaseModel):
    message: str = Field(min_length=1, max_length=1000)
    context_symbol: str | None = None

class HoldingRequest(BaseModel):
    symbol: str
    quantity: float = Field(gt=0)
    buy_price: float = Field(gt=0)

@app.get("/health")
def health():
    return {"status": "ok", "mode": "demo"}

@app.post("/api/auth/login")
def login():
    return {"access_token": "demo-token", "token_type": "bearer", "demo": True}

@app.get("/api/market/overview")
def market_overview():
    indices = {"NIFTY 50": 0.74, "SENSEX": 0.61, "BANK NIFTY": 0.42, "NASDAQ": 1.05, "S&P 500": 0.68}
    return {"demo": True, "indices": [{"name": name, "value": 10000 + i * 137, "change": change, "trend": "up" if change >= 0 else "down"} for i, (name, change) in enumerate(indices.items())]}

@app.get("/api/stocks/search")
def search_stocks(q: str = Query(min_length=1)):
    query = q.lower()
    return {"demo": True, "results": [stock(symbol) for symbol, item in DEMO_STOCKS.items() if query in symbol.lower() or query in item["name"].lower()]}

@app.get("/api/stocks/{symbol}")
def get_stock(symbol: str):
    result = stock(symbol)
    if not result:
        raise HTTPException(404, "No stock found")
    return result

@app.get("/api/stocks/{symbol}/history")
def get_history(symbol: str):
    if not stock(symbol):
        raise HTTPException(404, "No stock found")
    return {"symbol": symbol.upper(), "demo": True, "history": history(symbol)}

@app.get("/api/stocks/{symbol}/technical")
def get_technical(symbol: str):
    if not stock(symbol):
        raise HTTPException(404, "No stock found")
    return technical(symbol)

@app.get("/api/stocks/{symbol}/ai-analysis")
def get_analysis(symbol: str):
    result = stock_analysis(symbol)
    if not result:
        raise HTTPException(404, "Unable to analyze stock")
    return {"demo": True, **result}

@app.get("/api/ai/portfolio-health")
def get_portfolio_health():
    return {"demo": True, **portfolio_analysis()}

@app.post("/api/ai/chat")
def chat(request: ChatRequest):
    symbol = request.context_symbol.upper() if request.context_symbol else "the selected market"
    return {"reply": f"For {symbol}, the current demo signals combine price momentum, technical indicators, sentiment, and risk. Review the supporting factors before making any decision. This is educational information, not financial advice.", "demo": True}

@app.get("/api/ai/daily-briefing")
def daily_briefing():
    return {"demo": True, "headline": "Markets are moderately positive today", "items": ["Technology is showing stronger momentum.", "Two watchlist stocks have meaningful technical changes.", "Review volatility before acting on any signal."]}

@app.get("/api/portfolio")
def portfolio():
    holdings = [{"symbol": "TCS", "quantity": 12, "buy_price": 3100, "current_price": 3420, "profit": 3840, "profit_percent": 10.32}, {"symbol": "NVDA", "quantity": 8, "buy_price": 112, "current_price": 128.9, "profit": 135.2, "profit_percent": 15.07}]
    return {"demo": True, "holdings": holdings, "invested": 46144, "current_value": 50119.2, "profit": 3975.2, "profit_percent": 8.62}

@app.get("/api/watchlist")
def watchlist():
    return {"demo": True, "stocks": [stock(symbol) for symbol in ["TCS", "RELIANCE", "NVDA", "AAPL", "TSLA"]]}
