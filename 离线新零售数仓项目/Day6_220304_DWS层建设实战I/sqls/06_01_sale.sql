select * from t_order_detail;

--- 指标：订单量、销售额
-- 维度：日期、日期+品牌

--方式1  祖传分组查询+union all

----- 指标：订单量、销售额
-- 维度：日期
select
    dt,
    count(distinct oid) as "订单量",
    sum(g_price) as "销售额"
from t_order_detail
group by dt;

----- 指标：订单量、销售额
-- 维度：日期+品牌

select
    dt,
    brand_id,
    count(distinct oid) as "各品牌订单量",
    sum(g_price) as "各品牌销售额"
from t_order_detail
group by dt,brand_id;

--最终 使用union all 合并
select
    dt as "日期",
    null as brand_id,
    count(distinct oid) as "订单量",
    null as "各品牌订单量",
    sum(g_price) as "销售额",
    null as "各品牌销售额"
from t_order_detail
group by dt
union all
select
    dt as "日期",
    brand_id,
    null as "订单量",
    count(distinct oid) as "各品牌订单量",
    null as "销售额",
    sum(g_price) as "各品牌销售额"
from t_order_detail
group by dt,brand_id;

---方式2  使用grouping sets计算
select
    dt as "日期",
    case when grouping(brand_id) = 0
        then brand_id else null end  as "品牌ID",
    case when grouping(brand_id) = 1
        then count(distinct oid) else null end as "订单量",
    case when grouping(brand_id) = 0
        then count(distinct oid) else null end as "各品牌订单量",
    case when grouping(brand_id) = 1
        then sum(g_price) else null end as "销售额",
    case when grouping(brand_id) = 0
        then sum(g_price) else null end as "各品牌销售额",
    case when grouping(brand_id) = 0
         then '品牌指标' else '仅日期指标' end as "group_type"
from t_order_detail
group  by grouping sets((dt),(dt,brand_id));

---------------模型升级 去重的问题
select * from t_order_detail_dup;

--问题：如何判断数据是重复的？
-- 找出最少的字段 能够识别出重复的数据  当然 所有字段都参与也行 只不过没必要

--问题：怎么去重？使用什么技术？
-- distinct  group by去重  row_number去重

--例1： 只以订单id去重
select * ,
    row_number() over(partition by oid ) as rn1
from t_order_detail_dup;

with tmp as (select * ,
    row_number() over(partition by oid ) as rn1
from t_order_detail_dup)
select * from tmp where rn1 =1;

----例2： 以订单id和goods_id

with tmp as (select * ,
    row_number() over(partition by oid,goods_id ) as rn2
from t_order_detail_dup)
select * from tmp where rn2 =1;

--
with tmp as (select * ,
    row_number() over(partition by oid,goods_id ) as rn2
from t_order_detail_dup)
select * from tmp where rn2 =1;

















