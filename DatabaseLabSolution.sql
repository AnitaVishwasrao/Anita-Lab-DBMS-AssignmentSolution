CREATE DATABASE IF NOT EXISTS gllab10;

USE gllab10;

-- Delete tables if present 
DROP TABLE IF EXISTS rating;

DROP TABLE IF EXISTS gllab10.order;

DROP TABLE IF EXISTS product_details;

DROP TABLE IF EXISTS product;

DROP TABLE IF EXISTS category;

DROP TABLE IF EXISTS customer;

DROP TABLE IF EXISTS supplier;

-- Create tables 
CREATE TABLE IF NOT EXISTS supplier
  (
     supp_id    INT auto_increment,
     supp_name  VARCHAR(50) NOT NULL,
     supp_city  VARCHAR(20) NOT NULL,
     supp_phone VARCHAR(10) NOT NULL,
     PRIMARY KEY(supp_id)
  );

CREATE TABLE IF NOT EXISTS customer
  (
     cus_id     INT auto_increment,
     cus_name   VARCHAR(50) NOT NULL,
     cus_phone  VARCHAR(10) NOT NULL,
     cus_city   VARCHAR(20) NOT NULL,
     cus_gender VARCHAR(1) NOT NULL,
     PRIMARY KEY(cus_id)
  );

CREATE TABLE IF NOT EXISTS category
  (
     cat_id   INT auto_increment,
     cat_name VARCHAR(50) NOT NULL,
     PRIMARY KEY(cat_id)
  );

CREATE TABLE IF NOT EXISTS product
  (
     pro_id    INT auto_increment,
     prod_name VARCHAR(50) NOT NULL,
     prod_desc VARCHAR(100) NOT NULL,
     cat_id    INT NOT NULL,
     PRIMARY KEY(pro_id),
     FOREIGN KEY(cat_id) REFERENCES category(cat_id)
  );

CREATE TABLE IF NOT EXISTS product_details
  (
     prod_id    INT auto_increment,
     pro_id     INT NOT NULL,
     supp_id    INT NOT NULL,
     prod_price DOUBLE NOT NULL,
     PRIMARY KEY(prod_id),
     FOREIGN KEY(pro_id) REFERENCES product(pro_id),
     FOREIGN KEY(supp_id) REFERENCES supplier(supp_id)
  );

CREATE TABLE IF NOT EXISTS gllab10.order
  (
     ord_id     INT,
     ord_amount DOUBLE NOT NULL,
     ord_date   DATE NOT NULL,
     cus_id     INT NOT NULL,
     prod_id    INT NOT NULL,
     PRIMARY KEY(ord_id),
     FOREIGN KEY(cus_id) REFERENCES customer(cus_id),
     FOREIGN KEY(prod_id) REFERENCES product_details(prod_id)
  );

CREATE TABLE IF NOT EXISTS rating
  (
     rat_id       INT auto_increment,
     cus_id       INT NOT NULL,
     supp_id      INT NOT NULL,
     rat_ratstars INT NOT NULL,
     PRIMARY KEY(rat_id),
     FOREIGN KEY(cus_id) REFERENCES customer(cus_id),
     FOREIGN KEY(supp_id) REFERENCES supplier(supp_id)
  ); 
  
  
  -- Insert values

INSERT INTO supplier (supp_name, supp_city, supp_phone)
  VALUES ("Rajesh Retails", "Delhi", "1234567890"),
  ("Appario Ltd.", "Mumbai", "2589631470"),
  ("Knome products", "Banglore", "9785462315"),
  ("Bansal Retails", "Kochi", "8975463285"),
  ("Mittal Ltd.", "Lucknow", "7898456532");


INSERT INTO customer (cus_name, cus_phone, cus_city, cus_gender)
  VALUES ("AAKASH", "9999999999", "DELHI", "M"),
  ("AMAN", "9785463215", "NOIDA", "M"),
  ("NEHA", "9999999999", "MUMBAI", "F"),
  ("MEGHA", "9994562399", "KOLKATA", "F"),
  ("PULKIT", "7895999999", "LUCKNOW", "M");

INSERT INTO category (cat_name)
  VALUES ("BOOKS"),
  ("GAMES"),
  ("GROCERIES"),
  ("ELECTRONICS"),
  ("CLOTHES");

