SELECT
    DATE_TRUNC('month', start_date) AS mrr_month,
    SUM(
        CASE
            WHEN billing_frequency = 'monthly' THEN mrr_amount
            WHEN billing_frequency = 'annual' THEN arr_amount / 12
        END
    ) AS total_mrr
FROM
    ravenstack_subscriptions s
JOIN
    ravenstack_accounts a ON s.account_id = a.account_id
WHERE
    s.is_trial = FALSE
    AND a.is_trial = FALSE
GROUP BY
    mrr_month
ORDER BY
    mrr_month;