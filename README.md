# Database layer

This directory contains the PostgreSQL schema and seed reference for AI MarketLens.

```powershell
docker compose up -d postgres
Get-Content database/schema.sql | docker compose exec -T postgres psql -U postgres -d marketlens
Get-Content database/seed.sql | docker compose exec -T postgres psql -U postgres -d marketlens
```

The current backend is intentionally usable in `APP_ENV=demo` without PostgreSQL credentials. Demo market data is labeled and held by the market-data service. Before production, connect the user, watchlist, holdings, alerts, news, and analysis repositories to these tables using migrations and authenticated user IDs.
