#模块三用户分层
-- 3.1 按总游戏时长分层
SELECT user_id,
       ROUND(SUM(value), 1) AS total_playtime,
       CASE
           WHEN SUM(value) = 0 THEN '僵尸用户'
           WHEN SUM(value) < 10 THEN '轻度用户'
           WHEN SUM(value) < 100 THEN '中度用户'
           WHEN SUM(value) < 500 THEN '重度用户'
           ELSE '超级用户'
       END AS user_segment
FROM steam_behavior
WHERE behavior = 'play'
GROUP BY user_id;

-- 3.2 各层用户占比 + 平均购买数
SELECT s.user_segment,
       COUNT(*) AS user_count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct,
       ROUND(AVG(p.games_purchased), 1) AS avg_games_purchased
FROM (
    SELECT user_id,
           CASE
               WHEN SUM(value) = 0 THEN '僵尸用户'
               WHEN SUM(value) < 10 THEN '轻度用户'
               WHEN SUM(value) < 100 THEN '中度用户'
               WHEN SUM(value) < 500 THEN '重度用户'
               ELSE '超级用户'
           END AS user_segment
    FROM steam_behavior
    WHERE behavior = 'play'
    GROUP BY user_id
) s
JOIN (
    SELECT user_id, COUNT(*) AS games_purchased
    FROM steam_behavior
    WHERE behavior = 'purchase'
    GROUP BY user_id
) p ON s.user_id = p.user_id
GROUP BY s.user_segment;