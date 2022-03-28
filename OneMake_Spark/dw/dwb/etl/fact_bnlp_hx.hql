-- hx_id	核销单ID
-- hx_code	核销单编号
-- ss_id	服务网点ID
-- logi_cmp_id	物流公司ID
-- logi_type_id	物流类型ID
-- apply_id	申请人ID
-- warehouse_id	仓库ID
-- hx_m_num	核销配件总数量
-- hx_m_money	核销配件总金额
-- hx_form_num	核销申请单数量
select
      hx.id as hx_id
    , hx.code as hx_code
    , ss.id as ss_id
    , hx.logistics_company as logi_cmp_id
    , hx.logistics_type as logi_type_id
    , hx.applicant_id as apply_id
    , hx.warehouse_code as warehouse_id
    , sum(hx_dtl_smry.total_cnt) as hx_m_num
    , sum(hx_dtl_smry.total_money) as hx_m_money
    , 1
from
    (select * from one_make_dwd.ciss_material_bnlp_hx_sqd where status = 6 /* 只取已确认状态核销单 */) hx
left join 
    one_make_dwd.ciss_base_servicestation ss
    on hx.dt = '20210101' and ss.dt = '20210101' and hx.service_station_code = ss.code
left join
    (
        select
              dtl.bnlp_hx_sqd_id as hx_id
            , sum(dtl.count_actual_receive) as total_cnt                /* 取最终收货数量 */
            , sum(dtl.count_actual_receive * m.price) as total_money
        from
            one_make_dwd.ciss_material_bnlp_hx_sqd_dtl dtl              /* 核销明细表中没有存单价，需要从物料表中取 */
        left join
            one_make_dwd.ciss_base_material m
            on dtl.dt = '20210101' and m.dt = '20210101' and dtl.code = m.code
        group by
            bnlp_hx_sqd_id
    ) hx_dtl_smry        /* smry - summary */
    on hx.id = hx_dtl_smry.hx_id
group by
    hx.id
    , hx.code
    , ss.id
    , hx.logistics_company
    , hx.logistics_type
    , hx.applicant_id
    , hx.warehouse_code
limit 5
;

insert overwrite table one_make_dwb.fact_bnlp_hx partition (dt = '20210101')
select
    /*+repartitions(1) */
      hx.id as hx_id
    , hx.code as hx_code
    , ss.id as ss_id
    , hx.logistics_company as logi_cmp_id
    , hx.logistics_type as logi_type_id
    , hx.applicant_id as apply_id
    , hx.warehouse_code as warehouse_id
    , sum(hx_dtl_smry.total_cnt) as hx_m_num
    , sum(hx_dtl_smry.total_money) as hx_m_money
    , 1
from
    (select * from one_make_dwd.ciss_material_bnlp_hx_sqd where status = 6 /* 只取已确认状态核销单 */) hx
left join 
    one_make_dwd.ciss_base_servicestation ss
    on hx.dt = '20210101' and ss.dt = '20210101' and hx.service_station_code = ss.code
left join
    (
        select
              dtl.bnlp_hx_sqd_id as hx_id
            , sum(dtl.count_actual_receive) as total_cnt                /* 取最终收货数量 */
            , sum(dtl.count_actual_receive * m.price) as total_money
        from
            one_make_dwd.ciss_material_bnlp_hx_sqd_dtl dtl              /* 核销明细表中没有存单价，需要从物料表中取 */
        left join
            one_make_dwd.ciss_base_material m
            on dtl.dt = '20210101' and m.dt = '20210101' and dtl.code = m.code
        group by
            bnlp_hx_sqd_id
    ) hx_dtl_smry        /* smry - summary */
    on hx.id = hx_dtl_smry.hx_id
group by
    hx.id
    , hx.code
    , ss.id
    , hx.logistics_company
    , hx.logistics_type
    , hx.applicant_id
    , hx.warehouse_code
;

-- 对数（数量为1342）
select * from one_make_dwb.fact_bnlp_hx where dt = '20210101' limit 5;
select count(1) from one_make_dwb.fact_bnlp_hx where dt = '20210101';
select count(1) from one_make_dwd.ciss_material_bnlp_hx_sqd where dt = '20210101' and status = 6;