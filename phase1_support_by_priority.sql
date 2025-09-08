SELECT
  priority,
  COUNT(ticket_id) AS total_tickets
FROM ravenstack_support_tickets
GROUP BY
  priority
ORDER BY
  total_tickets DESC;