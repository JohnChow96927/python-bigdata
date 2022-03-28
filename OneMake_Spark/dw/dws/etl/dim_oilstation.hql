-- 添加油站维度建模
-- name	油站名称
-- code	油站编码
-- customer_id	客户ID
-- customer_name	客户名称
-- province_id	省份id
-- province_name	省份名称
-- city_id	城市id
-- city_name	城市名称
-- county_id	县城ID
-- county_name	县城名称
-- area_id	区域ID
-- area_name	区域名称
-- customer_classify_id	客户分类ID
-- customer_classify_name	客户分类名称
-- status	油站状态（1、2）
-- status_name	油站状态名（正常、停用）
-- company_id	所属公司ID
-- company_name	所属公司名称
-- customer_province_id	客户所属省份ID
-- customer_province_name	客户所属省份
insert overwrite table one_make_dws.dim_oilstation partition(dt='20210101')
select oil.id
     , oil.name
     , oil.code
     , customer_id
     , customer_name
     , oil.province province_id
     , p.areaname province_name
     , oil.city city_id
     , c.areaname city_name
     , oil.region county_id
     , county.areaname county_name
     , oil.township area_id
     , a.areaname area_name
     , oil.customer_classify customer_classify_id
     , ede.dictname customer_classify_name
     , oil.status status
     , eosde.dictname status_name
     , cbc.company company_id
     , binfo.companyname company_name
     , proname.id customer_province_id
     , proname.areaname customer_province_name
from (select id, name, code, customer_id, customer_name, province, city, region, township, status, customer_classify, dt from one_make_dwd.ciss_base_oilstation where id != '' and name is not null and name != 'null' and customer_id is not null) oil
         left join (select id, areaname, parentid from one_make_dwd.ciss_base_areas where rank = 1) p on oil.province = p.id
         left join (select id, areaname, parentid from one_make_dwd.ciss_base_areas where rank = 2) c on oil.city = c.id
         left join (select id, areaname, parentid from one_make_dwd.ciss_base_areas where rank = 3) county on oil.region = county.id
         left join (select id, areaname, parentid from one_make_dwd.ciss_base_areas where rank = 4) a on oil.township = a.id
         left join (select dictid, dictname  from one_make_dwd.eos_dict_entry) ede on oil.customer_classify = ede.dictid
         left join (
    select dictid, dictname from one_make_dwd.eos_dict_entry t1
                                     left join one_make_dwd.eos_dict_type t2 on t1.dicttypeid = t2.dicttypeid where t2.dicttypename = '油站状态'
) eosde on oil.status = eosde.dictid
    -- 客户所属公司id，所属公司名称，所属省份id，所属省份名称
         left join (
    select code, province, company from one_make_dwd.ciss_base_customer
) cbc on oil.customer_id = cbc.code
         left join (
    select id, areaname from one_make_dwd.ciss_base_areas where rank = 1 and id != 83
) proname on cbc.province = proname.areaname
         left join (
    select ygcode, companyname from one_make_dwd.ciss_base_baseinfo group by ygcode, companyname
) binfo on cbc.company = binfo.ygcode
where dt = '20210101';