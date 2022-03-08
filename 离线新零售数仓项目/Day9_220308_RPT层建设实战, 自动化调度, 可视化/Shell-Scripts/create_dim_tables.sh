#! /bin/bash
export LANG=zh_CN.UTF-8
HIVE_HOME=/usr/bin/hive

${HIVE_HOME} -S -e "
--区域字典表（全量覆盖）
DROP TABLE if EXISTS yp_dwd.dim_district;
CREATE TABLE yp_dwd.dim_district(
  id string COMMENT '主键ID', 
  code string COMMENT '区域编码', 
  name string COMMENT '区域名称', 
  pid string COMMENT '父级ID', 
  alias string COMMENT '别名')
COMMENT '区域字典表'
row format delimited fields terminated by '\t'
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');

--时间维度
drop table yp_dwd.dim_date;
CREATE TABLE yp_dwd.dim_date
(
    dim_date_id           string COMMENT '日期',
    date_code             string COMMENT '日期编码',
    lunar_calendar        string COMMENT '农历',
    year_code             string COMMENT '年code',
    year_name             string COMMENT '年名称',
    month_code            string COMMENT '月份编码',
    month_name            string COMMENT '月份名称',
    quanter_code          string COMMENT '季度编码',
    quanter_name          string COMMENT '季度名称',
    year_month            string COMMENT '年月',
    year_week_code        string COMMENT '一年中第几周',
    year_week_name        string COMMENT '一年中第几周名称',
    year_week_code_cn     string COMMENT '一年中第几周（中国）',
    year_week_name_cn     string COMMENT '一年中第几周名称（中国',
    week_day_code         string COMMENT '周几code',
    week_day_name         string COMMENT '周几名称',
    day_week              string COMMENT '周',
    day_week_cn           string COMMENT '周(中国)',
    day_week_num          string COMMENT '一周第几天',
    day_week_num_cn       string COMMENT '一周第几天（中国）',
    day_month_num         string COMMENT '一月第几天',
    day_year_num          string COMMENT '一年第几天',
    date_id_wow           string COMMENT '与本周环比的上周日期',
    date_id_mom           string COMMENT '与本月环比的上月日期',
    date_id_wyw           string COMMENT '与本周同比的上年日期',
    date_id_mym           string COMMENT '与本月同比的上年日期',
    first_date_id_month   string COMMENT '本月第一天日期',
    last_date_id_month    string COMMENT '本月最后一天日期',
    half_year_code        string COMMENT '半年code',
    half_year_name        string COMMENT '半年名称',
    season_code           string COMMENT '季节编码',
    season_name           string COMMENT '季节名称',
    is_weekend            string COMMENT '是否周末（周六和周日）',
    official_holiday_code string COMMENT '法定节假日编码',
    official_holiday_name string COMMENT '法定节假日',
    festival_code         string COMMENT '节日编码',
    festival_name         string COMMENT '节日',
    custom_festival_code  string COMMENT '自定义节日编码',
    custom_festival_name  string COMMENT '自定义节日',
    update_time           string COMMENT '更新时间'
)
COMMENT '时间维度表'
row format delimited fields terminated by '\t'
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');


