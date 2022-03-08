#! /bin/bash
export LANG=zh_CN.UTF-8
HIVE_HOME=/usr/bin/hive

if [[ $1 == "" ]];then
   TD_DATE=`date -d '1 days ago' "+%Y-%m-%d"`
else
   TD_DATE=$1
fi

${HIVE_HOME} -S -e "
--分区配置
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;

--===========订单事实表（拉链表）===========
-- 1、ODS抽取新增/变更数据
-- 略
-- 2、重建临时表
DROP TABLE if EXISTS yp_dwd.fact_shop_order_tmp;
CREATE TABLE yp_dwd.fact_shop_order_tmp(
  id string COMMENT '根据一定规则生成的订单编号',
  order_num string COMMENT '订单序号',
  buyer_id string COMMENT '买家的userId',
  store_id string COMMENT '店铺的id',
  order_from string COMMENT '此字段可以转换 1.安卓\; 2.ios\; 3.小程序H5 \; 4.PC',
  order_state int COMMENT '订单状态:1.已下单\; 2.已付款, 3. 已确认 \;4.配送\; 5.已完成\; 6.退款\;7.已取消',
  create_date string COMMENT '下单时间',
  finnshed_time timestamp COMMENT '订单完成时间,当配送员点击确认送达时,进行更新订单完成时间,后期需要根据订单完成时间,进行自动收货以及自动评价',
  is_settlement tinyint COMMENT '是否结算\;0.待结算订单\; 1.已结算订单\;',
  is_delete tinyint COMMENT '订单评价的状态:0.未删除\;  1.已删除\;(默认0)',
  evaluation_state tinyint COMMENT '订单评价的状态:0.未评价\;  1.已评价\;(默认0)',
  way string COMMENT '取货方式:SELF自提\;SHOP店铺负责配送',
  is_stock_up int COMMENT '是否需要备货 0：不需要    1：需要    2:平台确认备货  3:已完成备货 4平台已经将货物送至店铺 ',
  create_user string,
  create_time string,
  update_user string,
  update_time string,
  is_valid tinyint COMMENT '是否有效  0: false\; 1: true\;   订单是否有效的标志',
  end_date string COMMENT '拉链结束日期')
