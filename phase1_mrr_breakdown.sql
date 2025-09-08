WITH
  monthly_metrics AS (
    SELECT
      DATE_TRUNC('month', start_date) AS mrr_month,
      s.account_id,
      s.plan_tier AS current_plan,
      LAG(s.plan_tier, 1) OVER (PARTITION BY s.account_id ORDER BY s.start_date) AS previous_plan,
      SUM(
        CASE
          WHEN billing_frequency = 'monthly' THEN mrr_amount
          WHEN billing_frequency = 'annual' THEN arr_amount / 12
        END
      ) AS total_mrr
    FROM
      ravenstack_subscriptions s
      JOIN ravenstack_accounts a ON s.account_id = a.account_id
    WHERE
      s.is_trial = FALSE
      AND a.is_trial = FALSE
    GROUP BY
      mrr_month,
      s.account_id,
      s.plan_tier,
      s.start_date
  ),
  churn_metrics AS (
    SELECT
      DATE_TRUNC('month', churn_date) AS churn_month,
      account_id,
      SUM(refund_amount_usd) AS churned_mrr
    FROM
      ravenstack_churn_events
    GROUP BY
      churn_month,
      account_id
  )
SELECT
  m.mrr_month,
  SUM(
    CASE
      WHEN m.previous_plan IS NULL THEN m.total_mrr
      ELSE 0
    END
  ) AS new_mrr,
  SUM(
    CASE
      WHEN m.previous_plan IS NOT NULL AND m.current_plan > m.previous_plan THEN m.total_mrr
      ELSE 0
    END
  ) AS expansion_mrr,
  SUM(
    CASE
      WHEN m.previous_plan IS NOT NULL AND m.current_plan < m.previous_plan THEN m.total_mrr
      ELSE 0
    END
  ) AS contraction_mrr,
  COALESCE(SUM(c.churned_mrr), 0) AS churned_mrr
FROM
  monthly_metrics m
  LEFT JOIN churn_metrics c ON m.account_id = c.account_id
  AND m.mrr_month = c.churn_month
GROUP BY
  m.mrr_month
ORDER BY
  m.mrr_month;