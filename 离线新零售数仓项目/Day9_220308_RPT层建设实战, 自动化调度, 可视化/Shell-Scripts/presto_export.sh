#! /bin/bash
export LANG=zh_CN.UTF-8
PRESTO_HOME=/export/server/presto/bin/presto
MYSQL_HOME=/usr/bin/mysql


echo '========================================'
echo '================开始导出================='
echo '========================================'


${MYSQL_HOME} -h192.168.88.80 -p3306 -uroot -p123456 -e "
CREATE DATABASE IF NOT EXISTS yp_olap DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
use yp_olap;
drop table IF EXISTS yp_olap.dm_sale;
DROP TABLE IF EXISTS yp_olap.dm_sku;
DROP TABLE IF EXISTS yp_olap.dm_user;
DROP TABLE IF EXISTS yp_olap.rpt_sale_store_cnt_month;
DROP TABLE IF EXISTS yp_olap.rpt_sale_day;
DROP TABLE IF EXISTS yp_olap.rpt_sale_month;
DROP TABLE IF EXISTS yp_olap.rpt_sale_fromtype_ratio;
drop table if exists yp_olap.rpt_goods_sale_topn;
drop table if exists yp_olap.rpt_goods_sale;
drop table if exists yp_olap.rpt_evaluation_topn_month;
drop table if exists yp_olap.rpt_user_count;
drop table if exists yp_olap.rpt_user_month_count;
"

${PRESTO_HOME} --catalog hive --server 192.168.88.80:8090 --execute "
CREATE TABLE if not exists mysql.yp_olap.dm_sale(
   time_type varchar COMMENT '统计时间维度：year、month、week、date',
   year_code varchar COMMENT '年code',
   year_month varchar COMMENT '年月',
   month_code varchar COMMENT '月份编码',
   day_month_num varchar COMMENT '一月第几天',
   dim_date_id varchar COMMENT '日期',
   year_week_name_cn varchar COMMENT '年中第几周',

   group_type varchar COMMENT '分组类型：store，trade_area，city，brand，min_class，mid_class，max_class，all',
   province_id varchar COMMENT '省份id',
   province_name varchar COMMENT '省份名称',
   city_id varchar COMMENT '城市id',
   city_name varchar COMMENT '城市name',
   trade_area_id varchar COMMENT '商圈id',
   trade_area_name varchar COMMENT '商圈名称',
   store_id varchar COMMENT '店铺的id',
   store_name varchar COMMENT '店铺名称',
   brand_id varchar COMMENT '品牌id',
   brand_name varchar COMMENT '品牌名称',
   max_class_id varchar COMMENT '商品大类id',
   max_class_name varchar COMMENT '大类名称',
   mid_class_id varchar COMMENT '中类id',
   mid_class_name varchar COMMENT '中类名称',
   min_class_id varchar COMMENT '小类id',
   min_class_name varchar COMMENT '小类名称',
   --   =======统计=======
   --   销售收入
   sale_amt DECIMAL(38,4) COMMENT '销售收入',
   --   平台收入
   plat_amt DECIMAL(38,4) COMMENT '平台收入',
   -- 配送成交额
   deliver_sale_amt DECIMAL(38,4) COMMENT '配送成交额',
   -- 小程序成交额
   mini_app_sale_amt DECIMAL(38,4) COMMENT '小程序成交额',
   -- 安卓APP成交额
   android_sale_amt DECIMAL(38,4) COMMENT '安卓APP成交额',
   --  苹果APP成交额
   ios_sale_amt DECIMAL(38,4) COMMENT '苹果APP成交额',
   -- PC商城成交额
   pcweb_sale_amt DECIMAL(38,4) COMMENT 'PC商城成交额',
   -- 成交单量
   order_cnt BIGINT COMMENT '成交单量',
   -- 参评单量
   eva_order_cnt BIGINT COMMENT '参评单量comment=>cmt',
   -- 差评单量
   bad_eva_order_cnt BIGINT COMMENT '差评单量negtive-comment=>ncmt',
   -- 配送成交单量
   deliver_order_cnt BIGINT COMMENT '配送单量',
   -- 退款单量
   refund_order_cnt BIGINT COMMENT '退款单量',
   -- 小程序成交单量
   miniapp_order_cnt BIGINT COMMENT '小程序成交单量',
   -- 安卓APP订单量
   android_order_cnt BIGINT COMMENT '安卓APP订单量',
   -- 苹果APP订单量
   ios_order_cnt BIGINT COMMENT '苹果APP订单量',
   -- PC商城成交单量
   pcweb_order_cnt BIGINT COMMENT 'PC商城成交单量',
   date_time varchar COMMENT '统计日期,不能用来分组统计'
)
COMMENT '销售主题宽表';

CREATE TABLE if not exists mysql.yp_olap.dm_sku
(
    time_type varchar COMMENT '统计时间维度：all、month',
    year_code varchar COMMENT '年code',
    year_month varchar COMMENT '年月',
    sku_id varchar comment 'sku_id',
    sku_name varchar comment '商品名称',
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
    evaluation_good_count bigint comment '好评数',
    evaluation_mid_count bigint comment '中评数',
    evaluation_bad_count bigint comment '差评数',
    date_time varchar comment '统计日期'
)
COMMENT '商品主题宽表';

