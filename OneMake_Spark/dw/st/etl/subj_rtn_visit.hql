-- 回访服务人员数量
-- 回访人员数量
-- 回访工单状态数量（工单）
--     待派工数量(wait_dispatch_num)
--     待出发数量(wait_departure_num)
--     已完工工单数量(alread_complete_num)
--     正在处理工单数量(processing_num)
-- 回访结果数量
--     满意数量(satisfied_num)
--     不满意数量(unsatisfied_num)
--     服务态度满意数量(srv_atu_num)
--     服务态度不满意数量(srv_bad_atu_num)
--     服务维修水平满意数量(srv_rpr_prof_num)
--     服务维修水平不满意数量(srv_rpr_unprof_num)
--     服务响应速度满意数量(srv_high_res_num)
--     服务响应速度不满意数量(srv_low_res_num)
--     返修数量(rtn_rpr_num)
-- 回访人员最大数量
-- 回访人员最小数量
-- 维度
--     日期维度(月)
--     日期维度(周)
--     日期维度(日)
--     组织机构(回访人员所属部门)
--     组织机构(回访人员所属岗位)
--     组织机构(回访人员名称)
--     油站维度(油站类型)
--     油站维度(油站所属省)
--     油站维度(油站所属市)
--     油站维度(油站所属区)
--     客户维度(客户类型)
--     客户维度(客户所属省)
select sum(rtn_srv_num) rtn_srv_num, sum(vst_user) vst_user, sum(wait_dispatch_sumnum) wait_dispatch_sumnum,
       sum(wait_departure_sumnum) wait_departure_sumnum, sum(alread_complete_sumnum) alread_complete_sumnum, sum(processing_sumnum) processing_sumnum,
       sum(satisfied_sumnum) satisfied_sumnum, sum(unsatisfied_sumnum) unsatisfied_sumnum, sum(srv_atu_sumnum) srv_atu_sumnum,
       sum(srv_bad_atu_sumnum) srv_bad_atu_sumnum, sum(srv_rpr_prof_sumnum) srv_rpr_prof_sumnum, sum(srv_rpr_unprof_sumnum) srv_rpr_unprof_sumnum,
       sum(srv_high_res_sumnum) srv_high_res_sumnum, sum(srv_low_res_sumnum) srv_low_res_sumnum, sum(rtn_rpr_sumnum) rtn_rpr_sumnum,
       max(vst_user) max_vst_user, min(vst_user) min_vst_user, dws_day, dws_week, dws_month, orgname, posiname, empname, oil_type, oil_province,
       oil_city, oil_county, customer_classify, customer_province
from (
         select
             count(srv_user_id) rtn_srv_num,
             count(vst_user_id) vst_user,
             sum(fwo.wait_dispatch_num) wait_dispatch_sumnum,
             sum(fwo.wait_departure_num) wait_departure_sumnum,
             sum(fwo.alread_complete_num) alread_complete_sumnum,
             sum(fwo.processing_num) processing_sumnum,
             sum(satisfied_num) satisfied_sumnum,
             sum(unsatisfied_num) unsatisfied_sumnum,
             sum(srv_atu_num) srv_atu_sumnum,
             sum(srv_bad_atu_num) srv_bad_atu_sumnum,
             sum(srv_rpr_prof_num) srv_rpr_prof_sumnum,
             sum(srv_rpr_unprof_num) srv_rpr_unprof_sumnum,
             sum(srv_high_res_num) srv_high_res_sumnum,
             sum(srv_low_res_num) srv_low_res_sumnum,
             sum(rtn_rpr_num) rtn_rpr_sumnum,
             dd.date_id dws_day, dd.week_in_year_id dws_week, dd.year_month_id dws_month, orgname, posiname, empname, dimoil.company_name oil_type,
             dimoil.province_name oil_province, dimoil.city_name oil_city, dimoil.county_name oil_county, dimoil.customer_classify_name customer_classify,
             dimoil.customer_province_name customer_province
         from one_make_dwb.fact_srv_rtn_visit fsrv
                  left join one_make_dwb.fact_worker_order fwo on fsrv.wrkodr_id = fwo.wo_id
                  left join one_make_dws.dim_date dd on fsrv.dt = dd.date_id
                  left join one_make_dws.dim_oilstation dimoil on fsrv.os_id = dimoil.id
                  left join one_make_dws.dim_emporg emp on fsrv.vst_user_id = emp.empid
         group by fsrv.wrkodr_id, dd.date_id, dd.week_in_year_id, dd.year_month_id, emp.orgname, emp.posiname, emp.empname, dimoil.company_name, dimoil.province_name, dimoil.city_name, dimoil.county_name,
                  dimoil.customer_classify_name, dimoil.customer_province_name
     )
