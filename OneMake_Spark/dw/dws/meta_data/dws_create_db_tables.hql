create database if not exists one_make_dws;

-- 创建行政地理区域维度表
-- 1. 位置维度表（区域粒度）
create external table if not exists one_make_dws.dim_location_area(
    id string comment 'id'
    , province_id string comment '省份ID'
    , province string comment '省份名称'
    , province_short_name string comment '省份短名称'
    , city_id string comment '城市ID'
    , city string comment '城市'
    , city_short_name string comment '城市短名称'
    , county_id string comment '县城ID'
    , county string comment '县城'
    , county_short_name string comment '县城短名称'
    , area_id string comment '区域ID'
    , area string comment '区域'
    , area_short_name string comment '区域短名称'
) comment '位置维度表（区域粒度）'
stored as orc
-- tblproperties ("orc.compress"="SNAPPY")
location '/data/dw/dws/one_make/dim_location_area'
;

-- 2. 位置维度表（县城粒度）
create external table if not exists one_make_dws.dim_location_county(
    id string comment 'id'
    , province_id string comment '省份ID'
    , province string comment '省份名称'
    , province_short_name string comment '省份短名称'
    , city_id string comment '城市ID'
    , city string comment '城市'
    , city_short_name string comment '城市短名称'
    , county_id string comment '县城ID'
    , county string comment '县城'
    , county_short_name string comment '县城短名称'
) comment '区域维度表（县城粒度）'
stored as orc
location '/data/dw/dws/one_make/dim_location_county'
;

-- 3. 位置维度表（城市粒度）
create external table if not exists one_make_dws.dim_location_city(
    id string comment 'id'
    , province_id string comment '省份ID'
    , province string comment '省份名称'
    , province_short_name string comment '省份短名称'
    , city_id string comment '城市ID'
    , city string comment '城市'
    , city_short_name string comment '城市短名称'
) comment '区域维度表'
stored as orc
location '/data/dw/dws/one_make/dim_location_city'
;

-- 4. 位置维度表（省份粒度）
create external table if not exists one_make_dws.dim_location_province(
    id string comment 'id'
    , province_id string comment '省份ID'
    , province string comment '省份名称'
    , province_short_name string comment '省份短名称'
) comment '区域维度表（省份粒度）'
stored as orc
location '/data/dw/dws/one_make/dim_location_province'
;

-- 创建日期维度表,日期维度表按照年份分区
create external table if not exists one_make_dws.dim_date(
    date_id string comment '日期id'
    , year_name_cn string comment '年份名称（中文）'
    , year_month_id string comment '年月id'
    , year_month_cn string comment '年月（中文）'
    , quota_id string comment '季度id'
    , quota_namecn string comment '季度名称（中文）'
    , quota_nameen string comment '季度名称（英文）'
    , quota_shortnameen string comment '季度名称（英文简写）'
    , week_in_year_id string comment '周id'
    , week_in_year_name_cn string comment '周（中文）'
    , week_in_year_name_en string comment '周（英文）'
    , weekday int comment '星期'
    , weekday_cn string comment '星期（中文）'
    , weekday_en string comment '星期（英文）'
    , weekday_short_name_en string comment '星期（英文缩写）'
    , yyyymmdd string comment '日期_yyyy_mm_dd'
    , yyyymmdd_cn string comment '日期中文'
    , is_workday string comment '是否工作日'
    , is_weekend string comment '是否周末'
    , is_holiday string comment '是否法定节假日'
    , date_type string comment '日期类型'
) comment '时间维度表'
partitioned by (year integer)
stored as orc
location '/data/dw/dws/one_make/dim_date'
;

-- 创建组织机构维度表，组织机构人员是经常变动的，所以按照日期分区
create external table if not exists one_make_dws.dim_emporg(
    empid string comment '人员id'
    , empcode string comment '人员编码(erp对应的账号id)'
    , empname string comment '人员姓名'
    , userid string comment '用户系统id（登录用户名）'
    , posid string comment '岗位id'
    , posicode string comment '岗位编码'
    , posiname string comment '岗位名称'
    , orgid string comment '部门id'
    , orgcode string comment '部门编码'
    , orgname string comment '部门名称'
) comment '组织机构维度表'
partitioned by (dt string)
stored as orc
location '/data/dw/dws/one_make/dim_emporg'
;

