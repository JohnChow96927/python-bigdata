#! /bin/bash
export LANG=zh_CN.UTF-8
PRESTO_HOME=/export/server/presto/bin/presto


${PRESTO_HOME} --catalog hive --server 192.168.88.80:8090 --execute "
--=======销售主题=======
insert into yp_dws.dws_sale_daycount
with order_base as
(
	select
--		维度
		SUBSTRING(o.create_date,1,10) as dt,
		s.province_id,
		s.province_name,
		s.city_id,
		s.city_name,
		s.trade_area_id,
		s.trade_area_name,
		s.id as store_id,
		s.store_name,
		g.brand_id,
		g.brand_name,
		g.max_class_id,
		g.max_class_name,
		g.mid_class_id,
		g.mid_class_name,
		g.min_class_id,
		g.min_class_name,
--		订单量指标
		o.order_id,
--		金额指标
		o.order_amount,
		o.total_price as goods_price,
		o.plat_fee,
		o.delivery_fee,
--		判断条件
		o.order_from,
		o.evaluation_id,
		o.geval_scores,
		o.delievery_id,
		o.refund_id,
		row_number() over(partition by o.order_id) rn,
		row_number() over(partition by s.city_id, o.order_id) city_rn,
		row_number() over(partition by s.trade_area_id, o.order_id) trade_area_rn,
		row_number() over(partition by o.store_id, o.order_id) store_rn,
		row_number() over(partition by g.brand_id, o.order_id) brand_rn,
		row_number() over(partition by g.max_class_id, o.order_id) max_class_rn,
		row_number() over(partition by g.max_class_id, g.mid_class_id, o.order_id) mid_class_rn,
		row_number() over(partition by g.max_class_id, g.mid_class_id, g.min_class_id, o.order_id) min_class_rn,

		row_number() over(partition by g.brand_id, o.order_id, o.goods_id) brand_goods_rn,
		row_number() over(partition by g.max_class_id, o.order_id, o.goods_id) max_class_goods_rn,
		row_number() over(partition by g.max_class_id, g.mid_class_id, o.order_id, o.goods_id) mid_class_goods_rn,
		row_number() over(partition by g.max_class_id, g.mid_class_id, g.min_class_id, o.order_id, o.goods_id) min_class_goods_rn
	from yp_dwb.dwb_order_detail o
		left join yp_dwb.dwb_shop_detail s on o.store_id=s.id
		left join yp_dwb.dwb_goods_detail g on o.goods_id=g.id
	where o.is_pay=1
--	and o.order_id='dd190404391438bed2'
)
select
--	=============维度=============
-- 	dt,
	province_id
	,province_name
	,city_id
	,city_name
	,trade_area_id
	,trade_area_name
	,store_id
	,store_name
	,brand_id
	,brand_name,
	max_class_id,
	max_class_name,
	mid_class_id,
	mid_class_name,
	min_class_id,
	min_class_name
	,case
		when grouping(brand_id)=0
		then 'brand'
		when grouping(min_class_id)=0
		then 'min_class'
		when grouping(mid_class_id)=0
		then 'mid_class'
		when grouping(max_class_id)=0
		then 'max_class'
		when grouping(store_id)=0
		then 'store'
		when grouping(trade_area_id)=0
		then 'trade_area'
		when grouping(city_id)=0
		then 'city'
		when grouping(dt)=0
		then 'all'
	end
	as group_type
--	=============金额=============
--   销售收入
	,case
		when grouping(brand_id)=0
		then sum(if(brand_goods_rn=1, coalesce(goods_price, 0), 0))
		when grouping(min_class_id)=0
		then sum(if(min_class_goods_rn=1, coalesce(goods_price, 0), 0))
		when grouping(mid_class_id)=0
		then sum(if(mid_class_goods_rn=1, coalesce(goods_price, 0), 0))
		when grouping(max_class_id)=0
		then sum(if(max_class_goods_rn=1, coalesce(goods_price, 0), 0))
		when grouping(store_id)=0
		then sum(if(store_rn=1, coalesce(order_amount, 0), 0))
		when grouping(trade_area_id)=0
		then sum(if(trade_area_rn=1, coalesce(order_amount, 0), 0))
		when grouping(city_id)=0
		then sum(if(city_rn=1, coalesce(order_amount, 0), 0))
		when grouping(dt)=0
		then sum(if(rn=1, coalesce(order_amount, 0), 0))
	    else null
	end
	as sale_amt,
