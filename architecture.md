# AI MarketLens architecture

Flutter is the mobile client. FastAPI owns authentication, market-data adapters, indicator calculations, sentiment/ML orchestration, portfolio analysis, and AI explanations. PostgreSQL stores user-owned data; Redis is reserved for market and news cache.

The backend currently runs in explicit `demo` mode so the product can be presented without API credentials. Replace the in-memory market-data adapter with a provider implementation behind `services/market_data.py`; never move provider keys into Flutter.

All AI copy is framed as educational decision support. Scores and trend categories are signals, not recommendations or guarantees.