--店铺（拉链表）
DROP TABLE if EXISTS yp_dwd.dim_store;
CREATE TABLE yp_dwd.dim_store(
  id string COMMENT '主键', 
  user_id string, 
  store_avatar string COMMENT '店铺头像', 
  address_info string COMMENT '店铺详细地址', 
  name string COMMENT '店铺名称', 
  store_phone string COMMENT '联系电话', 
  province_id int COMMENT '店铺所在省份ID', 
  city_id int COMMENT '店铺所在城市ID', 
  area_id int COMMENT '店铺所在县ID', 
  mb_title_img string COMMENT '手机店铺 页头背景图', 
  store_description string COMMENT '店铺描述', 
  notice string COMMENT '店铺公告', 
  is_pay_bond tinyint COMMENT '是否有交过保证金 1：是0：否', 
  trade_area_id string COMMENT '归属商圈ID', 
  delivery_method tinyint COMMENT '配送方式  1 ：自提 ；3 ：自提加配送均可\; 2 : 商家配送', 
  origin_price decimal(36,2), 
  free_price decimal(36,2), 
  store_type int COMMENT '店铺类型 22天街网店 23实体店 24直营店铺 33会员专区店', 
  store_label string COMMENT '店铺logo', 
  search_key string COMMENT '店铺搜索关键字', 
  end_time string COMMENT '营业结束时间', 
  start_time string COMMENT '营业开始时间', 
  operating_status tinyint COMMENT '营业状态  0 ：未营业 ；1 ：正在营业', 
  create_user string, 
  create_time string, 
  update_user string, 
  update_time string, 
  is_valid tinyint COMMENT '0关闭，1开启，3店铺申请中', 
  state string COMMENT '可使用的支付类型:MONEY金钱支付\;CASHCOUPON现金券支付', 
  idcard string COMMENT '身份证', 
  deposit_amount decimal(36,2) COMMENT '商圈认购费用总额', 
  delivery_config_id string COMMENT '配送配置表关联ID', 
  aip_user_id string COMMENT '通联支付标识ID', 
  search_name string COMMENT '模糊搜索名称字段:名称_+真实名称', 
  automatic_order tinyint COMMENT '是否开启自动接单功能 1：是  0 ：否', 
  is_primary tinyint COMMENT '是否是总店 1: 是 2: 不是', 
  parent_store_id string COMMENT '父级店铺的id，只有当is_primary类型为2时有效',
  end_date string COMMENT '拉链结束日期')
COMMENT '店铺表'
partitioned by (start_date string)
row format delimited fields terminated by '\t'
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');


--商圈（拉链表）
DROP TABLE if EXISTS yp_dwd.dim_trade_area;
CREATE TABLE yp_dwd.dim_trade_area(
  id string COMMENT '主键', 
  user_id string COMMENT '用户ID', 
  user_allinpay_id string COMMENT '通联用户表id', 
  trade_avatar string COMMENT '商圈logo', 
  name string COMMENT '商圈名称', 
  notice string COMMENT '商圈公告', 
  distric_province_id int COMMENT '商圈所在省份ID', 
  distric_city_id int COMMENT '商圈所在城市ID', 
  distric_area_id int COMMENT '商圈所在县ID', 
  address string COMMENT '商圈地址', 
  radius double COMMENT '半径', 
  mb_title_img string COMMENT '手机商圈 页头背景图', 
  deposit_amount decimal(36,2) COMMENT '商圈认购费用总额', 
  hava_deposit int COMMENT '是否有交过保证金 1：是0：否', 
  state tinyint COMMENT '申请商圈状态 -1 ：未认购 ；0 ：申请中；1 ：已认购；', 
  search_key string COMMENT '商圈搜索关键字', 
  create_user string, 
  create_time string, 
  update_user string, 
  update_time string, 
  is_valid tinyint COMMENT '是否有效  0: false\; 1: true',
  end_date string COMMENT '拉链结束日期')
COMMENT '商圈表'
partitioned by (start_date string)
row format delimited fields terminated by '\t'
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');


--地址信息表（拉链表）
DROP TABLE if EXISTS yp_dwd.dim_location;
CREATE TABLE yp_dwd.dim_location(
  id string COMMENT '主键', 
  type int COMMENT '类型   1：商圈地址；2：店铺地址；3.用户地址管理\;4.订单买家地址信息\;5.订单卖家地址信息', 
  correlation_id string COMMENT '关联表id', 
  address string COMMENT '地图地址详情', 
  latitude double COMMENT '纬度', 
  longitude double COMMENT '经度', 
  street_number string COMMENT '门牌', 
  street string COMMENT '街道', 
  district string COMMENT '区县', 
  city string COMMENT '城市', 
  province string COMMENT '省份', 
  business string COMMENT '百度商圈字段，代表此点所属的商圈', 
  create_user string, 
  create_time string, 
  update_user string, 
  update_time string, 
  is_valid tinyint COMMENT '是否有效  0: false\; 1: true', 
  adcode string COMMENT '百度adcode,对应区县code',
  end_date string COMMENT '拉链结束日期')
COMMENT '地址信息'
partitioned by (start_date string)
row format delimited fields terminated by '\t'
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');