--	平台分润金额
	case
--		店铺
		when grouping(store_id)=0
		then sum(case when rn=1 and store_id is not null then coalesce(plat_fee, 0) else 0 end)
--		商圈
		when grouping(trade_area_id)=0
		then sum(case when rn=1 and trade_area_id is not null then coalesce(plat_fee, 0) else 0 end)
--		城市
		when grouping(city_id)=0
		then sum(case when rn=1 and city_id is not null then coalesce(plat_fee, 0) else 0 end)
--		品牌
		when grouping(brand_id)=0
		then null
--		小类
		when grouping(min_class_id)=0
		then null
--		中类
		when grouping(mid_class_id)=0
		then null
--		大类
		when grouping(max_class_id)=0
		then null
--		全部
		else sum(case when rn=1 then coalesce(plat_fee, 0) else 0 end)
	end
	as plat_amt,
--	配送额
	case
--		店铺
		when grouping(store_id)=0
		then sum(case when rn=1 and store_id is not null then coalesce(delivery_fee, 0) else 0 end)
--		商圈
		when grouping(trade_area_id)=0
		then sum(case when rn=1 and trade_area_id is not null then coalesce(delivery_fee, 0) else 0 end)
--		城市
		when grouping(city_id)=0
		then sum(case when rn=1 and city_id is not null then coalesce(delivery_fee, 0) else 0 end)
--		品牌
		when grouping(brand_id)=0
		then null
--		小类
		when grouping(min_class_id)=0
		then null
--		中类
		when grouping(mid_class_id)=0
		then null
--		大类
		when grouping(max_class_id)=0
		then null
--		全部
		else sum(case when rn=1 then coalesce(delivery_fee, 0) else 0 end)
	end
	as deliver_sale_amt,
--	小程序销售额
	case
--		店铺
		when grouping(store_id)=0
		then sum(case when o.order_from='miniapp' and rn=1 and store_id is not null then coalesce(order_amount, 0) else 0 end)
--		商圈
		when grouping(trade_area_id)=0
		then sum(case when o.order_from='miniapp' and rn=1 and trade_area_id is not null then coalesce(order_amount, 0) else 0 end)
--		城市
		when grouping(city_id)=0
		then sum(case when o.order_from='miniapp' and rn=1 and city_id is not null then coalesce(order_amount, 0) else 0 end)
--		品牌
		when grouping(brand_id)=0
		then sum(case when o.order_from='miniapp' and brand_goods_rn=1 and brand_id is not null then coalesce(goods_price, 0) else 0 end)
--		小类
		when grouping(min_class_id)=0
		then sum(case when o.order_from='miniapp' and min_class_goods_rn=1 and min_class_id is not null then coalesce(goods_price, 0) else 0 end)
--		中类
		when grouping(mid_class_id)=0
		then sum(case when o.order_from='miniapp' and mid_class_goods_rn=1 and mid_class_id is not null then coalesce(goods_price, 0) else 0 end)
--		大类
		when grouping(max_class_id)=0
		then sum(case when o.order_from='miniapp' and max_class_goods_rn=1 and max_class_id is not null then coalesce(goods_price, 0) else 0 end)
--		全部
		else sum(case when o.order_from='miniapp' and rn=1 then coalesce(order_amount, 0) else 0 end)
	end
	as mini_app_sale_amt,
--	安卓销售额
	case
--		店铺
		when grouping(store_id)=0
		then sum(case when o.order_from='android' and rn=1 and store_id is not null then coalesce(order_amount, 0) else 0 end)
--		商圈
		when grouping(trade_area_id)=0
		then sum(case when o.order_from='android' and rn=1 and trade_area_id is not null then coalesce(order_amount, 0) else 0 end)
--		城市
		when grouping(city_id)=0
		then sum(case when o.order_from='android' and rn=1 and city_id is not null then coalesce(order_amount, 0) else 0 end)
--		品牌
		when grouping(brand_id)=0
		then sum(case when o.order_from='android' and brand_goods_rn=1 and brand_id is not null then coalesce(goods_price, 0) else 0 end)
--		小类
		when grouping(min_class_id)=0
		then sum(case when o.order_from='android' and min_class_goods_rn=1 and min_class_id is not null then coalesce(goods_price, 0) else 0 end)
