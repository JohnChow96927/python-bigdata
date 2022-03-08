#! /bin/bash
export LANG=zh_CN.UTF-8
HIVE_HOME=/usr/bin/hive

#上个月1日
Last_Month_DATE=$(date -d "-1 month" +%Y-%m-01)


${HIVE_HOME} -S -e "
--分区配置
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;

--=======订单宽表=======
--覆盖插入
insert overwrite table yp_dwb.dwb_order_detail partition (dt)
select
	o.id as order_id,
	o.order_num,
	o.buyer_id,
	o.store_id,
	o.order_from,
	o.order_state,
	o.create_date,
	o.finnshed_time,
	o.is_settlement,
	o.is_delete,
	o.evaluation_state,
	o.way,
	o.is_stock_up,
	od.order_amount,
	od.discount_amount,
	od.goods_amount,
	od.is_delivery,
	od.buyer_notes,
	od.pay_time,
	od.receive_time,
	od.delivery_begin_time,
	od.arrive_store_time,
	od.arrive_time,
	od.create_user,
	od.create_time,
	od.update_user,
	od.update_time,
	od.is_valid,
	og.group_id,
	og.is_pay,
	op.order_pay_amount as group_pay_amount,
	refund.id as refund_id,
	refund.apply_date,
	refund.refund_reason,
	refund.refund_amount,
	refund.refund_state,
	os.id as settle_id,
	os.settlement_amount,
	os.dispatcher_user_id,
	os.dispatcher_money,
	os.circle_master_user_id,
	os.circle_master_money,
	os.plat_fee,
	os.store_money,
	os.status,
	os.settle_time,

    e.id,
    e.user_id,
    e.geval_scores,
    e.geval_scores_speed,
    e.geval_scores_service,
    e.geval_isanony,
    e.create_time,
    d.id,
    d.dispatcher_order_state,
    d.delivery_fee,
    d.distance,
    d.dispatcher_code,
    d.receiver_name,
    d.receiver_phone,
    d.sender_name,
    d.sender_phone,
    d.create_time,

	ogoods.id as order_goods_id,
	ogoods.goods_id,
	ogoods.buy_num,
	ogoods.goods_price,
	ogoods.total_price,
	ogoods.goods_name,
	ogoods.goods_specification,
	ogoods.goods_type,
    ogoods.goods_brokerage,
	ogoods.is_refund as is_goods_refund,
	SUBSTRING(o.create_date,1,10) as dt
--订单表
from yp_dwd.fact_shop_order o
--订单副表
left join yp_dwd.fact_shop_order_address_detail od on o.id = od.id and od.end_date='9999-99-99'
--订单组表
left join yp_dwd.fact_shop_order_group og on o.id = og.order_id and og.end_date='9999-99-99'
--订单组支付表
left join yp_dwd.fact_order_pay op on og.group_id = op.group_id
--退款单表
left join yp_dwd.fact_refund_order refund on refund.order_id=o.id and refund.end_date='9999-99-99'
--结算单表
left join yp_dwd.fact_order_settle os on os.order_id=o.id and os.end_date='9999-99-99'
--订单商品快照
left join yp_dwd.fact_shop_order_goods_details ogoods on ogoods.order_id=o.id and ogoods.end_date='9999-99-99'
--订单评价表
left join yp_dwd.fact_goods_evaluation e on e.order_id=o.id and e.is_valid=1
--订单配送表
left join yp_dwd.fact_order_delievery_item d on d.shop_order_id=o.id and d.dispatcher_order_type=1 and d.is_valid=1 and d.end_date='9999-99-99'
where o.end_date='9999-99-99'
--   读取上个月1日至今的数据
   and SUBSTRING(o.create_date,1,10) >= '${Last_Month_DATE}' and o.start_date >= '${Last_Month_DATE}'
;

