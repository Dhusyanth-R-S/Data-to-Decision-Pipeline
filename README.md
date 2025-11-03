The Data-to-Decision Pipeline

Project Background: The Data-to-Decision Pipeline 

Global Superstore is a fictional e-commerce company with vast global transactional data. This project thoroughly analyzes and synthesizes the data to uncover critical insights that will drive commercial success, optimize operational efficiency, and maximize profitability.

Key Analytical Areas

Sales Masking Profits: Revealing where high revenue disguises underlying profit issues.

Sales Trend Analysis: Evaluating global and regional historical patterns, incorporating Profit and Logistical Risk Index (LRI %).

Product Performance: Categorical and granular analysis of profit margins versus discount rates.

Regional Investment Strategy: Providing concise, data-driven recommendations on resource allocation and divestment across global markets.


Data Structure and Transformation

Global Superstore's data spans over 50,000 records, initially contained within a single flat wide table at the transaction granularity. I performed the complete data normalization, moving from this raw state to an efficient Star Schema model linked by foreign keys, ensuring data integrity and OLAP readiness.


<img width="469" height="467" alt="Star Schema Image Pipeline" src="https://github.com/user-attachments/assets/f0b665c8-bf2b-4a15-9024-f294585ac263" />



Tools and Purpose of the project :


Project Pipeline Breakdown by Tool

1. Python (Pandas)

Process: Data Engineering

File Reference: pandas_pipeline_1.ipynb

Purpose: Responsible for cleaning, performing data type conversion, and executing the Star Schema normalization of the raw data.

2. SQL (DDL & Advanced Queries)

Process: Database Integrity

File Reference: SQL table creation.sql

Purpose: Defines and enforces constraints (Primary Keys/Foreign Keys) and integrity rules to ensure data quality and optimize the structure for Online Analytical Processing (OLAP).

Process: Analytical Queries

File Reference: SQL Query Pipeline.sql

Purpose: Executes key business questions and metrics using complex join operations and advanced Window Functions (e.g., LAG, NTILE, RANK).

3. Power BI (Report & Storytelling)

Process: Final Storytelling

File Reference: Powerbi_Pipeline_project.pbix

Purpose: Provides interactive visualization and narrative-driven reporting to communicate the analytical insights and the complete story. 




Executive Summary: Overview of Critical Findings

1. Logistics Leak: The Cost of Speed

Insight: Approximately 13% of the company's total profit is consumed by shipping costs, primarily driven by the 'Same Day Delivery' option.

Recommendation: Limit 'Same Day Delivery' availability exclusively to high-density locations where cost-to-deliver is verifiably lower, preserving crucial profit margins.

<img width="537" height="214" alt="Screenshot 2025-11-03 165408" src="https://github.com/user-attachments/assets/383d79bf-5056-4d1a-994f-7893c0ff6cfc" />

2. Sales Masking Profit

Insight: Despite leading the market in sales volume, the 'Furniture' category generates less than half the profit margin of the 'Office Supplies' category. High revenue is aggressively masking underlying profitability issues.

3. Profit Margin Anchors (Product Granularity)

Insight: Even the successful 'Technology' category leads the company's sales and profits, products like 'Cubify CubeX 3D Printer Double Head Print,' which alone caused a staggering $9,000 USD loss more than any other product by biggest margin in loses. 

Recommendation: This highlights the critical need for continuous, granular margin analysis to immediately flag and address severely underperforming SKUs.


<img width="671" height="224" alt="Screenshot 2025-11-03 165547" src="https://github.com/user-attachments/assets/c6316159-d045-4d2b-95de-8b8445695f36" />


4. Strategic Regional Investment

Insight: Investment initiatives outside capital cities are yielding exceptional results. For example, the city of Hamburg drives 150% more profit than Berlin, despite generating only 65% of Berlin's sales amount, indicating superior operational efficiency and pricing outside the main hub.

Recommendation: Double down on investment and logistical support in these highly efficient, second-tier cities to sustain hyper-profitable growth.


<img width="1186" height="462" alt="Screenshot 2025-11-03 165709" src="https://github.com/user-attachments/assets/09fa1595-5479-4fd4-a696-9ad265be3144" />



5. Global Sales Trend & Customer Loyalty

Sales Trend: The company exhibits a smooth, reliable global sales seasonality, consistently starting the year with low volume and peaking toward the final quarter. This pattern has been stable over the four-year dataset.

Customer Loyalty: A select group of customers contribute a vital, marginal amount to the company's overall profit. Their retention is critical.

Recommendation: A formal Customer Loyalty Program should be established to recognize and incentivize these top global patrons.


<img width="498" height="342" alt="image" src="https://github.com/user-attachments/assets/a34c755c-5c2f-41e4-81b4-1abd496338b0" />


The interactive PowerBI dashboard with much more details in depth can be downloaded here .[link]



Apart from this, 13 effective business reports has been done using SQL (MySQL)
	
	These queries performs perfect business analysis and get us know what is happening beyond simple analysis

1. Product Profitability Ranking:
	 Top 10 Products: Sales vs. Profit Margin Rank

2. Year-over-Year (YoY) Profit Growth:
	 Customer Segment YoY Profit Growth

3. Customer Lifetime Value (CLV) & Metrics: 
	Top 10 Customer Lifetime Value (CLV)

4. Cost Efficiency Ratio:
	 Shipping Cost as % of Sales by Mode & Segment
	
5. Geographic Profit Anomaly:
	 Top 5 Cities: High Discount Sales Percentage

6. Sustained Sales Decline: 
	Sub-Categories with 3+ Months of MoM Quantity Decline

7. Quarterly Trend Analysis & Ranking:
	 Quarterly Category Sales Rank (Last 8 Quarters)

8. Discount Tier Profitability: 
	Discount Tier Analysis: Avg Profit & Quantity

9. Regional Performance Quartiles:
	 High Sales / Low Profit Margin States Anomaly

10. Sales Volatility Detection: 
	Sales Volatility: MoM Change Exceeding 20%

11. Cumulative Market Growth: 
	Market-Specific Cumulative Sales Trend

12. New Product Performance:
	 New Product Performance: First 3-Month Avg Sales & Profit

13. Above/Below Average Profitability:
	 Order Profit Margin vs. Category Average


The raw file used for the project can be downloaded [here]

The Pandas(Python) code for setting up that data for a next levela analysis can be downloaded [here]

The SQL table set up (Data Integrety ) can be found downloaded [here]

The file of 13 Business queries can be downloaded [here]

The interactive Dashboard with complete story can be downloaded [here]




