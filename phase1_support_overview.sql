SELECT
    COUNT(ticket_id) AS total_tickets,
    AVG(resolution_time_hours) AS avg_resolution_time_hours,
    AVG(first_response_time_minutes) AS avg_first_response_time_minutes,
    SUM(CASE WHEN escalation_flag = TRUE THEN 1 ELSE 0 END) AS escalated_tickets_count
FROM
    ravenstack_support_tickets;