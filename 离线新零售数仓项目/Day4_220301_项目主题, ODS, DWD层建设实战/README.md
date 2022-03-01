# 项目主题, ODS, DWD层建设实战

## I. 项目业务结构梳理

### 1. 业务系统表结构

- 表结构图

  ![image-20211009211833056](assets/image-20211009211833056.png)

- 订单相关

  ```properties
  t_shop_order:  订单主表 
  	记录订单基础信息(买家、卖家、订单来源、订单状态、订单评价状态、取货方式、是否需要备货)
  t_shop_order_address_detail:  订单副表 
  	记录订单额外信息 与订单主表是1对1关系 (订单金额、优化金额、是否配送、支付接单配送到达完成各时间) 
  t_shop_order_group:  订单组表 
  	多笔订单构成一个订单组 (含orderID)
  t_order_pay:    订单组支付表
  	记录订单组支付信息 (订单组ID、订单总金额)
  t_order_settle:  订单结算表
  	记录一笔订单中配送员、圈主、平台、商家的分成 (含orderID)
  t_order_delievery_item:  订单配送表
  	记录配送员信息、收货人信息、商品信息(含orderID)
  t_refund_order:  订单退款表
  	记录退款相关信息(含orderID)
  t_goods_evaluation:  订单评价表
  	记录订单综合评分,送货速度评分等(含orderID)
  t_goods_evaluation_detail:  订单中商品评价信息表
  	记录订单中对所购买商品的评价信息(含orderID)
  t_shop_order_goods_details:  订单和商品的中间表
  	记录订单中商品的相关信息，如商品ID、数量、价格、总价、名称、规格、分类(含orderID)
  t_trade_record:  交易记录表
  	记录所有交易记录信息，比如支付、结算、退款
  ```

- 店铺相关

  ```properties
  t_store:  店铺详情表
  	记录一家店铺的详细信息
  t_trade_area:  商圈表
  	记录商圈相关信息，店铺需要归属商圈中
  t_location:  地址表
  	记录了地址信息以及地址的所属类别，如是商圈地址还是店铺地址，还是买家地址
  t_district:  区域字典表
  	记录了省市县区域的名称、别名、编码、父级区域ID
  ```

- 商品相关

  ```properties
  t_goods:  商品表
  	记录了商品相关信息
  t_goods_class:  商品分类表
  t_brand:  品牌表
  	记录了品牌的相关信息
  t_goods_collect:  商品收藏表
  ```

- 用户相关

  ```properties
  t_user_login:  登陆日志表
  	记录登陆日志信息，如登陆用户、类型、客户端标识、登陆时间、登陆ip、登出时间等
  t_store_collect:  店铺收藏表
  	记录用户收藏的店铺ID
  t_shop_cart:  购物车表
  	记录用户添加购物车的商品id、商品数量、卖家店铺ID
  ```

- 系统配置相关

  ```properties
  t_date:  时间日期维度表
  	记录了年月日周、农历等相关信息
  ```

### 2. 项目分析主题梳理

> 主题是数据综合体，抽象的。一个分析主题的数据可能横跨多个数据源（多个表）。
>
> 1、所谓指标指的是该主题需要计算出哪些数据值，来衡量比较大小、好坏、高低、涨跌情况。
>
> 2、所谓维度指的是从哪些角度或者多个角度组合起来去计算指标

- ==销售主题==

  - 指标

    ```properties
    销售收入、平台收入
    配送成交额、小程序成交额、安卓APP成交额、苹果APP成交额、PC商城成交额
    订单量、参评单量、差评单量、配送单量、退款单量、小程序订单量、安卓APP订单量、苹果APP订单量、PC商城订单量
    
    16个指标
    ```

  - 维度

    ```properties
    日期、城市、商圈、店铺、品牌、大类、中类、小类
    
    8个维度
    ```

  > 所有维度的理论组合情况：2^8=256个
  >
  > 最终需要计算的指标个数：256*16=4096

- ==商品主题==

  - 指标

    ```properties
    下单次数、下单件数、下单金额
    被支付次数、被支付金额、被退款次数、被退款件数、被退款金额、被加入购物车次数、被加入购物车件数、被收藏次数
    好评数、中评数、差评数
    ```

  - 维度

    ```properties
    商品、日期
    ```

- 用户主题

  - 指标

    ```properties
    登录次数、收藏店铺数、收藏商品数、加入购物车次数、加入购物车金额
    下单次数、下单金额、支付次数、支付金额
    ```

  - 维度

    ```properties
    用户、日期
    ```

## II. DataGrip工具的使用

### 1. 业务数据导入

- step1：windows创建工程文件夹

  > 要求无中文，无空格环境
  >
  > 把项目资料中的脚本文件添加至工程文件夹中

  ![image-20211009225956655](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009225956655.png)

- step2：DataGrip创建Project

  ![image-20211009224420277](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009224420277.png)

  ![image-20211009224520331](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009224520331.png)

  ![image-20211009224537254](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009224537254.png)

- step3：关联本地工程文件夹

  ![image-20211009224720048](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009224720048.png)

  ![image-20211009224746393](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009224746393.png)

  ![image-20211009230028113](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009230028113.png)

- step4：DataGrip连接MySQL 

  ![image-20211009225433834](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009225433834.png)

  ![image-20211009225450423](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009225450423.png)

  ![image-20211009225519930](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009225519930.png)

  ![image-20211009225534200](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009225534200.png)

- step5：导入业务数据

  > 学会如何使用DataGrip工具执行sql文件

  ![image-20211009230053609](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009230053609.png)

  ![image-20211009230106096](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009230106096.png)

  ![image-20211009230116103](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009230116103.png)

  ![image-20211009230125990](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009230125990.png)

- step6：选中yipin数据库，刷新，查看数据是否正常

  ![image-20211009230204010](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009230204010.png)

  ![image-20211009230212523](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009230212523.png)

  ![image-20211009230221876](../../../../Users/JohnChow/Desktop/%E6%96%B0%E9%9B%B6%E5%94%AEday04--%E7%AC%94%E8%AE%B0+%E6%80%BB%E7%BB%93/Day04_%E9%A1%B9%E7%9B%AE%E4%B8%BB%E9%A2%98%E3%80%81ODS%E3%80%81DWD%E5%B1%82%E5%BB%BA%E8%AE%BE%E5%AE%9E%E6%88%98.assets/image-20211009230221876.png)

### 2. Hive中文注释乱码的问题



## III. ODS层构建

## IV. DWD(detail)层构建