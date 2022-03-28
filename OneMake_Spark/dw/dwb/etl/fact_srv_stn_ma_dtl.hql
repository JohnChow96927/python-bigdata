-- ss_id	服务中心ID
-- warehouse_id	仓库ID
-- m_code	物料编码
-- m_name	物料名称
-- total_m_num	物料申请总数量
-- total_m_money	物料申请总金额
-- inst_m_num	安装申请物料数量
-- inst_m_money	安装申请物料金额
-- bn_m_num	保内申请物料数量
-- bn_m_money	保内申请物料金额
-- rmd_m_num	改造申请物料数量
-- rmd_m_money	改造申请物料金额
-- rpr_m_num	维修申请物料数量
-- rpr_m_money	维修申请物料金额
-- sales_m_num	销售申请物料数量
-- sales_m_money	销售申请物料金额
-- insp_m_num	巡检申请物料数量
-- insp_m_money	巡检申请物料金额
select
      stn.id as ss_id
    , ma.warehouse_code as warehouse_id
    , m_smry.m_code
    , m_smry.m_name
    , sum(m_smry.cnt) as total_m_num
    , sum(m_smry.money) as total_m_money
    , count(1) as ma_form_num
    , sum(case when m_smry.ma_rsn = 1 then m_smry.cnt else 0 end) as inst_m_num
    , sum(case when m_smry.ma_rsn = 1 then m_smry.money else 0 end) as inst_m_money
    , sum(case when m_smry.ma_rsn = 2 then m_smry.cnt else 0 end) as bn_m_num
    , sum(case when m_smry.ma_rsn = 2 then m_smry.money else 0 end) as bn_m_money
    , sum(case when m_smry.ma_rsn = 3 then m_smry.cnt else 0 end) as rmd_m_num
    , sum(case when m_smry.ma_rsn = 3 then m_smry.money else 0 end) as rmd_m_money
    , sum(case when m_smry.ma_rsn = 4 then m_smry.cnt else 0 end) as rpr_m_num
    , sum(case when m_smry.ma_rsn = 4 then m_smry.money else 0 end) as rpr_m_money
    , sum(case when m_smry.ma_rsn = 5 then m_smry.cnt else 0 end) as sales_m_num
    , sum(case when m_smry.ma_rsn = 5 then m_smry.money else 0 end) as sales_m_money
    , sum(case when m_smry.ma_rsn = 6 then m_smry.cnt else 0 end) as insp_m_num
    , sum(case when m_smry.ma_rsn = 6 then m_smry.money else 0 end) as insp_m_money
from
    (select * from one_make_dwd.ciss_material_wdwl_sqd where dt = '20210101' and status = 8 /* 只处理已受理的申请单 */) ma
left join
    one_make_dwd.ciss_base_servicestation stn
    on stn.dt = '20210101' and ma.service_station_code = stn.code
left join
    (
        select
              dtl.wdwl_sqd_id as wdwl_sqd_id
            , dtl.application_reason as ma_rsn
            , dtl.code as m_code
            , dtl.description as m_name
            , sum(dtl.count_approve) as cnt
            , sum(dtl.price * dtl.count) as money
        from
            one_make_dwd.ciss_material_wdwl_sqd_dtl dtl
        where 
            dtl.dt = '20210101'
        group by
            dtl.wdwl_sqd_id
            , dtl.application_reason
            , dtl.code
            , dtl.description
    ) m_smry
    on m_smry.wdwl_sqd_id = ma.id
group by
      stn.id
    , ma.warehouse_code
    , m_smry.m_code
    , m_smry.m_name
limit 5
;

insert overwrite table one_make_dwb.fact_srv_stn_ma_dtl partition(dt = '20210101')
select
      stn.id as ss_id
    , ma.warehouse_code as warehouse_id
    , m_smry.m_code
    , m_smry.m_name
    , sum(m_smry.cnt) as total_m_num
    , sum(m_smry.money) as total_m_money
    , count(1) as ma_form_num
    , sum(case when m_smry.ma_rsn = 1 then m_smry.cnt else 0 end) as inst_m_num
    , sum(case when m_smry.ma_rsn = 1 then m_smry.money else 0 end) as inst_m_money
    , sum(case when m_smry.ma_rsn = 2 then m_smry.cnt else 0 end) as bn_m_num
    , sum(case when m_smry.ma_rsn = 2 then m_smry.money else 0 end) as bn_m_money
    , sum(case when m_smry.ma_rsn = 3 then m_smry.cnt else 0 end) as rmd_m_num
    , sum(case when m_smry.ma_rsn = 3 then m_smry.money else 0 end) as rmd_m_money
    , sum(case when m_smry.ma_rsn = 4 then m_smry.cnt else 0 end) as rpr_m_num
    , sum(case when m_smry.ma_rsn = 4 then m_smry.money else 0 end) as rpr_m_money
    , sum(case when m_smry.ma_rsn = 5 then m_smry.cnt else 0 end) as sales_m_num
    , sum(case when m_smry.ma_rsn = 5 then m_smry.money else 0 end) as sales_m_money
    , sum(case when m_smry.ma_rsn = 6 then m_smry.cnt else 0 end) as insp_m_num
    , sum(case when m_smry.ma_rsn = 6 then m_smry.money else 0 end) as insp_m_money
from
    (select * from one_make_dwd.ciss_material_wdwl_sqd where dt = '20210101' and status = 8 /* 只处理已受理的申请单 */) ma
left join
    one_make_dwd.ciss_base_servicestation stn
    on stn.dt = '20210101' and ma.service_station_code = stn.code
left join
    (
        select
              dtl.wdwl_sqd_id as wdwl_sqd_id
            , dtl.application_reason as ma_rsn
            , dtl.code as m_code
            , dtl.description as m_name
            , sum(dtl.count_approve) as cnt
            , sum(dtl.price * dtl.count) as money
        from
            one_make_dwd.ciss_material_wdwl_sqd_dtl dtl
        where 
            dtl.dt = '20210101'
        group by
            dtl.wdwl_sqd_id
            , dtl.application_reason
            , dtl.code
            , dtl.description
    ) m_smry
    on m_smry.wdwl_sqd_id = ma.id
group by
      stn.id
    , ma.warehouse_code
    , m_smry.m_code
    , m_smry.m_name
;

-- 对数SQL（正确为：均为48个已受理）
select * from one_make_dwb.fact_srv_stn_ma_dtl where dt = '20210101' limit 5;
select count(1) from one_make_dwb.fact_srv_stn_ma_dtl where dt = '20210101';

select 
    count(1)
from
    (select 
    ma.service_station_code, ma.warehouse_code, dtl.code, count(1)
    from 
    one_make_dwd.ciss_material_wdwl_sqd_dtl dtl 
    left join one_make_dwd.ciss_material_wdwl_sqd ma 
    on ma.id = dtl.wdwl_sqd_id and ma.dt = '20210101'
    where ma.status = 8
    group by ma.service_station_code, ma.warehouse_code, dtl.code) result
;