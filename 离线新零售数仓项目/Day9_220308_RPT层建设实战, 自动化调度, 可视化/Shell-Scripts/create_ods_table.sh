#! /bin/bash
export LANG=zh_CN.UTF-8
HIVE_HOME=/usr/bin/hive


${HIVE_HOME} -S -e "
-- 建库
create database if not exists yp_ods;

DROP TABLE if exists yp_ods.t_district;
CREATE TABLE yp_ods.t_district
(
    id string COMMENT '主键ID',
    code string COMMENT '区域编码',
    name string COMMENT '区域名称',
    pid  string COMMENT '父级ID',
    alias string COMMENT '别名'
)
comment '区域字典表'
row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress'='ZLIB');

drop table yp_ods.t_date;
CREATE TABLE yp_ods.t_date
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
tblproperties ('orc.compress' = 'ZLIB');

DROP TABLE if exists yp_ods.t_goods_evaluation;
CREATE TABLE yp_ods.t_goods_evaluation
(
    id                   string,
    user_id              string COMMENT '评论人id',
    store_id             string COMMENT '店铺id',
    order_id             string COMMENT '订单id',
    geval_scores         INT COMMENT '综合评分',
    geval_scores_speed   INT COMMENT '送货速度评分0-5分(配送评分)',
    geval_scores_service INT COMMENT '服务评分0-5分',
    geval_isanony        TINYINT COMMENT '0-匿名评价，1-非匿名',
    create_user          string,
    create_time          string,
    update_user          string,
    update_time          string,
    is_valid             TINYINT COMMENT '0 ：失效，1 ：开启'
)
comment '商品评价表'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress'='ZLIB');

DROP TABLE if exists yp_ods.t_goods_evaluation_detail;
CREATE TABLE yp_ods.t_goods_evaluation_detail
(
    id                              string,
    user_id                         string COMMENT '评论人id',
    store_id                        string COMMENT '店铺id',
    goods_id                        string COMMENT '商品id',
    order_id                        string COMMENT '订单id',
    order_goods_id                  string COMMENT '订单商品表id',
    geval_scores_goods              INT COMMENT '商品评分0-10分',
    geval_content                   string,
    geval_content_superaddition     string COMMENT '追加评论',
    geval_addtime                   string COMMENT '评论时间',
    geval_addtime_superaddition     string COMMENT '追加评论时间',
    geval_state                     TINYINT COMMENT '评价状态 1-正常 0-禁止显示',
    geval_remark                    string COMMENT '管理员对评价的处理备注',
    revert_state                    TINYINT COMMENT '回复状态0未回复1已回复',
    geval_explain                   string COMMENT '管理员回复内容',
    geval_explain_superaddition     string COMMENT '管理员追加回复内容',
    geval_explaintime               string COMMENT '管理员回复时间',
    geval_explaintime_superaddition string COMMENT '管理员追加回复时间',
    create_user                     string,
    create_time                     string,
    update_user                     string,
    update_time                     string,
    is_valid                        TINYINT COMMENT '0 ：失效，1 ：开启'
)
comment '商品评价明细'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress'='ZLIB');

DROP TABLE if exists yp_ods.t_order_delievery_item;
CREATE TABLE yp_ods.t_order_delievery_item
(
    id                     string COMMENT '主键id',
    shop_order_id          string COMMENT '订单表ID',
    refund_order_id        string,
    dispatcher_order_type  TINYINT COMMENT '配送订单类型1.支付单; 2.退款单',
    shop_store_id          string COMMENT '卖家店铺ID',
    buyer_id               string COMMENT '购买用户ID',
    circle_master_user_id  string COMMENT '圈主ID',
    dispatcher_user_id     string COMMENT '配送员ID',
    dispatcher_order_state TINYINT COMMENT '配送订单状态:0.待接单.1.已接单,2.已到店.3.配送中 4.商家普通提货码完成订单.5.商家万能提货码完成订单。6，买家完成订单',
    order_goods_num        TINYINT COMMENT '订单商品的个数',
    delivery_fee           DECIMAL(11,2) COMMENT '配送员的运费',
    distance               INT COMMENT '配送距离',
    dispatcher_code        string COMMENT '收货码',
    receiver_name          string COMMENT '收货人姓名',
    receiver_phone         string COMMENT '收货人电话',
    sender_name            string COMMENT '发货人姓名',
    sender_phone           string COMMENT '发货人电话',
    create_user            string,
    create_time            string,
    update_user            string,
    update_time            string,
    is_valid               TINYINT COMMENT '是否有效  0: false; 1: true'
)
comment '订单配送详细信息表'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress' = 'ZLIB');