-- 服务网点维度表
create external table if not exists one_make_dws.dim_srv_station(
    id string comment '服务网点id'
    , name string comment '服务网点名称'
    ,code string comment '网点编号'
    ,province_id string comment '省份id'
    ,province string comment '省份名称'
    ,city_id string comment '城市id'
    ,city string comment '城市'
    ,county_id string comment '县城id'
    ,county string comment '县城'
    ,status string comment '服务网点状态'
    ,status_name string comment '状态中文名'
    ,org_id string comment '所属组织机构id'
    ,org_name string comment '所属组件机构名称'
)comment '服务网点维度表'
partitioned by (dt string)
stored as orc
location '/data/dw/dws/one_make/dim_srv_station'
;

-- 仓库维度表
create external table if not exists one_make_dws.dim_warehouse(
    code string comment '仓库编码'
    , name string comment '仓库名称'
    , company_id string comment '所属公司'
    , company string comment '公司名称'
    , srv_station_id string comment '所属服务网点ID'
    , srv_station_name string comment '所属服务网点名称'
)
comment '仓库维度表'
partitioned by (dt string)
stored as orc
location '/data/dw/dws/one_make/dim_warehouse'
;

-- 油站维度(包含客户信息、地理区域信息、数据字典)
create external table if not exists one_make_dws.dim_oilstation
(
    id                     string comment '油站ID',
    name                   string comment '油站名称',
    code                   string comment '油站编码',
    customer_id            string comment '客户ID',
    customer_name          string comment '客户名称',
    province_id            int comment '省份id',
    province_name          string comment '省份名称',
    city_id                int comment '城市id',
    city_name              string comment '城市名称',
    county_id              int comment '县城ID',
    county_name            string comment '县城名称',
    area_id                int comment '区域id',
    area_name              string comment '区域名称',
    customer_classify_id   string comment '客户分类ID',
    customer_classify_name string comment '客户分类名称',
    status                 int comment '油站状态（1、2）',
    status_name            string comment '油站状态名（正常、停用）',
    company_id             int comment '所属公司ID',
    company_name           string comment '所属公司名称',
    customer_province_id   int comment '客户所属省份ID',
    customer_province_name string comment '客户所属省份'
) COMMENT '油站维度表'
    PARTITIONED BY (dt STRING)
    STORED AS TEXTFILE
    LOCATION '/data/dw/dws/one_make/dim_oilstation'
;

-- 服务属性维度
-- 针对服务工单分析的属性维度
create external table if not exists one_make_dws.dim_service_attribute(
    prop_name string comment '字典名称'
    , type_id string comment '属性id'
    , type_name string comment '属性名称'
)
comment '服务属性维度表'
partitioned by (dt string)
stored as orc
location '/data/dw/dws/one_make/dim_service_attribute'
;

-- 物流维度表(和服务属性表类似)
create external table if not exists one_make_dws.dim_logistics(
    prop_name string comment '字典名称'
    , type_id string comment '属性id'
    , type_name string comment '属性名称'
)
comment '物流维度表'
partitioned by (dt string)
stored as orc
location '/data/dw/dws/one_make/dim_logistics'
;

-- 故障分类维度表（4级粒度）
create external table if not exists one_make_dws.dim_fault_catalog(
      lv4_id string comment '4级故障ID'
    , lv4_code string comment '4级故障编码'
    , lv4_name string comment '4级故障名称'
    , lv3_id string comment '3级故障ID'
    , lv3_code string comment '3级故障编码'
    , lv3_name string comment '3级故障名称'
    , lv2_id string comment '2级故障ID'
    , lv2_code string comment '2级故障编码'
    , lv2_name string comment '2级故障名称'
    , lv1_id string comment '1级故障ID'
    , lv1_code string comment '1级故障编码'
    , lv1_name string comment '1级故障名称'
)
comment '故障维度表（4级粒度）'
partitioned by (dt string)
stored as orc
location '/data/dw/dws/one_make/dim_fault_catalog'
;