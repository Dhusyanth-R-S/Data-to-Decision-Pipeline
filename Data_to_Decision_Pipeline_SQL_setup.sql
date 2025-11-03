/*	1.	 Product Profitability Ranking:
 Identify the Top 10 Products by total sales revenue. For these 10 products,calculate their
 average Profit Margin over their lifetime and rank them based on this margin (highest margin first).    */

With product_sales as (
				Select
					p.product_id,
					p.product_name,
                    sum(f.sales) as prod_sales,
                    sum(f.profit) as prod_profit
				From
					products p Inner Join fact f
						On p.product_id = f.product_id
				Group by 
					p.product_id, p.product_name
				),
product_rank as (
				Select
					product_id,
                    product_name,
                    prod_sales,
                    prod_profit,
                    rank() over(order by prod_sales desc) as rnk
				From
					product_sales
			),
top_10_products as (
				Select
					product_id,
					product_name,
					prod_sales,
					prod_profit
				From
					product_rank
				Where
					rnk <= 10
			)
Select
	product_id,
    product_name,
    round(prod_profit *100/prod_sales,2) as profit_margin_pct
From
	top_10_products
Order by
	profit_margin_pct desc;

/* 2.**Year-over-Year (YoY) Profit Growth:** 
	  Calculate the Year-over-Year (YoY) Growth Percentage in total profit for each distinct
      Customer Segment across data. */															

With segment_year as (
				Select
					distinct c.segment ,
                    year(f.order_date) as order_year,
                    sum(profit) as profit
				From
					customers c Left Join fact f
						ON c.customer_id = f.customer_id
				Group by
					c.segment, order_year
				Order by
					c.segment,order_year
				)
Select
	*,
    concat(round(
    (profit - Lag(profit) over(partition by segment order by order_year)) * 100
		/ lag(profit) over(partition by segment order by order_year),2),"%")
																			as profit_growth
From
	segment_year;
					
/* 					3. **Customer Lifetime Value (CLV) & Metrics:** 
Determine the Cumulative Profit for the Top 10 Customers.
Display this CLV alongside the customer's total number of orders and the date of their very first order.*/

With customer_metrics as (	
					Select
						c.customer_id,
                        c.customer_name,
                        sum(f.profit) as CLV_cumulative_profit,
                        count(f.order_id) as total_orders,
                        min(f.order_date) as first_order_date
					From
						customers c Inner Join fact f 
							On c.customer_id = f.customer_id
					Group by
						c.customer_id, c.customer_name
				),
customer_rank as (
				Select * , 
						rank() over(order by CLV_cumulative_profit desc ) as rnk
				From
					customer_metrics
				)
Select
	*
From
	customer_rank
Where
	rnk <= 10 ;
                            
/*            4.  ** Cost Efficiency Ratio:** 
Calculate the Shipping Cost as a percentage of total sales for 
every combination of Shipping Mode and Customer Segment. */

With ship_segment as (
				Select
					l.ship_mode,
					c.segment,
					sum(f.shipping_cost) as ship_cost,
					sum(f.sales) as sales
				From
					fact f Inner Join customers c
						ON f.customer_id = c.customer_id
							Inner Join logistics l
						On l.log_id = f.log_id
				Group by
					l.ship_mode, c.segment
				)
Select
	ship_mode,
    segment,
    ship_cost,
    sales,
    round((ship_cost/sales )*100,2) as ship_cost_pct
From
	ship_segment;

/* 5.  			**Geographic Profit Anomaly:** 
Identify the Top 5 Cities by total profit. For these 5 cities, 
calculate the percentage of their total sales that were made with a discount greater than 20%.		*/

With city_metrics as (
			Select
				l.location_id,
                l.city,
                sum(f.profit) as city_profit,
                sum(f.sales) as city_sales
			From
				locations l Inner Join fact f
					On l.location_id = f.location_id
			group by 
				l.city,l.location_id
			),
city_rank as (
			Select
				*,rank() over(order by city_profit desc) as rnk
			From
				city_metrics
                ),
top_5_cities as (
			Select
				* 
			From
				city_rank 
			Where
				rnk <= 5
			)
Select
	t.location_id,
    t.city,
    t.rnk,
    t.city_profit,
    t.city_sales,
    sum(f.sales) as discount_sales ,
    round(
			sum(f.sales) * 100 /
							city_sales,2) as discount_sales_pct
