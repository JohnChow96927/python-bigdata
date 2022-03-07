# DM层建设实战

## I. DM层架构

### 目标与需求

- 新零售数仓分层图

  ![image-20211017084052778](assets/image-20211017084052778.png)

- DM

  - 名称：数据集市层 Data Market

  - 功能：基于DWS层日统计宽表，==上卷==出周、月、年等统计宽表，即==粗粒度汇总==。

  - 解释

    - 从理论层面来说，数据集市是一个小型的部门或工作组级别的数据仓库。
    - 一些公司早期的数据集市后期可能会演变成为数仓系统。
    - 本项目中在数据集市层面主要进行粗粒度汇总，也可以将这些功能下放至DWS层完成。抛弃DM.

    百科数据集市：https://baike.baidu.com/item/%E6%95%B0%E6%8D%AE%E9%9B%86%E5%B8%82/607135?fr=aladdin

    ![image-20211204134827255](assets/image-20211204134827255.png)

- 使用DataGrip在Hive中创建dm层

  > 注意，==**对于建库建表操作，需直接使用Hive**==，因为Presto只是一个数据分析的引擎，其语法不一定支持直接在Hive中建库建表。

  ```sql
  create database if not exists yp_dm;
  ```

### 1. 销售主题统计宽表构建

#### 1.1. 建模

- 概述

  > DM层销售主题宽表，基于DWS层销售主题日统计宽表的值，**上卷统计出年、月、周的数据**。
  >
  > 指标和DWS一致。

- 指标

  ```properties
  销售收入、平台收入、配送成交额、小程序成交额、安卓APP成交额、苹果APP成交额、PC商城成交额、订单量、参评单量、差评单量、配送单量、退款单量、小程序订单量、安卓APP订单量、苹果APP订单量、PC商城订单量
  ```

- 维度

  ```properties
  日期:天(已经统计过), 周,  月, 年
  城市
  商圈
  店铺
  品牌
  大类、中类、小类
  ```

- 建表

  > 整个表和DWS层销售主题统计宽表dws_sale_daycount的区别就在于==多了开头的时间粒度字段==。
  >
  > 用于标识后面的指标是哪个时间粒度统计出来的指标。

  ```sql
  CREATE TABLE yp_dm.dm_sale(
     date_time string COMMENT '统计日期,不能用来分组统计',
     time_type string COMMENT '统计时间维度：year、month、week、date(就是天day)',
     year_code string COMMENT '年code',
     year_month string COMMENT '年月',
     month_code string COMMENT '月份编码', 
     day_month_num string COMMENT '一月第几天', 
     dim_date_id string COMMENT '日期',
     year_week_name_cn string COMMENT '年中第几周',
     
     group_type string COMMENT '分组类型：store，trade_area，city，brand，min_class，mid_class，max_class，all',
     city_id string COMMENT '城市id',
     city_name string COMMENT '城市name',
     trade_area_id string COMMENT '商圈id',
     trade_area_name string COMMENT '商圈名称',
     store_id string COMMENT '店铺的id',
     store_name string COMMENT '店铺名称',
     brand_id string COMMENT '品牌id',
     brand_name string COMMENT '品牌名称',
     max_class_id string COMMENT '商品大类id',
     max_class_name string COMMENT '大类名称',
     mid_class_id string COMMENT '中类id', 
     mid_class_name string COMMENT '中类名称',
     min_class_id string COMMENT '小类id', 
     min_class_name string COMMENT '小类名称',
     --   =======统计=======
     --   销售收入
     sale_amt DECIMAL(38,2) COMMENT '销售收入',
     --   平台收入
     plat_amt DECIMAL(38,2) COMMENT '平台收入',
     -- 配送成交额
     deliver_sale_amt DECIMAL(38,2) COMMENT '配送成交额',
     -- 小程序成交额
     mini_app_sale_amt DECIMAL(38,2) COMMENT '小程序成交额',
     -- 安卓APP成交额
     android_sale_amt DECIMAL(38,2) COMMENT '安卓APP成交额',
     --  苹果APP成交额
     ios_sale_amt DECIMAL(38,2) COMMENT '苹果APP成交额',
     -- PC商城成交额
     pcweb_sale_amt DECIMAL(38,2) COMMENT 'PC商城成交额',
     -- 成交单量
     order_cnt BIGINT COMMENT '成交单量',
     -- 参评单量
     eva_order_cnt BIGINT COMMENT '参评单量comment=>cmt',
     -- 差评单量
     bad_eva_order_cnt BIGINT COMMENT '差评单量negtive-comment=>ncmt',
     -- 配送成交单量
     deliver_order_cnt BIGINT COMMENT '配送单量',
     -- 退款单量
     refund_order_cnt BIGINT COMMENT '退款单量',
     -- 小程序成交单量
     miniapp_order_cnt BIGINT COMMENT '小程序成交单量',
     -- 安卓APP订单量
     android_order_cnt BIGINT COMMENT '安卓APP订单量',
     -- 苹果APP订单量
     ios_order_cnt BIGINT COMMENT '苹果APP订单量',
     -- PC商城成交单量
     pcweb_order_cnt BIGINT COMMENT 'PC商城成交单量'
  )
  COMMENT '销售主题宽表' 
  ROW format delimited fields terminated BY '\t' 
  stored AS orc tblproperties ('orc.compress' = 'SNAPPY');
  ```

#### 1.2. 表关系梳理



#### 1.3. 按年统计



#### 1.4. 完整实现



#### 1.5. grouping精准识别分组



### 2. 商品主题统计宽表构建

#### 2.1. 建模



#### 2.2. 首次执行



#### 2.3. 循环操作



### 3. 用户主题统计宽表构建

#### 3.1. 建模



#### 3.2. 首次执行, 循环执行



## II. 数据治理

### 1. 元数据管理



### 2. 数据质量管理



