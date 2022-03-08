#! /bin/bash
export LANG=zh_CN.UTF-8
PRESTO_HOME=/export/server/presto/bin/presto


${PRESTO_HOME} --catalog hive --server 192.168.88.80:8090 --execute "
-- 门店月销售单量排行
insert into yp_rpt.rpt_sale_store_cnt_month
select 
   year_code,
   year_month,
   province_id,
   province_name,
   city_id,
   city_name,
   trade_area_id,
   trade_area_name,
   store_id,
   store_name,
   order_cnt,
   miniapp_order_cnt,
   android_order_cnt,
   ios_order_cnt,
   pcweb_order_cnt,
   sale_amt, mini_app_sale_amt, android_sale_amt, ios_sale_amt, pcweb_sale_amt,
   date_time
from yp_dm.dm_sale 
where time_type ='month' and group_type='store' and store_id is not null
-- 计算日期-最新计算的数据
-- and date_time = '${TD_DATE}' 
order by order_cnt desc;

--日销售曲线
insert into yp_rpt.rpt_sale_day
select 
   year_code,
   month_code,
   day_month_num,
   dim_date_id,
   sale_amt,
   order_cnt,
   date_time
from yp_dm.dm_sale 
where time_type ='date' and group_type='all'
-- 计算日期-最新计算的数据
-- and date_time = '${TD_DATE}' 
--按照日期排序显示曲线
order by dim_date_id;

--月销售曲线
insert into yp_rpt.rpt_sale_month
select 
   year_code,
   month_code,
   year_month,
   sale_amt,
   plat_amt, mini_app_sale_amt, android_sale_amt, ios_sale_amt, pcweb_sale_amt,
   order_cnt,
   deliver_order_cnt,
   refund_order_cnt,
   bad_eva_order_cnt, miniapp_order_cnt, android_order_cnt, ios_order_cnt, pcweb_order_cnt,
   date_time
from yp_dm.dm_sale 
where time_type ='month' and group_type='all'
--按照日期排序显示曲线
order by dim_date_id;

--渠道销量占比
insert into yp_rpt.rpt_sale_fromtype_ratio
select 
   time_type,
   year_code,
   year_month,
   dim_date_id,
   order_cnt,
   sale_amt,
   miniapp_order_cnt,
   mini_app_sale_amt,
   cast(miniapp_order_cnt as DECIMAL(38,4)) / cast(order_cnt as DECIMAL(38,4))
      * 100
   miniapp_order_ratio,
   android_order_cnt,
   android_sale_amt,
   cast(android_order_cnt as DECIMAL(38,4)) / cast(order_cnt as DECIMAL(38,4))
      * 100
   android_order_ratio,
   ios_order_cnt,
   ios_sale_amt,
   cast(ios_order_cnt as DECIMAL(38,4)) / cast(order_cnt as DECIMAL(38,4))
      * 100
   ios_order_ratio,
   pcweb_order_cnt,
   pcweb_sale_amt,
   cast(pcweb_order_cnt as DECIMAL(38,4)) / cast(order_cnt as DECIMAL(38,4))
      * 100
   pcweb_order_ratio,
   date_time
from yp_dm.dm_sale
where group_type = 'all';
-- 计算日期-最新计算的数据
-- and date_time = '${TD_DATE}';


-- 商品销量topn
insert into yp_rpt.rpt_goods_sale_topn
select
    sku_id, sku_name,
    payment_count, payment_amount,
    dt
from
    yp_dws.dws_sku_daycount
order by payment_count desc;

-- 商品收藏topn
insert into yp_rpt.rpt_goods_favor_topn
select
    sku_id, sku_name,
    favor_count,
    dt
from
    yp_dws.dws_sku_daycount
order by favor_count desc;

-- 商品加入购物车topn
insert into yp_rpt.rpt_goods_cart_topn
select
    sku_id, sku_name,
    cart_num,
    '2021-08-31' dt
from
    yp_dws.dws_sku_daycount
order by cart_num desc;

-- 商品退款率TopN
insert into yp_rpt.rpt_goods_refund_topn
select
    sku_id, sku_name,
    cast(refund_count as DECIMAL(38,4)) / cast(order_count as DECIMAL(38,4))
      * 100
    refund_ratio,
    '2021-08-31'
from yp_dm.dm_sku
where order_count!=0 and refund_count!=0
order by refund_ratio desc;

-- 商品月度消费监控
insert into yp_rpt.rpt_goods_sale
select
    year_month,
    sku_id, sku_name,
    order_count,
    order_num,
    order_amount,
    payment_count,
    payment_num,
    payment_amount,
    refund_count,
    refund_num,
    refund_amount,
    cart_count,
    cart_num,
    favor_count,
    case when payment_num != 0
        then cast(refund_num as DECIMAL(38,4)) / cast(payment_num as DECIMAL(38,4)) * 100
        else 0.0000
    end
    as refund_ratio,
    '2021-08-31'