--		中类
		when grouping(mid_class_id)=0
		then sum(case when o.order_from='android' and mid_class_goods_rn=1 and mid_class_id is not null then coalesce(goods_price, 0) else 0 end)
--		大类
		when grouping(max_class_id)=0
		then sum(case when o.order_from='android' and max_class_goods_rn=1 and max_class_id is not null then coalesce(goods_price, 0) else 0 end)
--		全部
		else sum(case when o.order_from='android' and rn=1 then coalesce(order_amount, 0) else 0 end)
	end
	as android_sale_amt,
--	ios销售额
	case
--		店铺
		when grouping(store_id)=0
		then sum(case when o.order_from='ios' and rn=1 and store_id is not null then coalesce(order_amount, 0) else 0 end)
--		商圈
		when grouping(trade_area_id)=0
		then sum(case when o.order_from='ios' and rn=1 and trade_area_id is not null then coalesce(order_amount, 0) else 0 end)
--		城市
		when grouping(city_id)=0
		then sum(case when o.order_from='ios' and rn=1 and city_id is not null then coalesce(order_amount, 0) else 0 end)
--		品牌
		when grouping(brand_id)=0
		then sum(case when o.order_from='ios' and brand_goods_rn=1 and brand_id is not null then coalesce(goods_price, 0) else 0 end)
--		小类
		when grouping(min_class_id)=0
		then sum(case when o.order_from='ios' and min_class_goods_rn=1 and min_class_id is not null then coalesce(goods_price, 0) else 0 end)
--		中类
		when grouping(mid_class_id)=0
		then sum(case when o.order_from='ios' and mid_class_goods_rn=1 and mid_class_id is not null then coalesce(goods_price, 0) else 0 end)
--		大类
		when grouping(max_class_id)=0
		then sum(case when o.order_from='ios' and max_class_goods_rn=1 and max_class_id is not null then coalesce(goods_price, 0) else 0 end)
--		全部
		else sum(case when o.order_from='ios' and rn=1 then coalesce(order_amount, 0) else 0 end)
	end
	as ios_sale_amt,
--	pc销售额
	case
--		店铺
		when grouping(store_id)=0
		then sum(case when o.order_from='pcweb' and rn=1 and store_id is not null then coalesce(order_amount, 0) else 0 end)
--		商圈
		when grouping(trade_area_id)=0
		then sum(case when o.order_from='pcweb' and rn=1 and trade_area_id is not null then coalesce(order_amount, 0) else 0 end)
--		城市
		when grouping(city_id)=0
		then sum(case when o.order_from='pcweb' and rn=1 and city_id is not null then coalesce(order_amount, 0) else 0 end)
--		品牌
		when grouping(brand_id)=0
		then sum(case when o.order_from='pcweb' and brand_goods_rn=1 and brand_id is not null then coalesce(goods_price, 0) else 0 end)
--		小类
		when grouping(min_class_id)=0
		then sum(case when o.order_from='pcweb' and min_class_goods_rn=1 and min_class_id is not null then coalesce(goods_price, 0) else 0 end)
--		中类
		when grouping(mid_class_id)=0
		then sum(case when o.order_from='pcweb' and mid_class_goods_rn=1 and mid_class_id is not null then coalesce(goods_price, 0) else 0 end)
--		大类
		when grouping(max_class_id)=0
		then sum(case when o.order_from='pcweb' and max_class_goods_rn=1 and max_class_id is not null then coalesce(goods_price, 0) else 0 end)
--		全部
		else sum(case when o.order_from='pcweb' and rn=1 then coalesce(order_amount, 0) else 0 end)
	end
	as pcweb_sale_amt
--	=============订单量=============
-- 	单量
	,case
		when grouping(brand_id)=0
		then count(if(brand_rn=1, order_id, null))
		when grouping(min_class_id)=0
		then count(if(min_class_rn=1, order_id, null))
		when grouping(mid_class_id)=0
		then count(if(mid_class_rn=1, order_id, null))
		when grouping(max_class_id)=0
		then count(if(max_class_rn=1, order_id, null))
		when grouping(store_id)=0
		then count(if(store_rn=1, order_id, null))
		when grouping(trade_area_id)=0
		then count(if(trade_area_rn=1, order_id, null))
		when grouping(city_id)=0
		then count(if(city_rn=1, order_id, null))
		when grouping(dt)=0
		then count(if(rn=1, order_id, null))
	end
	as order_cnt