DROP TABLE if exists yp_ods.t_user_login;
CREATE TABLE yp_ods.t_user_login(
   id string,
   login_user string,
   login_type string COMMENT '登录类型（登陆时使用）',
   client_id string COMMENT '推送标示id(登录、第三方登录、注册、支付回调、给用户推送消息时使用)',
   login_time string,
   login_ip string,
   logout_time string
) 
COMMENT '用户登录记录表'
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress' = 'ZLIB');

DROP TABLE if exists yp_ods.t_trade_record;
CREATE TABLE yp_ods.t_trade_record
(
    id                   string COMMENT '交易单号',
    external_trade_no    string COMMENT '(支付,结算.退款)第三方交易单号',
    relation_id          string COMMENT '关联单号',
    trade_type           TINYINT COMMENT '1.支付订单; 2.结算订单; 3.退款订单；4.充值单；5.提现单；6.分销单；7缴纳保证金单8退还保证金单9,冻结通联订单，10通联通账户余额充值，11.扫码单',
    status               TINYINT COMMENT '1.成功;2.失败;3.进行中',
    finnshed_time        string COMMENT '订单完成时间,当配送员点击确认送达时,进行更新订单完成时间,后期需要根据订单完成时间,进行自动收货以及自动评价',
    fail_reason          string COMMENT '交易失败的原因',
    payment_type         string COMMENT '支付方式:小程序,app微信,支付宝,快捷支付,钱包，银行卡,消费券',
    trade_before_balance DECIMAL(11,2) COMMENT '交易前余额',
    trade_true_amount    DECIMAL(11,2) COMMENT '交易实际支付金额,第三方平台扣除优惠以后实际支付金额',
    trade_after_balance  DECIMAL(11,2) COMMENT '交易后余额',
    note                 string COMMENT '业务说明',
    user_card            string COMMENT '第三方平台账户标识/多钱包用户钱包id',
    user_id              string COMMENT '用户id',
    aip_user_id          string COMMENT '钱包id',
    create_user          string,
    create_time          string,
    update_user          string,
    update_time          string,
    is_valid             TINYINT COMMENT '是否有效  0: false; 1: true;   订单是否有效的标志'
)
comment '所有交易记录信息'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress' = 'ZLIB');

DROP TABLE if exists yp_ods.t_store;
CREATE TABLE yp_ods.t_store
(
    id                 string COMMENT '主键',
    user_id            string,
    store_avatar       string COMMENT '店铺头像',
    address_info       string COMMENT '店铺详细地址',
    name               string COMMENT '店铺名称',
    store_phone        string COMMENT '联系电话',
    province_id        INT COMMENT '店铺所在省份ID',
    city_id            INT COMMENT '店铺所在城市ID',
    area_id            INT COMMENT '店铺所在县ID',
    mb_title_img       string COMMENT '手机店铺 页头背景图',
    store_description string COMMENT '店铺描述',
    notice             string COMMENT '店铺公告',
    is_pay_bond        TINYINT COMMENT '是否有交过保证金 1：是0：否',
    trade_area_id      string COMMENT '归属商圈ID',
    delivery_method    TINYINT COMMENT '配送方式  1 ：自提 ；3 ：自提加配送均可; 2 : 商家配送',
    origin_price       DECIMAL,
    free_price         DECIMAL,
    store_type         INT COMMENT '店铺类型 22天街网店 23实体店 24直营店铺 33会员专区店',
    store_label        string COMMENT '店铺logo',
    search_key         string COMMENT '店铺搜索关键字',
    end_time           string COMMENT '营业结束时间',
    start_time         string COMMENT '营业开始时间',
    operating_status   TINYINT COMMENT '营业状态  0 ：未营业 ；1 ：正在营业',
    create_user        string,
    create_time        string,
    update_user        string,
    update_time        string,
    is_valid           TINYINT COMMENT '0关闭，1开启，3店铺申请中',
    state              string COMMENT '可使用的支付类型:MONEY金钱支付;CASHCOUPON现金券支付',
    idCard             string COMMENT '身份证',
    deposit_amount     DECIMAL(11,2) COMMENT '商圈认购费用总额',
    delivery_config_id string COMMENT '配送配置表关联ID',
    aip_user_id        string COMMENT '通联支付标识ID',
    search_name        string COMMENT '模糊搜索名称字段:名称_+真实名称',
    automatic_order    TINYINT COMMENT '是否开启自动接单功能 1：是  0 ：否',
    is_primary         TINYINT COMMENT '是否是总店 1: 是 2: 不是',
    parent_store_id    string COMMENT '父级店铺的id，只有当is_primary类型为2时有效'
)
comment '店铺表'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress'='ZLIB');

