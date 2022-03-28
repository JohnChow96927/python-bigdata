-- wkodr_id	工单id
-- csp_id	服务商id
-- os_id	油站id
-- wkodr_num	工单单据数量
-- cmp_wkodr_num	已完工工单数量（已完工）   
-- working_wkodr_num	正在处理工单数量（已提交）   
-- device_num	 设备数量
select
      wrkodr.id as wkodr_id
    , wrkodr.csp_id as csp_id
    , wrkodr.csp_os_id as os_id
    , 1
    , (case when wrkodr.status = 2 /* 已完工 */ then 1 else 0 end) as cmp_wkodr_num
    , (case when wrkodr.status = 1 /* 已提交 */ then 1 else 0 end) as working_wkodr_num
    , dvc.total_cnt as device_num
from 
    one_make_dwd.ciss_csp_workorder wrkodr
left join
    (
        select
              csp_workorder_id
            , count(factory_num) /* 出厂编号不为空的计数 */ as total_cnt
        from
            one_make_dwd.ciss_csp_workorder_device
        where
            dt = '20210101'
        group by
            csp_workorder_id
    ) dvc
    on wrkodr.dt = '20210101' and wrkodr.id = dvc.csp_workorder_id
limit 5
;

-- 加载到表中
insert overwrite table one_make_dwb.fact_csp_workorder partition(dt = '20210101')
select
      wrkodr.id as wkodr_id
    , wrkodr.csp_id as csp_id
    , wrkodr.csp_os_id as os_id
    , 1
    , (case when wrkodr.status = 2 /* 已完工 */ then 1 else 0 end) as cmp_wkodr_num
    , (case when wrkodr.status = 1 /* 已提交 */ then 1 else 0 end) as working_wkodr_num
    , dvc.total_cnt as device_num
from 
    one_make_dwd.ciss_csp_workorder wrkodr
left join
    (
        select
              csp_workorder_id
            , count(factory_num) /* 出厂编号不为空的计数 */ as total_cnt
        from
            one_make_dwd.ciss_csp_workorder_device
        where
            dt = '20210101'
        group by
            csp_workorder_id
    ) dvc
    on wrkodr.dt = '20210101' and wrkodr.id = dvc.csp_workorder_id
;

-- 对数（跑的结果为：6183条数据）
-- 1. 检查数据字段
select * from one_make_dwb.fact_csp_workorder where dt = '20210101' limit 5;
-- 2. 检查分区条数
select count(1) from one_make_dwb.fact_csp_workorder where dt = '20210101';
select count(1) from one_make_dwd.ciss_csp_workorder where dt = '20210101';