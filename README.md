# SaaS-Performance-Analytics
## Project Overview
This repository contains a comprehensive analysis of key performance metrics for a fictional SaaS company, Ravenstack. The project's purpose is to identify critical drivers of customer churn and revenue contraction, providing actionable, data-backed insights to improve business strategy and customer retention using **SQL**. The dataset is sourced from kaggle.

## Project Phases & Analysis
The project is structured into five distinct phases.
### Phase 1: Financial and Support Metrics
#### Key Insights:
* **Revenue Growth**: The total Monthly Recurring Revenue (MRR) showed strong growth, increasing from **$3,753** in January 2023 to **$150,093** in August 2023. However, the data reveals significant revenue contractions in June and September, indicating periods of instability that warrant further investigation.
* **MRR Drivers**: While growth is primarily driven by New MRR, the analysis identified a major financial risk from **Contraction MRR**, with revenue losses of **$20,534** in June and **$30,701** in July 2023 due to customer downgrades.
* **Contraction Hotspots**: The most financially damaging downgrade paths are from **Enterprise to Pro** and **Enterprise to Basic**, with a combined total lost MRR of over **$23.5 million**. This highlights the critical importance of retaining high-value customers.
* **Support Performance**: The support team handles an average of **2,000** tickets with an average resolution time of **35.86 hours**.
* **Tier-Based Support**: A detailed breakdown shows that **Enterprise customers** are the most demanding, generating the most tickets (**6,814**) and having the longest average resolution time (**36.31 hours**), suggesting more complex issues that require specialized attention.

### Phase 2: Churn & Downgrade Analysis
#### Key Insights:
* **Top Churn Reasons**: The top reasons for churn are **"features," "support," and "budget,"** all with similar counts (e.g., **114** churn events for "features," **104** for "support"). This demonstrates that product quality and support are as critical as pricing in customer retention.
* **Costly Downgrades**: The **Enterprise to Pro** downgrade path is both the most frequent (**2,280** occurrences) and most financially impactful in terms of lost MRR (**$11,567,556**). This reinforces the finding from Phase 1.

### Phase 3: Feature Usage Analysis
#### Key Insights:
The analysis revealed a counter-intuitive finding: **churned accounts often have a higher total feature usage than active accounts**. For example, for "feature_1," churned accounts had **7,703** total uses compared to only **1,702** for active accounts. This suggests that high usage may be a sign of customer frustration and a search for a solution, rather than satisfaction.

### Phase 4: Support Ticket and Churn Analysis
#### Key Insights:
A clear correlation was established: churned accounts consistently have a **higher number of support tickets** and a **lower average satisfaction score** for almost every feature compared to active accounts. For "feature_1," churned accounts had **2,985** tickets with an average satisfaction score of **3.93**, while active accounts had only **747** tickets with a satisfaction score of **4.02**. This directly ties poor support experience to a higher likelihood of churn.

### Phase 5: Feature Error Analysis
#### Key Insights:
The data provides a definitive answer: for most features, churned accounts have a **higher error rate**. For instance, "feature_1" had an error rate of **5.8%** for churned accounts, versus **5.05%** for active accounts. This confirms that technical issues with specific features are a significant, underlying cause of customer frustration and churn.
