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

- join方式的选择

  - left左连接

    > 以yp_dwd.fact_shop_order为左表，其他表进行left join

- 注意事项

  - 除fact_order_pay订单组表之外，其他表都是通过order_id与订单主表进行连接
  - fact_order_pay与fact_shop_order_group通过group_id连接，间接与订单主表连接
  - ==如果表是一张拉链表，注意加上过滤条件 end_date='9999-99-99',把当前有效的数据查询出来==
  - 对于fact_shop_order的end_date='9999-99-99'过滤，应该放在where条件中完成，先过滤，后join

- join模板

  ```sql
  select
  xxxxx
  xxx
  xxxxx
  FROM yp_dwd.fact_shop_order o
  --订单副表
  LEFT JOIN yp_dwd.fact_shop_order_address_detail od on o.id=od.id and od.end_date='9999-99-99'
  --订单组
  LEFT JOIN yp_dwd.fact_shop_order_group og on og.order_id = o.id and og.end_date='9999-99-99'
  --and og.is_pay=1  是否支付的过滤 0未支付 1 已支付
  --订单组支付信息
  LEFT JOIN yp_dwd.fact_order_pay op ON op.group_id = og.group_id and op.end_date='9999-99-99'
  --退款信息
  LEFT JOIN yp_dwd.fact_refund_order refund on refund.order_id=o.id and refund.end_date='9999-99-99'
  --and refund.refund_state=5  退款状态 5表示退款已经完成
  --结算信息
  LEFT JOIN yp_dwd.fact_order_settle os on os.order_id = o.id and os.end_date='9999-99-99'
  --商品快照
  LEFT JOIN yp_dwd.fact_shop_order_goods_details ogoods on ogoods.order_id = o.id and ogoods.end_date='9999-99-99'
  --订单评价表
  LEFT JOIN yp_dwd.fact_goods_evaluation e on e.order_id=o.id and e.is_valid=1
  --订单配送表
  LEFT JOIN yp_dwd.fact_order_delievery_item d on d.shop_order_id=o.id and d.dispatcher_order_type=1 and d.is_valid=1
  where o.end_date='9999-99-99';
  ```

#### 3.3. 最终SQL实现

```sql
INSERT into yp_dwb.dwb_order_detail
select
	o.id as order_id,
	o.order_num,
	o.buyer_id,
	o.store_id,
	o.order_from,
	o.order_state,
	o.create_date,
	o.finnshed_time,
	o.is_settlement,
	o.is_delete,
	o.evaluation_state,
	o.way,
	o.is_stock_up,
	od.order_amount,
	od.discount_amount,
	od.goods_amount,
	od.is_delivery,
	od.buyer_notes,
	od.pay_time,
	od.receive_time,
	od.delivery_begin_time,
	od.arrive_store_time,
	od.arrive_time,
	od.create_user,
	od.create_time,
	od.update_user,
	od.update_time,
	od.is_valid,
	og.group_id,
	og.is_pay,
	op.order_pay_amount as group_pay_amount,
	refund.id as refund_id,
	refund.apply_date,
	refund.refund_reason,
	refund.refund_amount,
	refund.refund_state,
	os.id as settle_id,
	os.settlement_amount,
	os.dispatcher_user_id,
	os.dispatcher_money,
	os.circle_master_user_id,
	os.circle_master_money,
	os.plat_fee,
	os.store_money,
	os.status,
	os.settle_time,
    e.id,
    e.user_id,
    e.geval_scores,
    e.geval_scores_speed,
    e.geval_scores_service,
    e.geval_isanony,
    e.create_time,
    d.id,
    d.dispatcher_order_state,
    d.delivery_fee,
    d.distance,
    d.dispatcher_code,
    d.receiver_name,
    d.receiver_phone,
    d.sender_name,
    d.sender_phone,
    d.create_time,
	ogoods.id as order_goods_id,
	ogoods.goods_id,
	ogoods.buy_num,
	ogoods.goods_price,
	ogoods.total_price,
	ogoods.goods_name,
	ogoods.goods_specification,
	ogoods.goods_type,
    ogoods.goods_brokerage,
	ogoods.is_refund as is_goods_refund,
	SUBSTRING(o.create_date,1,10) as dt --动态分区值
FROM yp_dwd.fact_shop_order o
--订单副表
left join yp_dwd.fact_shop_order_address_detail od on o.id=od.id and od.end_date='9999-99-99'
--订单组
left join yp_dwd.fact_shop_order_group og on og.order_id = o.id and og.end_date='9999-99-99'
--and og.is_pay=1
--订单组支付信息
left JOIN yp_dwd.fact_order_pay op ON op.group_id = og.group_id and op.end_date='9999-99-99'
--退款信息
left join yp_dwd.fact_refund_order refund on refund.order_id=o.id and refund.end_date='9999-99-99'
--and refund.refund_state=5
--结算信息
LEFT JOIN yp_dwd.fact_order_settle os on os.order_id = o.id and os.end_date='9999-99-99'
--商品快照
LEFT JOIN yp_dwd.fact_shop_order_goods_details ogoods on ogoods.order_id = o.id and ogoods.end_date='9999-99-99'
--订单评价表
left join yp_dwd.fact_goods_evaluation e on e.order_id=o.id and e.is_valid=1
--订单配送表
left join yp_dwd.fact_order_delievery_item d on d.shop_order_id=o.id and d.dispatcher_order_type=1 and d.is_valid=1
where o.end_date='9999-99-99';
```

