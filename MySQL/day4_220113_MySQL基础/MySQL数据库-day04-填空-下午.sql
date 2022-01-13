# ============================================ 报表案例：数据集介绍 ============================================

-- 练习1
-- 需求：查看员工表中的表结构
DESC employees;

-- 练习2
-- 需求：查看客户表的表结构
DESC customers;

-- 练习3
-- 需求：查看商品类别表的表结构
DESC categories;

-- 练习4
-- 需求：查看商品表的表结构
DESC products;

-- 练习5
-- 需求：查看供应商表的表结构
DESC suppliers;

-- 练习6
-- 需求：查看订单表的表结构
DESC orders;

-- 练习7
-- 需求：查看订单明细表的表结构
DESC order_items;


-- 练习8
-- 需求：查询每一个商品的`product_name`、`category_name`、`quantity_per_unit`、`unit_price`、`units_in_stock` 并且通过 `unit_price` 字段排序
SELECT product_name,
       category_name,
       quantity_per_unit,
       unit_price,
       units_in_stock
FROM products
         JOIN categories
              ON products.category_id = categories.category_id
ORDER BY unit_price;



-- 练习9
-- 需求：查询提供了3种以上不同商品的供应商列表
-- 查询结果字段：
-- 	suppler_id(供应商ID)、company_name(供应商公司名称)、products_count(提供的商品数量)
SELECT s.supplier_id,
       s.company_name,
       COUNT(*) `products_count`
FROM suppliers s
         JOIN products p
              ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_id, s.company_name
HAVING products_count > 3;


-- 在标准的 SQL 分组聚合中，除了聚合的结果，其他的列如果在GROUP BY没有出现，不允许出现在 SELECT 中
-- 在 MySQL 的分组聚合中，SELECT后面的列值只要在每组内都是唯一的，即使在 GROUP BY 中没有出现，MySQL也不会报错

-- MySQL测试版数据库：不会报错


# ============================================ 报表案例：SQL 数据汇总 ============================================

-- 1.1 详细报告

-- 练习1
-- 需求：查询运输到法国的订单信息，返回如下结果
--
-- 查询结果字段：
-- customer_company_name(客户公司名称)、employee_first_name和employee_last_name(销售员工姓名)、order_date(下单日期)、shipped_date(发货日期)、ship_country(收货国家)
SELECT c.company_name `customer_company_name`,
       e.first_name   `employee_first_name`,
       e.last_name    `emloyee_last_name`,
       o.order_date,
       o.shipped_date,
       o.ship_country
FROM orders o
         JOIN employees e
              ON o.employee_id = e.employee_id
         JOIN customers c
              ON o.customer_id = c.customer_id
WHERE o.ship_country = 'France';



-- 练习2
-- 需求：查询订单编号为10250的订单详情，按商品名称排序，返回如下结果
-- 查询结果字段：
-- 	product_name(商品名称)、quantity(购买数量)、unit_price(购买单价)、discount(折扣)、order_date(下单日期)
SELECT p.product_name,
       oi.quantity,
       oi.unit_price,
       oi.discount,
       o.order_date
FROM orders o
         JOIN order_items oi on o.order_id = oi.order_id
         JOIN products p on oi.product_id = p.product_id
WHERE o.order_id = 10250
ORDER BY p.product_name;



-- 1.2 带时间限制的报表

-- 练习3
-- 需求：统计2016年7月的订单数量
-- 查询结果字段：
-- 	order_count(2016年7月的订单数量)
SELECT COUNT(*) `order_count`
FROM orders
WHERE order_date >= '2016-07-01'
  AND order_date <= '2016-07-31';



-- 1.3 计算多个对象

-- 练习4
-- 需求：统计订单号在10200-10260之间的订单中的总商品件数
-- 查询结果字段：
-- 	order_id(订单ID)、order_items_count(订单中的总商品件数)
SELECT order_id,
       COUNT(*) `order_items_count`
FROM order_items
WHERE order_id BETWEEN 10200 AND 10260
GROUP BY order_id;


-- 1.4 订单金额计算

-- 练习5
-- 需求：统计ID为10250的订单的总价（折扣前）
-- 查询结果字段：
-- 	order_id(订单ID)、total_price(订单总价-折扣前)
SELECT SUM(unit_price * quantity) `total_price`
FROM order_items
WHERE order_id = 10250;



-- 练习6
-- 需求：统计运输到法国的每个订单的总金额
-- 查询结果字段：
-- 	order_id(订单ID)、company_name(客户公司名称)、total_price(每个订单的总金额)
SELECT o.order_id                       `订单ID`,
       c.company_name                   `客户公司名称`,
       SUM(oi.unit_price * oi.quantity) `total_price`
