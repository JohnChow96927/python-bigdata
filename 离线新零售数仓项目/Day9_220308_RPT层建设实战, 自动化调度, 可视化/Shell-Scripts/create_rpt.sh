#! /bin/bash
export LANG=zh_CN.UTF-8
HIVE_HOME=/usr/bin/hive


${HIVE_HOME} -S -e "
create database IF NOT EXISTS yp_rpt;

DROP TABLE IF EXISTS yp_rpt.rpt_sale_store_cnt_month;
CREATE TABLE yp_rpt.rpt_sale_store_cnt_month(
   year_code string COMMENT '年code',
   year_month string COMMENT '年月',
   
   province_id string COMMENT '省份id',
   province_name string COMMENT '省份名称',
   city_id string COMMENT '城市id',
   city_name string COMMENT '城市name',
   trade_area_id string COMMENT '商圈id',
   trade_area_name string COMMENT '商圈名称',
   store_id string COMMENT '店铺的id',
   store_name string COMMENT '店铺名称',
   
   order_store_cnt BIGINT COMMENT '店铺销售单量',
   miniapp_order_store_cnt BIGINT COMMENT '店铺小程序销售单量',
   android_order_store_cnt BIGINT COMMENT '店铺android销售单量',
   ios_order_store_cnt BIGINT COMMENT '店铺ios销售单量',
   pcweb_order_store_cnt BIGINT COMMENT '店铺pcweb销售单量',
   sale_amt DECIMAL(38,4) COMMENT '销售收入',
   mini_app_sale_amt DECIMAL(38,4) COMMENT '小程序成交额',
   android_sale_amt DECIMAL(38,4) COMMENT '安卓APP成交额',
   ios_sale_amt DECIMAL(38,4) COMMENT '苹果APP成交额',
   pcweb_sale_amt DECIMAL(38,4) COMMENT 'PC商城成交额'
)
COMMENT '门店月销售单量排行' 
-- 统计日期,不能用来分组统计
PARTITIONED BY(date_time STRING)
ROW format delimited fields terminated BY '\t' 
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');

DROP TABLE IF EXISTS yp_rpt.rpt_sale_day;
CREATE TABLE yp_rpt.rpt_sale_day(
   year_code string COMMENT '年code',
   month_code string COMMENT '月份编码', 
   day_month_num string COMMENT '一月第几天', 
   dim_date_id string COMMENT '日期',

   sale_amt DECIMAL(38,4) COMMENT '销售收入',
   order_cnt BIGINT COMMENT '订单量'
)
COMMENT '日销售曲线' 
-- 统计日期,不能用来分组统计
PARTITIONED BY(date_time STRING)
ROW format delimited fields terminated BY '\t' 
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');

DROP TABLE IF EXISTS yp_rpt.rpt_sale_month;
CREATE TABLE yp_rpt.rpt_sale_month(
   year_code string COMMENT '年code',
   month_code string COMMENT '月份编码', 
   year_month string COMMENT '年月',
   sale_amt DECIMAL(38,4) COMMENT '销售收入',
   plat_amt DECIMAL(38,4) COMMENT '平台收入',
   mini_app_sale_amt DECIMAL(38,4) COMMENT '小程序成交额',
   android_sale_amt DECIMAL(38,4) COMMENT '安卓APP成交额',
   ios_sale_amt DECIMAL(38,4) COMMENT '苹果APP成交额',
   pcweb_sale_amt DECIMAL(38,4) COMMENT 'PC商城成交额',
   order_cnt BIGINT COMMENT '订单量',
   deliver_order_cnt BIGINT COMMENT '配送单量',
   refund_order_cnt BIGINT COMMENT '退款单量',
   bad_eva_order_cnt BIGINT COMMENT '差评单量',
   miniapp_order_cnt BIGINT COMMENT '小程序成交单量',
   android_order_cnt BIGINT COMMENT '安卓APP订单量',
   ios_order_cnt BIGINT COMMENT '苹果APP订单量',
   pcweb_order_cnt BIGINT COMMENT 'PC商城成交单量'
)
COMMENT '日销售曲线' 
-- 统计日期,不能用来分组统计
PARTITIONED BY(date_time STRING)
ROW format delimited fields terminated BY '\t' 
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');


