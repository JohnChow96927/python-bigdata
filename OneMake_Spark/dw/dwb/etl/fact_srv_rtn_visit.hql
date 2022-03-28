-- vst_id	回访ID
-- vst_code	回访编号
-- wrkodr_id 工单ID
-- srv_user_id	服务人员ID
-- os_id	油站ID
-- cstm_id	用户ID
-- ss_id	服务网点ID
-- vst_user_id	回访人员ID
-- satisfied_num	满意数量
-- unsatisfied_num	不满意数量
-- srv_atu_num	服务态度满意数量
-- srv_bad_atu_num	服务态度不满意数量
-- srv_rpr_prof_num	服务维修水平满意数量
-- srv_rpr_unprof_num	服务维修水平不满意数量
-- srv_high_res_num	服务响应速度满意数量
-- srv_low_res_num	服务响应速度不满意数量
-- rtn_rpr_num	返修数量	IS_REPAIR为1
select visit.id vst_id, visit.code vst_code, visit.workorder_id wrkodr_id, swo.service_userid srv_user_id,
       swo.oil_station_id os_id, swo.service_station_id cstm_id, swo.service_station_id ss_id, visit.create_userid vst_user_id,
       satisfied_num, unsatisfied_num, srv_atu_num, srv_bad_atu_num, srv_rpr_prof_num, srv_rpr_unprof_num, srv_high_res_num,
       srv_low_res_num, rtn_rpr_num
from one_make_dwd.ciss_service_return_visit visit
         left join one_make_dwd.ciss_service_workorder swo on visit.workorder_id = swo.id
         left join (
    select
        visit.workorder_id,
        sum(case when visit.service_attitude = 1 and visit.response_speed = 1 and visit.repair_level = 1 and visit.yawp_problem_type = 1 then 1 else 0 end) satisfied_num,
        sum(case when visit.service_attitude = 0 then 1 when visit.response_speed = 0 then 1 when visit.repair_level = 0 then 1 when visit.yawp_problem_type = 0 then 1 else 0 end) unsatisfied_num,
        sum(case when visit.service_attitude = 1 then 1 else 0 end) srv_atu_num,
        sum(case when visit.service_attitude = 0 then 1 else 0 end) srv_bad_atu_num,
        sum(case when visit.repair_level = 1 then 1 else 0 end) srv_rpr_prof_num,
        sum(case when visit.repair_level = 0 then 1 else 0 end) srv_rpr_unprof_num,
        sum(case when visit.response_speed = 1 then 1 else 0 end) srv_high_res_num,
        sum(case when visit.response_speed = 0 then 1 else 0 end) srv_low_res_num,
        sum(case when visit.is_repair = 1 then 1 else 0 end) rtn_rpr_num
    from one_make_dwd.ciss_service_return_visit visit
             left join one_make_dwd.ciss_service_workorder swo on visit.workorder_id = swo.id
    where visit.dt = '20210101'
    group by visit.workorder_id
) vstswo on visit.workorder_id = vstswo.workorder_id
where visit.dt = '20210101'
;

insert overwrite table one_make_dwb.fact_srv_rtn_visit partition(dt = '20210101')
select visit.id vst_id, visit.code vst_code, visit.workorder_id wrkodr_id, swo.service_userid srv_user_id,
       swo.oil_station_id os_id, swo.service_station_id cstm_id, swo.service_station_id ss_id, visit.create_userid vst_user_id,
       satisfied_num, unsatisfied_num, srv_atu_num, srv_bad_atu_num, srv_rpr_prof_num, srv_rpr_unprof_num, srv_high_res_num,
       srv_low_res_num, rtn_rpr_num
from one_make_dwd.ciss_service_return_visit visit
         left join one_make_dwd.ciss_service_workorder swo on visit.workorder_id = swo.id
         left join (
    select
        visit.workorder_id,
        sum(case when visit.service_attitude = 1 and visit.response_speed = 1 and visit.repair_level = 1 and visit.yawp_problem_type = 1 then 1 else 0 end) satisfied_num,
        sum(case when visit.service_attitude = 0 then 1 when visit.response_speed = 0 then 1 when visit.repair_level = 0 then 1 when visit.yawp_problem_type = 0 then 1 else 0 end) unsatisfied_num,
        sum(case when visit.service_attitude = 1 then 1 else 0 end) srv_atu_num,
        sum(case when visit.service_attitude = 0 then 1 else 0 end) srv_bad_atu_num,
        sum(case when visit.repair_level = 1 then 1 else 0 end) srv_rpr_prof_num,
        sum(case when visit.repair_level = 0 then 1 else 0 end) srv_rpr_unprof_num,
        sum(case when visit.response_speed = 1 then 1 else 0 end) srv_high_res_num,
        sum(case when visit.response_speed = 0 then 1 else 0 end) srv_low_res_num,
        sum(case when visit.is_repair = 1 then 1 else 0 end) rtn_rpr_num
    from one_make_dwd.ciss_service_return_visit visit
             left join one_make_dwd.ciss_service_workorder swo on visit.workorder_id = swo.id
    where visit.dt = '20210101'
    group by visit.workorder_id
) vstswo on visit.workorder_id = vstswo.workorder_id
where visit.dt = '20210101'