CREATE TABLE if not exists mysql.yp_olap.dm_user
(
    time_type varchar COMMENT '统计时间维度：all、month',
    year_code varchar COMMENT '年code',
    year_month varchar COMMENT '年月',
    user_id varchar  comment '用户id',
    -- 登录
    login_date_first varchar  comment '首次登录日期',
    login_date_last varchar  comment '末次登录日期',
    login_count bigint comment '登录天数',
    -- 购物车
    cart_date_first varchar comment '首次加入购物车日期',
    cart_date_last varchar comment '末次加入购物车日期',
    cart_count bigint comment '加入购物车次数',
    cart_amount decimal(38,4) comment '加入购物车金额',
    -- 订单
    order_date_first varchar  comment '首次下单日期',
    order_date_last varchar  comment '末次下单日期',
    order_count bigint comment '下单次数',
    order_amount decimal(38,4) comment '下单金额',
    -- 支付
    payment_date_first varchar  comment '首次支付日期',
    payment_date_last varchar  comment '末次支付日期',
    payment_count bigint comment '支付次数',
    payment_amount decimal(38,4) comment '支付金额',
    date_time varchar COMMENT '统计日期'
)
COMMENT '用户主题宽表';

-- 门店月销售单量排行
-- DROP TABLE IF EXISTS yp_olap.rpt_sale_store_cnt_month;
CREATE TABLE mysql.yp_olap.rpt_sale_store_cnt_month(
    year_code varchar COMMENT '年code',
    year_month varchar COMMENT '年月',
    province_id varchar COMMENT '省份id',
    province_name varchar COMMENT '省份名称',
    city_id varchar COMMENT '城市id',
    city_name varchar COMMENT '城市name',
    trade_area_id varchar COMMENT '商圈id',
    trade_area_name varchar COMMENT '商圈名称',
    store_id varchar COMMENT '店铺的id',
    store_name varchar COMMENT '店铺名称',
    order_store_cnt BIGINT COMMENT '店铺成交单量',
    miniapp_order_store_cnt BIGINT COMMENT '店铺成交单量',
    android_order_store_cnt BIGINT COMMENT '店铺成交单量',
    ios_order_store_cnt BIGINT COMMENT '店铺成交单量',
    pcweb_order_store_cnt BIGINT COMMENT '店铺成交单量',
    sale_amt DECIMAL(38,4) COMMENT '销售收入',
    mini_app_sale_amt DECIMAL(38,4) COMMENT '小程序成交额',
    android_sale_amt DECIMAL(38,4) COMMENT '安卓APP成交额',
    ios_sale_amt DECIMAL(38,4) COMMENT '苹果APP成交额',
    pcweb_sale_amt DECIMAL(38,4) COMMENT 'PC商城成交额',
    date_time varchar COMMENT '统计日期,不能用来分组统计'
)
COMMENT '门店月销售单量排行';


-- 日销售曲线
-- DROP TABLE IF EXISTS yp_olap.rpt_sale_day;
CREATE TABLE if not exists mysql.yp_olap.rpt_sale_day(
year_code varchar COMMENT '年code',
month_code varchar COMMENT '月份编码',
day_month_num varchar COMMENT '一月第几天',
dim_date_id varchar COMMENT '日期',
sale_amt DECIMAL(38,4) COMMENT '销售收入',
order_cnt BIGINT COMMENT '成交单量',
date_time varchar COMMENT '统计日期,不能用来分组统计'
)
COMMENT '日销售曲线';

-- 月销售曲线
-- DROP TABLE IF EXISTS yp_olap.rpt_sale_month;
CREATE TABLE if not exists mysql.yp_olap.rpt_sale_month(
year_code varchar COMMENT '年code',
month_code varchar COMMENT '月份编码',
year_month varchar COMMENT '年月',
sale_amt DECIMAL(38,4) COMMENT '销售收入',
plat_amt DECIMAL(38,4) COMMENT '平台收入',
mini_app_sale_amt DECIMAL(38,4) COMMENT '小程序成交额',
android_sale_amt DECIMAL(38,4) COMMENT '安卓APP成交额',
ios_sale_amt DECIMAL(38,4) COMMENT '苹果APP成交额',
pcweb_sale_amt DECIMAL(38,4) COMMENT 'PC商城成交额',
order_cnt BIGINT COMMENT '成交单量',
deliver_order_cnt BIGINT COMMENT '配送单量',
refund_order_cnt BIGINT COMMENT '退款单量',
bad_eva_order_cnt BIGINT COMMENT '差评单量',
miniapp_order_cnt BIGINT COMMENT '小程序成交单量',
android_order_cnt BIGINT COMMENT '安卓APP订单量',
ios_order_cnt BIGINT COMMENT '苹果APP订单量',
pcweb_order_cnt BIGINT COMMENT 'PC商城成交单量',
date_time varchar COMMENT '统计日期,不能用来分组统计'
)
COMMENT '月销售曲线';