--=======店铺宽表=======
--增量覆盖插入
insert overwrite table yp_dwb.dwb_shop_detail partition (dt)
select
	s.id,
	s.address_info,
	s.name as store_name,
	s.is_pay_bond,
	s.trade_area_id,
	s.delivery_method,
	s.store_type,
	s.is_primary,
	s.parent_store_id,
	ta.name as trade_area_name,
	pro.id province_id,
	city.id city_id,
	area.id area_id,
	pro.name province_name,
	city.name city_name,
	area.name area_name,
	SUBSTRING(s.create_time,1,10) dt
--店铺
from yp_dwd.dim_store s
--商圈
left join yp_dwd.dim_trade_area ta on s.trade_area_id=ta.id and ta.end_date='9999-99-99'
--     地区
left join yp_dwd.dim_location lo on lo.type=2 and lo.correlation_id=s.id and lo.end_date='9999-99-99'
left join yp_dwd.dim_district area on area.code=lo.adcode
left join yp_dwd.dim_district city on area.pid=city.id
left join yp_dwd.dim_district pro on city.pid=pro.id
where s.end_date='9999-99-99'
--   读取上个月1日至今的数据
and SUBSTRING(s.create_time,1,10) >= '${Last_Month_DATE}' and s.start_date >= '${Last_Month_DATE}'
;

--=======商品宽表=======
--先删除，测试用
ALTER TABLE yp_dwb.dwb_goods_detail DROP IF EXISTS PARTITION (dt>='${Last_Month_DATE}');
--增量插入
INSERT into yp_dwb.dwb_goods_detail partition (dt)
SELECT
	goods.id,
	goods.store_id,
	goods.class_id,
	goods.store_class_id,
	goods.brand_id,
	goods.goods_name,
	goods.goods_specification,
	goods.search_name,
	goods.goods_sort,
	goods.goods_market_price,
	goods.goods_price,
	goods.goods_promotion_price,
	goods.goods_storage,
	goods.goods_limit_num,
	goods.goods_unit,
	goods.goods_state,
	goods.goods_verify,
	goods.activity_type,
	goods.discount,
	goods.seckill_begin_time,
	goods.seckill_end_time,
	goods.seckill_total_pay_num,
	goods.seckill_total_num,
	goods.seckill_price,
	goods.top_it,
	goods.create_user,
	goods.create_time,
	goods.update_user,
	goods.update_time,
	goods.is_valid,
	CASE class1.level WHEN 3
		THEN class1.id
		ELSE NULL
		END as min_class_id,
	CASE class1.level WHEN 3
		THEN class1.name
		ELSE NULL
		END as min_class_name,
	CASE WHEN class1.level=2
		THEN class1.id
		WHEN class2.level=2
		THEN class2.id
		ELSE NULL
		END as mid_class_id,
	CASE WHEN class1.level=2
		THEN class1.name
		WHEN class2.level=2
		THEN class2.name
		ELSE NULL
		END as mid_class_name,
	CASE WHEN class1.level=1
		THEN class1.id
		WHEN class2.level=1
		THEN class2.id
		WHEN class3.level=1
		THEN class3.id
		ELSE NULL
		END as max_class_id,
	CASE WHEN class1.level=1
		THEN class1.name
		WHEN class2.level=1
		THEN class2.name
		WHEN class3.level=1
		THEN class3.name
		ELSE NULL
		END as max_class_name,
	brand.brand_name,
	SUBSTRING(goods.create_time,1,10) dt
--SKU
FROM yp_dwd.dim_goods goods
--商品分类
left join yp_dwd.dim_goods_class class1 on goods.store_class_id = class1.id AND class1.end_date='9999-99-99'
left join yp_dwd.dim_goods_class class2 on class1.parent_id = class2.id AND class2.end_date='9999-99-99'
left join yp_dwd.dim_goods_class class3 on class2.parent_id = class3.id AND class3.end_date='9999-99-99'
--品牌
left join yp_dwd.dim_brand brand on goods.brand_id=brand.id AND brand.end_date='9999-99-99'
WHERE goods.end_date='9999-99-99'
    --   读取上个月1日至今的数据
   and SUBSTRING(goods.create_time,1,10) >= '${Last_Month_DATE}' and goods.start_date >= '${Last_Month_DATE}'
;
"