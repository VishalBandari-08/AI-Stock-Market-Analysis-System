CREATE TABLE IF NOT EXISTS users (id UUID PRIMARY KEY, email TEXT UNIQUE NOT NULL, password_hash TEXT NOT NULL, full_name TEXT NOT NULL, created_at TIMESTAMPTZ DEFAULT now());
CREATE TABLE IF NOT EXISTS user_preferences (user_id UUID PRIMARY KEY REFERENCES users(id), risk_preference TEXT, experience TEXT, preferred_market TEXT, language TEXT DEFAULT 'en', mode TEXT DEFAULT 'beginner');
CREATE TABLE IF NOT EXISTS watchlists (id UUID PRIMARY KEY, user_id UUID REFERENCES users(id), name TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS watchlist_stocks (watchlist_id UUID REFERENCES watchlists(id), symbol TEXT NOT NULL, position INTEGER DEFAULT 0, PRIMARY KEY (watchlist_id, symbol));
CREATE TABLE IF NOT EXISTS portfolio_holdings (id UUID PRIMARY KEY, user_id UUID REFERENCES users(id), symbol TEXT NOT NULL, quantity NUMERIC NOT NULL, buy_price NUMERIC NOT NULL, purchase_date DATE NOT NULL);
CREATE TABLE IF NOT EXISTS alerts (id UUID PRIMARY KEY, user_id UUID REFERENCES users(id), symbol TEXT NOT NULL, alert_type TEXT NOT NULL, threshold NUMERIC, enabled BOOLEAN DEFAULT true);