FROM orders o
         JOIN order_items oi on o.order_id = oi.order_id
         JOIN customers c on o.customer_id = c.customer_id
WHERE o.ship_country = 'France'
GROUP BY o.order_id, c.company_name;


-- 1.5 GROUP BY 分组操作

-- 注意1：使用GROUP BY分组聚合统计时，需要考虑分组字段中的相同值的业务含义是否相同

-- 练习7
-- 需求：统计每个员工销售的订单数量
--
-- 查询结果字段：
-- 	first_name和last_name(员工姓和名)、orders_count(员工销售订单数)
SELECT e.first_name,
       e.last_name,
       COUNT(*) `orders_count`
FROM employees e
         JOIN orders o on e.employee_id = o.employee_id
GROUP BY e.employee_id,
         e.first_name,
         e.last_name;



-- 注意2：GROUP BY之后的分组字段不是必须在 SELECT 中出现

-- 练习8
-- 需求：统计2016年6月到2016年7月每个客户的总下单金额，并按金额从高到低排序
--
-- 提示：
-- 	计算实际总付款金额： SUM(unit_price * quantity * (1 - discount))
--
-- 查询结果字段：
-- 	company_name(客户公司名称)、total_paid(客户总下单金额-折扣后)
SELECT c.company_name,
       SUM(oi.unit_price * oi.quantity * (1 - oi.discount)) `total_paid`
FROM customers c
         JOIN orders o on c.customer_id = o.customer_id
         JOIN order_items oi on o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2016
  AND MONTH(o.order_date) BETWEEN 6 AND 7
GROUP BY c.customer_id, c.company_name
ORDER BY total_paid DESC;



-- 1.6 COUNT()计数统计注意点

-- 注意点1：`COUNT(*)` 和 `COUNT(列名)`之间的区别
-- * COUNT(*)：进行计数，包括NULL
-- * COUNT(列名)：对指定列的非NULL数据进行计数

-- 练习9
-- 需求：统计要发货到不同国家的订单数量以及已经发货的订单数量
--
-- 提示：
-- 	shipped_date为NULL，表示还未发货
--
-- 查询结果字段：
-- 	ship_country(国家)、all_orders(总订单数)、shipped_orders(已发货订单数)
SELECT ship_country        '国家',
       COUNT(*)            `总订单数`,
       COUNT(shipped_date) `已发货订单数量`
FROM orders
GROUP BY ship_country;


-- 注意点2：`COUNT()` 和 `LEFT JOIN` 配合使用
-- 使用SQL出报表时，必须记住关联某些对象可能不存在

-- 练习10
-- 需求：统计客户ID为 ALFKI、FISSA、PARIS 这三客户各自的订单总数，没有订单的客户也计算在内
--
-- 查询结果字段：
-- 	customer_id(客户ID)、company_name(客户公司名称)、orders_count(客户订单总数)
SELECT c.customer_id,
       c.company_name,
       COUNT(o.order_id) `orders_count`
FROM customers c
         LEFT JOIN orders o on c.customer_id = o.customer_id
WHERE c.customer_id IN ('ALFKI', 'FISSA', 'PARIS')
GROUP BY c.customer_id, c.company_name;



-- 注意点3：COUNT()统计时考虑是否需要去重

-- 练习11
-- 需求：查询订单运送到西班牙的客户数量
--
-- 提示：
-- 	一个客户可能下了多个订单
--
-- 查询结果字段：
-- 	number_of_companies(客户数)
SELECT COUNT(DISTINCT customer_id) `number_of_companies`
FROM orders
WHERE ship_country = 'Spain';

# ============================================ 报表案例：CASE WHEN 语法 ============================================
-- 1.1 CASE WHEN自定义分组

-- 练习1
-- 需求：我们要在报表中显示每种产品的库存量，但我们不想简单地将"units_in_stock"列放在报表中，
-- 还需要按照如下规则显示一个库存级别列：
--
-- 	库存>100，显示 "high"
-- 	50 < 库存 <= 100，显示 "moderate"
-- 	0 < 库存 <= 50，显示 "low"
-- 	库存=0，显示 "none"
--
-- 查询结果字段：
-- 	product_id(商品ID)、product_name(商品名称)、units_in_stock(商品库存量)、stock_level(库存级别)
SELECT product_id,
       product_name,
       units_in_stock,
       CASE
           WHEN units_in_stock > 100 THEN 'HIGH'
           WHEN units_in_stock > 50 THEN 'MODERATE'
           WHEN units_in_stock > 0 THEN 'LOW'
           WHEN units_in_stock = 0 THEN 'NONE'
           END `stock level`
