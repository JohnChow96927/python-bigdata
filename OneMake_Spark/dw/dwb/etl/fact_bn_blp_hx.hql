-- blphx_id	不良品核销申请ID
-- blphx_code	不良品核销编码
-- ss_id	服务网点ID
-- logi_cmp_id	物流公司ID
-- logi_type_id	物流类型ID
-- warehouse_id	仓库ID
-- hx_m_num	核销配件总数量
-- hx_m_money	核销配件金额
-- hx_exchg_m_num	工单配件更换数量
-- hx_exchg_m_money	工单配置更换金额
-- hx_form_num	核销申请单数量
select
      hx.id as blphx_id
    , hx.code as blphx_code
    , ss.id as ss_id
    , hx.logistics_company as logi_cmp_id
    , hx.logistics_type as logi_type_id
    , hx.warehouse_code as warehouse_id
    , sum(hx_smry.total_cnt) as hx_m_num
    , sum(hx_smry.total_money) as hx_m_money
    , sum(hx_smry.total_ex_cnt) as hx_exchg_m_num
    , sum(hx_smry.total_ex_money) as hx_exchg_m_money
    , 1 as hx_form_num
from
    (select * from one_make_dwd.ciss_material_bnblp_hx_sqd where status = 6 /* 取已完成的核销单 */) hx
left join 
    (
        select
              dtl.bnblp_hx_sqd_id as bnblp_hx_sqd_id
            , sum(dtl.count_actual_receive) as total_cnt
            , sum(dtl.count_actual_receive * m.price) as total_money 
            , sum(ex.count) as total_ex_cnt
            , sum(ex.count *m.price) as total_ex_money
        from
            one_make_dwd.ciss_material_bnblp_hx_sqd_dtl dtl
        left join
            one_make_dwd.ciss_base_material m
            on dtl.dt = '20210101' and m.dt = '20210101' and dtl.code = m.code
        left join
            one_make_dwd.ciss_service_exchanged_m_dtl ex                                        /* 工单更换数量 */
            on ex.dt = '20210101' and ex.status = 3 and dtl.exchanged_m_dtl_id = ex.id          /* 更换已核销的配件 */
        group by
            dtl.bnblp_hx_sqd_id
    ) hx_smry
    on hx.dt = '20210101' and hx.id = hx_smry.bnblp_hx_sqd_id
left join
    one_make_dwd.ciss_base_servicestation ss
    on ss.dt = '20210101' and ss.code = hx.service_station_code
group by
      hx.id
    , hx.code
    , ss.id
    , hx.logistics_company
    , hx.logistics_type
    , hx.warehouse_code
limit 5
;

insert overwrite table one_make_dwb.fact_bn_blp_hx partition(dt = '20210101')
select
    /*+repartitions(1) */
      hx.id as blphx_id
    , hx.code as blphx_code
    , ss.id as ss_id
    , hx.logistics_company as logi_cmp_id
    , hx.logistics_type as logi_type_id
    , hx.warehouse_code as warehouse_id
    , sum(hx_smry.total_cnt) as hx_m_num
    , sum(hx_smry.total_money) as hx_m_money
    , sum(hx_smry.total_ex_cnt) as hx_exchg_m_num
    , sum(hx_smry.total_ex_money) as hx_exchg_m_money
    , 1 as hx_form_num
from
    (select * from one_make_dwd.ciss_material_bnblp_hx_sqd where status = 6 /* 取已完成的核销单 */) hx
left join 
    (
        select
              dtl.bnblp_hx_sqd_id as bnblp_hx_sqd_id
            , sum(dtl.count_actual_receive) as total_cnt
            , sum(dtl.count_actual_receive * m.price) as total_money 
            , sum(ex.count) as total_ex_cnt
            , sum(ex.count *m.price) as total_ex_money
        from
            one_make_dwd.ciss_material_bnblp_hx_sqd_dtl dtl
        left join
            one_make_dwd.ciss_base_material m
            on dtl.dt = '20210101' and m.dt = '20210101' and dtl.code = m.code
        left join
            one_make_dwd.ciss_service_exchanged_m_dtl ex                                        /* 工单更换数量 */
            on ex.dt = '20210101' and ex.status = 3 and dtl.exchanged_m_dtl_id = ex.id          /* 更换已核销的配件 */
        group by
            dtl.bnblp_hx_sqd_id
    ) hx_smry
    on hx.dt = '20210101' and hx.id = hx_smry.bnblp_hx_sqd_id
left join
    one_make_dwd.ciss_base_servicestation ss
    on ss.dt = '20210101' and ss.code = hx.service_station_code
group by
      hx.id
    , hx.code
    , ss.id
    , hx.logistics_company
    , hx.logistics_type
    , hx.warehouse_code
;

-- 对数
select * from one_make_dwb.fact_bn_blp_hx where dt = '20210101' limit 5;
select count(1) from one_make_dwb.fact_bn_blp_hx where dt = '20210101';
select count(1) from one_make_dwd.ciss_material_bnblp_hx_sqd where dt = '20210101' and status = 6;