-- 支付费用统计
-- 小时费用统计
-- 零部件费用统计
-- 交通费用统计
-- 故障类型总数统计
-- 故障类型最大数量统计
-- 故障类型平均数量统计
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
--     物流公司(维度字段)
select sum(pay_money) sum_pay_money, sum(hour_money) sum_hour_money, sum(parts_money) sum_parts_money, sum(fars_money) sum_fars_money,
       sum(fault_type_num) sum_faulttype_num, max(fault_type_num) max_faulttype_num, avg(fault_type_num) avg_faulttype_num,
       dws_day, dws_week, dws_month, oil_type, oil_province, oil_city, oil_county, customer_classify, customer_province,logi_company
from (
         select
             (hour_money + parts_money+fars_money) pay_money, hour_money, parts_money, fars_money,
             case
                 when (size(split(fault_type_ids, ','))) <= 0 then 0
                 else (size(split(fault_type_ids, ','))) end fault_type_num
                 , dd.date_id dws_day, dd.week_in_year_id dws_week, dd.year_month_id dws_month, dimoil.company_name oil_type, dimoil.province_name oil_province,
             dimoil.city_name oil_city, dimoil.county_name oil_county, dimoil.customer_classify_name customer_classify,
             dimoil.customer_province_name customer_province, type_name logi_company
         from one_make_dwb.fact_srv_repair repair
                  left join one_make_dws.dim_date dd on repair.dt = dd.date_id
                  left join one_make_dws.dim_oilstation dimoil on repair.os_id = dimoil.id
                  left join one_make_dwb.fact_srv_stn_ma fssm on repair.ss_id = fssm.ss_id
                  left join (select type_id, type_name from one_make_dws.dim_logistics where prop_name = '物流公司') dl on fssm.logi_cmp_id = dl.type_id
         where exp_rpr_num = 1
     ) repair_tmp
group by dws_day, dws_week, dws_month, oil_type, oil_province, oil_city, oil_county, customer_classify, customer_province,logi_company
;

-- 装载数据
insert overwrite table one_make_st.subj_repair partition(month = '202101', week='2021W1', day='20210101')
select sum(pay_money) sum_pay_money, sum(hour_money) sum_hour_money, sum(parts_money) sum_parts_money, sum(fars_money) sum_fars_money,
       sum(fault_type_num) sum_faulttype_num, max(fault_type_num) max_faulttype_num, avg(fault_type_num) avg_faulttype_num,
       dws_day, dws_week, dws_month, oil_type, oil_province, oil_city, oil_county, customer_classify, customer_province,logi_company
from (
         select
             (hour_money + parts_money+fars_money) pay_money, hour_money, parts_money, fars_money,
             case
                 when (size(split(fault_type_ids, ','))) <= 0 then 0
                 else (size(split(fault_type_ids, ','))) end fault_type_num
                 , dd.date_id dws_day, dd.week_in_year_id dws_week, dd.year_month_id dws_month, dimoil.company_name oil_type, dimoil.province_name oil_province,
             dimoil.city_name oil_city, dimoil.county_name oil_county, dimoil.customer_classify_name customer_classify,
             dimoil.customer_province_name customer_province, type_name logi_company
         from one_make_dwb.fact_srv_repair repair
                  left join one_make_dws.dim_date dd on repair.dt = dd.date_id
                  left join one_make_dws.dim_oilstation dimoil on repair.os_id = dimoil.id
                  left join one_make_dwb.fact_srv_stn_ma fssm on repair.ss_id = fssm.ss_id
                  left join (select type_id, type_name from one_make_dws.dim_logistics where prop_name = '物流公司') dl on fssm.logi_cmp_id = dl.type_id
         where dd.year_month_id = '202101'and dd.week_in_year_id = '2021W1' and  dd.date_id = '20210101' and exp_rpr_num = 1
     ) repair_tmp
group by dws_day, dws_week, dws_month, oil_type, oil_province, oil_city, oil_county, customer_classify, customer_province,logi_company
;