- Hive执行动态分区配置参数

  ```shell
  --分区
  SET hive.exec.dynamic.partition=true;
  SET hive.exec.dynamic.partition.mode=nonstrict;
  set hive.exec.max.dynamic.partitions.pernode=10000;
  set hive.exec.max.dynamic.partitions=100000;
  set hive.exec.max.created.files=150000;
  --hive压缩
  set hive.exec.compress.intermediate=true;
  set hive.exec.compress.output=true;
  --写入时压缩生效
  set hive.exec.orc.compression.strategy=COMPRESSION;
  ```

### 4. 店铺明细宽表构建

#### 4.1. 建表

- 表梳理

  ![image-20211011152512209](assets/image-20211011152512209.png)

  ```properties
  核心表: yp_dwd.dim_store 店铺表
  退化维度表:
  	dim_trade_area 商圈表
  		记录商圈相关信息，店铺需要归属商圈中(ID主键是店铺表中的外键，trade_area_id)
  	dim_location 地址信息表
  		记录了店铺地址
  	dim_district 区域字典表
  		记录了省市县区域的名称、别名、编码、父级区域ID
  ```

- 建表语句

  ```sql
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
  row format delimited fields terminated by '\t' 
  stored as orc 
  tblproperties ('orc.compress' = 'SNAPPY');
  ```

#### 4.2. 省市县3级查询思路与实现

- 业务梳理

  > 业务系统在设计地址信息类数据存储时，采用的方法如下。

  ```shell
  #a、所有地址类信息统一存储在dim_location地址表中，通过type来表名属于什么地址。比如我们需要店铺地址时，需要在查询是添加条件where type=2来找出店铺地址信息。
  	1：商圈地址；2：店铺地址；3.用户地址管理;4.订单买家地址信息;5.订单卖家地址信息
  
  #b、而地址详细信息比如我们业务需要的省、市、县名称及其ID共6个字段，却又是存储在dim_district区域字典表中的。
  
  
  #c、然而比较可惜的是，区域字典表中的数据，不是所谓的帮省市区信息存储在一行种，而是通过父ID这样的方式形成关联。具体数据样式见下图。
  ```

  ![image-20211011161112899](assets/image-20211011161112899.png)

  ![image-20211011161551573](assets/image-20211011161551573.png)

  ![image-20211011161856077](assets/image-20211011161856077.png)

- 实现思路

  - 见画图。

  - sql伪代码实现

    ```sql
    --店铺先和地址连接 得到店铺的adcode
    yp_dwd.dim_store s
    LEFT JOIN yp_dwd.dim_location lc on lc.correlation_id = s.id and lc.type=2
    --在根据adcode去区域字典表中进行查询，先查出县
    LEFT JOIN yp_dwd.dim_district d1 ON d1.code = lc.adcode
    --根据县的pid再去区域字典表中查询出市
    LEFT JOIN yp_dwd.dim_district d2 ON d2.id = d1.pid
    --根据市的pid再去区域字典表中查询出省
    LEFT JOIN yp_dwd.dim_district d3 ON d3.id = d2.pid
    ```

#### 4.3. 最终SQL实现

```sql
INSERT into yp_dwb.dwb_shop_detail
SELECT 
	s.id,
	s.address_info,
	s.name as store_name,
	s.is_pay_bond,
	s.trade_area_id,
	s.delivery_method,
	s.store_type,
	s.is_primary,
	s.parent_store_id,
	ta.name as trade_area_name,
	d3.code as province_id,
	d2.code as city_id,
	d1.code as area_id,
	d3.name as province_name,
	d2.name as city_name,
	d1.name as area_name
--店铺
FROM yp_dwd.dim_store s
--商圈
LEFT JOIN yp_dwd.dim_trade_area ta ON ta.id = s.trade_area_id and ta.end_date='9999-99-99'
--地区  注意type=2才表示地址是店铺地址
LEFT JOIN yp_dwd.dim_location lc on lc.correlation_id = s.id and lc.type=2 and lc.end_date='9999-99-99'
LEFT JOIN yp_dwd.dim_district d1 ON d1.code = lc.adcode
LEFT JOIN yp_dwd.dim_district d2 ON d2.id = d1.pid
LEFT JOIN yp_dwd.dim_district d3 ON d3.id = d2.pid
WHERE s.end_date='9999-99-99'
;
```

