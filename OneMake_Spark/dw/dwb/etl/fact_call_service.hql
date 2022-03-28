-- 来电受理事实表ETL处理

-- 为了方便后续取业务字典中的数据，我们将业务字典的数据拉宽，放到一个临时表中
drop table if exists one_make_dwb.tmp_dict;
create table if not exists one_make_dwb.tmp_dict
stored as orc
as
select
    dict_t.dicttypename         -- 字典名称
    , dict_e.dictid             -- 字典编号
    , dict_e.dictname           -- 字典名称
from
    one_make_dwd.eos_dict_type dict_t
left join
    one_make_dwd.eos_dict_entry dict_e
on dict_t.dt = '20210101'
    and dict_e.dt = '20210101'
    and dict_t.dicttypeid = dict_e.dicttypeid
order by
  dict_t.dicttypename
  , dict_e.dictid
;

-- id	受理id（唯一标识）
-- code	受理单唯一编码
-- call_date	来电日期（日期ID）
-- call_hour	来电时间（小时）（事实维度）
-- call_type_id	来电类型（事实维度）
-- call_type_name	来电类型名称（事实维度）
-- process_way_id	受理方式（事实维度）
-- process_way_name	受理方式（事实维度）
-- oil_station_id	油站ID
-- userid	受理人员ID
-- cnt	单据数量（指标列）
-- dispatch_cnt	派工数量
-- cancellation_cnt	派工单作废数量
-- chargeback_cnt	派工单退单数量
-- interval	受理时长（单位：秒）
-- tel_spt_cnt	电话支持数量
-- on_site_spt_cnt	现场安装、维修、改造、巡检数量
-- custm_visit_cnt	回访单据数量
-- complain_cnt	投诉单据数量
-- other_cnt	其他业务单据数量
insert overwrite table one_make_dwb.fact_call_service partition (dt = '20210101')
select
    call.id
    , call.code -- 受理单唯一编码
    , date_format(timestamp(call.call_time), 'yyyyMMdd') as call_date -- 来电日期（日期ID）
    , hour(timestamp(call.call_time))  -- 来电时间（小时）（事实维度）
    , call.call_type -- 来电类型（事实维度）
    , call_dict.dictname -- 来电类型名称（事实维度）
    , call.process_way -- 受理方式（事实维度）
    , process_dict.dictname -- 受理方式（事实维度）
    , call.call_oilstation_id -- 油站ID
    , call.accept_userid -- 受理人员ID
    , 1 -- 单据数量（指标列）
    , case when call.process_way = 5  then 1 else 0 end -- 派工数量
    , case when workorder.status = -1 then 1 else 0 end -- 派工单作废数量
    , case when workorder.status = -2 then 1 else 0 end -- 派工单退单数量
    , floor(to_unix_timestamp(timestamp(call.process_time),'yyyy-MM-dd HH:mm:ss') - to_unix_timestamp(timestamp(call.call_time), 'yyyy-MM-dd HH:mm:ss') / 1000.0) -- 受理时长（单位：秒）
    , case when call.call_type = 5 then 1 else 0 end -- 电话支持数量
    , case when call.call_type in (1, 2, 3, 4) then 1 else 0 end -- 现场安装、维修、改造、巡检数量
    , case when call.call_type = 7 then 1 else 0 end -- 回访单据数量
    , case when call.call_type = 8 then 1 else 0 end -- 投诉单据数量
    , case when call.call_type = 9 or call.call_type = 6 then 1 else 0 end -- 其他业务单据数量
from
    one_make_dwd.ciss_service_callaccept call
left join
    one_make_dwb.tmp_dict call_dict
    on call.call_type = call_dict.dictid
        and call_dict.dicttypename = '来电类型'
left join
    one_make_dwb.tmp_dict process_dict
    on call.process_way = process_dict.dictid
        and process_dict.dicttypename = '来电受理单--处理方式'
left join
    one_make_dwd.ciss_service_workorder workorder
    on workorder.dt = '20210101' 
        and workorder.callaccept_id = call.id
where
    call.dt = '20210101' 
        and call.code != 'NULL'         -- 受理编码不为NULL
        and call.call_time is not null  -- 受理时间不为NULL
;

select * from one_make_dwb.fact_call_service limit 5;