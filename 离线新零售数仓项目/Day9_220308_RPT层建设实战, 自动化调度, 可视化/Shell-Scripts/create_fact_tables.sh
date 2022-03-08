#! /bin/bash
export LANG=zh_CN.UTF-8
HIVE_HOME=/usr/bin/hive

${HIVE_HOME} -S -e "
create database if not EXISTS yp_dwd;

--订单事实表（拉链表）
DROP TABLE if EXISTS yp_dwd.fact_shop_order;
CREATE TABLE yp_dwd.fact_shop_order(
  id string COMMENT '根据一定规则生成的订单编号', 
  order_num string COMMENT '订单序号', 
  buyer_id string COMMENT '买家的userId', 
  store_id string COMMENT '店铺的id', 
  order_from string COMMENT '此字段可以转换 1.安卓\; 2.ios\; 3.小程序H5 \; 4.PC', 
  order_state int COMMENT '订单状态:1.已下单\; 2.已付款, 3. 已确认 \;4.配送\; 5.已完成\; 6.退款\;7.已取消', 
  create_date string COMMENT '下单时间', 
  finnshed_time timestamp COMMENT '订单完成时间,当配送员点击确认送达时,进行更新订单完成时间,后期需要根据订单完成时间,进行自动收货以及自动评价', 
  is_settlement tinyint COMMENT '是否结算\;0.待结算订单\; 1.已结算订单\;', 
  is_delete tinyint COMMENT '订单评价的状态:0.未删除\;  1.已删除\;(默认0)', 
  evaluation_state tinyint COMMENT '订单评价的状态:0.未评价\;  1.已评价\;(默认0)', 
  way string COMMENT '取货方式:SELF自提\;SHOP店铺负责配送', 
  is_stock_up int COMMENT '是否需要备货 0：不需要    1：需要    2:平台确认备货  3:已完成备货 4平台已经将货物送至店铺 ', 
  create_user string, 
  create_time string, 
  update_user string, 
  update_time string, 
  is_valid tinyint COMMENT '是否有效  0: false\; 1: true\;   订单是否有效的标志',
  end_date string COMMENT '拉链结束日期')
COMMENT '订单表'
partitioned by (start_date string)
clustered by(id) sorted by(id) into 10 buckets
row format delimited fields terminated by '\t' 
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');

--订单详情表（拉链表）
DROP TABLE if EXISTS yp_dwd.fact_shop_order_address_detail;
CREATE TABLE yp_dwd.fact_shop_order_address_detail(
  id string COMMENT '关联订单的id', 
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
  end_date string COMMENT '拉链结束日期')
COMMENT '订单详情表'
partitioned by (start_date string)
clustered by(id) sorted by(id) into 10 buckets
row format delimited fields terminated by '\t' 
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');

--订单结算表
DROP TABLE if exists yp_dwd.fact_order_settle;
CREATE TABLE yp_dwd.fact_order_settle(
  id string COMMENT '结算单号', 
  order_id string, 
  settlement_create_date string COMMENT '用户申请结算的时间', 
  settlement_amount decimal(36,2) COMMENT '如果发生退款,则结算的金额 = 订单的总金额 - 退款的金额', 
  dispatcher_user_id string COMMENT '配送员id', 
  dispatcher_money decimal(36,2) COMMENT '配送员的配送费(配送员的运费(如果退货方式为1:则买家支付配送费))', 
  circle_master_user_id string COMMENT '圈主id', 
  circle_master_money decimal(36,2) COMMENT '圈主分润的金额', 
  plat_fee decimal(36,2) COMMENT '平台应得的分润', 
  store_money decimal(36,2) COMMENT '商家应得的订单金额', 
  status tinyint COMMENT '0.待结算；1.待审核 \; 2.完成结算；3.拒绝结算', 
  note string COMMENT '原因', 
  settle_time string COMMENT ' 结算时间', 
  create_user string, 
  create_time string, 
  update_user string, 
  update_time string, 
  is_valid tinyint COMMENT '是否有效  0: false\; 1: true\;   订单是否有效的标志', 
  first_commission_user_id string COMMENT '一级分佣用户', 
  first_commission_money decimal(36,2) COMMENT '一级分佣金额', 
  second_commission_user_id string COMMENT '二级分佣用户', 
  second_commission_money decimal(36,2) COMMENT '二级分佣金额',
  end_date string COMMENT '拉链结束日期')
COMMENT '订单结算表'
partitioned by (start_date string)
row format delimited fields terminated by '\t' 
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');


--退款订单表（拉链表）
DROP TABLE if exists yp_dwd.fact_refund_order;
CREATE TABLE yp_dwd.fact_refund_order
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
    is_valid             TINYINT COMMENT '是否有效  0: false; 1: true;   订单是否有效的标志',
  	end_date string COMMENT '拉链结束日期'
)
comment '退款订单表'
partitioned by (start_date string)
row format delimited fields terminated by '\t' 
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');



