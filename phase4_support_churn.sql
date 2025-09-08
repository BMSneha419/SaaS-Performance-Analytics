WITH ChurnedAccounts AS (
    SELECT
        account_id
    FROM
        ravenstack_churn_events
),

AccountSupportTickets AS (
    SELECT
        st.account_id,
        st.ticket_id,
        st.satisfaction_score,
        fu.feature_name
    FROM
        ravenstack_support_tickets AS st
    INNER JOIN
        ravenstack_feature_usage_clean AS fu
    ON
        st.account_id = (SELECT s.account_id FROM ravenstack_subscriptions AS s WHERE s.subscription_id = fu.subscription_id)
),

TicketAnalysis AS (
    SELECT
        ast.feature_name,
        CASE
            WHEN ca.account_id IS NOT NULL THEN 'Churned'
            ELSE 'Active'
        END AS account_status,
        COUNT(ast.ticket_id) AS number_of_tickets,
        AVG(ast.satisfaction_score) AS avg_satisfaction_score
    FROM
        AccountSupportTickets AS ast
    LEFT JOIN
        ChurnedAccounts AS ca
    ON
        ast.account_id = ca.account_id
    GROUP BY
        ast.feature_name,
        account_status
)

SELECT
    *
FROM
    TicketAnalysis
ORDER BY
    feature_name,
    account_status DESC;