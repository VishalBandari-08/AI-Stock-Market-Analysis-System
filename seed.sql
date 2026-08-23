-- Safe demo seed reference. Demo market prices are served by the backend adapter.
-- User-owned tables should be seeded only after creating a real user.

INSERT INTO user_preferences (user_id, risk_preference, experience, preferred_market, language, mode)
SELECT id, 'Moderate', 'Beginner', 'Both', 'en', 'beginner'
FROM users
WHERE email = 'demo@marketlens.local'
ON CONFLICT (user_id) DO NOTHING;
