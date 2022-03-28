-- os_id	油站ID
-- os_name	油站名称
-- os_code	油站编码
-- province_id	省份ID
-- city_id	城市ID
-- county_id	县ID
-- status_id	状态ID
-- cstm_type_id	客户分类ID
-- os_num	油站数量	默认为1
-- invalid_os_num	已停用油站数量	状态为已停用为1，否则为0
-- valid_os_num	有效油站数量	状态为启用为1，否则为0
-- current_new_os_num	*（当日新增油站）新增油站为1，老油站为0
-- current_invalid_os_num	*（当日停用油站）当天停用的油站数量
-- device_num	油站设备数量
select oil.id os_id, name os_name, code os_code, province province_id, city city_id, region county_id, status status_id,
       customer_classify cstm_type_id, 1 os_num,
       case when status = 2 then 1 else 0 end invalid_os_num,
       case when status = 1 then 1 else 0 end valid_os_num,
       current_new_os_num,
       case when current_invalid_os_num is null then 0 else current_invalid_os_num end current_invalid_os_num,
       device_num
from one_make_dwd.ciss_base_oilstation oil
         left join (
    select oil.id, case when oil.id = his.id then 0 else 1 end current_new_os_num from one_make_dwd.ciss_base_oilstation oil
                                                                                           left outer join one_make_dwd.ciss_base_oilstation_history his on oil.id = his.id where oil.dt = '20210101'
) oilnewhis on oil.id = oilnewhis.id
         left join (
    select oil.id, count(oil.id) current_invalid_os_num from one_make_dwd.ciss_base_oilstation oil
    where oil.dt = '20210101' and oil.status = 2 group by oil.id
) invalidos on oil.id = invalidos.id
         left join (
    select oil.id, count(dev.id) device_num from one_make_dwd.ciss_base_oilstation oil
                                                     left join one_make_dwd.ciss_base_device_detail dev on oil.id = dev.oilstation_id
    where oil.dt = '20210101' group by oil.id
) devinfo on oil.id = devinfo.id
;

insert overwrite table one_make_dwb.fact_oil_station partition(dt = '20210101')
select oil.id os_id, name os_name, code os_code, province province_id, city city_id, region county_id, status status_id,
       customer_classify cstm_type_id, 1 os_num,
       case when status = 2 then 1 else 0 end invalid_os_num,
       case when status = 1 then 1 else 0 end valid_os_num,
       current_new_os_num,
       case when current_invalid_os_num is null then 0 else current_invalid_os_num end current_invalid_os_num,
       device_num
from one_make_dwd.ciss_base_oilstation oil
         left join (
    select oil.id, case when oil.id = his.id then 0 else 1 end current_new_os_num from one_make_dwd.ciss_base_oilstation oil
                                                                                           left outer join one_make_dwd.ciss_base_oilstation_history his on oil.id = his.id where oil.dt = '20210101'
) oilnewhis on oil.id = oilnewhis.id
         left join (
    select oil.id, count(oil.id) current_invalid_os_num from one_make_dwd.ciss_base_oilstation oil
    where oil.dt = '20210101' and oil.status = 2 group by oil.id
) invalidos on oil.id = invalidos.id
         left join (
    select oil.id, count(dev.id) device_num from one_make_dwd.ciss_base_oilstation oil
                                                     left join one_make_dwd.ciss_base_device_detail dev on oil.id = dev.oilstation_id
    where oil.dt = '20210101' group by oil.id
) devinfo on oil.id = devinfo.id
;

-- 对数 29978
select count(oil.id) totalNum
from one_make_dwd.ciss_base_oilstation oil
         left join (
    select oil.id, case when oil.id = his.id then 0 else 1 end current_new_os_num from one_make_dwd.ciss_base_oilstation oil
                                                                                           left outer join one_make_dwd.ciss_base_oilstation_history his on oil.id = his.id where oil.dt = '20210101'
) oilnewhis on oil.id = oilnewhis.id
         left join (
    select oil.id, count(oil.id) current_invalid_os_num from one_make_dwd.ciss_base_oilstation oil
    where oil.dt = '20210101' and oil.status = 2 group by oil.id
) invalidos on oil.id = invalidos.id
         left join (
    select oil.id, count(dev.id) device_num from one_make_dwd.ciss_base_oilstation oil
                                                     left join one_make_dwd.ciss_base_device_detail dev on oil.id = dev.oilstation_id
    where oil.dt = '20210101' group by oil.id
) devinfo on oil.id = devinfo.id
;
select count(1) from one_make_dwd.ciss_base_oilstation;

/**
 * todo 实现过程
 */
-- 油站总数
select count(1) os_num from one_make_dwd.ciss_base_oilstation
;
-- 已停用油站数量
select count(1) invalid_os_num from one_make_dwd.ciss_base_oilstation where status = 2
;
-- 有效油站数量
select count(1) valid_os_num from one_make_dwd.ciss_base_oilstation where status = 1
;
-- 查询油站对应的设备数
select oil.id, count(dev.id) device_num from one_make_dwd.ciss_base_oilstation oil
                                                 left join one_make_dwd.ciss_base_device_detail dev on oil.id = dev.oilstation_id
group by oil.id;
-- 创建油站临时记录表并加载数据
create table if not exists one_make_dwd.ciss_base_oilstation_history stored as orc as select * from one_make_dwd.ciss_base_oilstation where dt < '20210111'
-- 当日新增油站
select oil.id, case when oil.id = his.id then 0 else 1 end current_new_os_num from one_make_dwd.ciss_base_oilstation oil left outer join one_make_dwd.ciss_base_oilstation_history his on oil.id = his.id where oil.dt = '20210101'
;
-- 当日停用油站
select oil.id, count(oil.id) num from one_make_dwd.ciss_base_oilstation oil where oil.dt = '20210101' and oil.status = 2 group by oil.id
;