--订单组表（拉链表）
DROP TABLE if EXISTS yp_dwd.fact_shop_order_group;
CREATE TABLE yp_dwd.fact_shop_order_group(
  id string, 
  order_id string COMMENT '订单id', 
  group_id string COMMENT '订单分组id', 
  is_pay tinyint COMMENT '是否已支付,0未支付,1已支付', 
  create_user string, 
  create_time string, 
  update_user string, 
  update_time string, 
  is_valid tinyint,
  end_date string COMMENT '拉链结束日期')
COMMENT '订单组'
partitioned by (start_date string)
row format delimited fields terminated by '\t' 
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');

--订单组支付（拉链表）
DROP TABLE if EXISTS yp_dwd.fact_order_pay;
CREATE TABLE yp_dwd.fact_order_pay(
  id string, 
  group_id string COMMENT '关联shop_order_group的group_id,一对多订单', 
  order_pay_amount decimal(36,2) COMMENT '订单总金额\;', 
  create_date string COMMENT '订单创建的时间,需要根据订单创建时间进行判断订单是否已经失效', 
  create_user string, 
  create_time string, 
  update_user string, 
  update_time string, 
  is_valid tinyint COMMENT '是否有效  0: false\; 1: true\;   订单是否有效的标志',
  end_date string COMMENT '拉链结束日期')
COMMENT '订单组支付表'
partitioned by (start_date string)
row format delimited fields terminated by '\t' 
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');


--订单商品快照(拉链表)
DROP TABLE if EXISTS yp_dwd.fact_shop_order_goods_details;
CREATE TABLE yp_dwd.fact_shop_order_goods_details(
  id string COMMENT 'id主键', 
  order_id string COMMENT '对应订单表的id', 
  shop_store_id string COMMENT '卖家店铺ID', 
  buyer_id string COMMENT '购买用户ID', 
  goods_id string COMMENT '购买商品的id', 
  buy_num int COMMENT '购买商品的数量', 
  goods_price decimal(36,2) COMMENT '购买商品的价格', 
  total_price decimal(36,2) COMMENT '购买商品的价格 = 商品的数量 * 商品的单价 ', 
  goods_name string COMMENT '商品的名称', 
  goods_image string COMMENT '商品的图片', 
  goods_specification string COMMENT '商品规格', 
  goods_weight int, 
  goods_unit string COMMENT '商品计量单位', 
  goods_type string COMMENT '商品分类     ytgj:进口商品    ytsc:普通商品     hots爆品', 
  refund_order_id string COMMENT '退款订单的id', 
  goods_brokerage decimal(36,2) COMMENT '商家设置的商品分润的金额', 
  is_refund tinyint COMMENT '0.不退款\; 1.退款', 
  create_user string, 
  create_time string, 
  update_user string, 
  update_time string, 
  is_valid tinyint COMMENT '是否有效  0: false\; 1: true',
  end_date string COMMENT '拉链结束日期')
COMMENT '订单商品快照'
partitioned by (start_date string)
row format delimited fields terminated by '\t' 
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');


--订单评价表（增量表，与ODS一致）
DROP TABLE if EXISTS yp_dwd.fact_goods_evaluation;
CREATE TABLE yp_dwd.fact_goods_evaluation(
  id string, 
  user_id string COMMENT '评论人id', 
  store_id string COMMENT '店铺id', 
  order_id string COMMENT '订单id', 
  geval_scores int COMMENT '综合评分', 
  geval_scores_speed int COMMENT '送货速度评分0-5分(配送评分)', 
  geval_scores_service int COMMENT '服务评分0-5分', 
  geval_isanony tinyint COMMENT '0-匿名评价，1-非匿名', 
  create_user string, 
  create_time string, 
  update_user string, 
  update_time string, 
  is_valid tinyint COMMENT '0 ：失效，1 ：开启')
COMMENT '订单评价表'
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');


