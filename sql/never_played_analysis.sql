-- 购买了但从未游玩的用户比例
SELECT 
    total_buyers,
    actual_players,
    total_buyers - actual_players AS never_played,
    ROUND((total_buyers - actual_players) * 100.0 / total_buyers, 1) AS never_played_pct
FROM (
    SELECT 
        COUNT(DISTINCT CASE WHEN behavior = 'purchase' THEN user_id END) AS total_buyers,
        COUNT(DISTINCT CASE WHEN behavior = 'play' AND value > 0 THEN user_id END) AS actual_players
    FROM steam_behavior
) t;