# DWB层建设实战、Presto计算引擎

## I. DWB层构建

### 1. DWB功能职责

- 新零售数仓分层图

  ![image-20211011134501462](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday05--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day05_DWB%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98%E3%80%81Presto%E8%AE%A1%E7%AE%97%E5%BC%95%E6%93%8E.assets/image-20211011134501462.png)

- DWB

  - 名称：基础数据层、中间数据层
  - 功能：==退化维度（降维）==形成大宽表

### 2. 维度退化(降维)概念与意义

- 百科定义

  > 退化维度（Degenerate Dimension,DD），就是那些看起来像是事实表的一个维度关键字，但实际上并没有对应的维度表。
  >
  > ==退化维度技术可以减少维度的数量（降维操作）==，简化维度数据仓库的模式。简单的模式比复杂的更容易理解，也有更好的查询性能。

  ![image-20211011134757903](assets/image-20211011134757903.png)

- 常见操作

  > 1、将==各个维度表的核心字段数据汇总到事实表==中；
  >
  > 2、如果一个业务模块有多个事实表，也可以将==多个事实表的核心字段汇总到一个事实表==。

- 功能

  - 通过退化维度操作之后，带来的显著效果是
    - 整个数仓中**表的个数减少**了；
    - 业务==相关联的数据==（跟你分析相关的）数据字段聚在一起了，==形成一张宽表==。
    - 分析==查询时的效率显著提高==了：多表查询和==单表查询==的差异。
  - 带来的坏处是
    - 数据大量冗余、宽表的概念已经不符合3范式设计要求了。
    - 但是数仓建模的核心追求是，只要有利于分析，能够加快数据分析，都可以做。

- 新零售项目--DWB层明细宽表

  > 根据业务形式和后续分析需求，划分了3大模块，对应着3张明细宽表。
  >
  > 用户业务模块没有进行退化维度操作，原因是后面的指标单表可以操作技术。

  - 订单明细宽表 **==dwb_order_detail==**
  - 店铺明细宽表 **==dwb_shop_detail==**
  - 商品明细宽表 **==dwb_goods_detail==**

- 使用DataGrip在Hive中创建dwb层

  ```sql
  create database if not exists yp_dwb;
  ```

  ![image-20211011145558382](assets/image-20211011145558382.png)

### 3. 订单明细宽表构建

#### 3.1. 建表

- 表梳理

  ![image-20211011143727903](assets/image-20211011143727903.png)

  ```properties
  核心表: yp_dwd.fact_shop_order订单主表
  		(也就说，其他表将围绕着订单主表拼接成为一张宽表)
  退化维度表:
  	fact_shop_order_address_detail:  订单副表 
  		记录订单额外信息 与订单主表是1对1关系 (id与orderID一一对应) 
  	fact_shop_order_group:  订单组表 
  		多笔订单构成一个订单组 (含orderID)
  	fact_order_pay:    订单组支付表
  		记录订单组支付信息，跟订单组是1对1关系 (含group_id)
  	fact_refund_order:  订单退款信息表
  		记录退款相关信息(含orderID)		
  	fact_order_settle:  订单结算表
  		记录一笔订单中配送员、圈主、平台、商家的分成 (含orderID)
  	fact_shop_order_goods_details:  订单和商品的中间表
  		记录订单中商品的相关信息，如商品ID、数量、价格、总价、名称、规格、分类(含orderID)
  	fact_goods_evaluation:  订单评价表
  		记录订单综合评分,送货速度评分等(含orderID)        
  	fact_order_delievery_item:  订单配送表
  		记录配送员信息、收货人信息、商品信息(含orderID)
  ```

- 建表：订单明细宽表 dwb_order_detail

  > 在进行维度退化的时候，需要将各个表的核心字段退化到事实表中形成宽表，究竟哪些是核心字段呢？
  >
  > 答案是：明显不需要的可以不退化  另外拿捏不住  “==宁滥勿缺==”。

  ```sql
  CREATE TABLE yp_dwb.dwb_order_detail(
  --订单主表
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
  --  结算
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
  ```

#### 3.2. join操作



#### 3.3. 最终SQL实现



### 4. 店铺明细宽表构建



#### 4.1. 省市县3级查询思路与实现



### 5. 商品明细宽表构建



## II. 分布式SQL引擎Presto

### 1. 介绍, 架构, 名词术语含义



### 2. 集群安装, 启停



### 3. 客户端的使用(命令行, DataGrip集成)



### 4. Presto时间日期类型使用注意事项



### 5. Presto优化

#### 5.1. 常规优化



#### 5.2. 内存优化