--商品评价表（增量表，与ODS一致）
DROP TABLE if EXISTS yp_dwd.fact_goods_evaluation_detail;
CREATE TABLE yp_dwd.fact_goods_evaluation_detail(
  id string, 
  user_id string COMMENT '评论人id', 
  store_id string COMMENT '店铺id', 
  goods_id string COMMENT '商品id', 
  order_id string COMMENT '订单id', 
  order_goods_id string COMMENT '订单商品表id', 
  geval_scores_goods int COMMENT '商品评分0-10分', 
  geval_content string, 
  geval_content_superaddition string COMMENT '追加评论', 
  geval_addtime string COMMENT '评论时间', 
  geval_addtime_superaddition string COMMENT '追加评论时间', 
  geval_state tinyint COMMENT '评价状态 1-正常 0-禁止显示', 
  geval_remark string COMMENT '管理员对评价的处理备注', 
  revert_state tinyint COMMENT '回复状态0未回复1已回复', 
  geval_explain string COMMENT '管理员回复内容', 
  geval_explain_superaddition string COMMENT '管理员追加回复内容', 
  geval_explaintime string COMMENT '管理员回复时间', 
  geval_explaintime_superaddition string COMMENT '管理员追加回复时间', 
  create_user string, 
  create_time string, 
  update_user string, 
  update_time string, 
  is_valid tinyint COMMENT '0 ：失效，1 ：开启',
  end_date string COMMENT '拉链结束日期')
COMMENT '商品评价明细'
partitioned by (start_date string)
row format delimited fields terminated by '\t'
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');


--配送表（增量表，与ODS一致）
DROP TABLE if EXISTS yp_dwd.fact_order_delievery_item;
CREATE TABLE yp_dwd.fact_order_delievery_item(
  id string COMMENT '主键id', 
  shop_order_id string COMMENT '订单表ID', 
  refund_order_id string, 
  dispatcher_order_type tinyint COMMENT '配送订单类型1.支付单\; 2.退款单', 
  shop_store_id string COMMENT '卖家店铺ID', 
  buyer_id string COMMENT '购买用户ID', 
  circle_master_user_id string COMMENT '圈主ID', 
  dispatcher_user_id string COMMENT '配送员ID', 
  dispatcher_order_state tinyint COMMENT '配送订单状态:0.待接单.1.已接单,2.已到店.3.配送中 4.商家普通提货码完成订单.5.商家万能提货码完成订单。6，买家完成订单', 
  order_goods_num tinyint COMMENT '订单商品的个数', 
  delivery_fee decimal(36,2) COMMENT '配送员的运费', 
  distance int COMMENT '配送距离', 
  dispatcher_code string COMMENT '收货码', 
  receiver_name string COMMENT '收货人姓名', 
  receiver_phone string COMMENT '收货人电话', 
  sender_name string COMMENT '发货人姓名', 
  sender_phone string COMMENT '发货人电话', 
  create_user string, 
  create_time string, 
  update_user string, 
  update_time string, 
  is_valid tinyint COMMENT '是否有效  0: false\; 1: true',
  end_date string COMMENT '拉链结束日期')
COMMENT '订单配送详细信息表'
partitioned by (start_date string)
row format delimited fields terminated by '\t'
stored as orc 
tblproperties ('orc.compress' = 'SNAPPY');

--登录记录表（增量表，与ODS一致）
DROP TABLE if exists yp_dwd.fact_user_login;
CREATE TABLE yp_dwd.fact_user_login(
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
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');


--购物车（拉链表）
DROP TABLE if exists yp_dwd.fact_shop_cart;
CREATE TABLE yp_dwd.fact_shop_cart
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
    is_valid      TINYINT COMMENT '是否有效  0: false; 1: true',
  end_date string COMMENT '拉链结束日期')
comment '购物车'
partitioned by (start_date string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');


--收藏店铺记录（拉链表）
DROP TABLE if exists yp_dwd.fact_store_collect;
CREATE TABLE yp_dwd.fact_store_collect
(
    id          string,
    user_id     string COMMENT '收藏人id',
    store_id    string COMMENT '店铺id',
    create_user string,
    create_time string,
    update_user string,
    update_time string,
    is_valid    TINYINT COMMENT '0 ：失效，1 ：开启',
  end_date string COMMENT '拉链结束日期')
comment '收藏店铺记录表'
partitioned by (start_date string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');


--商品收藏（拉链表）
DROP TABLE if exists yp_dwd.fact_goods_collect;
CREATE TABLE yp_dwd.fact_goods_collect
(
    id          string,
    user_id     string COMMENT '收藏人id',
    goods_id    string COMMENT '商品id',
    store_id    string COMMENT '通过哪个店铺收藏的（因主店分店概念存在需要）',
    create_user string,
    create_time string,
    update_user string,
    update_time string,
    is_valid    TINYINT COMMENT '0 ：失效，1 ：开启',
  end_date string COMMENT '拉链结束日期')
comment '收藏商品记录表'
partitioned by (start_date string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');

--交易记录（增量表，和ODS一致）
DROP TABLE if exists yp_dwd.fact_trade_record;
CREATE TABLE yp_dwd.fact_trade_record
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
    is_valid             TINYINT COMMENT '是否有效  0: false; 1: true;   订单是否有效的标志',
  end_date string COMMENT '拉链结束日期')
comment '交易记录'
partitioned by (start_date string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');
"