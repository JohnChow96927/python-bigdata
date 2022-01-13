USE winfunc;

SELECT id, country, views
FROM (
         SELECT id,
                country,
                views,
                AVG(views) OVER () `avg_views`
         FROM auction
     ) c
WHERE views < avg_views;

SELECT group_no          `分组编号`,
       MAX(asking_price) `该组最高底价`,
       MIN(asking_price) `该组最低底价`,
       AVG(asking_price) `该组平均底价`
FROM (
         SELECT asking_price,
                NTILE(6) over (ORDER BY asking_price DESC) `group_no`
         FROM auction
     ) c
GROUP BY group_no
ORDER BY group_no;

SELECT category_id                    `商品类别`,
       MAX(asking_price)              `最高起拍价`,
       AVG(MAX(asking_price)) OVER () `平均最高起拍价`
FROM auction
GROUP BY category_id;


SELECT ended                                        `拍卖结束日期`,
       AVG(views)                                   `平均浏览量`,
       DENSE_RANK() OVER (ORDER BY AVG(views) DESC) `行号`
FROM auction
GROUP BY ended;


USE northwind;

SELECT p.product_name `商品名称`,
       oi.unit_price  `购买单价`,
       oi.quantity    `购买数量`,
       s.company_name `供应商公司名称`
FROM order_items oi
         LEFT JOIN products p on oi.product_id = p.product_id
         LEFT JOIN suppliers s on p.supplier_id = s.supplier_id
WHERE oi.order_id = 10248;

SELECT product_name,
       oi.unit_price,
       oi.quantity,
       company_name AS `supplier_name`
FROM order_items oi
         JOIN products p
              ON oi.product_id = p.product_id
         JOIN suppliers s
              ON s.supplier_id = p.supplier_id
WHERE oi.order_id = 10248;

SELECT p.product_name      `商品名称`,
       s.company_name      `供应商公司名称`,
       c.category_id       `商品类别名称`,
       p.unit_price        `商品销售单价`,
       p.quantity_per_unit `每单位商品数量`
FROM products p
         JOIN suppliers s on p.supplier_id = s.supplier_id
         JOIN categories c on p.category_id = c.category_id;

SELECT COUNT(*) `2013年入职员工数量`
FROM employees
WHERE YEAR(hire_date) = 2013;


SELECT s.supplier_id               `供应商ID`,
       company_name                `供应商公司名称`,
       COUNT(DISTINCT category_id) `商品种类数量`
FROM products p
         JOIN suppliers s on p.supplier_id = s.supplier_id
GROUP BY s.supplier_id;

SELECT o.order_id                       `订单ID`,
       SUM(oi.unit_price * oi.quantity) `订单总价-折扣前`
FROM orders o
         JOIN order_items oi on o.order_id = oi.order_id
WHERE o.order_id = 10250;



SELECT e.employee_id     `员工ID`,
       first_name        `名`,
       last_name         `姓`,
       COUNT(o.order_id) `处理订单总数`
FROM employees e
         JOIN orders o on e.employee_id = o.employee_id
GROUP BY e.employee_id, first_name, last_name;

SELECT p.category_id                    `商品分类ID`,
       c.category_name                  `商品类别名称`,
       SUM(unit_price * units_in_stock) `库存商品总价值`
FROM products p
         join categories c on p.category_id = c.category_id
GROUP BY p.category_id, c.category_name;


SELECT c.customer_id `客户ID`,
       c.company_name,
       COUNT(o.order_id)
FROM customers c
         JOIN orders o on c.customer_id = o.customer_id
GROUP BY c.customer_id, c.company_name;

SELECT COUNT(*)   `客户总数`,
       COUNT(fax) `带有传真号码的客户数量`
FROM customers;

SELECT s.company_name    `供应商公司名称`,
       COUNT(product_id) `提供的产品数量`
FROM products
         RIGHT JOIN suppliers s on products.supplier_id = s.supplier_id
GROUP BY s.supplier_id, s.company_name;


SELECT COUNT(DISTINCT product_id) `不同产品数`
FROM orders o
         JOIN order_items oi on o.order_id = oi.order_id
WHERE ship_country = 'France';


SELECT COUNT(*)               `供应商总数`,
       COUNT(region)          `分配了地区的供应商数量`,
       COUNT(DISTINCT region) `多少个不同的区域`
FROM suppliers;


SELECT e.first_name,
       e.last_name,
       SUM(unit_price * quantity) `订单总金额`
FROM employees e
         JOIN orders o on e.employee_id = o.employee_id
         JOIN order_items oi on o.order_id = oi.order_id
WHERE order_date >= '2016-07-05'
  AND order_date < '2016-08-01'
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY '订单总金额' DESC;

SELECT first_name,
       last_name,
       hire_date,
       CASE
           WHEN hire_date > '2014-01-01' THEN 'junior'
           WHEN hire_date > '2013-01-01' THEN 'middle'
           WHEN hire_date <= '2013-01-01' THEN 'senior'
           END AS `experience`
FROM employees;

SELECT CASE
           WHEN birth_date > '1980-01-01' THEN 'Young'
           ELSE 'Old'
           END  AS `age_group`,
       COUNT(*) AS `employee_count`
FROM employees
GROUP BY age_group;


SELECT COUNT(CASE
                 WHEN contact_title = 'Owner' THEN customer_id
    END)        AS `represented_by_owner`,
       COUNT(CASE
                 WHEN contact_title != 'Owner' THEN customer_id
           END) AS `not_represented_by_owner`
FROM customers;

SELECT c.category_name,
       COUNT(CASE
                 WHEN units_in_stock > 30 THEN product_id
           END) AS `high_availability`,
       COUNT(CASE
                 WHEN units_in_stock <= 30 THEN product_id
           END) AS `low_availability`
FROM products p
         JOIN categories c
              ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name;

SELECT SUM(CASE
               WHEN discount = 0 THEN 1
    END)        AS `full_price`,
       SUM(CASE
               WHEN discount != 0 THEN 1
           END) AS `discounted_price`
FROM orders o
         JOIN order_items oi
              ON o.order_id = oi.order_id
WHERE ship_country = 'France';

SELECT s.supplier_id,
       s.company_name,
       SUM(units_in_stock)                           AS `all_units`,
       SUM(IF(unit_price > 40.0, units_in_stock, 0)) AS `expensive_units`
FROM products p
         JOIN suppliers s
              ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_id, s.company_name;

SELECT product_id,
       product_name,
       unit_price,
       CASE
           WHEN unit_price > 100 THEN 'expensive'
           WHEN unit_price > 40 THEN 'average'
           ELSE 'cheap'
           END AS price_level
FROM products;

SELECT COUNT(CASE
                 WHEN freight >= 80.0 THEN order_id
    END)        AS `high_freight`,
       COUNT(CASE
                 WHEN freight < 40.0 THEN order_id
           END) AS `low_freight`,
       COUNT(CASE
                 WHEN freight >= 40.0 AND freight < 80.0 THEN order_id
           END) AS `avg_freight`
FROM orders;

