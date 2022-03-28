-- 生成服务网点维度
-- name 
-- ,code 
-- ,province_id 
-- ,province 
-- ,city_id 
-- ,city 
-- ,county_id 
-- ,county 
-- ,status 
-- ,status_name 
-- ,org_id 
-- ,org_name 
insert overwrite table one_make_dws.dim_srv_station partition(dt='20210101')
select
    station.id
    , station.name
    , station.code
    , province.id as province_id
    , province.areaname as province
    , city.id as city_id
    , city.areaname as city
    , county.id as county_id
    , county.areaname as county
    , station.status as status
    , dict_e.dictname as status_name
    , station.org_id as org_id
    , station.org_name as org_name
from 
    one_make_dwd.ciss_base_servicestation station
left join
    one_make_dwd.ciss_base_areas province
    on station.dt = '20210101' and station.province = province.id and province.rank = 1     -- 关联省份RANK为1
left join
    one_make_dwd.ciss_base_areas city
    on station.city = city.id and city.rank = 2             -- 关联城市RANK为2
left join
    one_make_dwd.ciss_base_areas county
    on station.region = county.id and county.rank = 3         -- 关联城市RANK为3
cross join
    one_make_dwd.eos_dict_type dict_t                       -- 关联字典父表（dict_t）
    on dict_t.dt = '20210101' and dict_t.dicttypename = '服务网点使用状态'
left join
    one_make_dwd.eos_dict_entry dict_e                      -- 关联字典子表（dict_e）
    on dict_e.dt = '20210101' and dict_t.dicttypeid = dict_e.dicttypeid and station.status = dict_e.dictid
;

select * from one_make_dws.dim_srv_station where dt = '20210101' limit 5;