INSERT INTO product (prod_name, prod_desc, cat_id)
  VALUES ("GTA V", "DFJDJFDJFDJFDJFJF", 2),
  ("TSHIRT ", "DFDFJDFJDKFD", 5),
  ("ROG LAPTOP", "DFNTTNTNTERND", 4),
  ("OATS", "REURENTBTOTH", 3),
  ("HARRY POTTER", "NBEMCTHTJTH", 1);

INSERT INTO product_details (pro_id, supp_id, prod_price)
  VALUES (1, 2, 1500),
  (3, 5, 30000),
  (5, 1, 3000),
  (2, 3, 2500),
  (4, 1, 1000);

INSERT INTO gllab10.order (ord_id, ord_amount, ord_date, cus_id, prod_id)
  VALUES (20, 1500, cast("2021-10-12" as date), 3, 5),
  (25, 30500, cast("2021-09-16" as date), 5, 2),
  (26, 2000, cast("2021-10-05" as date), 1, 1),
  (30, 3500, cast("2021-08-16" as date), 4, 3),
  (50, 2000, cast("2021-10-06" as date), 2, 1);


INSERT INTO rating (cus_id, supp_id, rat_ratstars)
  VALUES (2, 2, 4),
  (3, 4, 3),
  (5, 1, 5),
  (1, 3, 2),
  (4, 5, 4);
  
--    Queries

-- Query 3)  - Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.

SELECT COUNT(c.cus_id) AS customers,
       c.cus_gender
FROM customer c
INNER JOIN gllab10.order o ON o.cus_id = c.cus_id
WHERE o.ord_amount >= 3000
GROUP BY c.cus_gender;

-- Query 4) -  Display all the gllab10.order along with the product name ordered by a customer having Customer_Id=2.

SELECT o.*,
       prod.prod_name
FROM gllab10.order o
INNER JOIN product_details pd ON o.prod_id = pd.prod_id
INNER JOIN product prod ON prod.pro_id = pd.pro_id
WHERE o.cus_id = 2;

-- Query 5)	Display the Supplier details who can supply more than one product.

SELECT s.*
FROM Supplier s
WHERE s.supp_id IN
    (SELECT pd.supp_id
     FROM product_details pd
     GROUP BY pd.supp_id
     HAVING COUNT(pd.supp_id) > 1);

-- Query 6)	Find the category of the product whose order amount is minimum

SELECT c.*
FROM category c
INNER JOIN product p ON p.cat_id = c.cat_id
INNER JOIN product_details pd ON pd.pro_id = p.pro_id
INNER JOIN gllab10.order o ON o.prod_id = pd.prod_id
WHERE o.ord_amount =
    (SELECT MIN(ord_amount)
     FROM gllab10.order);

-- Query 7) - Display the Id and Name of the Product ordered after “2021-10-05”.

SELECT p.pro_id,
       p.prod_name
FROM product p
INNER JOIN product_details pd ON pd.pro_id = p.pro_id
INNER JOIN gllab10.order o ON o.prod_id = pd.prod_id
WHERE o.ord_date > "2021-10-05";

-- Query 8) - Display customer name and gender whose names start or end with character 'A'.

SELECT cus_name, cus_gender
FROM customer
WHERE UPPER(cus_name) LIKE "A%"
  OR UPPER(cus_name) LIKE "%A";

-- Query 9) - Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.

DROP PROCEDURE IF EXISTS GetSupplierRatings;


DELIMITER $$
CREATE PROCEDURE `GetSupplierRatings`(supplier_id int)
BEGIN
SELECT
      s.supp_name,
      r.rat_ratstars as ratings,
      (CASE
         WHEN
            r.rat_ratstars > 4
         THEN
            "Genuine Supplier"
         WHEN
            r.rat_ratstars > 2
         THEN
            "Average Supplier"
         ELSE
            "Supplier should not be considered"
      END
      ) AS verdict
   FROM
      rating r
      INNER JOIN
         supplier s
         ON r.supp_id = s.supp_id
         WHERE r.supp_id = supplier_id;
END$$
DELIMITER ;

CALL GetSupplierRatings(1);
CALL GetSupplierRatings(2);
CALL GetSupplierRatings(3);
CALL GetSupplierRatings(4);
CALL GetSupplierRatings(5);
  