-- 	参评单量
	,case
		when grouping(brand_id)=0
		then count(if(brand_rn=1 and evaluation_id is not null, order_id, null))
		when grouping(min_class_id)=0
		then count(if(min_class_rn=1 and evaluation_id is not null, order_id, null))
		when grouping(mid_class_id)=0
		then count(if(mid_class_rn=1 and evaluation_id is not null, order_id, null))
		when grouping(max_class_id)=0
		then count(if(max_class_rn=1 and evaluation_id is not null, order_id, null))
		when grouping(store_id)=0
		then count(if(store_rn=1 and evaluation_id is not null, order_id, null))
		when grouping(trade_area_id)=0
		then count(if(trade_area_rn=1 and evaluation_id is not null, order_id, null))
		when grouping(city_id)=0
		then count(if(city_rn=1 and evaluation_id is not null, order_id, null))
		when grouping(dt)=0
		then count(if(rn=1 and evaluation_id is not null, order_id, null))
	end
	as eva_order_cnt,
--差评单量
	case
--		店铺
		when grouping(store_id)=0
		then count(case when evaluation_id is not null and coalesce(geval_scores, 0)<=6 and rn=1 then o.order_id else null end)
--		商圈
		when grouping(trade_area_id)=0
		then count(case when evaluation_id is not null and coalesce(geval_scores, 0)<=6 and rn=1 then o.order_id else null end)
--		城市
		when grouping(city_id)=0
		then count(case when evaluation_id is not null and coalesce(geval_scores, 0)<=6 and rn=1 then o.order_id else null end)
--		品牌
		when grouping(brand_id)=0
		then count(case when evaluation_id is not null and coalesce(geval_scores, 0)<=6 and brand_rn=1 then o.order_id else null end)
--		小类
		when grouping(min_class_id)=0
		then count(case when evaluation_id is not null and coalesce(geval_scores, 0)<=6 and min_class_rn=1 then o.order_id else null end)
--		中类
		when grouping(mid_class_id)=0
		then count(case when evaluation_id is not null and coalesce(geval_scores, 0)<=6 and mid_class_rn=1 then o.order_id else null end)
--		大类
		when grouping(max_class_id)=0
		then count(case when evaluation_id is not null and coalesce(geval_scores, 0)<=6 and max_class_rn=1 then o.order_id else null end)
--		全部
		else count(case when evaluation_id is not null and coalesce(geval_scores, 0)<=6 and rn=1 then o.order_id else null end)
	end
	as bad_eva_order_cnt,
--配送单量
	case
--		店铺
		when grouping(store_id)=0
		then count(case when delievery_id is not null and rn=1 then o.order_id else null end)
--		商圈
		when grouping(trade_area_id)=0
		then count(case when delievery_id is not null and rn=1 then o.order_id else null end)
--		城市
		when grouping(city_id)=0
		then count(case when delievery_id is not null and rn=1 then o.order_id else null end)
--		品牌
		when grouping(brand_id)=0
		then count(case when delievery_id is not null and brand_rn=1 then o.order_id else null end)
--		小类
		when grouping(min_class_id)=0
		then count(case when delievery_id is not null and min_class_rn=1 then o.order_id else null end)
--		中类
		when grouping(mid_class_id)=0
		then count(case when delievery_id is not null and mid_class_rn=1 then o.order_id else null end)
--		大类
		when grouping(max_class_id)=0
		then count(case when delievery_id is not null and max_class_rn=1 then o.order_id else null end)
--		全部
		else count(case when delievery_id is not null and rn=1 then o.order_id else null end)
	end
	as deliver_order_cnt,
--退款单量
	case
--		店铺
		when grouping(store_id)=0
		then count(case when refund_id is not null and rn=1 then o.order_id else null end)
--		商圈
		when grouping(trade_area_id)=0
		then count(case when refund_id is not null and rn=1 then o.order_id else null end)
--		城市
		when grouping(city_id)=0
		then count(case when refund_id is not null and rn=1 then o.order_id else null end)
--		品牌
		when grouping(brand_id)=0
		then count(case when refund_id is not null and brand_rn=1 then o.order_id else null end)
