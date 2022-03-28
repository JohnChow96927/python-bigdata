-- 创建数据集市库
create database if not exists one_make_dm;

-- 创建运营部数据集市表
-- drop table if exists one_make_dm.mart_operation_dept;
create table if not exists one_make_dm.mart_operation_dept(
    wo_id string comment '工单ID'
    ,userids string comment '工单服务用户ID'
    ,callaccept_id string comment '来电受理ID'
    ,oil_station_id string comment '油站ID'
    ,os_name string comment '油站名称'
    ,service_total_duration decimal(20,2) comment '服务工时(小时)'
    ,repair_num bigint comment '维修工单数量'
    ,wo_num bigint comment '工单数量'
    ,sum_os_num bigint comment '油站总数'
    ,avg_wo_num int comment '平均工单'
    ,sum_os_online int comment '加油机在线设备总数'
    ,atu_num_rate decimal(5,2) comment '客户回访满意度率'
    ,rtn_visit_duration decimal(20,2) comment '来电受理时长(小时)'
    ,dws_day string comment '日期维度-按天'
    ,dws_week string comment '日期维度-按周'
    ,dws_month string comment '日期维度-按月'
) comment '运营部数据集市表'
    partitioned by (month String, week String, day String)
    stored as orc
    location '/data/dw/dm/one_make/mart_operation_dept'
;