-- 渠道销量占比
-- DROP TABLE IF EXISTS yp_olap.rpt_sale_fromtype_ratio;
CREATE TABLE if not exists mysql.yp_olap.rpt_sale_fromtype_ratio(
time_type varchar COMMENT '统计时间维度：year、month、day',
year_code varchar COMMENT '年code',
year_month varchar COMMENT '年月',
dim_date_id varchar COMMENT '日期',
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
pcweb_order_ratio DECIMAL(38,4) COMMENT 'PC商城成交单量占比',
date_time varchar COMMENT '统计日期,不能用来分组统计'
)
COMMENT '渠道销量占比';

-- drop table if exists mysql.yp_olap.rpt_goods_sale_topn;
CREATE TABLE if not exists mysql.yp_olap.rpt_goods_sale_topn(
  sku_id varchar COMMENT '商品ID',
  sku_name varchar COMMENT '商品名称',
  payment_num bigint COMMENT '销量',
  payment_amount decimal(38,4) comment '被支付金额',
  dt varchar COMMENT '统计日期'
) COMMENT '商品销量topn';


-- drop table if exists mysql.yp_olap.rpt_goods_sale;
create table mysql.yp_olap.rpt_goods_sale(
    year_month varchar COMMENT '年月',
    sku_id varchar COMMENT '商品ID',
    sku_name varchar COMMENT '商品名称',
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
    refund_ratio decimal(38,4) COMMENT '退款率',
    dt varchar COMMENT '统计日期'
) COMMENT '商品月度消费监控';


-- DROP table if exists mysql.yp_olap.rpt_evaluation_topn_month;
create table mysql.yp_olap.rpt_evaluation_topn_month(
    year_month varchar COMMENT '年月',
    sku_id varchar COMMENT '商品ID',
    sku_name varchar COMMENT '商品名称',
    evaluation_good_count bigint comment '好评数',
    evaluation_mid_count bigint comment '中评数',
    evaluation_bad_count bigint comment '差评数',
    evaluation_good_ratio DECIMAL(38,4) COMMENT '好评率',
    evaluation_mid_ratio DECIMAL(38,4) COMMENT '中评率',
    evaluation_bad_ratio DECIMAL(38,4) COMMENT '差评率',
    dt varchar COMMENT '统计日期'
) COMMENT '商品评价月度排行';


--drop table if exists mysql.yp_olap.rpt_user_count;
CREATE TABLE if not exists mysql.yp_olap.rpt_user_count(
  day_users BIGINT COMMENT '日活跃会员数',
  day_new_users BIGINT COMMENT '日新增会员数',
  day_new_payment_users BIGINT COMMENT '日新增消费会员数',
  day_payment_users BIGINT COMMENT '日付费会员数',
  payment_users BIGINT COMMENT '总付费会员数',
  users BIGINT COMMENT '总会员数',
  day_users2users decimal(38,4) COMMENT '会员活跃率',
  payment_users2users decimal(38,4) COMMENT '会员付费率',
  day_new_users2users decimal(38,4) COMMENT '会员新鲜度',
  dt varchar COMMENT '统计日期'
)
COMMENT '用户数量统计报表';


--drop table if exists mysql.yp_olap.rpt_user_month_count;
CREATE TABLE if not exists mysql.yp_olap.rpt_user_month_count(
    year_month varchar comment '月份',
    yoy_month varchar comment '同比月份',
    mom_month varchar comment '环比月份',
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
    month_new_users2users decimal(38,4) COMMENT '月度会员新鲜度',
    dt varchar
)
COMMENT '用户数量统计报表';

--宽表
insert into mysql.yp_olap.dm_sale
select * from hive.yp_dm.dm_sale;

insert into mysql.yp_olap.dm_sku
select * from hive.yp_dm.dm_sku;

insert into mysql.yp_olap.dm_user
select * from hive.yp_dm.dm_user;

--促销
insert into mysql.yp_olap.rpt_sale_store_cnt_month
select * from hive.yp_rpt.rpt_sale_store_cnt_month;


insert into mysql.yp_olap.rpt_sale_day
select * from hive.yp_rpt.rpt_sale_day;

insert into mysql.yp_olap.rpt_sale_month
select * from hive.yp_rpt.rpt_sale_month;


insert into mysql.yp_olap.rpt_sale_fromtype_ratio
select * from hive.yp_rpt.rpt_sale_fromtype_ratio;

--商品
insert into mysql.yp_olap.rpt_goods_sale_topn
select * from hive.yp_rpt.rpt_goods_sale_topn;

insert into mysql.yp_olap.rpt_goods_sale
select * from hive.yp_rpt.rpt_goods_sale;

insert into mysql.yp_olap.rpt_evaluation_topn_month
select * from hive.yp_rpt.rpt_evaluation_topn_month;

--用户
insert into mysql.yp_olap.rpt_user_count
select * from hive.yp_rpt.rpt_user_count;

insert into mysql.yp_olap.rpt_user_month_count
select * from hive.yp_rpt.rpt_user_month_count;
"

echo '========================================'
echo '=================success================'
echo '========================================'