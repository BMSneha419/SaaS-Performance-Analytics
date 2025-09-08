SELECT
    s.plan_tier,
    COUNT(t.ticket_id) AS total_tickets,
    AVG(t.resolution_time_hours) AS avg_resolution_time_hours,
    AVG(t.first_response_time_minutes) AS avg_first_response_time_minutes,
    SUM(CASE WHEN t.escalation_flag = TRUE THEN 1 ELSE 0 END) AS escalated_tickets_count
FROM
    ravenstack_support_tickets t
JOIN
    ravenstack_subscriptions s ON t.account_id = s.account_id
GROUP BY
    s.plan_tier
ORDER BY
    total_tickets DESC;