COMMENT '订单表'
partitioned by (start_date string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');
-- 3、合并新旧数据
insert overwrite table yp_dwd.fact_shop_order_tmp partition (start_date)
select * from
    (
--      一、ods表的新数据
        select
            id,
            order_num,
            buyer_id,
            store_id,
            case order_from 
                 when 1
                 then 'android'
                 when 2
                 then 'ios'
                 when 3
                 then 'miniapp'
                 when 4
                 then 'pcweb'
                 else 'other'
                 end
               as order_from,
            order_state,
            create_date,
            finnshed_time,
            is_settlement,
            is_delete,
            evaluation_state,
            way,
            is_stock_up,
            create_user,
            create_time,
            update_user,
            update_time,
            is_valid,
          '9999-99-99' end_date,
          '${TD_DATE}' as start_date
        from yp_ods.t_shop_order where dt='${TD_DATE}'

        union all

--      二、历史拉链表数据，并根据up_id判断更新end_time有效期
        select
            fso.id,
            fso.order_num,
            fso.buyer_id,
            fso.store_id,
            fso.order_from,
            fso.order_state,
            fso.create_date,
            fso.finnshed_time,
            fso.is_settlement,
            fso.is_delete,
            fso.evaluation_state,
            fso.way,
            fso.is_stock_up,
            fso.create_user,
            fso.create_time,
            fso.update_user,
            fso.update_time,
            fso.is_valid,
          --3、更新end_time：如果没有匹配到变更数据，或者当前已经是无效的历史数据，则保留原始end_time过期时间；否则变更end_time时间为前天（昨天之前有效）
          if(up.id is null or fso.end_date<'9999-99-99', fso.end_date, date_add('${TD_DATE}',-1)) end_time,
          fso.start_date
        from yp_dwd.fact_shop_order fso left join
            (
                select
                *
                from yp_ods.t_shop_order
                where dt='${TD_DATE}'
            ) up
        on fso.id=up.id
        --4、时间限制：如果订单的变更周期是30天则可加上此条件，结果会按照所属分区进行覆盖插入
        --where fso.start_date >= date_add('${TD_DATE}',-30)
    )his
order by his.id, start_date;

-- 4、临时表覆盖拉链表
INSERT OVERWRITE TABLE yp_dwd.fact_shop_order partition (start_date)
SELECT * from yp_dwd.fact_shop_order_tmp;



--订单详情表（拉链表）
INSERT overwrite TABLE yp_dwd.fact_shop_order_address_detail PARTITION (start_date)
SELECT 
	id,
	order_amount,
	discount_amount,
	goods_amount,
	is_delivery,
	buyer_notes,
	pay_time,
	receive_time,
	delivery_begin_time,
	arrive_store_time,
	arrive_time,
	create_user,
	create_time,
	update_user,
	update_time,
	is_valid,
	'9999-99-99' end_date,
	dt as start_date
FROM yp_ods.t_shop_order_address_detail;

--订单结算表
set hive.exec.dynamic.partition.mode=nonstrict;
INSERT overwrite TABLE  yp_dwd.fact_order_settle PARTITION (start_date)
SELECT
	id
	,order_id
	,settlement_create_date
	,settlement_amount
	,dispatcher_user_id
	,dispatcher_money
	,circle_master_user_id
	,circle_master_money
	,plat_fee
	,store_money
	,status
	,note
	,settle_time
	,create_user
	,create_time
	,update_user
	,update_time
	,is_valid
	,first_commission_user_id
	,first_commission_money
	,second_commission_user_id
	,second_commission_money
	,'9999-99-99' end_date,
	dt as start_date
FROM yp_ods.t_order_settle;


--订单退款表
INSERT overwrite TABLE yp_dwd.fact_refund_order PARTITION (start_date)
SELECT
	id
	,order_id
	,apply_date
	,modify_date
	,refund_reason
	,refund_amount
	,refund_state
	,refuse_refund_reason
	,refund_goods_type
	,refund_shipping_fee
	,create_user
	,create_time
	,update_user
	,update_time
	,is_valid
	,'9999-99-99' end_date
	,dt as start_date
FROM yp_ods.t_refund_order;


--订单组表（拉链表）
INSERT overwrite TABLE yp_dwd.fact_shop_order_group PARTITION (start_date)
SELECT
	id,
	order_id,
	group_id,
	is_pay,
	create_user,
	create_time,
	update_user,
	update_time,
	is_valid,
	'9999-99-99' end_date,
	dt as start_date
FROM yp_ods.t_shop_order_group;


--订单组支付表
INSERT overwrite TABLE yp_dwd.fact_order_pay PARTITION (start_date)
SELECT
	id
	,group_id
	,order_pay_amount
	,create_date
	,create_user
	,create_time
	,update_user
	,update_time
	,is_valid
	,'9999-99-99' end_date
	,dt as start_date
FROM yp_ods.t_order_pay;


--订单商品快照(拉链表)
INSERT overwrite TABLE yp_dwd.fact_shop_order_goods_details PARTITION (start_date)
SELECT
	id,
	order_id,
	shop_store_id,
	buyer_id,
	goods_id,
	buy_num,
	goods_price,
	total_price,
	goods_name,
	goods_image,
	goods_specification,
	goods_weight,
	goods_unit,
	goods_type,
	refund_order_id,
	goods_brokerage,
	is_refund,
	create_user,
	create_time,
	update_user,
	update_time,
	is_valid,
	'9999-99-99' end_date,
	dt as start_date
FROM
yp_ods.t_shop_order_goods_details;


--购物车(拉链表)
INSERT overwrite TABLE yp_dwd.fact_shop_cart PARTITION (start_date)
SELECT
	id,
	shop_store_id,
	buyer_id,
	goods_id,
	buy_num,
	create_user,
	create_time,
	update_user,
	update_time,
	is_valid,
	'9999-99-99' end_date,
	dt as start_date
FROM
yp_ods.t_shop_cart;


--店铺收藏(拉链表)
INSERT overwrite TABLE yp_dwd.fact_store_collect PARTITION (start_date)
SELECT
	id,
	user_id,
	store_id,
	create_user,
	create_time,
	update_user,
	update_time,
	is_valid,
	'9999-99-99' end_date,
	dt as start_date
FROM yp_ods.t_store_collect;


--店铺收藏(拉链表)
INSERT overwrite TABLE yp_dwd.fact_goods_collect PARTITION (start_date)
SELECT
	id,
	user_id,
	goods_id,
	store_id,
	create_user,
	create_time,
	update_user,
	update_time,
	is_valid,
	'9999-99-99' end_date,
	dt as start_date
FROM yp_ods.t_goods_collect;


--===========增量表，只会新增不会更新===========
--订单评价表（增量表，与ODS一致，可以做适当的清洗）
INSERT overwrite TABLE yp_dwd.fact_goods_evaluation PARTITION(dt)
select 
	id,
	user_id,
	store_id,
	order_id,
	geval_scores,
	geval_scores_speed,
	geval_scores_service,
	geval_isanony,
	create_user,
	create_time,
	update_user,
	update_time,
	is_valid,
	dt
from yp_ods.t_goods_evaluation;


--评价明细表（增量表，与ODS一致）
INSERT overwrite TABLE yp_dwd.fact_goods_evaluation_detail PARTITION(start_date)
select 
   id,
   user_id,
   store_id,
   goods_id,
   order_id,
   order_goods_id,
   GEVAL_scores_goods,
   geval_content,
   geval_content_superaddition,
   geval_addtime,
   geval_addtime_superaddition,
   geval_state,
   geval_remark,
   revert_state,
   geval_explain,
   geval_explain_superaddition,
   geval_explaintime,
   geval_explaintime_superaddition,
   create_user,
   create_time,
   update_user,
   update_time,
   is_valid,
   '9999-99-99' end_date,
   substr(create_time, 1, 10) as start_date
from yp_ods.t_goods_evaluation_detail;

--配送表（增量表，与ODS一致）
INSERT overwrite TABLE yp_dwd.fact_order_delievery_item PARTITION(start_date)
select
   id,
   shop_order_id,
   refund_order_id,
   dispatcher_order_type,
   shop_store_id,
   buyer_id,
   circle_master_user_id,
   dispatcher_user_id,
   dispatcher_order_state,
   order_goods_num,
   delivery_fee,
   distance,
   dispatcher_code,
   receiver_name,
   receiver_phone,
   sender_name,
   sender_phone,
   create_user,
   create_time,
   update_user,
   update_time,
   is_valid,
   '9999-99-99' end_date,
   substr(create_time, 1, 10) as start_date
FROM yp_ods.t_order_delievery_item;


--用户登录记录表（增量表，与ODS一致）
INSERT overwrite TABLE yp_dwd.fact_user_login PARTITION(dt)
select
	id,
	login_user,
	login_type,
	client_id,
	login_time,
	login_ip,
	logout_time,
	SUBSTRING(login_time, 1, 10) as dt
FROM yp_ods.t_user_login;


--交易记录(增量表)
INSERT overwrite TABLE yp_dwd.fact_trade_record PARTITION (start_date)
SELECT
   id,
   external_trade_no,
   relation_id,
   trade_type,
   status,
   finnshed_time,
   fail_reason,
   payment_type,
   trade_before_balance,
   trade_true_amount,
   trade_after_balance,
   note,
   user_card,
   user_id,
   aip_user_id,
   create_user,
   create_time,
   update_user,
   update_time,
   is_valid,
   '9999-99-99' end_date,
   substr(create_time, 1, 10) as start_date
FROM yp_ods.t_trade_record;
"