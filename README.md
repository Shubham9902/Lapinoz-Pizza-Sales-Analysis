# 🍕 Lapinoss Pizza Sales Analysis

## 📌 Project Overview
This project analyzes the sales data of **Lapinoss Pizza** to identify business opportunities for revenue growth and operational efficiency. Using **MySQL** for exploratory data analysis (EDA) and **Power BI** for visualization, the analysis provides actionable insights into peak sales hours, best-performing categories, and customer spending habits.

The goal is to answer key business questions:
- *When are the busiest times of the day?*
- *Which pizza categories drive the highest profit?*
- *How does price sensitivity impact sales volume?*

## 📊 Dashboard Visuals
*(Note: The .pbix file is included in this repo, but here are the key views for quick reference)*

### 1. Executive Overview
![Dashboard Overview](assets/dashboard_overview.png)
*Displays high-level KPIs: Total Revenue, Total Orders, and Average Order Value.*

### 2. Sales Trends & Peak Hours
![Hourly Trends](assets/hourly_trends.png)
*Breakdown of sales by hour and day to optimize staffing.*

---

## 🛠️ Tech Stack
- **Database:** MySQL 8.0 (Data Cleaning, EDA, Window Functions)
- **Visualization:** Power BI (DAX Measures, Interactive Dashboards)
- **Language:** SQL (Advanced queries including CTEs and Window Functions)

## 🔍 Key Insights & Findings
Based on the SQL analysis, the following trends were identified:

1.  **Peak Efficiency Hours:** The "Dinner" time bucket (20:00 - 23:00) accounts for the highest volume of orders, suggesting a need for increased staff during these hours compared to the "Late Night" shift.
2.  **Category Performance:** While distinct categories exist, specific "Supreme" and "Chicken" variants drive the bulk of the revenue, indicating they should be the focus of marketing campaigns.
3.  **Price Sensitivity:** Analysis of price bands (`Budget`, `Standard`, `Premium`) reveals that customer volume is highest in the standard price range ($10-$20), but premium pizzas contribute disproportionately to the profit margin.
4.  **Operational Bottlenecks:** Average items per order is stable, but peak hour surges strain kitchen throughput (inferred from order timestamps).