FROM products;

-- 1.2 CASE WHEN中ELSE的使用

-- 练习2
-- 需求：查询客户基本信息报表，返回结果如下：
--
-- 查询结果字段：
-- 	customer_id(客户ID)、company_name(公司名称)、country(所在国家)、language(使用语言)
--
-- 使用语言的取值规则如下：
-- 	Germany、Switzerland、and Austria 语言为德语 'German'
-- 	UK、Canada、the USA、and Ireland 语言为英语 'English'
-- 	其他所有国家 'Other'
SELECT customer_id,
       company_name,
       country,
       CASE
           WHEN country IN ('Germany', 'Switzerland', 'Austria') THEN 'German'
           WHEN country IN ('UK', 'Canada', 'the USA', 'Ireland') THEN 'English'
           ELSE 'Other'
           END `language`
FROM customers;

-- 练习3
-- 需求：创建报表统计来自不同大洲的供应商
--
-- 查询结果字段：
-- 	supplier_id(供应商ID)、supplier_continent(大洲)
--
-- 供应商来自哪个大洲的取值规则：
-- 	`USA`和`Canada`两个国家的大洲取值为：'North America'
-- 	`Japan`和`Singapore`两个国家的大洲取值为：'Asia'
-- 	其他国家的大洲取值为 'Other'

-- 标准SQL中, GROUP BY后不能使用别名
SELECT CASE
           WHEN s.country IN ('USA', 'Canada') THEN 'North America'
           WHEN s.country IN ('Japan', 'Singapore') THEN 'Asia'
           ELSE 'Other'
           END             `supplier_continent`,
       COUNT(p.product_id) `products_count`
FROM suppliers s
         LEFT JOIN products p on s.supplier_id = p.supplier_id
GROUP BY CASE
             WHEN s.country IN ('USA', 'Canada') THEN 'North America'
             WHEN s.country IN ('Japan', 'Singapore') THEN 'Asia'
             ELSE 'Other'
             END;

-- MySQL中, 可以使用别名
SELECT CASE
           WHEN s.country IN ('USA', 'Canada') THEN 'North America'
           WHEN s.country IN ('Japan', 'Singapore') THEN 'Asia'
           ELSE 'Other'
           END             `supplier_continent`,
       COUNT(p.product_id) `products_count`
FROM suppliers s
         LEFT JOIN products p on s.supplier_id = p.supplier_id
GROUP BY `supplier_continent`;

-- 1.3 在GROUP BY中使用CASE WHEN

-- 练习4
-- 需求：创建报表统计来自不同大洲的供应商的供应的产品数量(包含未供应产品的供应商)
--
-- 查询结果字段：
-- 	supplier_continent(大洲)、products_count(供应产品数量)
--
-- 供应商来自哪个大洲的取值规则：
-- 	`USA`和`Canada`两个国家的大洲取值为：'North America'
-- 	`Japan`和`Singapore`两个国家的大洲取值为：'Asia'
-- 	其他国家的大洲取值为 'Other'
SELECT CASE
           WHEN s.country IN ('USA', 'Canada') THEN 'North America'
           WHEN s.country IN ('Japan', 'Singapore') THEN 'Asia'
           ELSE 'Other'
           END             `supplier_continent`,
       COUNT(p.product_id) `product_count`
FROM suppliers s
         LEFT JOIN products p on s.supplier_id = p.supplier_id
GROUP BY supplier_continent;



-- 1.4 CASE WHEN 和 COUNT
-- 可以将 CASE WHEN 和 COUNT 结合使用，自定义分组并统计每组数据数量


-- 练习5
-- 需求：Washington (WA) 是 Northwind 的主要运营地区，统计有多少订单是由华盛顿地区的员工处理的，多少订单是有其他地区的员工处理的
-- 
-- 查询结果字段：
-- 	orders_wa_employees(华盛顿地区员工处理订单数)、orders_not_wa_employees(其他地区员工处理订单数)
SELECT COUNT(
               CASE
                   WHEN e.region = 'WA' THEN order_id
                   END
           ) `orders_wa_employees`,
       COUNT(
               CASE
                   WHEN region != 'WA' THEN order_id
                   END
           ) `orders_not_wa_employees`
FROM employees e
         JOIN orders o
              ON e.employee_id = o.employee_id;

