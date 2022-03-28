-- 派单类型数量
--     安装单数量
--     维修单数量
--     巡检单数量
--     改造单数量
-- 派单数最大值
-- 派单数最小值
-- 派单数平均值
-- 呼叫中心派单人
-- 呼叫中心最大派单
-- 呼叫中心最小派单
-- 呼叫中心平均派单
-- 派单平均值
-- 派单响应时长
-- 服务时长
-- 工单人数
select sum(fwo.install_num) install_sumnum, sum(fwo.repair_num) repair_sumnum, sum(fwo.remould_num) remould_sumnum, sum(fwo.inspection_num) inspection_sumnum,
       max(fwo.wo_num) max_wo_num, min(fwo.wo_num) min_wo_num, avg(fwo.wo_num) avg_wo_num, sum(fcs.userid) call_srv_user, max(fcs.dispatch_cnt) max_dispatch_cnt,
       min(fcs.dispatch_cnt) min_dispatch_cnt, avg(fcs.dispatch_cnt) avg_dispatch_cnt, sum(fwo.wo_num) / sum(fwo.people_num) people_wo_num,
       sum(fwo.repair_service_duration) srv_reps_duration, sum(fwo.service_total_duration) srv_duration, sum(fwo.people_num) pepople_sumnum,
       dd.date_id dws_day, dd.week_in_year_id dws_week, dd.year_month_id dws_month, orgname, posiname, empname, dimoil.company_name oil_type,
       dimoil.province_name oil_province, dimoil.city_name oil_city, dimoil.county_name oil_county, dimoil.customer_classify_name customer_classify,
       dimoil.customer_province_name customer_province
from one_make_dwb.fact_call_service fcs
         left join one_make_dwb.fact_worker_order fwo on fcs.id = fwo.callaccept_id
         left join one_make_dws.dim_emporg emp on fcs.userid = emp.empid
         left join one_make_dws.dim_date dd on fcs.dt = dd.date_id
         left join one_make_dws.dim_oilstation dimoil on fcs.oil_station_id = dimoil.id
group by dd.date_id, dd.week_in_year_id, dd.year_month_id, emp.orgname, emp.posiname, emp.empname, dimoil.company_name, dimoil.province_name,
         dimoil.city_name, dimoil.county_name, dimoil.customer_classify_name, dimoil.customer_province_name
;

-- 装载数据
insert overwrite table one_make_st.subj_dispatch partition(month = '202101', week='2021W1', day='20210101')
select sum(fwo.install_num) install_sumnum, sum(fwo.repair_num) repair_sumnum, sum(fwo.remould_num) remould_sumnum, sum(fwo.inspection_num) inspection_sumnum,
       max(fwo.wo_num) max_wo_num, min(fwo.wo_num) min_wo_num, avg(fwo.wo_num) avg_wo_num, sum(fcs.userid) call_srv_user, max(fcs.dispatch_cnt) max_dispatch_cnt,
       min(fcs.dispatch_cnt) min_dispatch_cnt, avg(fcs.dispatch_cnt) avg_dispatch_cnt, sum(fwo.wo_num) / sum(fwo.people_num) people_wo_num,
       sum(fwo.repair_service_duration) srv_reps_duration, sum(fwo.service_total_duration) srv_duration, sum(fwo.people_num) pepople_sumnum,
       dd.date_id dws_day, dd.week_in_year_id dws_week, dd.year_month_id dws_month, orgname, posiname, empname, dimoil.company_name oil_type,
       dimoil.province_name oil_province, dimoil.city_name oil_city, dimoil.county_name oil_county, dimoil.customer_classify_name customer_classify,
       dimoil.customer_province_name customer_province
from one_make_dwb.fact_call_service fcs
         left join one_make_dwb.fact_worker_order fwo on fcs.id = fwo.callaccept_id
         left join one_make_dws.dim_emporg emp on fcs.userid = emp.empid
         left join one_make_dws.dim_date dd on fcs.dt = dd.date_id
         left join one_make_dws.dim_oilstation dimoil on fcs.oil_station_id = dimoil.id
where dd.year_month_id = '202101'and dd.week_in_year_id = '2021W1' and  dd.date_id = '20210101'
group by dd.date_id, dd.week_in_year_id, dd.year_month_id, emp.orgname, emp.posiname, emp.empname, dimoil.company_name, dimoil.province_name,
         dimoil.city_name, dimoil.county_name, dimoil.customer_classify_name, dimoil.customer_province_name
;