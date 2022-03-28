-- xhp_id	消耗品申请单ID
-- xhp_code	消耗品申请单编码
-- csp_id	服务商ID
-- csp_wh_code	服务商仓库编码
-- logi_cmp_id	物流公司ID
-- logi_type_id	物流类型ID
-- apply_m_num	申请物料总数量
-- apply_m_money	申请物料总金额
select id xhp_id, code xhp_code, csp_id, warehouse_code csp_wh_code, company logi_cmp_id, logistics_type logi_type_id, apply_m_num, apply_m_money
from one_make_dwd.ciss_csp_m_xhp_sqd ccmxs
         left join (
    select xhp_sqd_id, count(1) apply_m_num, sum(cbm.price) apply_m_money from one_make_dwd.ciss_csp_m_xhp_sqd_dtl xsd
                                                                                   left join one_make_dwd.ciss_base_material cbm on xsd.material_code = cbm.code
    where xsd.dt='20210101' and cbm.dt='20210101'
    group by xhp_sqd_id
) ccmxsd on ccmxs.id = ccmxsd.xhp_sqd_id
where ccmxs.dt='20210101'
;

-- 加载到表中
insert overwrite table one_make_dwb.fact_csp_xhp_hx partition(dt = '20210101')
select id xhp_id, code xhp_code, csp_id, warehouse_code csp_wh_code, company logi_cmp_id, logistics_type logi_type_id, apply_m_num, apply_m_money
from one_make_dwd.ciss_csp_m_xhp_sqd ccmxs
         left join (
    select xhp_sqd_id, count(1) apply_m_num, sum(cbm.price) apply_m_money from one_make_dwd.ciss_csp_m_xhp_sqd_dtl xsd
    left join one_make_dwd.ciss_base_material cbm on xsd.material_code = cbm.code
    where xsd.dt='20210101' and cbm.dt='20210101'
    group by xhp_sqd_id
) ccmxsd on ccmxs.id = ccmxsd.xhp_sqd_id
where ccmxs.dt='20210101'
;

-- 对数 总数为76条记录
select count(1) from one_make_dwd.ciss_csp_m_xhp_sqd ccmxs
;
select xhp_sqd_id, count(1) from one_make_dwd.ciss_csp_m_xhp_sqd_dtl xsd
    left join one_make_dwd.ciss_base_material cbm on xsd.material_code = cbm.code
group by xhp_sqd_id
;