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
        SUM(fu.usage_count) AS total_usage_count,
        SUM(fu.error_count) AS total_error_count
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

FeatureAnalysis AS (
    SELECT
        af.feature_name,
        CASE
            WHEN ca.account_id IS NOT NULL THEN 'Churned'
            ELSE 'Active'
        END AS account_status,
        COUNT(af.account_id) AS number_of_accounts,
        SUM(af.total_usage_count) AS total_feature_usage,
        SUM(af.total_error_count) AS total_feature_errors
    FROM
        AccountFeatures AS af
    LEFT JOIN
        ChurnedAccounts AS ca
    ON
        af.account_id = ca.account_id
    GROUP BY
        af.feature_name,
        account_status
)

SELECT
    feature_name,
    account_status,
    number_of_accounts,
    total_feature_usage,
    total_feature_errors,
    (CAST(total_feature_errors AS REAL) / total_feature_usage) AS error_rate
FROM
    FeatureAnalysis
ORDER BY
    feature_name,
    account_status DESC;