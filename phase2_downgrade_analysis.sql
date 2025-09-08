SELECT
    s1.plan_tier AS old_plan,
    s2.plan_tier AS new_plan,
    COUNT(s2.subscription_id) AS number_of_downgrades,
    SUM(s1.mrr_amount - s2.mrr_amount) AS lost_mrr
FROM
    ravenstack_subscriptions AS s1
JOIN
    ravenstack_subscriptions AS s2
ON
    s1.account_id = s2.account_id
WHERE
    s1.start_date < s2.start_date
    AND s1.plan_tier != s2.plan_tier
    AND s1.mrr_amount > s2.mrr_amount
GROUP BY
    s1.plan_tier,
    s2.plan_tier
ORDER BY
    lost_mrr DESC;