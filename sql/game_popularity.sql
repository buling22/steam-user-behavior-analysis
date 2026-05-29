#模块一
-- 1.1 购买量Top20游戏
SELECT game_title,
       COUNT(*) AS purchase_count
FROM steam_behavior
WHERE behavior = 'purchase'
GROUP BY game_title
ORDER BY purchase_count DESC
LIMIT 20;

-- 1.2 总游戏时长Top20（真正受玩家喜爱的游戏）
SELECT game_title,
       ROUND(SUM(value), 0) AS total_playtime,
       ROUND(AVG(value), 1) AS avg_playtime
FROM steam_behavior
WHERE behavior = 'play'
GROUP BY game_title
ORDER BY total_playtime DESC
LIMIT 20;

-- 1.3 买了不玩的游戏（高购买低时长）
SELECT p.game_title,
       p.purchase_count,
       ROUND(COALESCE(pl.avg_playtime, 0), 1) AS avg_playtime,
       ROUND(COALESCE(pl.avg_playtime, 0) / p.purchase_count, 2) AS engagement_ratio
FROM (
    SELECT game_title, COUNT(*) AS purchase_count
    FROM steam_behavior WHERE behavior = 'purchase'
    GROUP BY game_title
) p
LEFT JOIN (
    SELECT game_title, AVG(value) AS avg_playtime
    FROM steam_behavior WHERE behavior = 'play'
    GROUP BY game_title
) pl ON p.game_title = pl.game_title
WHERE p.purchase_count >= 100
ORDER BY avg_playtime ASC
LIMIT 20;