-- rpr_id	维修单ID
-- rpr_code	维修单编码
-- srv_user_id	服务人员ID
-- ss_id	服务网点ID
-- os_id	油站ID
-- date_id	日期ID
-- exp_rpr_num	收费维修数量
-- hour_money	工时费用
-- parts_money	配件费用
-- fars_money	车船费用
-- rpr_device_num	维修设备数量
-- rpr_mtrl_num	维修配件数量
-- exchg_parts_num	更换配件数量
-- upgrade_parts_num	升级配件数量
-- fault_type_ids	故障类型ID集合 Array类型
select repair.id rpr_id, repair.code rpr_code, swo.service_userid srv_user_id, swo.service_station_id ss_id, swo.oil_station_id os_id, swo.create_time date_id,
       case when repair.is_pay = 1 then 1 else 0 end exp_rpr_num, repair.hour_charge hour_money, repair.parts_charge parts_money,
       repair.fares_charge fars_money, rpr_device_num, rpr_mtrl_num, exchg_parts_num, upgrade_parts_num, fault_type_ids
from one_make_dwd.ciss_service_repair repair
         left join one_make_dwd.ciss_service_order sorder on repair.service_id = sorder.id
         left join one_make_dwd.ciss_service_workorder swo on sorder.workorder_id = swo.id
         left join (
    select rep.id, count(rep.id) rpr_device_num from one_make_dwd.ciss_service_repair rep
    left join one_make_dwd.ciss_service_order sod on rep.service_id = sod.id
    left join one_make_dwd.ciss_service_order_device dev on sod.id = dev.service_order_id
    group by rep.id
) repairdvc on repair.id = repairdvc.id
         left join (
    select rep.id,
           sum(case when sfd.solution_id = 1 then 1 else 0 end) rpr_mtrl_num,
           sum(case when sfd.solution_id = 2 then 1 else 0 end) exchg_parts_num,
           sum(case when sfd.solution_id = 3 then 1 else 0 end) upgrade_parts_num
    from one_make_dwd.ciss_service_repair rep
             left join one_make_dwd.ciss_service_order sod on rep.service_id = sod.id
             left join one_make_dwd.ciss_service_order_device dev on sod.id = dev.service_order_id
             left join one_make_dwd.ciss_service_fault_dtl sfd on dev.id = sfd.serviceorder_device_id
    group by dev.id,rep.id
) dvcnum on repair.id = dvcnum.id
         left join (
    select rep.id, concat_ws(',', collect_set(sfd.fault_type_id)) fault_type_ids
    from one_make_dwd.ciss_service_repair rep
             left join one_make_dwd.ciss_service_order sod on rep.service_id = sod.id
             left join one_make_dwd.ciss_service_order_device dev on sod.id = dev.service_order_id
             left join one_make_dwd.ciss_service_fault_dtl sfd on dev.id = sfd.serviceorder_device_id
--     where sfd.fault_type_id is not null
    group by rep.id
) faulttype on repair.id = faulttype.id
where repair.dt = '20210101'
;

insert overwrite table one_make_dwb.fact_srv_repair partition(dt = '20210101')
select repair.id rpr_id, repair.code rpr_code, swo.service_userid srv_user_id, swo.service_station_id ss_id, swo.oil_station_id os_id, swo.create_time date_id,
       case when repair.is_pay = 1 then 1 else 0 end exp_rpr_num, repair.hour_charge hour_money, repair.parts_charge parts_money,
       repair.fares_charge fars_money, rpr_device_num, rpr_mtrl_num, exchg_parts_num, upgrade_parts_num, fault_type_ids
from one_make_dwd.ciss_service_repair repair
         left join one_make_dwd.ciss_service_order sorder on repair.service_id = sorder.id
         left join one_make_dwd.ciss_service_workorder swo on sorder.workorder_id = swo.id
         left join (
    select rep.id, count(rep.id) rpr_device_num from one_make_dwd.ciss_service_repair rep
    left join one_make_dwd.ciss_service_order sod on rep.service_id = sod.id
    left join one_make_dwd.ciss_service_order_device dev on sod.id = dev.service_order_id
    group by rep.id
) repairdvc on repair.id = repairdvc.id
         left join (
    select rep.id,
           sum(case when sfd.solution_id = 1 then 1 else 0 end) rpr_mtrl_num,
           sum(case when sfd.solution_id = 2 then 1 else 0 end) exchg_parts_num,
           sum(case when sfd.solution_id = 3 then 1 else 0 end) upgrade_parts_num
    from one_make_dwd.ciss_service_repair rep
        left join one_make_dwd.ciss_service_order sod on rep.service_id = sod.id
        left join one_make_dwd.ciss_service_order_device dev on sod.id = dev.service_order_id
        left join one_make_dwd.ciss_service_fault_dtl sfd on dev.id = sfd.serviceorder_device_id
    group by dev.id,rep.id
) dvcnum on repair.id = dvcnum.id
         left join (
    select rep.id, concat_ws(',', collect_set(sfd.fault_type_id)) fault_type_ids
    from one_make_dwd.ciss_service_repair rep
        left join one_make_dwd.ciss_service_order sod on rep.service_id = sod.id
        left join one_make_dwd.ciss_service_order_device dev on sod.id = dev.service_order_id
        left join one_make_dwd.ciss_service_fault_dtl sfd on dev.id = sfd.serviceorder_device_id
--     where sfd.fault_type_id is not null
    group by rep.id
) faulttype on repair.id = faulttype.id
where repair.dt = '20210101'
;

-- 对数，故障类型id不为空的有170997个，为空的有5876
select count(1)
from one_make_dwd.ciss_service_repair rep
         left join one_make_dwd.ciss_service_order sod on rep.service_id = sod.id
         left join one_make_dwd.ciss_service_order_device dev on sod.id = dev.service_order_id
         left join one_make_dwd.ciss_service_fault_dtl sfd on dev.id = sfd.serviceorder_device_id
where sfd.fault_type_id is not null
;