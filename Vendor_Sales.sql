#Indicate the brand with the highest Discount_rate in Vendor_1.

SELECT Brands, Discount_rates as "Highest Discount_rates"
FROM Vendor_1 
WHERE Discount_rates = (SELECT MAX(Discount_rates) 
                        FROM VENDOR_1);
	
#Indicate the brands in both Vendor_1 and Vendor_1_updated, discount rate, and difference between Vendor_1_updated Discount_rate and Vendor_1 Discount_rate.	

SELECT v.Brands as "Brands", 
       v.DISCOUNT_RATES as "Vendor_1 DISCOUNT_RATES", 
       vu.DISCOUNT_RATES as "Vendor_1_Updated DISCOUNT_RATES", 
       vu.DISCOUNT_RATES - v.DISCOUNT_RATES as "Difference" 
FROM Vendor_1 v JOIN  vendor_1_updated vu ON v.ID = vu.ID 
WHERE v.Brands = vu.Brands;
	

#Indicate day, brands, total sales and the running total of sales ordered by brand name and day descending from vendor_1_updated.

SELECT s.dates, vu.brands, s.sale_amount as "Total Sales", SUM(s.sale_amount) OVER (PARTITION BY vu.brands ORDER BY s.dates DESC) AS "Running Total Sales"
FROM Sales s 
JOIN Vendor_1 v ON S.vendor1_merchant_id = v.ID 
JOIN vendor_1_updated vu ON v.ID = vu.ID 
WHERE v.brands = vu.Brands 
ORDER BY vu.brands, s.dates DESC ;
	
#Indicate total sales by week and the most frequently purchased brand for that week from vendor_1_updated.

	WITH WeeklyBrandSales AS (
	    SELECT 
	        TO_CHAR(s.dates, 'YYYY-WW') AS week,
	        vu.brands,
	        SUM(s.sale_amount) AS total_sales,
	        RANK() OVER (PARTITION BY TO_CHAR(s.dates, 'YYYY-WW') ORDER BY SUM(s.sale_amount) DESC) AS brand_rank
	    FROM 
	        Sales s
	    JOIN Vendor_1 v ON s.vendor1_merchant_id = v.ID 
	    JOIN Vendor_1_updated vu ON v.ID = vu.ID 
	    WHERE v.brands = vu.Brands 
	    GROUP BY 
	        TO_CHAR(s.dates, 'YYYY-WW'), vu.Brands
	)
	SELECT 
	    week,
	    SUM(total_sales) AS "Total Sales by Week",
	    MAX(CASE WHEN brand_rank = 1 THEN brands END) AS "Most Frequently Purchased Brand"
	FROM 
	    WeeklyBrandSales
	GROUP BY  
	    week
	ORDER BY 
	    week;
