#! /bin/bash
export LANG=zh_CN.UTF-8
HIVE_HOME=/usr/bin/hive


${HIVE_HOME} -S -e "
-- 建库
create database if not exists yp_dwb;

-- =======订单明细宽表=======
DROP TABLE if EXISTS yp_dwb.dwb_order_detail;
CREATE TABLE yp_dwb.dwb_order_detail(
  order_id string COMMENT '根据一定规则生成的订单编号',
  order_num string COMMENT '订单序号',
  buyer_id string COMMENT '买家的userId',
  store_id string COMMENT '店铺的id',
  order_from string COMMENT '渠道类型：android、ios、miniapp、pcweb、other',
  order_state int COMMENT '订单状态:1.已下单\; 2.已付款, 3. 已确认 \;4.配送\; 5.已完成\; 6.退款\;7.已取消',
  create_date string COMMENT '下单时间',
  finnshed_time timestamp COMMENT '订单完成时间,当配送员点击确认送达时,进行更新订单完成时间,后期需要根据订单完成时间,进行自动收货以及自动评价',
  is_settlement tinyint COMMENT '是否结算\;0.待结算订单\; 1.已结算订单\;',
  is_delete tinyint COMMENT '订单评价的状态:0.未删除\;  1.已删除\;(默认0)',
  evaluation_state tinyint COMMENT '订单评价的状态:0.未评价\;  1.已评价\;(默认0)',
  way string COMMENT '取货方式:SELF自提\;SHOP店铺负责配送',
  is_stock_up int COMMENT '是否需要备货 0：不需要    1：需要    2:平台确认备货  3:已完成备货 4平台已经将货物送至店铺 ',
--  订单副表
  order_amount decimal(36,2) COMMENT '订单总金额:购买总金额-优惠金额',
  discount_amount decimal(36,2) COMMENT '优惠金额',
  goods_amount decimal(36,2) COMMENT '用户购买的商品的总金额+运费',
  is_delivery string COMMENT '0.自提；1.配送',
  buyer_notes string COMMENT '买家备注留言',
  pay_time string,
  receive_time string,
  delivery_begin_time string,
  arrive_store_time string,
  arrive_time string COMMENT '订单完成时间,当配送员点击确认送达时,进行更新订单完成时间,后期需要根据订单完成时间,进行自动收货以及自动评价',
  create_user string,
  create_time string,
  update_user string,
  update_time string,
  is_valid tinyint COMMENT '是否有效  0: false\; 1: true\;   订单是否有效的标志',
--  订单组
  group_id string COMMENT '订单分组id',
  is_pay tinyint COMMENT '订单组是否已支付,0未支付,1已支付',
--  订单组支付
  group_pay_amount decimal(36,2) COMMENT '订单总金额\;',
--  退款单
  refund_id string COMMENT '退款单号',
  apply_date string COMMENT '用户申请退款的时间',
  refund_reason string COMMENT '买家退款原因',
  refund_amount decimal(36,2) COMMENT '订单退款的金额',
  refund_state tinyint COMMENT '1.申请退款\;2.拒绝退款\; 3.同意退款,配送员配送\; 4:商家同意退款,用户亲自送货 \;5.退款完成',
--  结算单
  settle_id string COMMENT '结算单号',
  settlement_amount decimal(36,2) COMMENT '如果发生退款,则结算的金额 = 订单的总金额 - 退款的金额',
  dispatcher_user_id string COMMENT '配送员id',
  dispatcher_money decimal(36,2) COMMENT '配送员的配送费(配送员的运费(如果退货方式为1:则买家支付配送费))',
  circle_master_user_id string COMMENT '圈主id',
  circle_master_money decimal(36,2) COMMENT '圈主分润的金额',
  plat_fee decimal(36,2) COMMENT '平台应得的分润',
  store_money decimal(36,2) COMMENT '商家应得的订单金额',
  status tinyint COMMENT '0.待结算；1.待审核 \; 2.完成结算；3.拒绝结算',
  settle_time string COMMENT ' 结算时间',
-- 订单评价
  evaluation_id string,
  evaluation_user_id string COMMENT '评论人id',
  geval_scores int COMMENT '综合评分',
  geval_scores_speed int COMMENT '送货速度评分0-5分(配送评分)',
  geval_scores_service int COMMENT '服务评分0-5分',
  geval_isanony tinyint COMMENT '0-匿名评价，1-非匿名',
  evaluation_time string,
-- 订单配送
  delievery_id string COMMENT '主键id',
  dispatcher_order_state tinyint COMMENT '配送订单状态:0.待接单.1.已接单,2.已到店.3.配送中 4.商家普通提货码完成订单.5.商家万能提货码完成订单。6，买家完成订单',
  delivery_fee decimal(36,2) COMMENT '配送员的运费',
  distance int COMMENT '配送距离',
  dispatcher_code string COMMENT '收货码',
  receiver_name string COMMENT '收货人姓名',
  receiver_phone string COMMENT '收货人电话',
  sender_name string COMMENT '发货人姓名',
  sender_phone string COMMENT '发货人电话',
  delievery_create_time string,
-- 商品快照
  order_goods_id string COMMENT '--商品快照id',
  goods_id string COMMENT '购买商品的id',
  buy_num int COMMENT '购买商品的数量',
  goods_price decimal(36,2) COMMENT '购买商品的价格',
  total_price decimal(36,2) COMMENT '购买商品的价格 = 商品的数量 * 商品的单价 ',
  goods_name string COMMENT '商品的名称',
  goods_specification string COMMENT '商品规格',
  goods_type string COMMENT '商品分类     ytgj:进口商品    ytsc:普通商品     hots爆品',
  goods_brokerage decimal(36,2) COMMENT '商家设置的商品分润的金额',
  is_goods_refund tinyint COMMENT '0.不退款\; 1.退款'
)
COMMENT '订单明细表'
PARTITIONED BY(dt STRING)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');


