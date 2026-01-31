Select * from customer
--Ingresos por Genero
Select gender, SUM(purchase_amount) as revenue
from customer
group by gender

--Clientes que usaron descuento y gastaron mas que el promedio
Select customer_id, purchase_amount
from customer
Where discount_applied = 'Yes' and purchase_amount >= (Select AVG(purchase_amount) from customer)

--Los 5 productos mas valorados
Select item_purchased, ROUND(AVG(review_rating::numeric),2) as "Average Product Rating"
from customer
group by item_purchased
order by avg(review_rating) DESC
limit 5; 

--Compara el tipo de envio 
select shipping_type, ROUND(AVG(purchase_amount),2) 
from customer
Where shipping_type in ('Standard','Express')
group by shipping_type

--Que tipo de susbcription gastan mas 

Select subscription_status, COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount),2)as avg_spend,
ROUND(SUM(purchase_amount),2)as total_revenue
from customer
group by subscription_status
order by total_revenue , avg_spend desc;

--Cuales son los 5 productos mas comprados con descuentos aplicados
Select item_purchased, ROUND(100*SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END )/COUNT(*), 2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;

--Segmentar segun sea el tipo de cliente

with customer_type as(
Select customer_id, previous_purchases,
CASE
	When previous_purchases = 1 THEN 'New'
	When previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
	ELSE 'Loyal'
	END AS customer_segment
from customer
)

Select customer_segment, count(*) as "Number of Customers"
from customer_type
group by customer_segment 

--3 productos mas comprados por categoria 

with item_counts as (
select category, item_purchased, COUNT(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id) DESC) as item_rank
from customer
group by category, item_purchased
)

Select item_rank, category, item_purchased, total_orders 
from item_counts
Where item_rank <= 3;

--Los clientes leales se suscriben?

Select subscription_status, COUNT(customer_id) as repeat_buyers
from customer
WHERE previous_purchases > 5
group by subscription_status

--Ingresos por grupos de edad
Select age_group , SUM(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue DESC;