### 5. 商品明细宽表构建

#### 5.1. 建表

- 表梳理

  ![image-20211011153639120](assets/image-20211011153639120.png)

  ```properties
  核心表: dim_goods 商品SKU表
  		记录了商品相关信息
  退化维度表:
  	dim_goods_class 商品分类表
  		记录了商品所属的分类信息：商品大类、商品中类、商品小类
  	dim_brand 品牌信息表	
  		记录了品牌信息		
  ```

- 建表语句

  ```sql
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
  row format delimited fields terminated by '\t' 
  stored as orc 
  tblproperties ('orc.compress' = 'SNAPPY');
  ```

#### 5.2. 商品分类实现剖析

- 背景

  ```shell
  # 1、业务系统在设计商品分类表dim_goods_class时，准备采用的是3级存储。通过level值来表示。
      1	 大类
      2	 中类
      3	 小类
      
  # 2、但是dim_goods_class数据集中实际等级效果只有两类，level=3的只有1个分类。  
  ```

  ![image-20211011180436152](assets/image-20211011180436152.png)

- 问题

  > 上述现象也就意味着==很多商品在存储的时候采用的是两类存储==，这点通过简单的sql得到了验证；

  ![image-20211011181418059](assets/image-20211011181418059.png)

  > 构建商品明细表时候，我们需要的是3类结果：商品小类、商品中类、商品大类。
  >
  > 因此在编写join的时候，我们需要关联3次，实际中的join情况因为分为下面3种：
  >
  > ==如果level=3，才会关联到level=2 ，再去关联level=1==
  >
  > ==如果level=2，关联到level=1,结束==
  >
  > ==如果level=1，结束==
  >
  > 结束指的是，已经到大类级别了，没有parent_id了。就是执行join，结果也是为空。

  ```
  1、先根据dim_goods.store_class_id = dim_goods_class.id查出商品小类
  
  2、然后根据小类.parent_id=dim_goods_class.id查出商品中类
  
  3、最后根据中类.parent_id=dim_goods_class.id查出商品大类
  ```

  > 这样导致的结果是：查询出来的3级分类会形成==错位==。如:
  >
  > 一个商品level=2，只能查询出来中类、大类，但是根据上述join的方式，却把
  >
  > 中类当成了小类，大类当成了中类，把null当成了大类。
  >
  > 那么==在查询结果取值返回的时候，一定要进行条件判断了，使用case when语句==。避免错误。

- 解决

  ```sql
  --商品小类 如果class1.level=3,说明这个商品第一级就是小类
  	CASE class1.level WHEN 3
  		THEN class1.id
  		ELSE NULL
  		END as min_class_id,
  	CASE class1.level WHEN 3
  		THEN class1.name
  		ELSE NULL
  		END as min_class_name,
  	--商品中类	如果class1.level=2，说明这个商品第一级就是中类
  	CASE WHEN class1.level=2
  		THEN class1.id
  		WHEN class2.level=2
  		THEN class2.id
  		ELSE NULL
  		END as mid_class_id,
  	CASE WHEN class1.level=2
  		THEN class1.name
  		WHEN class2.level=2
  		THEN class2.name
  		ELSE NULL
  		END as mid_class_name,
  	--商品大类	如果class1.level=1，说明这个商品第一级就是大类
  	CASE WHEN class1.level=1
  		THEN class1.id
  		WHEN class2.level=1
  		THEN class2.id
  		WHEN class3.level=1
  		THEN class3.id
  		ELSE NULL
  		END as max_class_id,
  	CASE WHEN class1.level=1
  		THEN class1.name
  		WHEN class2.level=1
  		THEN class2.name
  		WHEN class3.level=1
  		THEN class3.name
  		ELSE NULL
  		END as max_class_name,
  ```

#### 5.3. 最终SQL实现



## II. 分布式SQL引擎Presto

### 1. 介绍, 架构, 名词术语含义



### 2. 集群安装, 启停



### 3. 客户端的使用(命令行, DataGrip集成)



### 4. Presto时间日期类型使用注意事项



### 5. Presto优化

#### 5.1. 常规优化



#### 5.2. 内存优化

