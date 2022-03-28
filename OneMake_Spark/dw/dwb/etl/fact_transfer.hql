-- transfer_id	调拨单ID
-- transfer_code	调拨单编号
-- trans_in_ss_id	申请服务中心ID
-- trans_out_ss_id	调出服务中心ID
-- trans_in_warehouse_id	申请仓库ID
-- trans_out_warehouse_id	调出仓库ID
-- logi_type_id	物流方式ID
-- logi_cmp_id	物流公司ID
-- trans_m_num	调拨物料件数
-- trans_m_money	调拨物料金额
-- trans_form_num	调拨单数量
select
      db.id as transfer_id
    , db.code as transfer_code
    , ss_in.id as trans_in_ss_id
    , ss_out.id as trans_out_ss_id
    , db.warehouse_code_send as trans_in_warehouse_id
    , db.warehouse_code_rec as trans_out_warehouse_id
    , db.logistics_type as logi_type_id
    , db.logistics_company as logi_cmp_id
    , sum(dtl_smry.total_cnt) as trans_m_num
    , sum(dtl_smry.total_money) as trans_m_money
    , 1 as trans_form_num
from
    (select * from one_make_dwd.ciss_material_wdwl_db_sqd where status = 6 /* 取已收货状态单据 */) db
left join
    one_make_dwd.ciss_base_servicestation ss_in
    on db.dt = '20210101' and ss_in.dt = '20210101' and db.service_station_code_send = ss_in.code
left join
    one_make_dwd.ciss_base_servicestation ss_out
    on ss_out.dt = '20210101' and db.service_station_code_rec = ss_out.code
left join
    (
        select
              dtl.wdwl_db_sqd_id as wdwl_db_sqd_id
            , sum(dtl.count_actual_delivery) as total_cnt
            , sum(dtl.count_actual_delivery * m.price) as total_money
        from
            one_make_dwd.ciss_material_wdwl_db_sqd_dtl dtl
        left join
            one_make_dwd.ciss_base_material m
            on dtl.dt = '20210101' and m.dt = '20210101' and dtl.code = m.code
        group by
            dtl.wdwl_db_sqd_id
    ) dtl_smry
    on db.id = dtl_smry.wdwl_db_sqd_id
group by
      db.id
    , db.code
    , ss_in.id
    , ss_out.id
    , db.warehouse_code_send
    , db.warehouse_code_rec
    , db.logistics_type
    , db.logistics_company
limit 5
;

insert overwrite table one_make_dwb.fact_transfer partition(dt = '20210101')
select
    /*+repartitions(1) */
      db.id as transfer_id
    , db.code as transfer_code
    , ss_in.id as trans_in_ss_id
    , ss_out.id as trans_out_ss_id
    , db.warehouse_code_send as trans_in_warehouse_id
    , db.warehouse_code_rec as trans_out_warehouse_id
    , db.logistics_type as logi_type_id
    , db.logistics_company as logi_cmp_id
    , sum(dtl_smry.total_cnt) as trans_m_num
    , sum(dtl_smry.total_money) as trans_m_money
    , 1 as trans_form_num
from
    (select * from one_make_dwd.ciss_material_wdwl_db_sqd where status = 6 /* 取已收货状态单据 */) db
left join
    one_make_dwd.ciss_base_servicestation ss_in
    on db.dt = '20210101' and ss_in.dt = '20210101' and db.service_station_code_send = ss_in.code
left join
    one_make_dwd.ciss_base_servicestation ss_out
    on ss_out.dt = '20210101' and db.service_station_code_rec = ss_out.code
left join
    (
        select
              dtl.wdwl_db_sqd_id as wdwl_db_sqd_id
            , sum(dtl.count_actual_delivery) as total_cnt
            , sum(dtl.count_actual_delivery * m.price) as total_money
        from
            one_make_dwd.ciss_material_wdwl_db_sqd_dtl dtl
        left join
            one_make_dwd.ciss_base_material m
            on dtl.dt = '20210101' and m.dt = '20210101' and dtl.code = m.code
        group by
            dtl.wdwl_db_sqd_id
    ) dtl_smry
    on db.id = dtl_smry.wdwl_db_sqd_id
group by
      db.id
    , db.code
    , ss_in.id
    , ss_out.id
    , db.warehouse_code_send
    , db.warehouse_code_rec
    , db.logistics_type
    , db.logistics_company
;

-- 对数（跑数为1420）
select * from one_make_dwb.fact_transfer where dt = '20210101' limit 5;
select count(1) from one_make_dwb.fact_transfer where dt = '20210101';
select count(1) from one_make_dwd.ciss_material_wdwl_db_sqd where dt = '20210101' and status = 6;