From
	top_5_cities t Inner Join fact f
		On t.location_id = f.location_id
Where
	f.discount > 0.2
Group by
	t.location_id, t.city, t.city_sales, t.city_profit, t.rnk;
    
/* 				6.  **Sustained Sales Decline:**
 Find all Product Sub-Categories that have experienced a Month-over-Month (MoM) 
decrease in Quantity Sold for at least three consecutive months.			*/

With sub_categorical_metrics as (
			Select
				p.sub_category,
                min(f.order_date) as ref_date,
                concat(year(f.order_date) ,"-",monthname(f.order_date)) as period,
                sum(f.quantity) as quantity
			From
				products p Inner Join fact f
					On p.product_id = f.product_id
			Group by
				p.sub_category, period
			Order by
				 p.sub_category, ref_date
			),
 MOM_calculation as (
			Select
				sub_category,
                period,
                ref_date,
                lag(quantity) over(partition by sub_category order by ref_date) as prev_month,
                quantity,
                lead(quantity) over(partition by sub_category order by ref_date) as next_month
                
			From
				sub_categorical_metrics
),
final_MOM as (
			Select 
				* ,lag(prev_month) over(partition by sub_category order by ref_date) as two_months_back
From
	MOM_calculation
    )
Select 
	distinct sub_category
From
	final_MOM
Where
	two_months_back > prev_month and prev_month > quantity and quantity > next_month ;
        
/* 			7.  **Quarterly Trend Analysis & Ranking:** 
Calculate the Total Sales for the most recent eight quarters.
For each quarter, **rank the Product Categories**
based on their sales performance within that specific quarter. */

With quarter_settings as (
			Select
				year(f.order_date) as order_year,
				quarter(f.order_date) as qtr,
                min(f.order_date) as ref_date
			From
				fact f 
			group by 1,2
                ),
quarter_rank as (
			Select 
					order_year,
                    qtr,
					row_Number() over(order by ref_date desc) as qtr_rnk
			from 
			quarter_settings
		),
required_qtr as(
			Select
				order_year,
                qtr,
                qtr_rnk
			From
				quarter_rank 
			Where
				qtr_rnk <=8
			order by 
				order_year , qtr
		),
qtr_metrics as (
			Select
				r.order_year,
                r.qtr,
                p.category,
                sum(f.sales) as category_sales
			From
				required_qtr r Inner Join fact f 
					On
					concat(year(f.order_date) , quarter(f.order_date)) = concat(r.order_year, r.qtr)
								Inner Join products p
					On 
						p.product_id = f.product_id
			Group by
				r.order_year,
                r.qtr,
                p.category
			order by
				r.order_year,r.qtr
			)
Select
	*,
    rank() over(partition by qtr,order_year order by category_sales desc) as category_rank
From
	qtr_metrics;
			
 /*			 8.  **Discount Tier Profitability:** 
 Create three discrete Discount Tiers (Low, Medium, High).
 Calculate the Average Order Profit and the Average Quantity Sold per Order for each of these tiers.   */ 
 
 With data_splitting as (
			Select
				*, Ntile(3) over(order by discount ) as discount_bucket
			From
				fact
		),
data_transforming as(
			Select
				*,
                case
					When discount_bucket = 1 then "Low"
                    When discount_bucket = 2 then "Medium"
				    else "High"
				end as discount_tier
			From
				data_splitting
			),
preparation as (
			Select
				discount_tier,
				order_id,
				avg(profit) as avg_profit,
				avg(quantity)  as avg_qty
			From
				data_transforming
			group by
				discount_tier, order_id
		)
Select
	discount_tier,
    round(avg(avg_profit),2) as avg_profit,
    round(avg(avg_qty),2) as avg_qty
From
	preparation
Group by
	discount_tier;

/*		 9. **Regional Performance Quartiles:**
 Segment all States into sales performance quartiles based on total sales.
 Identify and list any State that is in the Top Sales Quartile but simultaneously
 falls in the Bottom Profit Margin Quartile.  					*/
 
With pre_state_metrics as (
				Select
                    l.state,
                    sum(sales) as state_sales,
                    sum(profit) as state_profit
				From
					locations l Left Join fact f
						On l.location_id = f.location_id
				Group by
					 l.state
				),
state_metrics as (
			Select
				state,
                state_sales,
                round(state_profit*100/state_sales,2) as state_profit_margin
			From	
				pre_state_metrics
			),