DROP TABLE if exists yp_ods.t_trade_area;
CREATE TABLE yp_ods.t_trade_area
(
    id                  string COMMENT '主键',
    user_id             string COMMENT '用户ID',
    user_allinpay_id    string COMMENT '通联用户表id',
    trade_avatar        string COMMENT '商圈logo',
    name                string COMMENT '商圈名称',
    notice              string COMMENT '商圈公告',
    distric_province_id INT COMMENT '商圈所在省份ID',
    distric_city_id     INT COMMENT '商圈所在城市ID',
    distric_area_id     INT COMMENT '商圈所在县ID',
    address             string COMMENT '商圈地址',
    radius              double COMMENT '半径',
    mb_title_img        string COMMENT '手机商圈 页头背景图',
    deposit_amount      DECIMAL(11,2) COMMENT '商圈认购费用总额',
    hava_deposit        INT COMMENT '是否有交过保证金 1：是0：否',
    state               TINYINT COMMENT '申请商圈状态 -1 ：未认购 ；0 ：申请中；1 ：已认购 ；',
    search_key          string COMMENT '商圈搜索关键字',
    create_user         string,
    create_time         string,
    update_user         string,
    update_time         string,
    is_valid            TINYINT COMMENT '是否有效  0: false; 1: true'
)
comment '商圈表'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress'='ZLIB');

DROP TABLE if exists yp_ods.t_location;
CREATE TABLE yp_ods.t_location
(
    id string COMMENT '主键',
    type      INT COMMENT '类型   1：商圈地址；2：店铺地址；3.用户地址管理;4.订单买家地址信息;5.订单卖家地址信息',
    correlation_id string COMMENT '关联表id',
    address string COMMENT '地图地址详情',
    latitude  double COMMENT '纬度',
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
    is_valid  TINYINT COMMENT '是否有效  0: false; 1: true',
    adcode    string COMMENT '百度adcode,对应区县code'
)
comment '地址信息'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress'='ZLIB');

DROP TABLE if exists yp_ods.t_goods;
CREATE TABLE yp_ods.t_goods
(
    id                    string,
    store_id              string COMMENT '所属商店ID',
    class_id              string COMMENT '分类id:只保存最后一层分类id',
    store_class_id        string COMMENT '店铺分类id',
    brand_id              string COMMENT '品牌id',
    goods_name            string COMMENT '商品名称',
    goods_specification   string COMMENT '商品规格',
    search_name           string COMMENT '模糊搜索名称字段:名称_+真实名称',
    goods_sort            INT COMMENT '商品排序',
    goods_market_price    DECIMAL(11,2) COMMENT '商品市场价',
    goods_price           DECIMAL(11,2) COMMENT '商品销售价格(原价)',
    goods_promotion_price DECIMAL(11,2) COMMENT '商品促销价格(售价)',
    goods_storage         INT COMMENT '商品库存',
    goods_limit_num       INT COMMENT '购买限制数量',
    goods_unit            string COMMENT '计量单位',
    goods_state           TINYINT COMMENT '商品状态 1正常，2下架,3违规（禁售）',
    goods_verify          TINYINT COMMENT '商品审核状态: 1通过，2未通过，3审核中',
    activity_type         TINYINT COMMENT '活动类型:0无活动1促销2秒杀3折扣',
    discount              INT COMMENT '商品折扣(%)',
    seckill_begin_time    string COMMENT '秒杀开始时间',
    seckill_end_time      string COMMENT '秒杀结束时间',
    seckill_total_pay_num INT COMMENT '已秒杀数量',
    seckill_total_num     INT COMMENT '秒杀总数限制',
    seckill_price         DECIMAL(11,2) COMMENT '秒杀价格',
    top_it                TINYINT COMMENT '商品置顶：1-是，0-否',
    create_user           string,
    create_time           string,
    update_user           string,
    update_time           string,
    is_valid              TINYINT COMMENT '0 ：失效，1 ：开启'
)
comment '商品表_店铺(SKU)'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress'='ZLIB');