DROP TABLE IF EXISTS yp_rpt.rpt_sale_fromtype_ratio;
CREATE TABLE yp_rpt.rpt_sale_fromtype_ratio(
   time_type string COMMENT '统计时间维度：year、month、day',
   year_code string COMMENT '年code',
   year_month string COMMENT '年月',
   dim_date_id string COMMENT '日期',
   order_cnt BIGINT COMMENT '成交单量',
   order_turnover DECIMAL(38,4) COMMENT '成交额度',
   miniapp_order_cnt BIGINT COMMENT '小程序成交单量',
   miniapp_order_turnover DECIMAL(38,4) COMMENT '小程序成交额',
   miniapp_order_ratio DECIMAL(38,4) COMMENT '小程序成交量占比',
   android_order_cnt BIGINT COMMENT '安卓APP订单量',
   android_order_turnover DECIMAL(38,4) COMMENT '安卓APP成交额',
   android_order_ratio DECIMAL(38,4) COMMENT '安卓APP订单量占比',
   ios_order_cnt BIGINT COMMENT '苹果APP订单量',
   ios_order_turnover DECIMAL(38,4) COMMENT '苹果APP成交额',
   ios_order_ratio DECIMAL(38,4) COMMENT '苹果APP订单量占比',
   pcweb_order_cnt BIGINT COMMENT 'PC商城成交单量',
   pcweb_order_turnover DECIMAL(38,4) COMMENT 'PC商城成交额',
   pcweb_order_ratio DECIMAL(38,4) COMMENT 'PC商城成交单量占比'
)
COMMENT '渠道销量占比' 
-- 统计日期,不能用来分组统计
PARTITIONED BY(date_time STRING)
ROW format delimited fields terminated BY '\t' 
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');


drop table if exists yp_rpt.rpt_goods_sale_topn;
create table yp_rpt.rpt_goods_sale_topn(
    sku_id string COMMENT '商品ID',
    sku_name string COMMENT '商品名称',
    payment_num bigint COMMENT '销量',
    payment_amount decimal(38,4) comment '被支付金额'
) COMMENT '商品销量topn'
-- 统计日期,不能用来分组统计
PARTITIONED BY(dt STRING)
ROW format delimited fields terminated BY '\t'
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');

drop table if exists yp_rpt.rpt_goods_favor_topn;
create table yp_rpt.rpt_goods_favor_topn(
    sku_id string COMMENT '商品ID',
    sku_name string COMMENT '商品名称',
    favor_count bigint COMMENT '收藏量'
) COMMENT '商品收藏topn'
-- 统计日期,不能用来分组统计
PARTITIONED BY(dt STRING)
ROW format delimited fields terminated BY '\t' 
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');

drop table if exists yp_rpt.rpt_goods_cart_topn;
create table yp_rpt.rpt_goods_cart_topn(
    sku_id string COMMENT '商品ID',
    sku_name string COMMENT '商品名称',
    cart_num bigint COMMENT '加入购物车数量'
) COMMENT '商品加入购物车topn'
-- 统计日期,不能用来分组统计
PARTITIONED BY(dt STRING)
ROW format delimited fields terminated BY '\t' 
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');

drop table if exists yp_rpt.rpt_goods_refund_topn;
create table yp_rpt.rpt_goods_refund_topn(
    sku_id string COMMENT '商品ID',
    sku_name string COMMENT '商品名称',
    refund_ratio decimal(38,4) COMMENT '退款率'
) COMMENT '商品退款率topn'
-- 统计日期,不能用来分组统计
PARTITIONED BY(dt STRING)
ROW format delimited fields terminated BY '\t' 
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');

drop table if exists yp_rpt.rpt_goods_sale;
create table yp_rpt.rpt_goods_sale(
    year_month string COMMENT '年月',
    sku_id string COMMENT '商品ID',
    sku_name string COMMENT '商品名称',
    order_count bigint comment '被下单次数',
    order_num bigint comment '被下单件数',
    order_amount decimal(38,4) comment '被下单金额',
    payment_count   bigint  comment '被支付次数',
    payment_num bigint comment '被支付件数',
    payment_amount  decimal(38,4) comment '被支付金额',
    refund_count bigint comment '退款次数',
    refund_num bigint comment '退款件数',
    refund_amount decimal(38,4) comment '退款金额',
    cart_count bigint comment '被加入购物车次数',
    cart_num bigint comment '被加入购物车件数',
    favor_count bigint comment '被收藏次数',
    refund_ratio decimal(38,4) COMMENT '退款率'
) COMMENT '商品月度消费监控'
-- 统计日期,不能用来分组统计
PARTITIONED BY(dt STRING)
ROW format delimited fields terminated BY '\t' 
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');

