WITH
  plan_values AS (
    SELECT
      *,
      CASE
        WHEN plan_tier = 'Free' THEN 1
        WHEN plan_tier = 'Basic' THEN 2
        WHEN plan_tier = 'Pro' THEN 3
        WHEN plan_tier = 'Enterprise' THEN 4
      END AS plan_value
    FROM
      ravenstack_subscriptions
  ),
  plan_changes AS (
    SELECT
      p.account_id,
      p.start_date,
      p.plan_value AS current_plan_value,
      LAG(p.plan_value, 1) OVER (
        PARTITION BY
          p.account_id
        ORDER BY
          p.start_date
      ) AS previous_plan_value,
      p.plan_tier AS current_plan,
      LAG(p.plan_tier, 1) OVER (
        PARTITION BY
          p.account_id
        ORDER BY
          p.start_date
      ) AS previous_plan,
      (
        CASE
          WHEN p.billing_frequency = 'monthly' THEN p.mrr_amount
          WHEN p.billing_frequency = 'annual' THEN p.arr_amount / 12
        END
      ) AS mrr_amount
    FROM
      plan_values p
      JOIN ravenstack_accounts a ON p.account_id = a.account_id
    WHERE
      p.is_trial = FALSE
      AND a.is_trial = FALSE
  )
SELECT
  previous_plan,
  current_plan,
  SUM(mrr_amount) AS total_contraction_mrr
FROM
  plan_changes
WHERE
  previous_plan_value IS NOT NULL
  AND current_plan_value < previous_plan_value
GROUP BY
  previous_plan,
  current_plan
ORDER BY
  total_contraction_mrr DESC;