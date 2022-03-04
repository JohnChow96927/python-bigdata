# DWS层建设实战I

## I. 聚合函数增强

### 1. grouping sets

- 背景

  - 数据环境准备

    ```sql
    --在hive中建表操作
    use test;
    
    create table test.t_cookie(
        month string, 
        day string, 
        cookieid string) 
    row format delimited fields terminated by ',';
    
    
    --数据样例
    2015-03,2015-03-10,cookie1
    2015-03,2015-03-10,cookie5
    2015-03,2015-03-12,cookie7
    2015-04,2015-04-12,cookie3
    2015-04,2015-04-13,cookie2
    2015-04,2015-04-13,cookie4
    2015-04,2015-04-16,cookie4
    2015-03,2015-03-10,cookie2
    2015-03,2015-03-10,cookie3
    2015-04,2015-04-12,cookie5
    2015-04,2015-04-13,cookie6
    2015-04,2015-04-15,cookie3
    2015-04,2015-04-15,cookie2
    2015-04,2015-04-16,cookie1
    ```

  - 需求

    > 分别按照==月==（month）、==天==（day）、==月和天==（month,day）统计**来访用户cookieid个数**，并获取三者的结果集（一起插入到目标宽表中）。
    >
    > 目标表：month   day   cnt_nums

    ```sql
    --3个分组统计而已，简单。统计完再使用union all合并结果集。
    --注意union all合并结果集需要各个查询返回字段个数、类型一致，因此需要合理的使用null来填充返回结果。
    select month,
           null,
           count(cookieid)
    from test.t_cookie
    group by month
    
    union all
    
    select null,
           day,
           count(cookieid)
    from test.t_cookie
    group by day
    
    union all
    
    select month,
           day,
           count(cookieid)
    from test.t_cookie
    group by month,day;
    ```

  - 执行结果如下

    > 思考一下，这样有什么不妥的地方吗？
    >
    > 首先感受就是==执行时间很长，很长==；
    >
    > 另外从sql层面分析，会对test.t_cookie==查询扫描3次==，因为是3个查询的结果集合并。
    >
    > 假如这是10个维度的所有组合计算同一个指标呢？？
    >
    > 2^10  * 1    条select查询 union all？？？？？

    ![image-20211012221755094](assets/image-20211012221755094.png)

- grouping sets功能

  > ==根据不同的维度组合进行聚合==，等价于将不同维度的GROUP BY结果集进行UNION ALL。

  ```sql
  select 
      month,day,count(cookieid) 
  from test.t_cookie 
      group by month,day 
  grouping sets (month,day,(month,day));
  ```

  ![image-20211012222448607](assets/image-20211012222448607.png)

  > 1、使用grouping sets，==执行结果==与使用多个分组查询union合并结果集==一样==；
  >
  > 2、grouping sets==查询速度吊打==分组查询结果union all。大家可以使用explain执行计划查看两条sql的执行逻辑差异。
  >
  > 3、使用grouping sets只==会对表进行一次扫描==。

- hive中grouping sets语法

  > https://cwiki.apache.org/confluence/display/Hive/Enhanced+Aggregation%2C+Cube%2C+Grouping+and+Rollup#EnhancedAggregation,Cube,GroupingandRollup-GROUPINGSETSclause

  ![image-20211012222852943](assets/image-20211012222852943.png)

  > 特别注意：==**Presto的grouping sets语法和hive略有差异**==。

  ```sql
  ---下面这个是Hive SQL语法支持
  select 
      month,day,count(cookieid) 
  from test.t_cookie 
      group by month,day 
  grouping sets (month,day,(month,day));
  
  ----下面这个是Presto SQL语法支持
  select 
      month,day,count(cookieid) 
  from test.t_cookie 
      group by
  grouping sets (month,day,(month,day));
  
  --区别就是在presto的语法中，group by后面不要再加上字段了。
  ```

### 2. cube, roll up

- ==**cube**==

  - cube翻译过来叫做立方体，data cubes就是数据立方体。

  - cube的功能：==实现多个任意维度的查询==。也可以理解为所有维度组合。

    > 公式：假如说有==**N个维度，那么所有维度的组合的个数：2^N**==
    >
    > 下面这个图，就显示了4个维度所有组合构成的数据立方体。

    ![image-20211012223824098](assets/image-20211012223824098.png)

  - 语法

    ```sql
    select month,day,count(cookieid)
    from test.t_cookie
    group by
    cube (month, day);
    
    --上述sql等价于
    select month,day,count(cookieid)
    from test.t_cookie
    group by
    grouping sets ((month,day), month, day, ());
    ```

    ![image-20211012224133056](assets/image-20211012224133056.png)