drop table if exists yp_rpt.rpt_evaluation_bad_topn;
create table yp_rpt.rpt_evaluation_bad_topn(
    sku_id string COMMENT '商品ID',
    sku_name string COMMENT '商品名称',
    evaluation_bad_ratio DECIMAL(38,4) COMMENT '差评率'
) COMMENT '商品差评率topn'
-- 统计日期,不能用来分组统计
PARTITIONED BY(dt STRING)
ROW format delimited fields terminated BY '\t' 
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');

DROP table if exists yp_rpt.rpt_evaluation_topn_month;
create table yp_rpt.rpt_evaluation_topn_month(
    year_month string COMMENT '年月',
    sku_id string COMMENT '商品ID',
    sku_name string COMMENT '商品名称',
    evaluation_good_count bigint comment '好评数',
    evaluation_mid_count bigint comment '中评数',
    evaluation_bad_count bigint comment '差评数',
    evaluation_good_ratio DECIMAL(38,4) COMMENT '好评率',
    evaluation_mid_ratio DECIMAL(38,4) COMMENT '中评率',
    evaluation_bad_ratio DECIMAL(38,4) COMMENT '差评率'
) COMMENT '商品评价月度排行'
-- 统计日期,不能用来分组统计
PARTITIONED BY(dt STRING)
ROW format delimited fields terminated BY '\t'
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');

drop table if exists yp_rpt.rpt_user_count;
create table yp_rpt.rpt_user_count(
    day_users BIGINT COMMENT '日活跃会员数',
    day_new_users BIGINT COMMENT '日新增会员数',
    day_new_payment_users BIGINT COMMENT '日新增消费会员数',
    day_payment_users BIGINT COMMENT '日付费会员数',
    payment_users BIGINT COMMENT '总付费会员数',
    users BIGINT COMMENT '总会员数',
    day_users2users decimal(38,4) COMMENT '会员活跃率',
    payment_users2users decimal(38,4) COMMENT '会员付费率',
    day_new_users2users decimal(38,4) COMMENT '会员新鲜度'
)
COMMENT '用户数量统计报表'
-- 统计日期,不能用来分组统计
PARTITIONED BY(dt STRING)
ROW format delimited fields terminated BY '\t'
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');

DROP table if exists yp_rpt.rpt_user_month_count;
create table yp_rpt.rpt_user_month_count(
    year_month string comment '月份',
    yoy_month string comment '同比月份',
    mom_month string comment '环比月份',
    month_users BIGINT COMMENT '月活跃会员数',
    month_new_users BIGINT COMMENT '月新增会员数',
    month_cart_users BIGINT COMMENT '月度购物车会员数',
    month_new_cart_users BIGINT COMMENT '月度新增购物车会员数',
    month_order_users BIGINT COMMENT '月度下单会员数',
    month_new_order_users BIGINT COMMENT '月度新增下单会员数',
    month_payment_users BIGINT COMMENT '月度付费会员数',
    month_new_payment_users BIGINT COMMENT '月度新增消费会员数',
    users BIGINT COMMENT '总会员数',
    cart_users BIGINT COMMENT '总购物车会员数',
    order_users BIGINT COMMENT '总下单会员数',
    payment_users BIGINT COMMENT '总付费会员数',
    month_users2users decimal(38,4) COMMENT '月度会员活跃率',
    payment_users2users decimal(38,4) COMMENT '月度会员付费率',
    month_new_users2users decimal(38,4) COMMENT '月度会员新鲜度'
)
COMMENT '用户数量统计报表'
-- 统计日期,不能用来分组统计
PARTITIONED BY(dt STRING)
ROW format delimited fields terminated BY '\t'
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');
"