--=======店铺明细款表=======
DROP TABLE if EXISTS yp_dwb.dwb_shop_detail;
CREATE TABLE yp_dwb.dwb_shop_detail(
--  店铺
  id string, 
  address_info string COMMENT '店铺详细地址', 
  store_name string COMMENT '店铺名称', 
  is_pay_bond tinyint COMMENT '是否有交过保证金 1：是0：否', 
  trade_area_id string COMMENT '归属商圈ID', 
  delivery_method tinyint COMMENT '配送方式  1 ：自提 ；3 ：自提加配送均可\; 2 : 商家配送', 
  store_type int COMMENT '店铺类型 22天街网店 23实体店 24直营店铺 33会员专区店', 
  is_primary tinyint COMMENT '是否是总店 1: 是 2: 不是', 
  parent_store_id string COMMENT '父级店铺的id，只有当is_primary类型为2时有效', 
--  商圈
  trade_area_name string COMMENT '商圈名称',
--  区域-店铺
  province_id string COMMENT '店铺所在省份ID', 
  city_id string COMMENT '店铺所在城市ID', 
  area_id string COMMENT '店铺所在县ID', 
  province_name string COMMENT '省份名称', 
  city_name string COMMENT '城市名称', 
  area_name string COMMENT '县名称'
  )
COMMENT '店铺明细表'
PARTITIONED BY(dt STRING)
row format delimited fields terminated by '\t' 
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');


--=======商品明细宽表=======
DROP TABLE if EXISTS yp_dwb.dwb_goods_detail;
CREATE TABLE yp_dwb.dwb_goods_detail(
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
--  商品小类
  min_class_id string COMMENT '分类id:只保存最后一层分类id', 
  min_class_name string COMMENT '店铺内分类名字', 
--  商品中类
  mid_class_id string COMMENT '分类id:只保存最后一层分类id', 
  mid_class_name string COMMENT '店铺内分类名字', 
--  商品大类
  max_class_id string COMMENT '分类id:只保存最后一层分类id', 
  max_class_name string COMMENT '店铺内分类名字', 
--  品牌
  brand_name string COMMENT '品牌名称'
  )
COMMENT '商品明细表'
PARTITIONED BY(dt STRING)
row format delimited fields terminated by '\t' 
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');
"