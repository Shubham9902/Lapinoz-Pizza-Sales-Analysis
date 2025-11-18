use pizza;
select* from order_details;
select* from orders;
select* from pizza_types;
select*from pizzas;
set @margin := 0.30;
# SECTION A: Base order-level metrics (order_total, items_count)
with order_line as(
select od.order_id,od.pizza_id,od.quantity, p.price,p.price*od.quantity as line_revenue from order_details od inner join pizzas p 
on od.pizza_id=p.pizza_id),	order_agg as (
select ol.order_id, sum(ol.line_revenue) as orders_total,sum(ol.quantity) as total_items from order_line ol group by ol.order_id)
select*from order_agg limit 10;	

# 1: TOTAL REVENUE (overall)
select round(sum(od.quantity*p.price)) as Total_revenue from order_details od inner join pizzas p on od.pizza_id= p.pizza_id;

#2: AOV(Average Order Value), Orders Count, Avg Items Per Order
with order_line as(
select od.order_id,od.pizza_id,od.quantity, p.price,p.price*od.quantity as line_revenue from order_details od inner join pizzas p 
on od.pizza_id=p.pizza_id),	order_agg as (
select ol.order_id, sum(ol.line_revenue) as orders_total,sum(ol.quantity) as total_items from order_line ol group by ol.order_id)
select*from order_agg limit 10;	SELECT COUNT(*) AS orders_count, ROUND(AVG(order_total), 2) AS AOV,ROUND(AVG(total_items), 2) AS avg_items_per_order
FROM order_agg;

# 3 Revenue by hour (and create time buckets)
select hour(o.time) as hours_of_day,
case
when hour(o.time) between 6 and 10 then 'Breakfast'
when hour(o.time) between 11 and 15 then 'Lunch'
when hour(o.time) between 16 and 19 then 'Snacks'
when hour(o.time) between 20 and 23 then 'Dinner'
else 'Late night'
end as Time_bucket, count(distinct o.order_id ) as order_count, round(sum(p.price*od.quantity),2) as Revenue from orders o 
inner join order_details od  on o.order_id = od.order_id inner join pizzas p on od.pizza_id = p.pizza_id group by time_bucket, hours_of_day
order by revenue desc;

# 4: Top SKUs by revenue & their contribution %
with sku_rev as (
select p.pizza_id, pt.name as pizza_name, p.size, sum(p.price*od.quantity) as Sku_revenue , sum(od.quantity) as sku_qty
from order_details od inner join pizzas p on p.pizza_id = od.pizza_id inner join pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY p.pizza_id, pt.name, p.size
), total_rev as ( select sum(sku_revenue) as total_revnue from sku_rev)
select s.pizza_id, s.pizza_name, s.size,s.sku_qty, round(s.sku_revenue,2) as sku_revenue,
round((s.sku_revenue/t.total_revnue)*100,2) as revenue_pct 
from sku_rev s cross join total_rev t order by s.sku_revenue desc limit 10;

# 5: Top 5 SKUs 
with sku_rev as (
select p.pizza_id, pt.name as pizza_name, p.size, sum(p.price*od.quantity) as Sku_revenue , sum(od.quantity) as sku_qty
from order_details od inner join pizzas p on p.pizza_id = od.pizza_id inner join pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY p.pizza_id, pt.name, p.size
)
select pizza_name, sku_qty, ROUND(sku_revenue,2) as revenue from sku_rev order by sku_revenue desc limit 5;

# 6: Revenue share by category
select pt.category , round(sum(p.price*od.quantity),2) as category_revenue, round((sum(p.price*od.quantity)/(select sum(p2.price*od2.quantity)
from order_details od2 inner join pizzas p2 on od2.pizza_id = p2.pizza_id))*100,2) as category_pct from order_details od inner join pizzas p
on od.pizza_id = p.pizza_id inner join pizza_types pt on p.pizza_type_id = pt.pizza_type_id group by pt.category order by category_revenue 
desc;

# 7: Price band analysis
select
  case
    when p.price < 100 then 'Low'
    when p.price between 100 and 199 then 'Mid'
    when p.price between 200 and 299 then 'High'
    else 'Premium'
  end as price_band,
count(distinct od.order_id) as orders_count,round(sum(p.price * od.quantity),2) as revenue,round(avg(p.price),2) as avg_price from order_details od
inner join pizzas p on od.pizza_id = p.pizza_id group by price_band order by revenue desc;

 # 8: Estimated profit by category 
select pt.category, round(sum(p.price * od.quantity),2) as revenue, round(sum(p.price * od.quantity) * @margin,2) as est_profit from order_details od
inner join pizzas p on od.pizza_id = p.pizza_id inner join pizza_types pt on p.pizza_type_id = pt.pizza_type_id group by pt.category
ORDER BY est_profit desc;

# 9: Weekly / Monthly revenue trend 
select date_format(o.date, '%Y-%m') as month, count(distinct o.order_id) as orders_count, round(sum(p.price * od.quantity),2) as revenue
from orders o inner join order_details od ON o.order_id = od.order_id inner join pizzas p ON od.pizza_id = p.pizza_id group by month
order by month;

# 10: Price sensitivity by size
select p.size, count(distinct od.order_id) as orders_count, sum(od.quantity) as qty, round(sum(p.price * od.quantity),2) as revenue,
round(avg(p.price),2) as avg_price from order_details od inner join pizzas p on od.pizza_id = p.pizza_id group by p.size
order by  revenue desc;