- ==**rollup**==

  - 语法功能：实现==从右到左递减==多级的统计,显示统计某一层次结构的聚合。

    > 即：rollup((a),(b),(c))等价于grouping sets((a,b,c),(a,b),(a),())。

  ```sql
  select month,day,count(cookieid)
  from test.t_cookie
  group by
  rollup (month,day);
  
  --等价于
  select month,day,count(cookieid)
  from test.t_cookie
  group by
  grouping sets ((month,day), (month), ());
  ```

  ![image-20211012224838605](assets/image-20211012224838605.png)

### 3. grouping

- 功能：使用grouping操作来==判断==当前数据==是按照哪个字段来分组的==。

  > 对于给定的分组，如果分组中==包含相应的列，则将位设置为0==，否则将其设置为1。

- 例子

  ```sql
  --为了计算高效 切换至Presto引擎中进行计算
  
  select month,
         day,
         count(cookieid),
         grouping(month)      as m,
         grouping(day)        as d,
         grouping(month, day) as m_d
  from test.t_cookie
  group by
     grouping sets (month, day, (month, day));
  ```

  ![image-20211012232435567](assets/image-20211012232435567.png)

- 解释说明

  ```properties
  grouping(month)列为0时，可以看到month列都是有值的，为1时则相反，证明当前行是按照month来进行分组统计的；
  
  grouping(day)同理，为0时day列有值，为1时day为空，证明当前行时按照day来进行分组统计的；
  
  grouping(month, day)是grouping(month)、grouping(day)二进制数值组合后转换得到的数字：
  a. 按照month分组，则month=0，day=1，组合后为01，二进制转换为十进制得到数字1；
  b. 按照day分组，则month=1，day=0，组合后为10，二进制转换为十进制得到数字2；
  c. 同时按照month和day分组，则month=0，day=0，组合后为00，二进制转换为十进制得到数字0。
  
  因此可以使用grouping操作来判断当前数据是按照哪个字段来分组的。
  ```

## II. DWS层搭建

### 1. 目标与需求

- 新零售数仓分层图

  ![image-20211012233145046](assets/image-20211012233145046.png)

- DWS

  - 名称：==数据服务层==  service
  - 功能：==按主题划分==，形成日统计的宽表，轻度汇总==提前聚合操作==。
  - 解释：轻度提前聚合说的是先聚合出日的指标，后续可以上卷出周、月、年的指标。

  > dws这里，主题终于出现了~~~ 
  >
  > 一个主题所需要的指标、维度，可能往往需要多个DWB层的宽表共同参与计算才能得出。甚至还需要之前层如dwd等参与计算。

  ```
  轻度、重度 ：描述干活的多少  如果都做 叫做重度  只做某一部分叫做轻度
  细粒度、粗粒度：越往下粒度越细
  	举个栗子：1、计算每年的销售额  2、计算每天的销售额
  	上面这个两个都是根据时间维度计算的 哪个粒度细？ 天的粒度细  年粒度粗
  
  时间维度：年 月 日 时 分 秒
  ```

- 使用DataGrip在Hive中创建dws层

  > 注意，==**对于建库建表操作，需直接使用Hive**==，因为Presto只是一个数据分析的引擎，其语法不一定支持直接在Hive中建库建表。

  ```sql
  create database if not exists yp_dws;
  ```

  ![image-20211012234058062](assets/image-20211012234058062.png)

### 2. 销售主题统计宽表 -- 需求与建表

- 主题需求

  - 指标

    ```properties
    销售收入、平台收入、配送成交额、小程序成交额、安卓APP成交额、苹果APP成交额、PC商城成交额、订单量、参评单量、差评单量、配送单量、退款单量、小程序订单量、安卓APP订单量、苹果APP订单量、PC商城订单量
    
    --共计: 16个指标
    ```

  - 维度

    ```properties
    日期、城市、商圈、店铺、品牌、商品大类、商品中类、商品小类
    
    --共计:  8个维度
    --cube所有组合:  2^8=256个
    
    注意，其中日期这个维度很特殊，特殊在我们的表就是根据日期分区的，分区的字段是day天。
    而dws这一层我们需要统计的也是按day统计，日统计宽表嘛
    这也就意味着一个分区就是一天。
    ```

  - 本主题需要维度组合

    > 提示：256个组合都计算还是计算当中的一部分，主动权在于业务、需求，我们做的是技术实现。

    ```properties
    日期
    日期+城市
    日期+城市+商圈
    日期+城市+商圈+店铺
    日期+品牌
    日期+大类
    日期+大类+中类
    日期+大类+中类+小类
    
    #各个维度之间的关系是什么样的？是并列关系还是递进关系？   维度最终落实sql层面就是分组字段。
    #判断上述8个维度组合中，哪个维度是真正起作用的维度？
    #技巧：如何判断是否起作用？在sql中的分组字段 把它去掉 会不会影响分组结果，如果没有影响  不起作用
    
    日期+城市  	     并列关系    城市有没有影响结果吗？  影响大
    日期+城市+商圈    递进关系    城市有没有影响结果吗？  没有影响 真正起决定作用的是 商圈
    
    
    #对应本项目来说 真正起决定作用的维度是
    	
    日期				   日期
    日期+城市  			 日期+城市
    日期+城市+商圈        日期+商圈     
    日期+城市+商圈+店铺    日期+店铺 
    日期+品牌            日期+品牌    
    日期+大类            日期+大类
    日期+大类+中类        日期+中类
    日期+大类+中类+小类    日期+小类
    ```

  - 总计需要计算的指标

    > ==**16*8=128**==
    >
    > 1、如果不加任何限制，只是求出每个指标，那么很简单，128个sql语句进行分组聚合操作。
    >
    > 2、实际中肯定不能那么做，需要==一条sql完成128个指标的计算，并且把结果插入主题统计宽表==中。

