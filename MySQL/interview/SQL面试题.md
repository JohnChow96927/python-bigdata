![image-20220112111151580](../../imgs/image-20220112111151580.png)

## Q1. 求每个月的每个省份的店销销售额 （单个订单的销售额=quantity * unit_price)

```mysql
SELECT MONTH(order_datetime) '月份',
       province_name '省份',
       SUM(quantity * unit_price) '销售额'
FROM fact_order_detail
LEFT JOIN dim_store ds on fact_order_detail.store_id = ds.store_id
LEFT JOIN dim_city dc on ds.city_id = dc.city_id
LEFT JOIN dim_province dp on dc.province_id = dp.province_id
GROUP BY MONTH(order_datetime), province_name;
```

## Q2. 求每个月的每个产品的销街额及其在当月的销售额占比



## Q3. 求每个月的销售额及其环比（销售额环比 =（本月销售额 - 上月销售额）/上月销售额）

## Q4. 求每个月比较其上月的新增用户量及其留存率（新增用户"定义为上月未产生购买行为且木月产生了购买行为的用户，“留存用户”定义为上月产生过购买行为且本月也产生了购买行为的人，留存名=本月留存用户数量/上月产生过购买用户数量)





