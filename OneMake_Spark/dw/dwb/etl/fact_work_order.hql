-- wo_id	工单id
-- callaccept_id	来电受理单id
-- oil_station_id	油站id
-- userids	服务该工单用户id(注意：可能会有多个，以逗号分隔)
-- wo_num	工单单据数量
-- back_num	退回工单数量
-- abolished_num	已作废工单数量
-- wait_dispatch_num	待派工数量
-- wait_departure_num	待出发数量
-- alread_complete_num	已完工工单数量
-- processing_num	正在处理工单数量
-- people_num	工单人数数量
-- service_total_duration	服务总时长（按小时）
-- repair_service_duration	报修响应时长（按小时）
-- customer_repair_num	客户报修工单数量
-- charg_num	收费工单数量
-- repair_device_num	维修设备数量
-- install_device_num	安装设备数据量
-- install_num	安装单数量
-- repair_num	维修单数量
-- remould_num	巡检单数量
-- inspection_num	改造单数量
-- workerorder_trvl_exp	工单差旅费
select
    wo.id wo_id
     , max(callaccept_id) callaccept_id
     , max(oil_station_id) oil_station_id
     , max(case when wo.service_userids is not null then CONCAT_WS(',', wo.service_userid, wo.service_userids) else wo.service_userid end) userids
     , count(wo.id) wo_num
     , count(wob.id) back_num
     , sum(case when status = '-1' then 1 else 0 end) abolished_num
     , sum(case when status = '4' then 1 else 0 end) wait_dispatch_num
     , sum(case when status = '2' then 1 else 0 end) wait_departure_num
     , sum(case when status = '5' then 1 when status = '6' then 1 else 0 end) alread_complete_num
     , sum(case when status = '3' then 1 when status = '4' then 1 else 0 end) processing_num
     , case when count(usr.id) = 0 then 1 else count(usr.id) end people_num
     , max((wo.leave_time - wo.start_time) / 3600000) service_total_duration
     , max((wo.start_time - wo.submit_time) / 3600000) repair_service_duration
     , sum(case when wo.is_customer_repairs = '2' then 1 else 0 end) customer_repairs
     , sum(case when wo.is_charg = '1' then 1 else 0 end) charg_num
     , max(case when sod.repair_device_num = 0 then 1 when sod.repair_device_num is null then 0 else sod.repair_device_num end) repair_device_num
     , max(case when sod2.install_device_num = 0 then 1 when sod2.install_device_num is null then 0 else sod2.install_device_num end) install_device_num
     , sum(case when serType.installId is not null then 1 else 0 end) install_num
     , sum(case when serType.repairId is not null then 1 else 0 end) repair_num
     , sum(case when serType.remouldId is not null then 1 else 0 end) remould_num
     , sum(case when serType.inspectionId is not null then 1 else 0 end) inspection_num
     , max(case when ed.submoney5 is null then 0.0 else ed.submoney5 end) workorder_trvl_exp
from one_make_dwd.ciss_service_workorder wo
         left join one_make_dwd.ciss_service_workorder_back wob on wo.id = wob.workorder_id
         left join one_make_dwd.ciss_service_workorder_user usr on wo.id = usr.workorder_id
         left join one_make_dwd.ciss_service_trvl_exp_dtl ed on wo.id = ed.work_order_id
         left join (
    select so.workorder_id, count(sod.id) repair_device_num from one_make_dwd.ciss_service_order so left join one_make_dwd.ciss_service_order_device sod on so.id = sod.service_order_id where so.type = '2' group by so.workorder_id
) sod on wo.id = sod.workorder_id
         left join (
    select so.workorder_id, count(sod.id) install_device_num from one_make_dwd.ciss_service_order so left join one_make_dwd.ciss_service_order_device sod on so.id = sod.service_order_id where so.type = '1' group by so.workorder_id
) sod2 on wo.id = sod2.workorder_id
         left join (
            select so.id, so.workorder_id, install.id installId, repair.id repairId, remould.id remouldId, inspection.id inspectionId from one_make_dwd.ciss_service_order so
            left join one_make_dwd.ciss_service_install install on so.id = install.service_id
            left join one_make_dwd.ciss_service_repair repair on so.id = repair.service_id
            left join one_make_dwd.ciss_service_remould remould on so.id = remould.service_id
            left join one_make_dwd.ciss_service_inspection inspection on so.id = inspection.service_id
) serType on wo.id = serType.workorder_id
group by wo.id
;

