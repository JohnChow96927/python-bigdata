-- code 仓库ID
-- name 仓库名称
-- company_id 所属公司
-- company 公司名称
-- srv_station_id 所属服务网点ID
-- srv_station_name 所属服务网点名称
insert overwrite table one_make_dws.dim_warehouse partition(dt='20210101')
select
    warehouse.code as code
    , warehouse.name as name
    , warehouse.company as company_id
    , cmp.compmay as compmay
    , station.id as srv_station_id
    , station.name as srv_station_name
from
    one_make_dwd.ciss_base_warehouse warehouse
left join   -- 关联公司信息表
    (select
        ygcode as company_id
        , max(companyname) as compmay
    from
        one_make_dwd.ciss_base_baseinfo
    where dt='20210101'
    group by
        ygcode) cmp    -- 需要对company信息进行分组去重，里面有一些重复数据
    on warehouse.dt = '20210101' and cmp.company_id = warehouse.company
left join   -- 关联服务网点和仓库关系表
    one_make_dwd.ciss_r_serstation_warehouse station_r_warehouse
    on station_r_warehouse.dt = '20210101' and station_r_warehouse.warehouse_code = warehouse.code
left join   -- 关联服务网点表
    one_make_dwd.ciss_base_servicestation station
    on station.dt = '20210101' and station.id = station_r_warehouse.service_station_id
;

select * from one_make_dws.dim_warehouse;