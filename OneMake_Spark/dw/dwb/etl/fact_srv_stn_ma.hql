-- ma_id	申请单ID
-- ma_code	申请单编码
-- ss_id	服务网点ID
-- logi_id	物流类型ID
-- logi_cmp_id	物流公司ID
-- warehouse_id	仓库ID
-- total_m_num	申请物料总数量
-- total_m_money	申请物料总金额
-- ma_form_num	申请单数量
-- inst_m_num	安装申请物料数量
-- inst_m_money	安装申请物料金额
-- bn_m_num	保内申请物料数量
-- bn_m_money	保内申请物料金额
-- rmd_m_num	改造申请物料数量
-- rmd_m_money	改造申请物料金额
-- rpr_m_num	维修申请物料数量
-- rpr_m_money	维修申请物料金额
-- sales_m_num	销售申请物料数量
-- sales_m_money 销售申请物料金额
-- ipt_m_num    巡检申请物料数量
-- ipt_m_money  巡检申请物料金额
select
      ma.id as ma_id
    , ma.code as ma_code
    , stn.id as ss_id
    , ma.logistics_type as logi_id
    , ma.logistics_company as logi_cmp_id
    , ma.warehouse_code as warehouse_id
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
            , sum(dtl.count_approve) as cnt
            , sum(dtl.price * dtl.count) as money
        from
            one_make_dwd.ciss_material_wdwl_sqd_dtl dtl
        where 
            dtl.dt = '20210101'
        group by
            dtl.wdwl_sqd_id
            , dtl.application_reason
    ) m_smry
    on m_smry.wdwl_sqd_id = ma.id
group by
      ma.id
    , ma.code
    , stn.id
    , ma.logistics_type
    , ma.logistics_company
    , ma.warehouse_code
limit 5
;

insert overwrite table one_make_dwb.fact_srv_stn_ma partition(dt = '20210101')
select
    /*+repartition(1) */
      ma.id as ma_id
    , ma.code as ma_code
    , stn.id as ss_id
    , ma.logistics_type as logi_id
    , ma.logistics_company as logi_cmp_id
    , ma.warehouse_code as warehouse_id
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
            , sum(dtl.count_approve) as cnt
            , sum(dtl.price * dtl.count) as money
        from
            one_make_dwd.ciss_material_wdwl_sqd_dtl dtl
        where 
            dtl.dt = '20210101'
        group by
            dtl.wdwl_sqd_id
            , dtl.application_reason
    ) m_smry
    on m_smry.wdwl_sqd_id = ma.id
group by
      ma.id
    , ma.code
    , stn.id
    , ma.logistics_type
    , ma.logistics_company
    , ma.warehouse_code
;

-- 对数测试（均为14）
-- select * from one_make_dwb.fact_srv_stn_ma where dt = '20210101' limit 5;
-- select count(1) from one_make_dwb.fact_srv_stn_ma where dt = '20210101';
-- select count(1) from one_make_dwd.ciss_material_wdwl_sqd where dt = '20210101' and status = 8;