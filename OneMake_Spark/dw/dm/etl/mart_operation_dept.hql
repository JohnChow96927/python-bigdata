-- 运营部（部门主题数据集市）
--  工单ID(wo_id)
--  工单服务用户ID(userids) 用于后续关联数据导出数据到es
--  来电受理ID(callaccept_id) 用于后续关联数据导出数据到es
--  油站ID(oil_station_id) 用于后续关联数据导出数据到es
--  油站名称(os_name)
--  服务工时(service_total_duration)
--  维修工单数量(repair_num)
--  工单数量(wo_num)
--  油站总数(sum_os_num)
--  平均工单(avg_wo_num)
--  加油机在线设备总数(sum_os_online)
--  客户回访满意度率(atu_num_rate) 满意数 / (满意+不满意)
--  来电受理时长(小时)(rtn_visit_duration)
--  维度
--      按天 dws_day
--      按周 dws_week
--      按月 dws_month
select fwo.wo_id, max(fwo.userids) userids, max(fwo.callaccept_id) callaccept_id,
       max(fwo.oil_station_id) oil_station_id, max(fwo.service_total_duration) service_total_duration,
       max(fos.os_name) os_name, max(fwo.repair_num) repair_num, sum(fwo.wo_num) wo_num,
       count(fos.os_id) sum_os_num, avg(fwo.wo_num) avg_wo_num, sum(fos.valid_os_num) sum_os_online,
       max(fsrv.srv_atu_num / (fsrv.srv_atu_num + fsrv.srv_bad_atu_num)) atu_num_rate,
       max(fcs.interval / 3600.0) rtn_visit_duration,
       dd.date_id dws_day, dd.week_in_year_id dws_week, dd.year_month_id dws_month
from one_make_dwb.fact_worker_order fwo
left join one_make_dwb.fact_oil_station fos on fwo.oil_station_id = fos.os_id
left join one_make_dwb.fact_srv_rtn_visit fsrv on fwo.wo_id = fsrv.wrkodr_id
left join one_make_dwb.fact_call_service fcs on fwo.callaccept_id = fcs.id
left join one_make_dws.dim_date dd on fwo.dt = dd.date_id
group by fwo.wo_id, dd.date_id, dd.week_in_year_id, dd.year_month_id;

-- 装载数据
insert overwrite table one_make_dm.mart_operation_dept partition(month = '202101', week='2021W1', day='20210101')
select fwo.wo_id, max(fwo.userids) userids, max(fwo.callaccept_id) callaccept_id,
    max(fwo.oil_station_id) oil_station_id, max(fwo.service_total_duration) service_total_duration,
    max(fos.os_name) os_name, max(fwo.repair_num) repair_num, sum(fwo.wo_num) wo_num,
    count(fos.os_id) sum_os_num, avg(fwo.wo_num) avg_wo_num, sum(fos.valid_os_num) sum_os_online,
    max(fsrv.srv_atu_num / (fsrv.srv_atu_num + fsrv.srv_bad_atu_num)) atu_num_rate,
    max(fcs.interval / 3600.0) rtn_visit_duration,
    dd.date_id dws_day, dd.week_in_year_id dws_week, dd.year_month_id dws_month
from one_make_dwb.fact_worker_order fwo
    left join one_make_dwb.fact_oil_station fos on fwo.oil_station_id = fos.os_id
    left join one_make_dwb.fact_srv_rtn_visit fsrv on fwo.wo_id = fsrv.wrkodr_id
    left join one_make_dwb.fact_call_service fcs on fwo.callaccept_id = fcs.id
    left join one_make_dws.dim_date dd on fwo.dt = dd.date_id
where dd.year_month_id = '202101'and dd.week_in_year_id = '2021W1' and  dd.date_id = '20210101'
group by fwo.wo_id, dd.date_id, dd.week_in_year_id, dd.year_month_id;