sales_quartile_metrics as(
				Select
                    state,
                    state_sales,
                    ntile(4) over(order by state_sales desc) as sales_quartile
				From
					state_metrics
			),
sales_top_quartile as (
				Select
					*
				From
					sales_quartile_metrics
				Where
					sales_quartile = 1
			),
profit_quartile_metrics as (	
			Select
                state,
                state_profit_margin,
                ntile(4) over(order by state_profit_margin ) as profit_quartile
			From
				state_metrics
			),
profit_bottom_quartile as (
			Select
				* 
			From
				profit_quartile_metrics
			Where
				profit_quartile = 1
		)
Select
    s.state,
    s.state_sales,
    p.state_profit_margin
From
	sales_top_quartile s Inner Join profit_bottom_quartile p
		On s.state = p.state;

/* 			10. **Sales Volatility Detection:**
 Calculate the Month-over-Month (MoM) change in total sales.
Identify and list all months where the absolute value of the change exceeded 20%. 			*/

With pre_processing as (
			Select
				year(order_date) as order_year,
                month(order_date) as order_month,
				monthname(order_date) as order_monthname,
				sum(sales) as period_sales
			From
				fact 
			Group by
				1,2,3
			order by 
				1,2
		),
MOM_calculation as (
			 Select
				order_year,
                order_month,
                order_monthname,
                period_sales,
                round(
                100*(period_sales - lag(period_sales) over(order by order_year,order_month))
					/ lag(period_sales) over(order by order_year, order_month),2) as MOM_growth_pct
			From
				pre_processing
		)
Select
	* 
From
	MOM_calculation 
Where
	abs(MOM_growth_pct) > 20;
			
/*   		 11. **Cumulative Market Growth:** 
Calculate the Running Total of Sales over year for each distinct Market 
 showing their independent growth trajectories.			*/
 
With pre_processing as (
			Select
				year(f.order_date) as period ,
                l.market,
                sum(sales) as period_sales
			From
				locations l Inner Join fact f 
					ON l.location_id = f.location_id
			Group by
				period, l.market
		)
Select
	market,
    period,
    period_sales,
    sum(period_sales) over(partition by market order by period) as cumulative_sales
From
	pre_processing;
    
/* 			12. **New Product Performance:**
 Analyze products introduced in the most recent year. 
 Calculate the average first-three-month sales and profit for these new products, grouped by Category.	  */
 
 With New_products as (
			Select	
				p.product_id,
                p.product_name,
                p.category,
				min(f.order_date) as first_order
			From
				fact f Inner Join products p 
					On f.product_id = p.product_id
			Group by 
				product_id, product_name, category
			Having
				year(min(order_date)) = ( Select 	
										year(max(order_date))
									 From
										fact )
	
				),
Order_window as (
			Select
				*,
                date_add(first_order, Interval 90 day) as end_line
			 From
				New_products
			)
Select
	o.category,
    avg(f.sales) as avg_category_sales,
    avg(f.profit) as avg_category_profit
From
	order_window o Inner Join fact f
		On o.product_id = f.product_id
Where
	f.order_date >= first_order
    and 
    f.order_date <= end_line
Group by
	o.category;

/* 					13. **Above/Below Average Profitability:**
For every order, determine if its individual Profit Margin was above or below the overall 
average Profit Margin for its respective Product Category.						         	*/

With order_metrics as (
			Select
				p.category,
                f.order_id,
                sum(f.sales) as order_sales,
                sum(f.profit) as order_profit
			From
				products p Inner Join fact f
					On p.product_id = f.product_id
			Group by 
				p.category ,f.order_id
			),
overall_metrics_prep as (
			Select
				category,
                order_id,
                order_sales,
                order_profit,
                sum(order_sales) over(partition by category) as cat_sales,
                sum(order_profit) over(partition by category) as cat_profit
			From
				order_metrics
			),
profit_margin as (
		Select
			category,
            order_id,
            order_sales,
            order_profit,
            round(order_profit *100/order_sales) as order_profit_margin,
            cat_sales,
            cat_profit,
            round(cat_profit * 100 / cat_sales) as cat_profit_margin
		From
			overall_metrics_prep
		)
Select
	category,
    order_id,
    order_profit_margin,
    cat_profit_margin,
	case 
		When order_profit_margin > cat_profit_margin then "Above"
        When order_profit_margin < cat_profit_margin then "Below"
        else "Same"
	end as profit_level
From
	profit_margin;
	