-- 1.5 GROUP BY 和 CASE WHEN组合使用
-- 将COUNT(CASE WHEN...) 和 GROUP BY 组合使用，可以创建更复杂的报表

-- 练习6
-- 需求：统计运往不同国家的订单中，低运费订单、一般运费订单、高运费订单的数量
-- 
-- 查询结果字段：
-- 	ship_country(订单运往国家)、low_freight(低运费订单数量)、moderate_freight(一般运费订单数量)、high_freight(高运费订单数量)
SELECT ship_country,
       COUNT(*)                                                         `order_count`,
       COUNT(CASE
                 WHEN freight < 40 THEN order_id
           END)                                                         `low_freight`,
       COUNT(CASE
                 WHEN freight >= 40 AND freight < 80 THEN order_id END) `moderate_freight`,
       COUNT(CASE
                 WHEN freight >= 80 THEN order_id END)                  `high_freight`
FROM orders
GROUP BY ship_country;



-- 1.6 SUM 中使用 CASE WHEN
-- 上面通过我们通过 COUNT() 函数 和CASE WHEN子句联合使用来创建的报表，也可以通过 SUM() 来替代 COUNT()


-- 练习7
-- 需求：Washington (WA) 是 Northwind 的主要运营地区，统计有多少订单是由华盛顿地区的员工处理的，多少订单是有其他地区的员工处理的
-- 
-- 查询结果字段：
-- 	orders_wa_employees(华盛顿地区员工处理订单数)、orders_not_wa_employees(其他地区员工处理订单数)
SELECT COUNT(
               CASE
                   WHEN e.region = 'WA' THEN order_id
                   END
           ) `orders_wa_employees`,
       COUNT(
               CASE
                   WHEN region != 'WA' THEN order_id
                   END
           ) `orders_not_wa_employees`
FROM employees e
         JOIN orders o
              ON e.employee_id = o.employee_id;

-- 使用 SUM 来替代 COUNT
SELECT SUM(
               CASE
                   WHEN e.region = 'WA' THEN 1
                   END
           ) `orders_wa_employees`,
       SUM(
               CASE
                   WHEN region != 'WA' THEN 1
                   END
           ) `orders_not_wa_employees`
FROM employees e
         JOIN orders o
              ON e.employee_id = o.employee_id;

-- 1.7 SUM中使用CASE WHEN进行复杂计算

-- 练习8
-- 需求：统计每个订单的总金额(折扣后)以及该订单中非素食产品的总金额(折扣后)
-- 
-- 查询结果字段：
-- 	order_id(订单ID)、total_price(订单总金额-折扣后)、non_vegetarian_price(订单非素食产品的总金额-折扣后)
-- 	
-- 提示：非素食产品的产品ID （ category_id） 是 6 和 8
SELECT o.order_id,
       SUM(quantity * oi.unit_price * (1 - discount)) `total_price`,
       SUM(CASE
               WHEN p.category_id IN (6, 8)
                   THEN quantity * oi.unit_price * (1 - discount)
               ELSE 0
           END)                                       `non_vegetarian_price`
FROM orders o
         JOIN order_items oi on o.order_id = oi.order_id
         JOIN products p on oi.product_id = p.product_id
GROUP BY o.order_id;

-- 练习9
-- 需求：制作报表统计所有订单的总价(折扣前)，并将订单按总价分成3类：high、average、low
-- 
-- 查询结果字段：
-- 	order_id(订单ID)、total_price(订单总金额)、price_group(订单总金额分类)
-- 
-- 订单总金额分类规则：
-- 	总价超过2000美元：'high'
-- 	总价在600到2000美元之间：'average'
-- 	总价低于600美元：'low'
SELECT o.order_id,
       SUM(unit_price * quantity) `total_price`,
       CASE
           WHEN SUM(unit_price * quantity) > 2000 THEN 'high'
           WHEN SUM(oi.unit_price * oi.quantity) > 600 THEN 'average'
           ELSE 'low'
           END                    `price_group`
FROM orders o
         JOIN order_items oi on o.order_id = oi.order_id
GROUP BY o.order_id;


CREATE TABLE Product_practice
(
    Product VARCHAR(30),
    Price   INT
);

INSERT INTO Product_practice
VALUES ('笔记本', 3050),
       ('手机', 2800),
       ('台式电脑', 2050);

UPDATE Product_practice
SET Price = CASE WHEN Price > 3000 THEN Price * 0.9 ELSE Price * 1.2 END;

UPDATE Product_practice
SET Price = IF(Price > 3000, Price * 0.9, Price * 1.2);