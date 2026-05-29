#模块2用户行为分析
-- 2.1 每个用户买了多少游戏
SELECT user_id,
       COUNT(*) AS games_purchased
FROM steam_behavior
WHERE behavior = 'purchase'
GROUP BY user_id
ORDER BY games_purchased DESC;

-- 2.2 用户购买数量分布
SELECT 
    CASE 
        WHEN games_purchased = 1 THEN '1个'
        WHEN games_purchased BETWEEN 2 AND 5 THEN '2-5个'
        WHEN games_purchased BETWEEN 6 AND 20 THEN '6-20个'
        ELSE '20个以上'
    END AS purchase_range,
    COUNT(*) AS user_count
FROM (
    SELECT user_id, COUNT(*) AS games_purchased
    FROM steam_behavior
    WHERE behavior = 'purchase'
    GROUP BY user_id
) t
GROUP BY purchase_range;

-- 2.3 用窗口函数找每个用户最爱玩的游戏
SELECT user_id, game_title, playtime
FROM (
    SELECT user_id,
           game_title,
           value AS playtime,
           RANK() OVER (PARTITION BY user_id ORDER BY value DESC) AS rnk
    FROM steam_behavior
    WHERE behavior = 'play' AND value > 0
) ranked
WHERE rnk = 1
LIMIT 20;