--		小类
		when grouping(min_class_id)=0
		then count(case when refund_id is not null and min_class_rn=1 then o.order_id else null end)
--		中类
		when grouping(mid_class_id)=0
		then count(case when refund_id is not null and mid_class_rn=1 then o.order_id else null end)
--		大类
		when grouping(max_class_id)=0
		then count(case when refund_id is not null and max_class_rn=1 then o.order_id else null end)
--		全部
		else count(case when refund_id is not null and rn=1 then o.order_id else null end)
	end
	as refund_order_cnt,
--小程序订单量
	case
--		店铺
		when grouping(store_id)=0
		then count(case when o.order_from='miniapp' and rn=1 then o.order_id else null end)
--		商圈
		when grouping(trade_area_id)=0
		then count(case when o.order_from='miniapp' and rn=1 then o.order_id else null end)
--		城市
		when grouping(city_id)=0
		then count(case when o.order_from='miniapp' and rn=1 then o.order_id else null end)
--		品牌
		when grouping(brand_id)=0
		then count(case when o.order_from='miniapp' and brand_rn=1 then o.order_id else null end)
--		小类
		when grouping(min_class_id)=0
		then count(case when o.order_from='miniapp' and min_class_rn=1 then o.order_id else null end)
--		中类
		when grouping(mid_class_id)=0
		then count(case when o.order_from='miniapp' and mid_class_rn=1 then o.order_id else null end)
--		大类
		when grouping(max_class_id)=0
		then count(case when o.order_from='miniapp' and max_class_rn=1 then o.order_id else null end)
--		全部
		else count(case when o.order_from='miniapp' and rn=1 then o.order_id else null end)
	end
	as miniapp_order_cnt,
--android订单量
	case
--		店铺
		when grouping(store_id)=0
		then count(case when o.order_from='android' and  rn=1 then o.order_id else null end)
--		商圈
		when grouping(trade_area_id)=0
		then count(case when o.order_from='android' and  rn=1 then o.order_id else null end)
--		城市
		when grouping(city_id)=0
		then count(case when o.order_from='android' and rn=1 then o.order_id else null end)
--		品牌
		when grouping(brand_id)=0
		then count(case when o.order_from='android' and brand_rn=1 then o.order_id else null end)
--		小类
		when grouping(min_class_id)=0
		then count(case when o.order_from='android' and min_class_rn=1 then o.order_id else null end)
--		中类
		when grouping(mid_class_id)=0
		then count(case when o.order_from='android' and mid_class_rn=1 then o.order_id else null end)
--		大类
		when grouping(max_class_id)=0
		then count(case when o.order_from='android' and max_class_rn=1 then o.order_id else null end)
--		全部
		else count(case when o.order_from='android' and rn=1 then o.order_id else null end)
	end
	as android_order_cnt,
--ios订单量
	case
--		店铺
		when grouping(store_id)=0
		then count(case when o.order_from='ios' and rn=1 then o.order_id else null end)
--		商圈
		when grouping(trade_area_id)=0
		then count(case when o.order_from='ios' and rn=1 then o.order_id else null end)
--		城市
		when grouping(city_id)=0
		then count(case when o.order_from='ios' and rn=1 then o.order_id else null end)
--		品牌
		when grouping(brand_id)=0
		then count(case when o.order_from='ios' and brand_rn=1 then o.order_id else null end)
--		小类
		when grouping(min_class_id)=0
		then count(case when o.order_from='ios' and min_class_rn=1 then o.order_id else null end)
--		中类
		when grouping(mid_class_id)=0
		then count(case when o.order_from='ios' and mid_class_rn=1 then o.order_id else null end)
--		大类
		when grouping(max_class_id)=0
		then count(case when o.order_from='ios' and max_class_rn=1 then o.order_id else null end)
--		全部
		else count(case when o.order_from='ios' and rn=1 then o.order_id else null end)
	end
	as ios_order_cnt,
--pc订单量
	case
--		店铺
		when grouping(store_id)=0
		then count(case when o.order_from='pcweb' and rn=1 then o.order_id else null end)
--		商圈
		when grouping(trade_area_id)=0
		then count(case when o.order_from='pcweb' and rn=1 then o.order_id else null end)
--		城市
		when grouping(city_id)=0
		then count(case when o.order_from='pcweb' and rn=1 then o.order_id else null end)