from yp_dm.dm_sku
where time_type='month';


--商品差评率topn
insert into yp_rpt.rpt_evaluation_bad_topn
select
    sku_id, sku_name,
	cast(evaluation_bad_count as DECIMAL(38,4)) / (evaluation_good_count+evaluation_mid_count+evaluation_bad_count)
		* 100 as evaluation_bad_ratio,
    '2021-08-31' dt
from
    yp_dws.dws_sku_daycount 
where
    (evaluation_good_count+evaluation_mid_count+evaluation_bad_count) != 0
order by evaluation_bad_ratio desc;


-- 商品评价月度排行
insert into yp_rpt.rpt_evaluation_topn_month
select
    year_month, sku_id, sku_name,
    evaluation_good_count, evaluation_mid_count, evaluation_bad_count,
	cast(evaluation_good_count as DECIMAL(38,4)) / (evaluation_good_count+evaluation_mid_count+evaluation_bad_count)
		* 100 as evaluation_good_ratio,
    cast(evaluation_mid_count as DECIMAL(38,4)) / (evaluation_good_count+evaluation_mid_count+evaluation_bad_count)
		* 100 as evaluation_mid_ratio,
    cast(evaluation_bad_count as DECIMAL(38,4)) / (evaluation_good_count+evaluation_mid_count+evaluation_bad_count)
		* 100 as evaluation_bad_ratio,
    '2021-08-31' dt
from
    yp_dm.dm_sku
where date_time='2021-08-31' and time_type='month' and
    (evaluation_good_count+evaluation_mid_count+evaluation_bad_count) != 0
order by evaluation_good_ratio desc;


-- 用户数量日统计报表
--用户数量统计
insert into yp_rpt.rpt_user_count
select
    sum(if(login_date_last='2021-08-31',1,0)) day_users,
    sum(if(login_date_first='2021-08-31',1,0)) day_new_users,
    sum(if(payment_date_first='2021-08-31',1,0)) day_new_payment_users,
    sum(if(payment_date_last='2021-08-31',1,0)) day_payment_users,
    sum(if(payment_count>0,1,0)) payment_users,
    count(*) users,
--  会员活跃率(活跃会员/总会员)
--      活跃会员数
    cast(sum(if(login_date_last='2021-08-31',1,0)) as DECIMAL(38,4))
--      总会员数
    /if(count(*) = 0, null , count(*))
    * 100
    as day_users2users,
--  会员付费率（付费会员/活跃会员数）
--  付费会员
    cast(sum(if(payment_date_last='2021-08-31',1,0)) as DECIMAL(38,4))
--  活跃会员数
    /if(sum(if(login_date_last='2021-08-31',1,0)) = 0,
        null,
        sum(if(login_date_last='2021-08-31',1,0))
    )
    * 100
    as payment_users2users,
--  会员新鲜度（新增会员/活跃会员数）
--      新增会员
    cast(sum(if(login_date_first='2021-08-31',1,0)) as DECIMAL(38,4))
--      活跃会员数
    /if(sum(if(login_date_last='2021-08-31',1,0)) = 0,
        null,
        sum(if(login_date_last='2021-08-31',1,0))
    )
    * 100
    as day_new_users2users,
    '2021-08-31' dt
from yp_dm.dm_user
where date_time='2021-08-31' and time_type='all';

-- 用户数量月统计报表
insert into yp_rpt.rpt_user_month_count
select
    '2021-08' as year_month,
    substr(max(d.date_id_mym), 1, 7) yoy_month,
    substr(max(d.date_id_mom), 1, 7) mom_month,
--    活跃会员数：当月登陆过
    sum(if(u.year_month='2021-08' and login_count>0,1,0)) month_users,
--    新增会员数：首次登录日期是当月
    sum(if(u.time_type='all' and SUBSTRING(login_date_first, 1, 7)='2021-08',1,0)) month_new_users,
--  购物车会员数
    sum(if(u.year_month='2021-08' and u.cart_count>0,1,0)) month_cart_users,
    sum(if(u.time_type='all' and SUBSTRING(cart_date_first, 1, 7)='2021-08',1,0)) month_new_cart_users,
--  下单会员数
    sum(if(u.year_month='2021-08' and u.order_count>0,1,0)) month_order_users,
    sum(if(u.time_type='all' and SUBSTRING(order_date_first, 1, 7)='2021-08',1,0)) month_new_order_users,
--  月度付费会员数
    sum(if(u.year_month='2021-08' and payment_count>0,1,0)) month_payment_users,
    sum(if(u.time_type='all' and SUBSTRING(payment_date_first, 1, 7)='2021-08',1,0)) month_new_payment_users,
--  总会员数
    count(if(u.time_type='all', user_id, null)) users,
--  购物车总会员数
    count(if(u.time_type='all' and u.cart_count>0, user_id, null)) cart_users,
--  下单总会员数
    count(if(u.time_type='all' and u.order_count>0, user_id, null)) order_users,