- Hive中建表

  > 既然是把一个主题相关的数据统计数据都存储在一张表中，那么意味着这张统计宽表应该要清晰的记录出维度、指标，有的计算，没有的null补上。

  ```sql
  CREATE TABLE yp_dws.dws_sale_daycount(
    --维度  
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
     group_type string COMMENT '分组类型：store，trade_area，city，brand，min_class，mid_class，max_class，all',
     --   =======日统计=======
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
  COMMENT '销售主题日统计宽表'
  PARTITIONED BY(dt STRING)
  ROW format delimited fields terminated BY '\t'
  stored AS orc tblproperties ('orc.compress' = 'SNAPPY');
  ```

### 3. 销售主题统计宽表 -- 简易模型分析

#### 3.1. 分组聚合union

> 为了更好的实现一条sql计算出所有的指标，这里我们先对数据模型进行简化操作。
>
> 这个模型理解了，销售主题宽表的计算就可以实现了。

- 需求

  - 订单宽表t_order_detail

    ```sql
    --建表（在hive中创建）
    create table test.t_order_detail(
        oid string comment '订单ID',
        goods_id string comment '商品ID',
        o_price int comment '订单总金额',
        g_num int comment '商品数量',
        g_price int comment '商品单价',
        brand_id string comment '品牌ID',
        dt string comment '日期'
    ) comment '订单详情宽表_简易模型'
    row format delimited fields terminated by ',';
    
    --加载数据
    o01,g01,100,1,80,b01,2021-08-29
    o01,g02,100,1,20,b02,2021-08-29
    o02,g03,180,1,80,b01,2021-08-29
    o02,g04,180,2,40,b02,2021-08-29
    o02,g07,180,3,60,b01,2021-08-29
    o03,g02,80,1,80,b02,2021-08-30
    o04,g01,300,2,160,b01,2021-08-30
    o04,g02,300,3,60,b02,2021-08-30
    o04,g03,300,4,80,b01,2021-08-30
    ```

    ![image-20211013225639853](assets/image-20211013225639853.png)

  - 需求

    - 指标：订单量、销售额
    - 维度：日期、日期+品牌

  - 计算出结果

    ![image-20211013232613817](assets/image-20211013232613817.png)

- 实现思路（在presto中计算）

  > 立马想到：多条sql分组聚合+union合并结果集，没有的字段使用null进行填补。

  - step1:统计每天的订单量、销售额

    ```sql
    select
      dt,
      count(distinct oid) as "订单量",
      sum(g_price) as "销售额"
    from test.t_order_detail
    group by dt;
    ```

    ![image-20211013230246919](assets/image-20211013230246919.png)

  - step2:统计每天每个品牌的订单量、销售额

    ```sql
    select
      dt,
      brand_id,
      count(distinct oid) as "各品牌订单量",
      sum(g_price) as "各品牌销售额"
    from test.t_order_detail
    group by dt,brand_id;
    ```

    ![image-20211013230507311](assets/image-20211013230507311.png)

  - step3:union all合并两个查询结果集

    ```sql
    select
      dt as "日期",
      null as "品牌id",
      count(distinct oid) as "订单量",
      null as "各品牌订单量",
      sum(g_price) as "销售额",
      null as "各品牌销售额",
      1 as group_id
    from test.t_order_detail
    group by dt
    union all
    select
      dt as "日期",
      brand_id as "品牌id",
      null as "订单量",
      count(distinct oid) as "各品牌订单量",
      null as "销售额",
      sum(g_price) as "各品牌销售额",
      2 as group_id
    from test.t_order_detail
    group by dt,brand_id;
    ```

    > 思考：这么做有什么不妥的地方？

#### 3.2. 增强聚合grouping sets



### 4. 销售主题统计宽表 -- 复杂模型分析



### 5. 新零售项目销售主题统计宽表的实现