--		品牌
		when grouping(brand_id)=0
		then count(case when o.order_from='pcweb' and brand_rn=1 then o.order_id else null end)
--		小类
		when grouping(min_class_id)=0
		then count(case when o.order_from='pcweb' and min_class_rn=1 then o.order_id else null end)
--		中类
		when grouping(mid_class_id)=0
		then count(case when o.order_from='pcweb' and mid_class_rn=1 then o.order_id else null end)
--		大类
		when grouping(max_class_id)=0
		then count(case when o.order_from='pcweb' and max_class_rn=1 then o.order_id else null end)
--		全部
		else count(case when o.order_from='pcweb' and rn=1 then o.order_id else null end)
	end
	as pcweb_order_cnt,
    dt
from order_base o
--where b.rn=1
group by
grouping sets(
	dt,
	(dt, city_id, city_name, province_id, province_name),
	(dt, trade_area_id, trade_area_name, city_id, city_name, province_id, province_name),
	(dt, store_id, store_name, trade_area_id, trade_area_name, city_id, city_name, province_id, province_name),
	(dt, brand_id, brand_name),
	(dt, max_class_id, max_class_name),
	(dt, mid_class_id, mid_class_name, max_class_id, max_class_name),
	(dt, min_class_id, min_class_name, mid_class_id, mid_class_name, max_class_id, max_class_name)
)
--order by dt desc,  sum(coalesce(order_amount, 0)) desc
;


