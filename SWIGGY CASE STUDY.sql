
USE swiggy;
show tables;

/*
 * HAVING 7 DIFFERENT TABLE CONSISTS OF --
   * users  -  having the details of all users using swiggy app.
   * restaurants -  having all the restaurants name which deliver food.
   * orders - having user_id, f_id, r_id , amount of order.
   * order_details - having order_id which contains different food items.
   * menu - menu_id, f_id, r_id, price.
   * food - list of all food items be offered.
   * delivery_partner  - partner_id and partner name.   
   */
   
   
/* OBJECTIVE :- 
	* Classify users on the basis of their ordering.
    * Most no. of food item sold by which restaurant.
    * Total amount of order in every restaurnat.
    * Maximum amount of order in every restaurnat.
    * Favourite food item of each users.
    * AVERAGE RATING OF ALL THE RESTAURANTS.
    * Classify users on the basis of their rating.
    * Classify resturants of each month on  the basis of most sales
    */
    
-- 1. Classify users on the basis of their ordering.


SELECT * FROM USERS
WHERE USER_ID IN (SELECT DISTINCT(USER_ID) FROM ORDERS);

-- Nitish, Khushboo, Vartika, Ankit, Neha are the users who always orders.

SELECT * FROM USERS
WHERE USER_ID NOT IN (SELECT DISTINCT (USER_ID) FROM ORDERS);

-- Anupama and Rishabh are the users who never orders.


-- 2. Most no. of food item sold by which restaurant.

SELECT R.r_name,O.r_id,COUNT(O.r_id) as No_of_orders from orders O
left join restaurants R
on O.r_id= R.r_id
group by O.r_id, R.r_name
order by No_of_orders desc limit 1;

-- kfc is the restaurant which sold max number of food item.


-- 3. Total amount of order in every restaurnat.

SELECT O.r_id ,R.r_name,sum(O.amount) as total_amount FROM order_details  OD
INNER JOIN orders  O
ON OD.order_id= O.order_id
LEFT JOIN restaurants R
ON O.r_id= R.r_id
GROUP BY r_id, R.r_name
order by sum(O.amount) desc;

-- 4. Maximum amount of order in every restaurant.
SELECT O.r_id ,R.r_name,max(O.amount) as max_amount FROM order_details  OD
INNER JOIN orders  O
ON OD.order_id= O.order_id
LEFT JOIN restaurants R
ON O.r_id= R.r_id
GROUP BY r_id, R.r_name
order by max(O.amount) desc;

-- 5. Favourite food item of each users.

WITH FAV_FOOD AS (SELECT O.USER_ID ,U.NAME, F.F_NAME, COUNT(F.F_NAME) AS NO_OF_ITEM 
				FROM ORDERS O
				INNER JOIN  ORDER_DETAILS OD
				ON O.ORDER_ID= OD.ORDER_ID
				INNER JOIN FOOD F
				ON OD.F_ID= F.F_ID
				INNER JOIN  USERS U
				ON O.USER_ID= U.USER_ID
				GROUP BY O.USER_ID , F.F_NAME, U.NAME
				ORDER BY NO_OF_ITEM DESC )
 
SELECT * FROM FAV_FOOD F1
WHERE NO_OF_ITEM= (SELECT MAX(NO_OF_ITEM) FROM FAV_FOOD F2 
					WHERE F2.USER_ID= F1.USER_ID);
                    
                    
-- 6. AVERAGE RATING OF ALL THE RESTAURANTS.

SELECT R.R_NAME, ROUND(AVG(O.RESTAURANT_RATING),2) AS AVG_RATING 
FROM RESTAURANTS R
INNER JOIN ORDERS  O
ON R.R_ID= O.R_ID
GROUP BY R.R_NAME
ORDER BY AVG_RATING DESC;


-- 7. Classify users on the basis of their rating.

SELECT U.NAME, MAX(O.RESTAURANT_RATING) AS MAX_RATING FROM USERS U
INNER JOIN ORDERS O
ON U.USER_ID= O.USER_ID
GROUP BY U.NAME
ORDER BY MAX_RATING DESC; 


-- 8. Classify resturants of each month on  the basis of most sales.

WITH TOP_SALES AS (SELECT O.R_ID,R.R_NAME,MONTHNAME(DATE) AS MONTH, SUM(AMOUNT) AS 
					TOTAL_AMOUNT 
					FROM RESTAURANTS R
					INNER JOIN ORDERS O
					ON R.R_ID=O.R_ID
					group by R.R_NAME, O.R_ID,MONTHNAME(DATE)
					ORDER BY MONTH DESC , TOTAL_AMOUNT DESC)
                    
SELECT * FROM TOP_SALES T1
WHERE TOTAL_AMOUNT= (SELECT MAX(TOTAL_AMOUNT) FROM TOP_SALES T2
					 WHERE T2.MONTH=T1.MONTH);
                     
/* OBSERVATIONS

	
    *  Nitish, Khushboo, Vartika, Ankit, Neha are the users who always orders.
    *  Anupama and Rishabh are the users who never orders.
    *  Kfc is the restaurant which sold max number of food item.
    *  Kfc is the restaurant which has max total_amount of item sold of Rs 8385.
    *  Max amount of order place in dominos of Rs 950.
    *  Favourite food_item by each customers are :--
	    * Neha  ---   	Choco Lava cake
        * Nitish ---  	Choco Lava cake
        * Khushboo ---  Choco Lava cake
        * Vartika  ---  Chicken Wings
        * Ankit ---     Schezwan Noodles and Veg Manchurian
        
	* China Town Restaurant have  highest average rating compared to others.
    * Nitish, Khushboo, Ankit gives 5 ratings and Vartika gives 2 followed by
       Neha gives only 1.
	
    * IN MAY-- DOMINOS HAVE MAXIMUM SALES
      IN JUNE-- KFC HAVE MAXIMUM SALES
      IN JULY-- KFC HAVE MAXIMUM SALES 
                                          */

   /* INSIGHTS
   
	* FOCUS ON THOSE CUSTOMERS WHO NEVER ORDERS BY PROVIDING THEM VARIOUS OFFERS.
    
    * GIVING COUPONS AND OFFER FOR SUBSCRIPTION TO REGULAR CUSTOMERS WHICH PROVIDES
		FREE DELIVERY AND BUY ONE GET ONE OFFER.
        
	* OFFERING MULTIPLE VARIETIES OF FAVOURITE FOOD_ITEM OF EACH CUSTOMERS TO 
		ENCHANCE THE SALE OF THE FOOD_ITEM.
        
	* GIVING DISCOUNT TO EVERY FOOD ITEM TO THOSE CUSTOMERS WHO RATED FULLY TO 
		RESTAURANTS.*/