DROP TABLE if exists yp_ods.t_goods_class;
CREATE TABLE yp_ods.t_goods_class
(
    id             string,
    store_id       string COMMENT '店铺id',
    class_id       string COMMENT '对应的平台分类表id',
    name           string COMMENT '店铺内分类名字',
    parent_id      string COMMENT '父id',
    level          TINYINT COMMENT '分类层级',
    is_parent_node TINYINT COMMENT '是否为父节点:1是0否',
    background_img string COMMENT '背景图片',
    img            string COMMENT '分类图片',
    keywords       string COMMENT '关键词',
    title          string COMMENT '搜索标题',
    sort           INT COMMENT '排序',
    note           string COMMENT '类型描述',
    url            string COMMENT '分类的链接',
    is_use         TINYINT COMMENT '是否使用:0否,1是',
    create_user    string,
    create_time    string,
    update_user    string,
    update_time    string,
    is_valid       TINYINT COMMENT '0 ：失效，1 ：开启'
)
comment '商品分类_店铺'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress'='ZLIB');

DROP TABLE if exists yp_ods.t_brand;
CREATE TABLE yp_ods.t_brand
(
    id          string,
    store_id    string COMMENT '店铺id',
    brand_pt_id string COMMENT '平台品牌库品牌Id',
    brand_name  string COMMENT '品牌名称',
    brand_image string COMMENT '品牌图片',
    initial     string COMMENT '品牌首字母',
    sort        INT COMMENT '排序',
    is_use      TINYINT COMMENT '0禁用1启用',
    goods_state TINYINT COMMENT '商品品牌审核状态 1 审核中,2 通过,3 拒绝',
    create_user string,
    create_time string,
    update_user string,
    update_time string,
    is_valid    TINYINT COMMENT '0 ：失效，1 ：开启'
)
comment '品牌（店铺）'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress'='ZLIB');

DROP TABLE if exists yp_ods.t_shop_order;
CREATE TABLE yp_ods.t_shop_order
(
    id               string COMMENT '根据一定规则生成的订单编号',
    order_num        string COMMENT '订单序号',
    buyer_id         string COMMENT '买家的userId',
    store_id         string COMMENT '店铺的id',
    order_from       TINYINT COMMENT '是来自于app还是小程序,或者pc 1.安卓; 2.ios; 3.小程序H5 ; 4.PC',
    order_state      INT COMMENT '订单状态:1.已下单; 2.已付款, 3. 已确认 ;4.配送; 5.已完成; 6.退款;7.已取消',
    create_date      string COMMENT '下单时间',
    finnshed_time    timestamp COMMENT '订单完成时间,当配送员点击确认送达时,进行更新订单完成时间,后期需要根据订单完成时间,进行自动收货以及自动评价',
    is_settlement    TINYINT COMMENT '是否结算;0.待结算订单; 1.已结算订单;',
    is_delete        TINYINT COMMENT '订单评价的状态:0.未删除;  1.已删除;(默认0)',
    evaluation_state TINYINT COMMENT '订单评价的状态:0.未评价;  1.已评价;(默认0)',
    way              string COMMENT '取货方式:SELF自提;SHOP店铺负责配送',
    is_stock_up      INT COMMENT '是否需要备货 0：不需要    1：需要    2:平台确认备货  3:已完成备货 4平台已经将货物送至店铺 ',
    create_user      string,
    create_time      string,
    update_user      string,
    update_time      string,
    is_valid         TINYINT COMMENT '是否有效  0: false; 1: true;   订单是否有效的标志'
)
comment '订单表'
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress' = 'ZLIB');