--=======商品主题宽表=======
insert into hive.yp_dws.dws_sku_daycount
with order_base as(
    select *,
       row_number() over(partition by order_id, goods_id) rn
    from yp_dwb.dwb_order_detail
),
-- 下单次数、件数、金额
order_count as (
    select dt, goods_id sku_id, goods_name sku_name,
           count(order_id) order_count,
           sum(coalesce(buy_num,0)) order_num,
           sum(coalesce(total_price,0)) order_amount
    from order_base
    where rn=1
    group by dt, goods_id, goods_name
),
pay_base as(
    select *,
       row_number() over(partition by order_id, goods_id) rn
    from yp_dwb.dwb_order_detail
    where is_pay=1
),
-- 支付次数、件数、金额
payment_count as(
    select dt, goods_id sku_id, goods_name sku_name,
       count(order_id) payment_count,
       sum(coalesce(buy_num,0)) payment_num,
       sum(coalesce(total_price,0)) payment_amount
    from pay_base
    where rn=1
    group by dt, goods_id, goods_name
),
refund_base as(
    select *,
       row_number() over(partition by order_id, goods_id) rn
    from yp_dwb.dwb_order_detail
    where refund_id is not null
),
-- 退款次数、件数、金额
refund_count as (
    select dt, goods_id sku_id, goods_name sku_name,
       count(order_id) refund_count,
       sum(coalesce(buy_num,0)) refund_num,
       sum(coalesce(total_price,0)) refund_amount
    from refund_base
    where rn=1
    group by dt, goods_id, goods_name
),
-- 购物车次数、件数
cart_count as (
    select substring(cart.create_time, 1, 10) dt, goods_id sku_id, goods_name sku_name,
           count(cart.id) cart_count,
            sum(coalesce(buy_num,0)) cart_num
    from yp_dwd.fact_shop_cart cart
    left join yp_dwb.dwb_goods_detail g on cart.goods_id=g.id
    where cart.end_date = '9999-99-99'
    group by substring(cart.create_time, 1, 10), goods_id, goods_name
),
-- 收藏次数
favor_count as (
    select substring(c.create_time, 1, 10) dt, goods_id sku_id, goods_name sku_name,
           count(c.id) favor_count
    from yp_dwd.fact_goods_collect c
    left join yp_dwb.dwb_goods_detail g on c.goods_id=g.id
    where c.end_date='9999-99-99'
    group by substring(c.create_time, 1, 10), goods_id, goods_name
),
-- 好评、中评、差评数量
evaluation_count as (
    select substring(geval_addtime, 1, 10) dt, e.goods_id sku_id, goods_name sku_name,
           count(if(geval_scores_goods >= 9, 1, null)) evaluation_good_count,
           count(if(geval_scores_goods >6 and geval_scores_goods < 9, 1, null)) evaluation_mid_count,
           count(if(geval_scores_goods <= 6, 1, null)) evaluation_bad_count
    from yp_dwd.fact_goods_evaluation_detail e
	left join yp_dwb.dwb_goods_detail g on e.goods_id=g.id
    group by substring(geval_addtime, 1, 10), e.goods_id, goods_name
),
unionall as (
    select
        dt, sku_id, sku_name,
        order_count,
        order_num,
        order_amount,
        0 as payment_count,
        0 as payment_num,
        0 as payment_amount,
        0 as refund_count,
        0 as refund_num,
        0 as refund_amount,
        0 as cart_count,
        0 as cart_num,
        0 as favor_count,
        0 as evaluation_good_count,
        0 as evaluation_mid_count,
        0 as evaluation_bad_count
    from order_count
    union all
    select
        dt, sku_id, sku_name,
        0 order_count,
        0 order_num,
        0 order_amount,
        payment_count,
        payment_num,
        payment_amount,
        0 as refund_count,
        0 as refund_num,
        0 as refund_amount,
        0 as cart_count,
        0 as cart_num,
        0 as favor_count,
        0 as evaluation_good_count,
        0 as evaluation_mid_count,
        0 as evaluation_bad_count
    from payment_count
    union all
    select
        dt, sku_id, sku_name,
        0 order_count,
        0 order_num,
        0 order_amount,
        0 as payment_count,
        0 as payment_num,
        0 as payment_amount,
        refund_count,
        refund_num,
        refund_amount,
        0 as cart_count,
        0 as cart_num,
        0 as favor_count,
        0 as evaluation_good_count,
        0 as evaluation_mid_count,
        0 as evaluation_bad_count
    from refund_count
    union all
    select
        dt, sku_id, sku_name,
        0 order_count,
        0 order_num,
        0 order_amount,
        0 as payment_count,
        0 as payment_num,
        0 as payment_amount,
        0 as refund_count,
        0 as refund_num,
        0 as refund_amount,
        cart_count,
        cart_num,
        0 as favor_count,
        0 as evaluation_good_count,
        0 as evaluation_mid_count,
        0 as evaluation_bad_count
    from cart_count
    union all
    select
        dt, sku_id, sku_name,
        0 order_count,
        0 order_num,
        0 order_amount,
        0 as payment_count,
        0 as payment_num,
        0 as payment_amount,
        0 as refund_count,
        0 as refund_num,
        0 as refund_amount,
        0 as cart_count,
        0 as cart_num,
        favor_count,
        0 as evaluation_good_count,
        0 as evaluation_mid_count,
        0 as evaluation_bad_count
    from favor_count
    union all
    select
        dt, sku_id, sku_name,
        0 order_count,
        0 order_num,
        0 order_amount,
        0 as payment_count,
        0 as payment_num,
        0 as payment_amount,
        0 as refund_count,
        0 as refund_num,
        0 as refund_amount,
        0 as cart_count,
        0 as cart_num,
        0 as favor_count,
        evaluation_good_count,
        evaluation_mid_count,
        evaluation_bad_count
    from evaluation_count
)
select
    dt, sku_id, max(sku_name),
    sum(coalesce(order_count, 0)),
    sum(coalesce(order_num,0)),
    sum(coalesce(order_amount,0)),
    sum(coalesce(payment_count,0)),
    sum(coalesce(payment_num,0)),
    sum(coalesce(payment_amount,0)),
    sum(coalesce(refund_count,0)),
    sum(coalesce(refund_num,0)),
    sum(coalesce(refund_amount,0)),
    sum(coalesce(cart_count,0)),
    sum(coalesce(cart_num,0)),
    sum(coalesce(favor_count,0)),
    sum(coalesce(evaluation_good_count,0)),
    sum(coalesce(evaluation_mid_count,0)),
    sum(coalesce(evaluation_bad_count,0))
from unionall
group by dt, sku_id
--order by dt, sku_id
;