group by dws_day, dws_week, dws_month, orgname, posiname, empname, oil_type, oil_province, oil_city, oil_county, customer_classify, customer_province
;

-- 装载数据
insert overwrite table one_make_st.subj_rtn_visit partition(month = '202101', week='2021W1', day='20210101')
select sum(rtn_srv_num) rtn_srv_num, sum(vst_user) vst_user, sum(wait_dispatch_sumnum) wait_dispatch_sumnum,
       sum(wait_departure_sumnum) wait_departure_sumnum, sum(alread_complete_sumnum) alread_complete_sumnum, sum(processing_sumnum) processing_sumnum,
       sum(satisfied_sumnum) satisfied_sumnum, sum(unsatisfied_sumnum) unsatisfied_sumnum, sum(srv_atu_sumnum) srv_atu_sumnum,
       sum(srv_bad_atu_sumnum) srv_bad_atu_sumnum, sum(srv_rpr_prof_sumnum) srv_rpr_prof_sumnum, sum(srv_rpr_unprof_sumnum) srv_rpr_unprof_sumnum,
       sum(srv_high_res_sumnum) srv_high_res_sumnum, sum(srv_low_res_sumnum) srv_low_res_sumnum, sum(rtn_rpr_sumnum) rtn_rpr_sumnum,
       max(vst_user) max_vst_user, min(vst_user) min_vst_user, dws_day, dws_week, dws_month, orgname, posiname, empname, oil_type, oil_province,
       oil_city, oil_county, customer_classify, customer_province
from (
         select
             count(srv_user_id) rtn_srv_num,
             count(vst_user_id) vst_user,
             sum(fwo.wait_dispatch_num) wait_dispatch_sumnum,
             sum(fwo.wait_departure_num) wait_departure_sumnum,
             sum(fwo.alread_complete_num) alread_complete_sumnum,
             sum(fwo.processing_num) processing_sumnum,
             sum(satisfied_num) satisfied_sumnum,
             sum(unsatisfied_num) unsatisfied_sumnum,
             sum(srv_atu_num) srv_atu_sumnum,
             sum(srv_bad_atu_num) srv_bad_atu_sumnum,
             sum(srv_rpr_prof_num) srv_rpr_prof_sumnum,
             sum(srv_rpr_unprof_num) srv_rpr_unprof_sumnum,
             sum(srv_high_res_num) srv_high_res_sumnum,
             sum(srv_low_res_num) srv_low_res_sumnum,
             sum(rtn_rpr_num) rtn_rpr_sumnum,
             dd.date_id dws_day, dd.week_in_year_id dws_week, dd.year_month_id dws_month, orgname, posiname, empname, dimoil.company_name oil_type,
             dimoil.province_name oil_province, dimoil.city_name oil_city, dimoil.county_name oil_county, dimoil.customer_classify_name customer_classify,
             dimoil.customer_province_name customer_province
         from one_make_dwb.fact_srv_rtn_visit fsrv
                  left join one_make_dwb.fact_worker_order fwo on fsrv.wrkodr_id = fwo.wo_id
                  left join one_make_dws.dim_date dd on fsrv.dt = dd.date_id
                  left join one_make_dws.dim_oilstation dimoil on fsrv.os_id = dimoil.id
                  left join one_make_dws.dim_emporg emp on fsrv.vst_user_id = emp.empid
         where dd.year_month_id = '202101'and dd.week_in_year_id = '2021W1' and  dd.date_id = '20210101'
         group by fsrv.wrkodr_id, dd.date_id, dd.week_in_year_id, dd.year_month_id, emp.orgname, emp.posiname, emp.empname, dimoil.company_name, dimoil.province_name, dimoil.city_name, dimoil.county_name,
                  dimoil.customer_classify_name, dimoil.customer_province_name
     )
group by dws_day, dws_week, dws_month, orgname, posiname, empname, oil_type, oil_province, oil_city, oil_county, customer_classify, customer_province
;