DROP TABLE if exists yp_ods.t_shop_order_address_detail;
CREATE TABLE yp_ods.t_shop_order_address_detail
(
    id                  string COMMENT '关联订单的id',
    order_amount        DECIMAL(11,2) COMMENT '订单总金额:购买总金额-优惠金额',
    discount_amount     DECIMAL(11,2) COMMENT '优惠金额',
    goods_amount        DECIMAL(11,2) COMMENT '用户购买的商品的总金额+运费',
    is_delivery         string COMMENT '0.自提；1.配送',
    buyer_notes         string COMMENT '买家备注留言',
    pay_time            string,
    receive_time        string,
    delivery_begin_time string,
    arrive_store_time   string,
    arrive_time         string COMMENT '订单完成时间,当配送员点击确认送达时,进行更新订单完成时间,后期需要根据订单完成时间,进行自动收货以及自动评价',
    create_user         string,
    create_time         string,
    update_user         string,
    update_time         string,
    is_valid            TINYINT COMMENT '是否有效  0: false; 1: true;   订单是否有效的标志'
)
 comment '订单详情表'
 partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress' = 'ZLIB');
 
DROP TABLE if exists yp_ods.t_order_settle;
CREATE TABLE yp_ods.t_order_settle
(
    id                        string COMMENT '结算单号',
    order_id                  string,
    settlement_create_date    string COMMENT '用户申请结算的时间',
    settlement_amount         DECIMAL(11,2) COMMENT '如果发生退款,则结算的金额 = 订单的总金额 - 退款的金额',
    dispatcher_user_id        string COMMENT '配送员id',
    dispatcher_money          DECIMAL(11,2) COMMENT '配送员的配送费(配送员的运费(如果退货方式为1:则买家支付配送费))',
    circle_master_user_id     string COMMENT '圈主id',
    circle_master_money       DECIMAL(11,2) COMMENT '圈主分润的金额',
    plat_fee                  DECIMAL(11,2) COMMENT '平台应得的分润',
    store_money               DECIMAL(11,2) COMMENT '商家应得的订单金额',
    status                    TINYINT COMMENT '0.待结算；1.待审核 ; 2.完成结算；3.拒绝结算',
    note                      string COMMENT '原因',
    settle_time               string COMMENT ' 结算时间',
    create_user               string,
    create_time               string,
    update_user               string,
    update_time               string,
    is_valid                  TINYINT COMMENT '是否有效  0: false; 1: true;   订单是否有效的标志',
    first_commission_user_id  string COMMENT '一级分佣用户',
    first_commission_money    DECIMAL(11,2) COMMENT '一级分佣金额',
    second_commission_user_id string COMMENT '二级分佣用户',
    second_commission_money   DECIMAL(11,2) COMMENT '二级分佣金额'
)
comment '订单结算表'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress' = 'ZLIB');

DROP TABLE if exists yp_ods.t_refund_order;
CREATE TABLE yp_ods.t_refund_order
(
    id                   string COMMENT '退款单号',
    order_id             string COMMENT '订单的id',
    apply_date           string COMMENT '用户申请退款的时间',
    modify_date          string COMMENT '退款订单更新时间',
    refund_reason        string COMMENT '买家退款原因',
    refund_amount        DECIMAL(11,2) COMMENT '订单退款的金额',
    refund_state         TINYINT COMMENT '1.申请退款;2.拒绝退款; 3.同意退款,配送员配送; 4:商家同意退款,用户亲自送货 ;5.退款完成',
    refuse_refund_reason string COMMENT '商家拒绝退款原因',
    refund_goods_type    string COMMENT '1.上门取货(买家承担运费); 2.买家送达;',
    refund_shipping_fee  DECIMAL(11,2) COMMENT '配送员的运费(如果退货方式为1:则买家支付配送费)',
    create_user          string,
    create_time          string,
    update_user          string,
    update_time          string,
    is_valid             TINYINT COMMENT '是否有效  0: false; 1: true;   订单是否有效的标志'
)
comment '退款订单表'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress' = 'ZLIB');