--=======用户主题宽表=======
insert into yp_dws.dws_user_daycount
-- 登录次数
with login_count as (
   select
      count(id) as login_count,
      login_user as user_id, dt
   from yp_dwd.fact_user_login
   group by login_user, dt
),
-- 店铺收藏数
store_collect_count as (
   select
      count(id) as store_collect_count,
      user_id, substring(create_time, 1, 10) as dt
   from yp_dwd.fact_store_collect
   where end_date='9999-99-99'
   group by user_id, substring(create_time, 1, 10)
),
-- 商品收藏数
goods_collect_count as (
   select
      count(id) as goods_collect_count,
      user_id, substring(create_time, 1, 10) as dt
   from yp_dwd.fact_goods_collect
    where end_date='9999-99-99'
   group by user_id, substring(create_time, 1, 10)
),
-- 加入购物车次数和金额
cart_count_amount as (
   select
      count(cart.id) as cart_count,
      sum(coalesce(g.goods_promotion_price,0)) as cart_amount,
      buyer_id as user_id, substring(cart.create_time, 1, 10) as dt
   from yp_dwd.fact_shop_cart cart, yp_dwb.dwb_goods_detail g
   where cart.end_date='9999-99-99' and cart.goods_id=g.id
   group by buyer_id, substring(cart.create_time, 1, 10)
),
-- 下单次数和金额
order_count_amount as (
   select
      count(o.id) as order_count,
      sum(coalesce(order_amount,0)) as order_amount,
      buyer_id as user_id, substring(create_date, 1, 10) as dt
   from yp_dwd.fact_shop_order o, yp_dwd.fact_shop_order_address_detail od
   where o.id=od.id
     and o.is_valid=1 and o.end_date='9999-99-99' and od.end_date='9999-99-99'
   group by buyer_id, substring(create_date, 1, 10)
--	order by buyer_id, substring(create_date, 1, 10)
),
-- 支付次数和金额
payment_count_amount as (
   select
      count(id) as payment_count,
      sum(coalesce(order_amount,0)) as payment_amount,
      create_user user_id, substring(create_time, 1, 10) as dt
   from yp_dwd.fact_shop_order_address_detail
   where is_valid = 1 and pay_time is not null and end_date='9999-99-99'
   group by create_user, substring(create_time, 1, 10)
),
groupby as (
    select lc.login_count,
           0 store_collect_count,
           0 goods_collect_count,
           0 cart_count, 0 cart_amount,
           0 order_count, 0 order_amount,
           0 payment_count, 0 payment_amount,
           user_id, dt
    from login_count lc
    union all
    select
           0 login_count,
           scc.store_collect_count,
           0 goods_collect_count,
           0 cart_count, 0 cart_amount,
           0 order_count, 0 order_amount,
           0 payment_count, 0 payment_amount,
           user_id, dt
    from store_collect_count scc
    union all
    select
           0 login_count,
           0 store_collect_count,
           gcc.goods_collect_count,
           0 cart_count, 0 cart_amount,
           0 order_count, 0 order_amount,
           0 payment_count, 0 payment_amount,
           user_id, dt
    from goods_collect_count gcc
    union all
    select
           0 login_count,
           0 store_collect_count,
           0 goods_collect_count,
           cca.cart_count, cart_amount,
           0 order_count, 0 order_amount,
           0 payment_count, 0 payment_amount,
           user_id, dt
    from cart_count_amount cca
    union all
    select
           0 login_count,
           0 store_collect_count,
           0 goods_collect_count,
           0 cart_count, 0 cart_amount,
           oca.order_count, order_amount,
           0 payment_count, 0 payment_amount,
           user_id, dt
    from order_count_amount oca
    union all
    select
           0 login_count,
           0 store_collect_count,
           0 goods_collect_count,
           0 cart_count, 0 cart_amount,
           0 order_count, 0 order_amount,
           pca.payment_count, payment_amount,
           user_id, dt
    from payment_count_amount pca
)
select
              dt,
       user_id,
      -- 登录次数
       sum(coalesce(login_count,0)) login_count,
       -- 店铺收藏数
       sum(coalesce(store_collect_count,0)) store_collect_count,
       -- 商品收藏数
       sum(coalesce(goods_collect_count,0)) goods_collect_count,
       -- 加入购物车次数和金额
       sum(coalesce(cart_count,0)) cart_count,
       sum(coalesce(cart_amount,0)) cart_amount,
       -- 下单次数和金额
       sum(coalesce(order_count,0)) order_count,
       sum(coalesce(order_amount,0)) order_amount,
       -- 支付次数和金额
       sum(coalesce(payment_count,0)) payment_count,
       sum(coalesce(payment_amount,0)) payment_amount
--	   ,dt
from groupby
group by user_id, dt
;
"