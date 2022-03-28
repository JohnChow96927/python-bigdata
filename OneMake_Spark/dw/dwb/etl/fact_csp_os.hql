-- os_id	油站ID
-- os_code	油站编码
-- province_id	省份ID
-- city_id	城市ID
-- county_id	县ID
-- csp_id	服务商ID
-- os_device_num	油站设备数量
-- os_num	油站数量

select
      os.id as os_id
    , os.code as os_code
    , os.province_code as province_id
    , os.city_code as city_id
    , os.country_town_code as county_id
    , csp.id
    , dvc.total_cnt
    , 1
from
    (select * from one_make_dwd.ciss_csp_oil_station where status = 1 /* 只取有效地油站 */ and dt = '20210101') os
left join
    (
        select
              csp_oil_station_id
            , count(factory_num) /* 取出库编码不为空计数 */ as total_cnt
        from
            one_make_dwd.ciss_csp_oil_station_device 
        where
            dt = '20210101'
        group by
            csp_oil_station_id
    ) dvc
    on os.id = dvc.csp_oil_station_id
left join
    one_make_dwd.ciss_base_csp csp
    on csp.dt = '20210101' and os.create_user_org_id = csp.org_id
limit 5
;

insert overwrite table one_make_dwb.fact_csp_os partition(dt = '20210101')
select
    /*+repartitions(1) */
      os.id as os_id
    , os.code as os_code
    , os.province_code as province_id
    , os.city_code as city_id
    , os.country_town_code as county_id
    , csp.id
    , dvc.total_cnt
    , 1
from
    (select * from one_make_dwd.ciss_csp_oil_station where status = 1 /* 只取有效地油站 */ and dt = '20210101') os
left join
    (
        select
              csp_oil_station_id
            , count(factory_num) /* 取出库编码不为空计数 */ as total_cnt
        from
            one_make_dwd.ciss_csp_oil_station_device 
        where
            dt = '20210101'
        group by
            csp_oil_station_id
    ) dvc
    on os.id = dvc.csp_oil_station_id
left join
    one_make_dwd.ciss_base_csp csp
    on csp.dt = '20210101' and os.create_user_org_id = csp.org_id
;

-- 对数（数据检查结果均为：5113条）
-- 1. 查看数据字段
select * from one_make_dwb.fact_csp_os where dt = '20210101' limit 5;
-- 2. 统计数据的条数
select count(1) from one_make_dwb.fact_csp_os where dt = '20210101';
-- 3. 检查dwd数据条数
select count(1) from one_make_dwd.ciss_csp_oil_station where dt = '20210101' and status = 1;