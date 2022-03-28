-- 安装费用(install_money)
-- 安装费用最大(max_install_money)
-- 安装费用最小(min_install_money)
-- 安装费用平均(avg_install_money)
-- 差旅费用类型总计
--     外出差旅费用金额总计(sumbiz_trip_money)
--     市内交通费用金额总计(sumin_city_traffic_money)
--     住宿费费用金额总计(sumhotel_money)
--     车船费用金额总计(sumfars_money)
--     补助费用金额总计(sumsubsidy_money)
--     过桥过路费用金额总计(sumroad_toll_money)
--     油费金额总计(sumoil_money)
-- 差旅费用扣款明细总计(exp_item_total)
-- 差旅费用总额统计(actual_total_money)
-- 差旅费用一阶段扣款总计(x)
-- 差旅费用二阶段扣款总计(sum_secondary_money)
-- 差旅费用三阶段扣款总计(sum_third_money)
-- 差旅费用四阶段扣款总计(x)
-- 差旅费用五阶段扣款总计(x)
-- 差旅费用一阶段最大扣款总计(x)
-- 差旅费用二阶段最大扣款总计(max_secondary_money)
-- 差旅费用三阶段最大扣款总计(max_third_money)
-- 差旅费用四阶段最大扣款总计(x)
-- 差旅费用五阶段最大扣款总计(x)
-- 报销平均耗时(x)
-- 报销最大耗时(x)
-- 报销最小耗时(x)
-- 报销人员总数量(sum_srv_user)
-- 报销人员最大数量(max_srv_user)
-- 报销人员最小数量(min_srv_user)
-- 报销人员平均数量(avg_srv_user)
-- 维度
--     日期维度(月)
--     日期维度(周)
--     日期维度(日)
--     油站维度(油站类型)
--     油站维度(油站所属省)
--     油站维度(油站所属市)
--     油站维度(油站所属区)
--     客户维度(客户类型)
--     客户维度(客户所属省)
select sum(install.exp_device_money) install_money, max(install.exp_device_money) max_install_money, min(install.exp_device_money) min_install_money,
       avg(install.exp_device_money) avg_install_money, sum(biz_trip_money) sumbiz_trip_money, sum(in_city_traffic_money) sumin_city_traffic_money,
       sum(hotel_money) sumhotel_money, sum(fars_money) sumfars_money, sum(subsidy_money) sumsubsidy_money, sum(road_toll_money) sumroad_toll_money,
       sum(oil_money) sumoil_money, count(distinct fre.exp_item_name) exp_item_total, sum(actual_total_money) actual_total_money,
       sum(fte.secondary_money) sum_secondary_money, sum(fte.third_money) sum_third_money, max(fte.secondary_money) max_secondary_money, max(fte.third_money) max_third_money,
       case when sum(size(split(fre.srv_user_id,','))) < 0 then 0 else sum(size(split(fre.srv_user_id,','))) end sum_srv_user,
       case when max(size(split(fre.srv_user_id,','))) < 0 then 0 else max(size(split(fre.srv_user_id,','))) end max_srv_user,
       case when min(size(split(fre.srv_user_id,','))) < 0 then 0 else min(size(split(fre.srv_user_id,','))) end min_srv_user,
       case when avg(size(split(fre.srv_user_id,','))) < 0 then 0 else avg(size(split(fre.srv_user_id,','))) end avg_srv_user,
       dd.date_id dws_day, dd.week_in_year_id dws_week, dd.year_month_id dws_month, dimoil.company_name oil_type, dimoil.province_name oil_province,
       dimoil.city_name oil_city, dimoil.county_name oil_county, dimoil.customer_classify_name customer_classify, dimoil.customer_province_name customer_province
from one_make_dwb.fact_trvl_exp fte
         left join one_make_dwb.fact_srv_install install on fte.ss_id = install.ss_id
         left join one_make_dwb.fact_regular_exp  fre on fte.srv_user_id = fre.srv_user_id
         left join one_make_dws.dim_date dd on fte.dt = dd.date_id
         left join one_make_dws.dim_oilstation dimoil on install.os_id = dimoil.id
group by inst_type_id, dd.date_id, dd.week_in_year_id, dd.year_month_id,  dimoil.company_name, dimoil.province_name, dimoil.city_name, dimoil.county_name,
         dimoil.customer_classify_name, dimoil.customer_province_name
;

-- 装载数据
insert overwrite table one_make_st.subj_expense partition(month = '202101', week='2021W1', day='20210101')
select sum(install.exp_device_money) install_money, max(install.exp_device_money) max_install_money, min(install.exp_device_money) min_install_money,
       avg(install.exp_device_money) avg_install_money, sum(biz_trip_money) sumbiz_trip_money, sum(in_city_traffic_money) sumin_city_traffic_money,
       sum(hotel_money) sumhotel_money, sum(fars_money) sumfars_money, sum(subsidy_money) sumsubsidy_money, sum(road_toll_money) sumroad_toll_money,
       sum(oil_money) sumoil_money, count(distinct fre.exp_item_name) exp_item_total, sum(actual_total_money) actual_total_money,
       sum(fte.secondary_money) sum_secondary_money, sum(fte.third_money) sum_third_money, max(fte.secondary_money) max_secondary_money, max(fte.third_money) max_third_money,
       sum(size(split(fre.srv_user_id,','))) sum_srv_user, max(size(split(fre.srv_user_id,','))) max_srv_user,
       min(size(split(fre.srv_user_id,','))) min_srv_user, avg(size(split(fre.srv_user_id,','))) avg_srv_user,
       dd.date_id dws_day, dd.week_in_year_id dws_week, dd.year_month_id dws_month, dimoil.company_name oil_type, dimoil.province_name oil_province,
       dimoil.city_name oil_city, dimoil.county_name oil_county, dimoil.customer_classify_name customer_classify, dimoil.customer_province_name customer_province
from one_make_dwb.fact_trvl_exp fte
         left join one_make_dwb.fact_srv_install install on fte.ss_id = install.ss_id
         left join one_make_dwb.fact_regular_exp  fre on fte.srv_user_id = fre.srv_user_id
         left join one_make_dws.dim_date dd on fte.dt = dd.date_id
         left join one_make_dws.dim_oilstation dimoil on install.os_id = dimoil.id
where dd.year_month_id = '202101'and dd.week_in_year_id = '2021W1' and  dd.date_id = '20210101'
group by inst_type_id, dd.date_id, dd.week_in_year_id, dd.year_month_id,  dimoil.company_name, dimoil.province_name, dimoil.city_name, dimoil.county_name,
         dimoil.customer_classify_name, dimoil.customer_province_name
;