DROP TABLE if exists yp_ods.t_shop_order_group;
CREATE TABLE yp_ods.t_shop_order_group
(
    id          string,
    order_id    string COMMENT '订单id',
    group_id    string COMMENT '订单分组id',
    is_pay      TINYINT COMMENT '是否已支付,0未支付,1已支付',
    create_user string,
    create_time string,
    update_user string,
    update_time string,
    is_valid    TINYINT
)
comment '订单分组表'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress' = 'ZLIB');

DROP TABLE if exists yp_ods.t_order_pay;
CREATE TABLE yp_ods.t_order_pay
(
    id               string,
    group_id         string COMMENT '关联shop_order_group的group_id,一对多订单',
    order_pay_amount DECIMAL(11,2) COMMENT '订单总金额;',
    create_date      string COMMENT '订单创建的时间,需要根据订单创建时间进行判断订单是否已经失效',
    create_user      string,
    create_time      string,
    update_user      string,
    update_time      string,
    is_valid         TINYINT COMMENT '是否有效  0: false; 1: true;   订单是否有效的标志'
)
comment '订单支付表'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress' = 'ZLIB');

DROP TABLE if exists yp_ods.t_shop_order_goods_details;
CREATE TABLE yp_ods.t_shop_order_goods_details
(
    id                  string COMMENT 'id主键',
    order_id            string COMMENT '对应订单表的id',
    shop_store_id       string COMMENT '卖家店铺ID',
    buyer_id            string COMMENT '购买用户ID',
    goods_id            string COMMENT '购买商品的id',
    buy_num             INT COMMENT '购买商品的数量',
    goods_price         DECIMAL(11,2) COMMENT '购买商品的价格',
    total_price         DECIMAL(11,2) COMMENT '购买商品的价格 = 商品的数量 * 商品的单价 ',
    goods_name          string COMMENT '商品的名称',
    goods_image         string COMMENT '商品的图片',
    goods_specification string COMMENT '商品规格',
    goods_weight        INT,
    goods_unit          string COMMENT '商品计量单位',
    goods_type          string COMMENT '商品分类     ytgj:进口商品    ytsc:普通商品     hots爆品',
    refund_order_id     string COMMENT '退款订单的id',
    goods_brokerage     DECIMAL(11,2) COMMENT '商家设置的商品分润的金额',
    is_refund           TINYINT COMMENT '0.不退款; 1.退款',
    create_user         string,
    create_time         string,
    update_user         string,
    update_time         string,
    is_valid            TINYINT COMMENT '是否有效  0: false; 1: true'
)
 comment '订单和商品的中间表'
 partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress' = 'ZLIB');
 
DROP TABLE if exists yp_ods.t_shop_cart;
CREATE TABLE yp_ods.t_shop_cart
(
    id            string COMMENT '主键id',
    shop_store_id string COMMENT '卖家店铺ID',
    buyer_id      string COMMENT '购买用户ID',
    goods_id      string COMMENT '购买商品的id',
    buy_num       INT COMMENT '购买商品的数量',
    create_user   string,
    create_time   string,
    update_user   string,
    update_time   string,
    is_valid      TINYINT COMMENT '是否有效  0: false; 1: true'
)
comment '购物车'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress' = 'ZLIB');

DROP TABLE if exists yp_ods.t_store_collect;
CREATE TABLE yp_ods.t_store_collect
(
    id          string,
    user_id     string COMMENT '收藏人id',
    store_id    string COMMENT '店铺id',
    create_user string,
    create_time string,
    update_user string,
    update_time string,
    is_valid    TINYINT COMMENT '0 ：失效，1 ：开启'
)
comment '店铺收藏'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress'='ZLIB');

DROP TABLE if exists yp_ods.t_goods_collect;
CREATE TABLE yp_ods.t_goods_collect
(
    id          string,
    user_id     string COMMENT '收藏人id',
    goods_id    string COMMENT '商品id',
    store_id    string COMMENT '通过哪个店铺收藏的（因主店分店概念存在需要）',
    create_user string,
    create_time string,
    update_user string,
    update_time string,
    is_valid    TINYINT COMMENT '0 ：失效，1 ：开启'
)
comment '商品收藏'
partitioned by (dt string) row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress'='ZLIB');
"