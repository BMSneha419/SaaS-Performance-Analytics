WITH ChurnedAccounts AS (
    SELECT
        account_id
    FROM
        ravenstack_churn_events
),

AccountFeatures AS (
    SELECT
        s.account_id,
        fu.feature_name,
        SUM(fu.usage_count) AS total_usage
    FROM
        ravenstack_feature_usage_clean AS fu
    INNER JOIN
        ravenstack_subscriptions AS s
    ON
        fu.subscription_id = s.subscription_id
    GROUP BY
        s.account_id,
        fu.feature_name
),

FeatureUsageStatus AS (
    SELECT
        af.feature_name,
        af.total_usage,
        CASE
            WHEN ca.account_id IS NOT NULL THEN 'Churned'
            ELSE 'Active'
        END AS account_status
    FROM
        AccountFeatures AS af
    LEFT JOIN
        ChurnedAccounts AS ca
    ON
        af.account_id = ca.account_id
)

SELECT
    feature_name,
    account_status,
    COUNT(account_status) AS number_of_accounts,
    SUM(total_usage) AS total_feature_usage
FROM
    FeatureUsageStatus
GROUP BY
    feature_name,
    account_status
ORDER BY
    feature_name,
    account_status DESC;