SELECT
    reason_code,
    COUNT(churn_event_id) AS total_churn_events
FROM
    ravenstack_churn_events
GROUP BY
    reason_code
ORDER BY
    total_churn_events DESC;