--商品SKU表（拉链表）
DROP TABLE if EXISTS yp_dwd.dim_goods;
CREATE TABLE yp_dwd.dim_goods(
  id string, 
  store_id string COMMENT '所属商店ID', 
  class_id string COMMENT '分类id:只保存最后一层分类id', 
  store_class_id string COMMENT '店铺分类id', 
  brand_id string COMMENT '品牌id', 
  goods_name string COMMENT '商品名称', 
  goods_specification string COMMENT '商品规格', 
  search_name string COMMENT '模糊搜索名称字段:名称_+真实名称', 
  goods_sort int COMMENT '商品排序', 
  goods_market_price decimal(36,2) COMMENT '商品市场价', 
  goods_price decimal(36,2) COMMENT '商品销售价格(原价)', 
  goods_promotion_price decimal(36,2) COMMENT '商品促销价格(售价)', 
  goods_storage int COMMENT '商品库存', 
  goods_limit_num int COMMENT '购买限制数量', 
  goods_unit string COMMENT '计量单位', 
  goods_state tinyint COMMENT '商品状态 1正常，2下架,3违规（禁售）', 
  goods_verify tinyint COMMENT '商品审核状态: 1通过，2未通过，3审核中', 
  activity_type tinyint COMMENT '活动类型:0无活动1促销2秒杀3折扣', 
  discount int COMMENT '商品折扣(%)', 
  seckill_begin_time string COMMENT '秒杀开始时间', 
  seckill_end_time string COMMENT '秒杀结束时间', 
  seckill_total_pay_num int COMMENT '已秒杀数量', 
  seckill_total_num int COMMENT '秒杀总数限制', 
  seckill_price decimal(36,2) COMMENT '秒杀价格', 
  top_it tinyint COMMENT '商品置顶：1-是，0-否', 
  create_user string, 
  create_time string, 
  update_user string, 
  update_time string, 
  is_valid tinyint COMMENT '0 ：失效，1 ：开启',
  end_date string COMMENT '拉链结束日期')
COMMENT '商品表_店铺(SKU)'
partitioned by (start_date string)
row format delimited fields terminated by '\t'
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');


--商品分类（拉链表）
DROP TABLE if EXISTS yp_dwd.dim_goods_class;
CREATE TABLE yp_dwd.dim_goods_class(
  id string, 
  store_id string COMMENT '店铺id', 
  class_id string COMMENT '对应的平台分类表id', 
  name string COMMENT '店铺内分类名字', 
  parent_id string COMMENT '父id', 
  level tinyint COMMENT '分类层级', 
  is_parent_node tinyint COMMENT '是否为父节点:1是0否', 
  background_img string COMMENT '背景图片', 
  img string COMMENT '分类图片', 
  keywords string COMMENT '关键词', 
  title string COMMENT '搜索标题', 
  sort int COMMENT '排序', 
  note string COMMENT '类型描述', 
  url string COMMENT '分类的链接', 
  is_use tinyint COMMENT '是否使用:0否,1是', 
  create_user string, 
  create_time string, 
  update_user string, 
  update_time string, 
  is_valid tinyint COMMENT '0 ：失效，1 ：开启',
  end_date string COMMENT '拉链结束日期')
COMMENT '商品分类表'
partitioned by (start_date string)
row format delimited fields terminated by '\t'
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');


--品牌表（拉链表）
DROP TABLE if EXISTS yp_dwd.dim_brand;
CREATE TABLE yp_dwd.dim_brand(
  id string, 
  store_id string COMMENT '店铺id', 
  brand_pt_id string COMMENT '平台品牌库品牌Id', 
  brand_name string COMMENT '品牌名称', 
  brand_image string COMMENT '品牌图片', 
  initial string COMMENT '品牌首字母', 
  sort int COMMENT '排序', 
  is_use tinyint COMMENT '0禁用1启用', 
  goods_state tinyint COMMENT '商品品牌审核状态 1 审核中,2 通过,3 拒绝', 
  create_user string, 
  create_time string, 
  update_user string, 
  update_time string, 
  is_valid tinyint COMMENT '0 ：失效，1 ：开启',
  end_date string COMMENT '拉链结束日期')
COMMENT '品牌（店铺）'
partitioned by (start_date string)
row format delimited fields terminated by '\t'
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY'); 
"