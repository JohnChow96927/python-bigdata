-- lv4_id string comment '4级故障ID'
-- , lv4_code string comment '4级故障编码'
-- , lv4_name string comment '4级故障名称'
-- , lv3_id string comment '3级故障ID'
-- , lv3_code string comment '3级故障编码'
-- , lv3_name string comment '3级故障名称'
-- , lv2_id string comment '2级故障ID'
-- , lv2_code string comment '2级故障编码'
-- , lv2_name string comment '2级故障名称'
-- , lv1_id string comment '1级故障ID'
-- , lv1_code string comment '1级故障编码'
-- , lv1_name string comment '1级故障名称'
insert overwrite table one_make_dws.dim_fault_catalog partition(dt = '20210101')
select
    lv4_id
    ,lv4_code
    ,lv4_name
    ,lv3_id
    ,lv3_code
    ,lv3_name
    ,lv2_id
    ,lv2_code
    ,lv2_name
    ,lv1_id
    ,lv1_code
    ,lv1_name
from
(select
    lv4.id as lv4_id
    , lv4.code as lv4_code
    , lv4.text as lv4_name
    , lv3.id as lv3_id
    , lv3.code as lv3_code
    , lv3.text as lv3_name
    , lv2.id as lv2_id
    , lv2.code as lv2_code
    , lv2.text as lv2_name
    , lv1.id as lv1_id
    , lv1.code as lv1_code
    , lv1.text as lv1_name
from
    one_make_dwd.ciss_base_fault_category lv4
left join
    one_make_dwd.ciss_base_fault_category lv3
    on lv4.dt = '20210101'
        and lv3.dt = '20210101'
        and lv4.lv = 4
        and lv3.lv = 3
        and lv4.pid = lv3.id
left join
    one_make_dwd.ciss_base_fault_category lv2
    on lv2.dt = '20210101'
        and lv3.lv = 3
        and lv2.lv = 2
        and lv3.pid = lv2.id
left join
    one_make_dwd.ciss_base_fault_category lv1
    on lv1.dt = '20210101'
        and lv2.lv = 2
        and lv1.lv = 1
        and lv2.pid = lv1.id) t
where
    t.lv3_id is not null
;