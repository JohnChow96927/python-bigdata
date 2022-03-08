#! /bin/bash
export LANG=zh_CN.UTF-8
PRESTO_HOME=/export/server/presto/bin/presto


${PRESTO_HOME} --catalog hive --server 192.168.88.80:8090 --execute "
-- ======销售主题======
insert into yp_dm.dm_sale
-- 获取日期数据（周、月的环比/同比日期）
with dt1 as (
  select
   dim_date_id, date_code
    ,date_id_mom -- 与本月环比的上月日期
    ,date_id_mym -- 与本月同比的上年日期
    ,year_code
    ,month_code
    ,year_month     --年月
    ,day_month_num --几号
    ,week_day_code --周几
    ,year_week_name_cn  --年周
from yp_dwd.dim_date
),
groupby as (
	select
	-- 统计日期
	   '2021-08-31' as date_time,
	-- 时间维度      year、month、date
	   case when grouping(dt1.year_code, dt1.month_code, dt1.day_month_num, dt1.dim_date_id) = 0
	      then 'date'
	       when grouping(dt1.year_code, dt1.year_week_name_cn) = 0
	      then 'week'
	      when grouping(dt1.year_code, dt1.month_code, dt1.year_month) = 0
	      then 'month'
	      when grouping(dt1.year_code) = 0
	      then 'year'
	   end
	   as time_type,
	   dt1.year_code,
	   dt1.year_month,
	   dt1.month_code,
	   dt1.day_month_num, --几号
	   dt1.dim_date_id,
	    dt1.year_week_name_cn,  --第几周
	-- 产品维度类型：store，trade_area，city，brand，min_class，mid_class，max_class，all
	   CASE WHEN grouping(dc.store_id)=0
	         THEN 'store'
	         WHEN grouping(dc.trade_area_id)=0
	         THEN 'trade_area'
	         WHEN grouping(dc.city_id)=0
	         THEN 'city'
	         WHEN grouping(dc.brand_id)=0
	         THEN 'brand'
	         WHEN grouping(dc.min_class_id)=0
	         THEN 'min_class'
	         WHEN grouping(dc.mid_class_id)=0
	         THEN 'mid_class'
	         WHEN grouping(dc.max_class_id)=0
	         THEN 'max_class'
	         ELSE 'all'
	   END
	   as group_type_new,
	   grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id) grouping_id,
	   group_type group_type_old,
	   dc.province_id,
	   dc.province_name,
	   dc.city_id,
	   dc.city_name,
	   dc.trade_area_id,
	   dc.trade_area_name,
	   dc.store_id,
	   dc.store_name,
	   dc.brand_id,
	   dc.brand_name,
	   dc.max_class_id,
	   dc.max_class_name,
	   dc.mid_class_id,
	   dc.mid_class_name,
	   dc.min_class_id,
	   dc.min_class_name,
	-- 统计值
		CASE WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=15 and group_type='store'
	         THEN sum(dc.sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=79 and group_type='trade_area'
	         THEN sum(dc.sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=111 and group_type='city'
	         THEN sum(dc.sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=119 and group_type='brand'
	         THEN sum(dc.sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=120 and group_type='min_class'
	         THEN sum(dc.sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=124 and group_type='mid_class'
	         THEN sum(dc.sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=126 and group_type='max_class'
	         THEN sum(dc.sale_amt)
	         when grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=127 and group_type='all'
	         then sum(dc.sale_amt)
	         ELSE null
	    end
	   as sale_amt,
		CASE WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=15 and group_type='store'
	         THEN sum(dc.plat_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=79 and group_type='trade_area'
	         THEN sum(dc.plat_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=111 and group_type='city'
	         THEN sum(dc.plat_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=119 and group_type='brand'
	         THEN sum(dc.plat_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=120 and group_type='min_class'
	         THEN sum(dc.plat_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=124 and group_type='mid_class'
	         THEN sum(dc.plat_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=126 and group_type='max_class'
	         THEN sum(dc.plat_amt)
	         when grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=127 and group_type='all'
	         then sum(dc.plat_amt)
	         ELSE null
	    end
	   as plat_amt,
	   CASE WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=15 and group_type='store'
	         THEN sum(dc.deliver_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=79 and group_type='trade_area'
	         THEN sum(dc.deliver_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=111 and group_type='city'
	         THEN sum(dc.deliver_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=119 and group_type='brand'
	         THEN sum(dc.deliver_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=120 and group_type='min_class'
	         THEN sum(dc.deliver_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=124 and group_type='mid_class'
	         THEN sum(dc.deliver_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=126 and group_type='max_class'
	         THEN sum(dc.deliver_sale_amt)
	         when grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=127 and group_type='all'
	         then sum(dc.deliver_sale_amt)
	         ELSE null
	    end
	   as deliver_sale_amt,
	   CASE WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=15 and group_type='store'
	         THEN sum(dc.mini_app_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=79 and group_type='trade_area'
	         THEN sum(dc.mini_app_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=111 and group_type='city'
	         THEN sum(dc.mini_app_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=119 and group_type='brand'
	         THEN sum(dc.mini_app_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=120 and group_type='min_class'
	         THEN sum(dc.mini_app_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=124 and group_type='mid_class'
	         THEN sum(dc.mini_app_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=126 and group_type='max_class'
	         THEN sum(dc.mini_app_sale_amt)
	         when grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=127 and group_type='all'
	         then sum(dc.mini_app_sale_amt)
	         ELSE null
	    end
	   as mini_app_sale_amt,
	   CASE WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=15 and group_type='store'
	         THEN sum(dc.android_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=79 and group_type='trade_area'
	         THEN sum(dc.android_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=111 and group_type='city'
	         THEN sum(dc.android_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=119 and group_type='brand'
	         THEN sum(dc.android_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=120 and group_type='min_class'
	         THEN sum(dc.android_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=124 and group_type='mid_class'
	         THEN sum(dc.android_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=126 and group_type='max_class'
	         THEN sum(dc.android_sale_amt)
	         when grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=127 and group_type='all'
	         then sum(dc.android_sale_amt)
	         ELSE null
	    end
	    as android_sale_amt,
	   CASE WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=15 and group_type='store'
	         THEN sum(dc.ios_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=79 and group_type='trade_area'
	         THEN sum(dc.ios_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=111 and group_type='city'
	         THEN sum(dc.ios_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=119 and group_type='brand'
	         THEN sum(dc.ios_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=120 and group_type='min_class'
	         THEN sum(dc.ios_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=124 and group_type='mid_class'
	         THEN sum(dc.ios_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=126 and group_type='max_class'
	         THEN sum(dc.ios_sale_amt)
	         when grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=127 and group_type='all'
	         then sum(dc.ios_sale_amt)
	         ELSE null
	    end
	   as ios_sale_amt,
	   CASE WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=15 and group_type='store'
	         THEN sum(dc.pcweb_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=79 and group_type='trade_area'
	         THEN sum(dc.pcweb_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=111 and group_type='city'
	         THEN sum(dc.pcweb_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=119 and group_type='brand'
	         THEN sum(dc.pcweb_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=120 and group_type='min_class'
	         THEN sum(dc.pcweb_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=124 and group_type='mid_class'
	         THEN sum(dc.pcweb_sale_amt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=126 and group_type='max_class'
	         THEN sum(dc.pcweb_sale_amt)
	         when grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=127 and group_type='all'
	         then sum(dc.pcweb_sale_amt)
	         ELSE null
	    end
	   as pcweb_sale_amt,

	   CASE WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=15 and group_type='store'
	         THEN sum(dc.order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=79 and group_type='trade_area'
	         THEN sum(dc.order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=111 and group_type='city'
	         THEN sum(dc.order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=119 and group_type='brand'
	         THEN sum(dc.order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=120 and group_type='min_class'
	         THEN sum(dc.order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=124 and group_type='mid_class'
	         THEN sum(dc.order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=126 and group_type='max_class'
	         THEN sum(dc.order_cnt)
	         when grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=127 and group_type='all'
	         then sum(dc.order_cnt)
	         ELSE null
	    end
	   as order_cnt,
	   CASE WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=15 and group_type='store'
	         THEN sum(dc.eva_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=79 and group_type='trade_area'
	         THEN sum(dc.eva_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=111 and group_type='city'
	         THEN sum(dc.eva_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=119 and group_type='brand'
	         THEN sum(dc.eva_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=120 and group_type='min_class'
	         THEN sum(dc.eva_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=124 and group_type='mid_class'
	         THEN sum(dc.eva_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=126 and group_type='max_class'
	         THEN sum(dc.eva_order_cnt)
	         when grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=127 and group_type='all'
	         then sum(dc.eva_order_cnt)
	         ELSE null
	    end
	   as eva_order_cnt,
	   CASE WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=15 and group_type='store'
	         THEN sum(dc.bad_eva_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=79 and group_type='trade_area'
	         THEN sum(dc.bad_eva_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=111 and group_type='city'
	         THEN sum(dc.bad_eva_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=119 and group_type='brand'
	         THEN sum(dc.bad_eva_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=120 and group_type='min_class'
	         THEN sum(dc.bad_eva_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=124 and group_type='mid_class'
	         THEN sum(dc.bad_eva_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=126 and group_type='max_class'
	         THEN sum(dc.bad_eva_order_cnt)
	         when grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=127 and group_type='all'
	         then sum(dc.bad_eva_order_cnt)
	         ELSE null
	    end
	   as bad_eva_order_cnt,
	   CASE WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=15 and group_type='store'
	         THEN sum(dc.deliver_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=79 and group_type='trade_area'
	         THEN sum(dc.deliver_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=111 and group_type='city'
	         THEN sum(dc.deliver_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=119 and group_type='brand'
	         THEN sum(dc.deliver_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=120 and group_type='min_class'
	         THEN sum(dc.deliver_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=124 and group_type='mid_class'
	         THEN sum(dc.deliver_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=126 and group_type='max_class'
	         THEN sum(dc.deliver_order_cnt)
	         when grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=127 and group_type='all'
	         then sum(dc.deliver_order_cnt)
	         ELSE null
	    end
	   as deliver_order_cnt,
	   CASE WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=15 and group_type='store'
	         THEN sum(dc.refund_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=79 and group_type='trade_area'
	         THEN sum(dc.refund_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=111 and group_type='city'
	         THEN sum(dc.refund_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=119 and group_type='brand'
	         THEN sum(dc.refund_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=120 and group_type='min_class'
	         THEN sum(dc.refund_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=124 and group_type='mid_class'
	         THEN sum(dc.refund_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=126 and group_type='max_class'
	         THEN sum(dc.refund_order_cnt)
	         when grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=127 and group_type='all'
	         then sum(dc.refund_order_cnt)
	         ELSE null
	    end
	   as refund_order_cnt,
	   CASE WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=15 and group_type='store'
	         THEN sum(dc.miniapp_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=79 and group_type='trade_area'
	         THEN sum(dc.miniapp_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=111 and group_type='city'
	         THEN sum(dc.miniapp_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=119 and group_type='brand'
	         THEN sum(dc.miniapp_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=120 and group_type='min_class'
	         THEN sum(dc.miniapp_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=124 and group_type='mid_class'
	         THEN sum(dc.miniapp_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=126 and group_type='max_class'
	         THEN sum(dc.miniapp_order_cnt)
	         when grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=127 and group_type='all'
	         then sum(dc.miniapp_order_cnt)
	         ELSE null
	    end
	    as miniapp_order_cnt,
	   CASE WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=15 and group_type='store'
	         THEN sum(dc.android_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=79 and group_type='trade_area'
	         THEN sum(dc.android_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=111 and group_type='city'
	         THEN sum(dc.android_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=119 and group_type='brand'
	         THEN sum(dc.android_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=120 and group_type='min_class'
	         THEN sum(dc.android_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=124 and group_type='mid_class'
	         THEN sum(dc.android_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=126 and group_type='max_class'
	         THEN sum(dc.android_order_cnt)
	         when grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=127 and group_type='all'
	         then sum(dc.android_order_cnt)
	         ELSE null
	    end
	   as android_order_cnt,
	   CASE WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=15 and group_type='store'
	         THEN sum(dc.ios_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=79 and group_type='trade_area'
	         THEN sum(dc.ios_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=111 and group_type='city'
	         THEN sum(dc.ios_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=119 and group_type='brand'
	         THEN sum(dc.ios_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=120 and group_type='min_class'
	         THEN sum(dc.ios_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=124 and group_type='mid_class'
	         THEN sum(dc.ios_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=126 and group_type='max_class'
	         THEN sum(dc.ios_order_cnt)
	         when grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=127 and group_type='all'
	         then sum(dc.ios_order_cnt)
	         ELSE null
	    end
	    as ios_order_cnt,
	   CASE WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=15 and group_type='store'
	         THEN sum(dc.pcweb_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=79 and group_type='trade_area'
	         THEN sum(dc.pcweb_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=111 and group_type='city'
	         THEN sum(dc.pcweb_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=119 and group_type='brand'
	         THEN sum(dc.pcweb_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=120 and group_type='min_class'
	         THEN sum(dc.pcweb_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=124 and group_type='mid_class'
	         THEN sum(dc.pcweb_order_cnt)
	         WHEN grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=126 and group_type='max_class'
	         THEN sum(dc.pcweb_order_cnt)
	         when grouping(dc.store_id, dc.trade_area_id, dc.city_id, dc.brand_id, dc.min_class_id, dc.mid_class_id, dc.max_class_id)=127 and group_type='all'
	         then sum(dc.pcweb_order_cnt)
	         ELSE null
	    end
	    as pcweb_order_cnt
	from yp_dws.dws_sale_daycount dc
	   left join dt1 on dc.dt = dt1.date_code
	--WHERE dc.dt >= '2021-08-31'
	group by
	grouping sets (
	-- 年，注意养成加小括号的习惯
	   (dt1.year_code, group_type),
	   (dt1.year_code, city_id, city_name, province_id, province_name, group_type),
	   (dt1.year_code, city_id, city_name, province_id, province_name, trade_area_id, trade_area_name, group_type),
	   (dt1.year_code, city_id, city_name, province_id, province_name, trade_area_id, trade_area_name, store_id, store_name, group_type),
	    (dt1.year_code, brand_id, brand_name, group_type),
	    (dt1.year_code, max_class_id, max_class_name, group_type),
	    (dt1.year_code, max_class_id, max_class_name,mid_class_id, mid_class_name, group_type),
	    (dt1.year_code, max_class_id, max_class_name,mid_class_id, mid_class_name,min_class_id, min_class_name, group_type),
	--  月
	   (dt1.year_code, dt1.month_code, dt1.year_month, group_type),
	   (dt1.year_code, dt1.month_code, dt1.year_month, city_id, city_name, province_id, province_name, group_type),
	   (dt1.year_code, dt1.month_code, dt1.year_month, city_id, city_name, province_id, province_name, trade_area_id, trade_area_name, group_type),
	   (dt1.year_code, dt1.month_code, dt1.year_month, city_id, city_name, province_id, province_name, trade_area_id, trade_area_name, store_id, store_name, group_type),
	    (dt1.year_code, dt1.month_code, dt1.year_month, brand_id, brand_name, group_type),
	    (dt1.year_code, dt1.month_code, dt1.year_month, max_class_id, max_class_name, group_type),
	    (dt1.year_code, dt1.month_code, dt1.year_month, max_class_id, max_class_name,mid_class_id, mid_class_name, group_type),
	    (dt1.year_code, dt1.month_code, dt1.year_month, max_class_id, max_class_name,mid_class_id, mid_class_name,min_class_id, min_class_name, group_type),
	-- 日
	   (dt1.year_code, dt1.month_code, dt1.day_month_num, dt1.dim_date_id, group_type),
	   (dt1.year_code, dt1.month_code, dt1.day_month_num, dt1.dim_date_id, city_id, city_name, province_id, province_name, group_type),
	   (dt1.year_code, dt1.month_code, dt1.day_month_num, dt1.dim_date_id, city_id, city_name, province_id, province_name, trade_area_id, trade_area_name, group_type),
	   (dt1.year_code, dt1.month_code, dt1.day_month_num, dt1.dim_date_id, city_id, city_name, province_id, province_name, trade_area_id, trade_area_name, store_id, store_name, group_type),
	    (dt1.year_code, dt1.month_code, dt1.day_month_num, dt1.dim_date_id, brand_id, brand_name, group_type),
	    (dt1.year_code, dt1.month_code, dt1.day_month_num, dt1.dim_date_id, max_class_id, max_class_name, group_type),
	    (dt1.year_code, dt1.month_code, dt1.day_month_num, dt1.dim_date_id, max_class_id, max_class_name,mid_class_id, mid_class_name, group_type),
	    (dt1.year_code, dt1.month_code, dt1.day_month_num, dt1.dim_date_id, max_class_id, max_class_name,mid_class_id, mid_class_name,min_class_id, min_class_name, group_type),
	--  周
	   (dt1.year_code, dt1.year_week_name_cn, group_type),
	   (dt1.year_code, dt1.year_week_name_cn, city_id, city_name, province_id, province_name, group_type),
	   (dt1.year_code, dt1.year_week_name_cn, city_id, city_name, province_id, province_name, trade_area_id, trade_area_name, group_type),
	   (dt1.year_code, dt1.year_week_name_cn, city_id, city_name, province_id, province_name, trade_area_id, trade_area_name, store_id, store_name, group_type),
	    (dt1.year_code, dt1.year_week_name_cn, brand_id, brand_name, group_type),
	    (dt1.year_code, dt1.year_week_name_cn, max_class_id, max_class_name, group_type),
	    (dt1.year_code, dt1.year_week_name_cn, max_class_id, max_class_name,mid_class_id, mid_class_name, group_type),
	    (dt1.year_code, dt1.year_week_name_cn, max_class_id, max_class_name,mid_class_id, mid_class_name,min_class_id, min_class_name, group_type)
	)
	-- order by time_type desc
)
select
	-- 时间维度      year、month、date
	   time_type,
	   year_code,
	   year_month,
	   month_code,
	   day_month_num, --几号
	   dim_date_id,
	   year_week_name_cn,  --第几周
	-- 产品维度类型：store，trade_area，city，brand，min_class，mid_class，max_class，all
	   group_type_new as group_type,
--	     业务属性维度
	   province_id,
	   province_name,
	   city_id,
	   city_name,
	   trade_area_id,
	   trade_area_name,
	   store_id,
	   store_name,
	   brand_id,
	   brand_name,
	   max_class_id,
	   max_class_name,
	   mid_class_id,
	   mid_class_name,
	   min_class_id,
	   min_class_name,
--	     订单金额
	   sale_amt, plat_amt, deliver_sale_amt, mini_app_sale_amt, android_sale_amt, ios_sale_amt, pcweb_sale_amt,
--	     订单量
	   order_cnt, eva_order_cnt, bad_eva_order_cnt, deliver_order_cnt, refund_order_cnt, miniapp_order_cnt, android_order_cnt, ios_order_cnt, pcweb_order_cnt,
	-- 统计日期
	   date_time
from groupby
where sale_amt is not null
;

-- ======商品主题======
insert into yp_dm.dm_sku
with all_count as (
    select
        'all' time_type,
        null year_code,
        null year_month,
        sku_id, sku_name,
        sum(coalesce(order_count,0)) as order_count,
        sum(coalesce(order_num,0)) as order_num,
        sum(coalesce(order_amount,0)) as order_amount,
        sum(coalesce(payment_count,0)) payment_count,
        sum(coalesce(payment_num,0)) payment_num,
        sum(coalesce(payment_amount,0)) payment_amount,
        sum(coalesce(refund_count,0)) refund_count,
        sum(coalesce(refund_num,0)) refund_num,
        sum(coalesce(refund_amount,0)) refund_amount,
        sum(coalesce(cart_count,0)) cart_count,
        sum(coalesce(cart_num,0)) cart_num,
        sum(coalesce(favor_count,0)) favor_count,
        sum(coalesce(evaluation_good_count,0))   evaluation_good_count,
        sum(coalesce(evaluation_mid_count,0))    evaluation_mid_count,
        sum(coalesce(evaluation_bad_count,0))    evaluation_bad_count
    from yp_dws.dws_sku_daycount
--     where order_count > 0
    group by sku_id, sku_name
),
month as (
    select
        'month' time_type,
        substring(dt, 1, 4) year_code,
        substring(dt, 1, 7) year_month,
        sku_id,  max(sku_name),
        sum(coalesce(order_count,0)) as order_count,
        sum(coalesce(order_num,0)) as order_num,
        sum(coalesce(order_amount,0)) as order_amount,
        sum(coalesce(payment_count,0)) payment_count,
        sum(coalesce(payment_num,0)) payment_num,
        sum(coalesce(payment_amount,0)) payment_amount,
        sum(coalesce(refund_count,0)) refund_count,
        sum(coalesce(refund_num,0)) refund_num,
        sum(coalesce(refund_amount,0)) refund_amount,
        sum(coalesce(cart_count,0)) cart_count,
        sum(coalesce(cart_num,0)) cart_num,
        sum(coalesce(favor_count,0)) favor_count,
        sum(coalesce(evaluation_good_count,0))   evaluation_good_count,
        sum(coalesce(evaluation_mid_count,0))    evaluation_mid_count,
        sum(coalesce(evaluation_bad_count,0))    evaluation_bad_count
    from yp_dws.dws_sku_daycount
    group by sku_id, substring(dt, 1, 7), substring(dt, 1, 4)
)
select ac.*, '2021-08-31' date_time from all_count ac
union all
select m.*, '2021-08-31' date_time from month m;



-- ======用户主题======
-- 全量
insert into yp_dm.dm_user
-- 登录次数、首末日期
with login_count as (
    select
        min(dt) as login_date_first,
        max (dt) as login_date_last,
        sum(if(login_count>0,1,0)) as login_count,
       user_id
    from yp_dws.dws_user_daycount
    where login_count > 0
    group by user_id
),
-- 购物车次数、金额、首末日期
cart_count as (
    select
        min(dt) as cart_date_first,
        max(dt) as cart_date_last,
        sum(coalesce(cart_count, 0)) as cart_count,
        sum(coalesce(cart_amount, 0)) as cart_amount,
       user_id
    from yp_dws.dws_user_daycount
    where cart_count > 0
    group by user_id
),
-- 订单量、订单额、首末日期
order_count as (
    select
        min(dt) as order_date_first,
        max(dt) as order_date_last,
        sum(coalesce(order_count, 0)) as order_count,
        sum(coalesce(order_amount, 0)) as order_amount,
       user_id
    from yp_dws.dws_user_daycount
    where order_count > 0
    group by user_id
),
-- 支付单量、支付金额、首末日期
payment_count as (
    select
        min(dt) as payment_date_first,
        max(dt) as payment_date_last,
        sum(coalesce(payment_count, 0)) as payment_count,
        sum(coalesce(payment_amount, 0)) as payment_amount,
       user_id
    from yp_dws.dws_user_daycount
    where payment_count > 0
    group by user_id
),
fulljoin as (
    select
        'all' time_type,
        null year_code,
        null year_month,
        '2021-08-31' date_time,
        coalesce(l.user_id, o.user_id, p.user_id, cc.user_id) user_id,
    --    登录
        l.login_date_first,
        l.login_date_last,
        l.login_count,
    --    购物车
        cc.cart_date_first,
        cc.cart_date_last,
        cc.cart_count,
        cc.cart_amount,
    --    订单
        o.order_date_first,
        o.order_date_last,
        o.order_count,
        o.order_amount,
    --    支付
        p.payment_date_first,
        p.payment_date_last,
        p.payment_count,
        p.payment_amount
    from login_count l
    full join order_count o on l.user_id=o.user_id
    full join payment_count p on o.user_id=p.user_id
    full join cart_count cc on p.user_id=cc.user_id
),
all as (
select
        'all' time_type,
        null year_code,
        null year_month,
        user_id,
    --    登录
        min(login_date_first) login_date_first,
        max(login_date_last) login_date_last,
        sum(coalesce(login_count, 0)) login_count,
    --    购物车
        min(cart_date_first) cart_date_first,
        max(cart_date_last) cart_date_last,
        sum(coalesce(cart_count, 0)) cart_count,
        sum(coalesce(cart_amount, 0)) cart_amount,
    --    订单
        min(order_date_first) order_date_first,
        max(order_date_last) order_date_last,
        sum(coalesce(order_count, 0)) order_count,
        sum(coalesce(order_amount, 0)) order_amount,
    --    支付
        min(payment_date_first) payment_date_first,
        max(payment_date_last) payment_date_last,
        sum(coalesce(payment_count, 0)) payment_count,
        sum(coalesce(payment_amount, 0)) payment_amount
    from fulljoin
    group by user_id
),
-- select * from all order by user_id, login_count desc, cart_amount desc, order_count desc, payment_count desc;
-- 月份数据统计
month as (
    select
        'month' time_type,
        substring(dt, 1, 4) year_code,
        substring(dt, 1, 7) year_month,
        user_id,
        --    登录
        min(if(login_count>0, dt, null)) login_date_first,
        max(if(login_count>0, dt, null)) login_date_last,
        sum(if(login_count>0,1,0)) login_count,
        --    购物车
        min(if(cart_count>0, dt, null)) cart_date_first,
        max(if(cart_count>0, dt, null)) cart_date_last,
        sum(if(login_count>0, coalesce(cart_count,0), 0)) cart_count,
        sum(if(login_count>0, coalesce(cart_amount,0), 0)) cart_amount,
        --    订单
        min(if(order_count>0, dt, null)) order_date_first,
        max(if(order_count>0, dt, null)) order_date_last,
        sum(if(order_count>0, coalesce(order_count,0), 0)) order_count,
        sum(if(order_count>0, coalesce(order_amount,0), 0)) order_amount,
        --    支付
        min(if(payment_count>0, dt, null)) payment_date_first,
        max(if(payment_count>0, dt, null)) payment_date_last,
        sum(if(payment_count>0, coalesce(payment_count,0), 0)) payment_count,
        sum(if(payment_count>0, coalesce(payment_amount,0), 0)) payment_amount
    from yp_dws.dws_user_daycount
    group by user_id, substring(dt, 1, 7), substring(dt, 1, 4)
)
select *, '2021-08-31' date_time from all
union all
select *, '2021-08-31' date_time from month
;
"