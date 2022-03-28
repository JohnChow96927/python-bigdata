-- 安装数量(sum_install_num)
-- 安装最大数量(max_install_num)
-- 安装最小数量(min_install_num)
-- 安装平均数量(avg_min_install_num)
-- 维修数量(sum_repair_num)
-- 维修最大数量(max_repair_num)
-- 维修最小数量(min_repair_num)
-- 维修平均数量(avg_repair_num)
-- 派工数量(sum_wo_num)
-- 派工最大数量(max_sum_wo_num)
-- 派工最小数量(min_sum_wo_num)
-- 派工平均数量(avg_wo_num)
-- 巡检数量(sum_remould_num)
-- 巡检最大数量(max_remould_num)
-- 巡检最小数量(min_remould_num)
-- 巡检平均数量(avg_remould_num)
-- 回访数量(sum_alread_complete_num{alread_complete_num：包含已完工和已回访})
-- 回访最大数量(max_alread_complete_num)
-- 回访最小数量(min_alread_complete_num)
-- 回访平均数量(avg_alread_complete_num)
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
select
    sum(fwo.install_num) sum_install_num, max(fwo.install_num) max_install_num, min(fwo.install_num) min_install_num,
    avg(fwo.install_num) avg_min_install_num, sum(fwo.repair_num) sum_repair_num, max((fwo.repair_num)) max_repair_num,
    min(fwo.repair_num) min_repair_num, avg((fwo.repair_num)) avg_repair_num, sum(fwo.wo_num) sum_wo_num, max(fwo.wo_num) max_sum_wo_num,
    min(fwo.wo_num) min_sum_wo_num, avg(fwo.wo_num) avg_wo_num, sum(fwo.remould_num) sum_remould_num, max(fwo.remould_num) max_remould_num,
    min(fwo.remould_num) min_remould_num, avg(fwo.remould_num) avg_remould_num, sum(fwo.alread_complete_num) sum_alread_complete_num,
    max(fwo.alread_complete_num) max_alread_complete_num, min(fwo.alread_complete_num) min_alread_complete_num,
    avg(fwo.alread_complete_num) avg_alread_complete_num, dd.date_id dws_day, dd.week_in_year_id dws_week, dd.year_month_id dws_month, dimoil.company_name oil_type,
    dimoil.province_name oil_province, dimoil.city_name oil_city, dimoil.county_name oil_county, dimoil.customer_classify_name customer_classify,
    dimoil.customer_province_name customer_province
from one_make_dwb.fact_worker_order fwo
         left join one_make_dws.dim_date dd on fwo.dt = dd.date_id
         left join one_make_dws.dim_oilstation dimoil on fwo.oil_station_id = dimoil.id
group by dd.date_id, dd.week_in_year_id, dd.year_month_id, dimoil.company_name, dimoil.province_name, dimoil.city_name, dimoil.county_name,
         dimoil.customer_classify_name, dimoil.customer_province_name
;

-- 装载数据
insert overwrite table one_make_st.subj_customer partition(month = '202101', week='2021W1', day='20210101')
select
    sum(fwo.install_num) sum_install_num, max(fwo.install_num) max_install_num, min(fwo.install_num) min_install_num,
    avg(fwo.install_num) avg_min_install_num, sum(fwo.repair_num) sum_repair_num, max((fwo.repair_num)) max_repair_num,
    min(fwo.repair_num) min_repair_num, avg((fwo.repair_num)) avg_repair_num, sum(fwo.wo_num) sum_wo_num, max(fwo.wo_num) max_sum_wo_num,
    min(fwo.wo_num) min_sum_wo_num, avg(fwo.wo_num) avg_wo_num, sum(fwo.remould_num) sum_remould_num, max(fwo.remould_num) max_remould_num,
    min(fwo.remould_num) min_remould_num, avg(fwo.remould_num) avg_remould_num, sum(fwo.alread_complete_num) sum_alread_complete_num,
    max(fwo.alread_complete_num) max_alread_complete_num, min(fwo.alread_complete_num) min_alread_complete_num,
    avg(fwo.alread_complete_num) avg_alread_complete_num, dd.date_id dws_day, dd.week_in_year_id dws_week, dd.year_month_id dws_month, dimoil.company_name oil_type,
    dimoil.province_name oil_province, dimoil.city_name oil_city, dimoil.county_name oil_county, dimoil.customer_classify_name customer_classify,
    dimoil.customer_province_name customer_province
from one_make_dwb.fact_worker_order fwo
         left join one_make_dws.dim_date dd on fwo.dt = dd.date_id
         left join one_make_dws.dim_oilstation dimoil on fwo.oil_station_id = dimoil.id
where dd.year_month_id = '202101'and dd.week_in_year_id = '2021W1' and  dd.date_id = '20210101'
group by dd.date_id, dd.week_in_year_id, dd.year_month_id, dimoil.company_name, dimoil.province_name, dimoil.city_name, dimoil.county_name,
         dimoil.customer_classify_name, dimoil.customer_province_name
;