--  总付费会员数
    sum(if(u.time_type='all' and payment_count>0,1,0)) payment_users,
--    ==会员活跃率
--        当月活跃会员
    cast(sum(if(u.year_month='2021-08' and login_count>0, 1, 0)) as DECIMAL(38,4))
--      /   总会员
    /if(
        count(if(u.time_type='all', user_id, null)) = 0,
        null,
        count(if(u.time_type='all', user_id, null))
    )
    * 100
    as month_users2users,
--    ==会员付费率
--        当月付费会员
    cast(sum(if(u.year_month='2021-08' and payment_count>0,1,0)) as DECIMAL(38,4))
--      /   当月活跃会员
    /if(
        sum(if(u.year_month='2021-08' and login_count>0,1,0))= 0,
        null,
        sum(if(u.year_month='2021-08' and login_count>0,1,0))
    )
    * 100
    as payment_users2users,
--    ==会员新鲜度
--        当月新增会员
    cast(sum(if(u.time_type='all' and SUBSTRING(login_date_first, 1, 7)='2021-08',1,0))  as DECIMAL(38,4))
--  /   当月活跃会员
    /if(sum(if(u.year_month='2021-08' and login_count>0,1,0)) = 0,
        null,
        sum(if(u.year_month='2021-08' and login_count>0,1,0))
    )
    * 100
    as day_new_users2users,
    '2021-08-31' dt
from yp_dm.dm_user u
-- 获取当前日期-以拿到同比月份
,yp_dwd.dim_date d
-- 根据统计日期获取数据（当月的统计数据和累计值统计数据）
where u.date_time='2021-08-31' and d.date_code='2021-08-31';


-- 7月份环比数据
insert into yp_rpt.rpt_user_month_count
select
    '2021-07' as year_month,
    substr(max(d.date_id_mym), 1, 7) yoy_month,
    substr(max(d.date_id_mom), 1, 7) mom_month,
--    活跃会员数：当月登陆过
    sum(if(u.year_month='2021-07' and login_count>0,1,0)) month_users,
--    新增会员数：首次登录日期是当月
    sum(if(u.time_type='all' and SUBSTRING(login_date_first, 1, 7)='2021-07',1,0)) month_new_users,
--  购物车会员数
    sum(if(u.year_month='2021-07' and u.cart_count>0,1,0)) month_cart_users,
    sum(if(u.time_type='all' and SUBSTRING(cart_date_first, 1, 7)='2021-07',1,0)) month_new_cart_users,
--  下单会员数
    sum(if(u.year_month='2021-07' and u.order_count>0,1,0)) month_order_users,
    sum(if(u.time_type='all' and SUBSTRING(order_date_first, 1, 7)='2021-07',1,0)) month_new_order_users,
--  月度付费会员数
    sum(if(u.year_month='2021-07' and payment_count>0,1,0)) month_payment_users,
    sum(if(u.time_type='all' and SUBSTRING(payment_date_first, 1, 7)='2021-07',1,0)) month_new_payment_users,
--  总会员数
    count(if(u.time_type='all', user_id, null)) users,
--  购物车总会员数
    count(if(u.time_type='all' and u.cart_count>0, user_id, null)) cart_users,
--  下单总会员数
    count(if(u.time_type='all' and u.order_count>0, user_id, null)) order_users,
--  总付费会员数
    sum(if(u.time_type='all' and payment_count>0,1,0)) payment_users,
--    ==会员活跃率
--        当月活跃会员
    cast(sum(if(u.year_month='2021-07' and login_count>0, 1, 0)) as DECIMAL(38,4))
--      /   总会员
    /if(
        count(if(u.time_type='all', user_id, null)) = 0,
        null,
        count(if(u.time_type='all', user_id, null))
    )
    * 100
    as month_users2users,
--    ==会员付费率
--        当月付费会员
    cast(sum(if(u.year_month='2021-07' and payment_count>0,1,0)) as DECIMAL(38,4))
--      /   当月活跃会员
    /if(
        sum(if(u.year_month='2021-07' and login_count>0,1,0))= 0,
        null,
        sum(if(u.year_month='2021-07' and login_count>0,1,0))
    )
    * 100
    as payment_users2users,
--    ==会员新鲜度
--        当月新增会员
    cast(sum(if(u.time_type='all' and SUBSTRING(login_date_first, 1, 7)='2021-07',1,0))  as DECIMAL(38,4))
--  /   当月活跃会员
    /if(sum(if(u.year_month='2021-07' and login_count>0,1,0)) = 0,
        null,
        sum(if(u.year_month='2021-07' and login_count>0,1,0))
    )
    * 100
    as day_new_users2users,
    '2021-08-31' dt
from yp_dm.dm_user u
-- 获取当前日期-以拿到同比月份
,yp_dwd.dim_date d
-- 根据统计日期获取数据（当月的统计数据和累计值统计数据）
where u.date_time='2021-08-31' and d.date_code='2021-07-31';
"