-- 填充数据
insert overwrite table one_make_dwb.fact_worker_order partition(dt = '20210101')
select
    wo.id wo_id
     , max(callaccept_id) callaccept_id
     , max(oil_station_id) oil_station_id
     , max(case when wo.service_userids is not null then CONCAT_WS(',', wo.service_userid, wo.service_userids) else wo.service_userid end) userids
     , count(wo.id) wo_num
     , count(wob.id) back_num
     , sum(case when status = '-1' then 1 else 0 end) abolished_num
     , sum(case when status = '4' then 1 else 0 end) wait_dispatch_num
     , sum(case when status = '2' then 1 else 0 end) wait_departure_num
     , sum(case when status = '5' then 1 when status = '6' then 1 else 0 end) alread_complete_num
     , sum(case when status = '3' then 1 when status = '4' then 1 else 0 end) processing_num
     , case when count(usr.id) = 0 then 1 else count(usr.id) end people_num
     , max((wo.leave_time - wo.start_time) / 3600000) service_total_duration
     , max((wo.start_time - wo.submit_time) / 3600000) repair_service_duration
     , sum(case when wo.is_customer_repairs = '2' then 1 else 0 end) customer_repairs
     , sum(case when wo.is_charg = '1' then 1 else 0 end) charg_num
     , max(case when sod.repair_device_num = 0 then 1 when sod.repair_device_num is null then 0 else sod.repair_device_num end) repair_device_num
     , max(case when sod2.install_device_num = 0 then 1 when sod2.install_device_num is null then 0 else sod2.install_device_num end) install_device_num
     , sum(case when serType.installId is not null then 1 else 0 end) install_num
     , sum(case when serType.repairId is not null then 1 else 0 end) repair_num
     , sum(case when serType.remouldId is not null then 1 else 0 end) remould_num
     , sum(case when serType.inspectionId is not null then 1 else 0 end) inspection_num
     , max(case when ed.submoney5 is null then 0.0 else ed.submoney5 end) workorder_trvl_exp
from one_make_dwd.ciss_service_workorder wo
         left join one_make_dwd.ciss_service_workorder_back wob on wo.id = wob.workorder_id
         left join one_make_dwd.ciss_service_workorder_user usr on wo.id = usr.workorder_id
         left join one_make_dwd.ciss_service_trvl_exp_dtl ed on wo.id = ed.work_order_id
         left join (
    select so.workorder_id, count(sod.id) repair_device_num from one_make_dwd.ciss_service_order so left join one_make_dwd.ciss_service_order_device sod on so.id = sod.service_order_id where so.type = '2' and so.dt='20210101' group by so.workorder_id
) sod on wo.id = sod.workorder_id
         left join (
    select so.workorder_id, count(sod.id) install_device_num from one_make_dwd.ciss_service_order so left join one_make_dwd.ciss_service_order_device sod on so.id = sod.service_order_id where so.type = '1' and so.dt='20210101' group by so.workorder_id
) sod2 on wo.id = sod2.workorder_id
         left join (
    select so.id, so.workorder_id, install.id installId, repair.id repairId, remould.id remouldId, inspection.id inspectionId from one_make_dwd.ciss_service_order so
    left join one_make_dwd.ciss_service_install install on so.id = install.service_id
    left join one_make_dwd.ciss_service_repair repair on so.id = repair.service_id
    left join one_make_dwd.ciss_service_remould remould on so.id = remould.service_id
    left join one_make_dwd.ciss_service_inspection inspection on so.id = inspection.service_id
    where so.dt = '20210101'
) serType on wo.id = serType.workorder_id
where wo.dt='20210101'
group by wo.id
;

-- 对数
-- 工单事实表维度建模：维修单设备数量
select count(sod.id) repair_device_num from (select id from one_make_dwd.ciss_service_workorder) sw
left join ( select id, workorder_id from one_make_dwd.ciss_service_order where  type = 2) so on sw.id = so.workorder_id
left join (select id, service_order_id from one_make_dwd.ciss_service_order_device) sod on so.id = sod.service_order_id
group by sw.id
;
-- 安装单设备数量
select count(sod.id) repair_device_num from (select id from one_make_dwd.ciss_service_workorder) sw
left join ( select id, workorder_id from one_make_dwd.ciss_service_order where  type = 1) so on sw.id = so.workorder_id
left join (select id, service_order_id from one_make_dwd.ciss_service_order_device) sod on so.id = sod.service_order_id
group by sw.id
;
-- 安装单数量（此数量和以下三个数量计算，会有数据重叠，存在一个工单中既有巡检，又有维修的情况）
select count(si.id) install_workerorder_num from one_make_dwd.ciss_service_workorder wo
left join one_make_dwd.ciss_service_order so on wo.id = so.workorder_id
left join one_make_dwd.ciss_service_install si on so.id = si.service_id
where si.id is not null
;
-- 维修单数量
select count(sr.id) install_workerorder_num from one_make_dwd.ciss_service_workorder wo
left join one_make_dwd.ciss_service_order so on wo.id = so.workorder_id
left join one_make_dwd.ciss_service_repair sr on so.id = sr.service_id
where sr.id is not null
;
-- 巡检单数量
select count(sr.id) install_workerorder_num from one_make_dwd.ciss_service_workorder wo
left join one_make_dwd.ciss_service_order so on wo.id = so.workorder_id
left join one_make_dwd.ciss_service_remould sr on so.id = sr.service_id
where sr.id is not null
;
-- 改造单数量
select count(si.id) install_workerorder_num from one_make_dwd.ciss_service_workorder wo
left join one_make_dwd.ciss_service_order so on wo.id = so.workorder_id
left join one_make_dwd.ciss_service_inspection si on so.id = si.service_id
where si.id is not null
;
-- 工单差旅费
select wo.id, ed.submoney5 workerorder_trvl_exp from one_make_dwd.ciss_service_workorder wo
left join one_make_dwd.ciss_service_trvl_exp_dtl ed on wo.id = ed.work_order_id
where ed.id is not null
;