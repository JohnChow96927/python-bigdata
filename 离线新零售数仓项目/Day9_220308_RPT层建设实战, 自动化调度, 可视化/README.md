# RPT层建设实战, 自动化调度, 可视化

## I. RPT层构建

### 1. 目标与需求

- 新零售数仓分层图

  ![image-20211017141939771](assets/image-20211017141939771.png)

- RPT

  - 名称：数据报表层（Report），其实就是我们所讲的数据应用层DA、APP。

  - 功能：==根据报表、专题分析的需求而计算生成的个性化数据==。表结构与报表系统保持一致。

  - 解释

    > 这一层存在的意义在于，如果报表系统需要一些及时高效的展示分析。我们可以在RPT层根据其需求提前把相关的字段、计算、统计做好，支撑报表系统的高效、便捷使用。

- 栗子

  - 比如报表需要展示：门店销售量Top10，展示如下效果

    ![image-20211207134550065](assets/image-20211207134550065.png)

  - 对于其依赖的数据有两种实现方式

    - 方式1：使用专业的BI报表软件直接读取数据仓库或数据集市的数据，然后自己根据需要展示的效果进行数据抽、转换、拼接动作，
    - 方式2：==大数据开发工程师针对前端Top10展示的需求，提前把数据拼接好，返回前端直接页面渲染展示。==

    ![image-20211207134945383](assets/image-20211207134945383.png)

- 使用DataGrip在Hive中创建RPT层

  > 注意，==**对于建库建表操作，需直接使用Hive**==，因为Presto只是一个数据分析的引擎，其语法不一定支持直接在Hive中建库建表。

  ```sql
  create database if not exists yp_rpt;
  ```

### 2. 销售主题报表

- 需求一：门店月销售单量排行

  > 按月统计，==各个门店==的==月销售单量==。

  - 建表

    ```sql
    CREATE TABLE yp_rpt.rpt_sale_store_cnt_month(
       date_time string COMMENT '统计日期,不能用来分组统计',
       year_code string COMMENT '年code',
       year_month string COMMENT '年月',
       
       city_id string COMMENT '城市id',
       city_name string COMMENT '城市name',
       trade_area_id string COMMENT '商圈id',
       trade_area_name string COMMENT '商圈名称',
       store_id string COMMENT '店铺的id',
       store_name string COMMENT '店铺名称',
       
       order_store_cnt BIGINT COMMENT '店铺成交单量',
       miniapp_order_store_cnt BIGINT COMMENT '小程序端店铺成交单量',
       android_order_store_cnt BIGINT COMMENT '安卓端店铺成交单量',
       ios_order_store_cnt BIGINT COMMENT 'ios端店铺成交单量',
       pcweb_order_store_cnt BIGINT COMMENT 'pc页面端店铺成交单量'
    )
    COMMENT '门店月销售单量排行' 
    ROW format delimited fields terminated BY '\t' 
    stored AS orc tblproperties ('orc.compress' = 'SNAPPY');
    ```

  - 实现

    > 从销售主题统计宽表中，找出分组为store，并且时间粒度为month的进行排序即可。

    ```sql
    --门店月销售单量排行
    insert into yp_rpt.rpt_sale_store_cnt_month
    select 
       date_time,
       year_code,
       year_month,
       city_id,
       city_name,
       trade_area_id,
       trade_area_name,
       store_id,
       store_name,
       order_cnt,
       miniapp_order_cnt,
       android_order_cnt,
       ios_order_cnt,
       pcweb_order_cnt
    from yp_dm.dm_sale 
    where time_type ='month' and group_type='store' and store_id is not null 
    order by order_cnt desc;
    ```

![image-20211204164443670](assets/image-20211204164443670.png)

- 需求二：日销售曲线

  > 按==天==统计，==总销售金额==和==销售单量==。

  - 建表

    ```sql
    --日销售曲线
    DROP TABLE IF EXISTS yp_rpt.rpt_sale_day;
    CREATE TABLE yp_rpt.rpt_sale_day(
       date_time string COMMENT '统计日期,不能用来分组统计',
       year_code string COMMENT '年code',
       month_code string COMMENT '月份编码', 
       day_month_num string COMMENT '一月第几天', 
       dim_date_id string COMMENT '日期',
    
       sale_amt DECIMAL(38,2) COMMENT '销售收入',
       order_cnt BIGINT COMMENT '成交单量'
    )
    COMMENT '日销售曲线' 
    ROW format delimited fields terminated BY '\t' 
    stored AS orc tblproperties ('orc.compress' = 'SNAPPY');
    ```

  - 实现

    ```sql
    --日销售曲线
    insert into yp_rpt.rpt_sale_day
    select 
       date_time,
       year_code,
       month_code,
       day_month_num,
       dim_date_id,
       sale_amt,
       order_cnt
    from yp_dm.dm_sale 
    where time_type ='date' and group_type='all'
    --按照日期排序显示曲线
    order by dim_date_id;
    ```

  ![image-20211207141004223](assets/image-20211207141004223.png)

- 需求三：渠道销售占比

  > 比如每天不同渠道的==订单量占比==。
  >
  > 也可以延伸为每周、每月、每个城市、每个品牌等等等。

  - 处理思路

    ```sql
    --在dm层的dm_sale表中
    	order_cnt 表示总订单量
    		miniapp_order_cnt 表示小程序订单量
    		android_order_cnt 安卓
    		ios_order_cnt ios订单量
    		pcweb_order_cnt  网站订单量
    --所谓的占比就是
    	每个占order_cnt总订单量的比例 也就是进行除法运算
    	
    --最后需要注意的是
    	上述这几个订单量的字段  存储类型是bigint类型。
    	如果想要得出90.25这样的占比率  需要使用cast函数将bigInt转换成为decimal类型。
    ```

  - 建表

    ```sql
    --渠道销量占比
    DROP TABLE IF EXISTS yp_rpt.rpt_sale_fromtype_ratio;
    CREATE TABLE yp_rpt.rpt_sale_fromtype_ratio(
       date_time string COMMENT '统计日期,不能用来分组统计',
       time_type string COMMENT '统计时间维度：year、month、day',
       year_code string COMMENT '年code',
       year_month string COMMENT '年月',
       dim_date_id string COMMENT '日期',
       
       order_cnt BIGINT COMMENT '成交单量',
       miniapp_order_cnt BIGINT COMMENT '小程序成交单量',
       miniapp_order_ratio DECIMAL(5,2) COMMENT '小程序成交量占比',
       android_order_cnt BIGINT COMMENT '安卓APP订单量',
       android_order_ratio DECIMAL(5,2) COMMENT '安卓APP订单量占比',
       ios_order_cnt BIGINT COMMENT '苹果APP订单量',
       ios_order_ratio DECIMAL(5,2) COMMENT '苹果APP订单量占比',
       pcweb_order_cnt BIGINT COMMENT 'PC商城成交单量',
       pcweb_order_ratio DECIMAL(5,2) COMMENT 'PC商城成交单量占比'
    )
    COMMENT '渠道销量占比' 
    ROW format delimited fields terminated BY '\t' 
    stored AS orc tblproperties ('orc.compress' = 'SNAPPY');
    ```

  - 实现

    ```sql
    --渠道销量占比
    insert into yp_rpt.rpt_sale_fromtype_ratio
    select 
       date_time,
       time_type,
       year_code,
       year_month,
       dim_date_id,
       
       order_cnt,
       miniapp_order_cnt,
       cast(
          cast(miniapp_order_cnt as DECIMAL(38,4)) / cast(order_cnt as DECIMAL(38,4))
          * 100
          as DECIMAL(5,2)
       ) miniapp_order_ratio,
       android_order_cnt,
       cast(
          cast(android_order_cnt as DECIMAL(38,4)) / cast(order_cnt as DECIMAL(38,4))
          * 100
          as DECIMAL(5,2)
       ) android_order_ratio,
       ios_order_cnt,
       cast(
          cast(ios_order_cnt as DECIMAL(38,4)) / cast(order_cnt as DECIMAL(38,4))
          * 100
          as DECIMAL(5,2)
       ) ios_order_ratio,
       pcweb_order_cnt,
       cast(
          cast(pcweb_order_cnt as DECIMAL(38,4)) / cast(order_cnt as DECIMAL(38,4))
          * 100
          as DECIMAL(5,2)
       ) pcweb_order_ratio
    from yp_dm.dm_sale
    where group_type = 'all';
    ```

  ![image-20211204164818513](assets/image-20211204164818513.png)

### 3. 商品主题报表

- 需求一：商品销量==topN==

  > 统计出某天销量最多的top10商品

- 需求二：商品收藏==topN==

  > 统计出某天收藏量最多的top10商品

- 需求三：商品加入购物车==topN==

  > 统计出某天，购物车最多的top10商品

- 建表

  ```sql
  --商品销量TOPN
  drop table if exists yp_rpt.rpt_goods_sale_topN;
  create table yp_rpt.rpt_goods_sale_topN(
      `dt` string COMMENT '统计日期',
      `sku_id` string COMMENT '商品ID',
      `payment_num` bigint COMMENT '销量'
  ) COMMENT '商品销量TopN'
  ROW format delimited fields terminated BY '\t'
  stored AS orc tblproperties ('orc.compress' = 'SNAPPY');
  
  --商品收藏TOPN
  drop table if exists yp_rpt.rpt_goods_favor_topN;
  create table yp_rpt.rpt_goods_favor_topN(
      `dt` string COMMENT '统计日期',
      `sku_id` string COMMENT '商品ID',
      `favor_count` bigint COMMENT '收藏量'
  ) COMMENT '商品收藏TopN'
  ROW format delimited fields terminated BY '\t' 
  stored AS orc tblproperties ('orc.compress' = 'SNAPPY');
  
  --商品加入购物车TOPN
  drop table if exists yp_rpt.rpt_goods_cart_topN;
  create table yp_rpt.rpt_goods_cart_topN(
      `dt` string COMMENT '统计日期',
      `sku_id` string COMMENT '商品ID',
      `cart_num` bigint COMMENT '加入购物车数量'
  ) COMMENT '商品加入购物车TopN'
  ROW format delimited fields terminated BY '\t' 
  stored AS orc tblproperties ('orc.compress' = 'SNAPPY');
  
  --商品退款率TOPN
  drop table if exists yp_rpt.rpt_goods_refund_topN;
  create table yp_rpt.rpt_goods_refund_topN(
      `dt` string COMMENT '统计日期',
      `sku_id` string COMMENT '商品ID',
      `refund_ratio` decimal(10,2) COMMENT '退款率'
  ) COMMENT '商品退款率TopN'
  ROW format delimited fields terminated BY '\t' 
  stored AS orc tblproperties ('orc.compress' = 'SNAPPY');
  ```

  ```sql
  --统计出某天销量最多的top10商品
  
  --方式1 ：简单方式
  select sku_id,order_count from yp_dm.dm_sku
  order by order_count desc limit 10;
  
  --方式2  ：复杂方式
  --需求：找出销量最多的前10个  重复的算并列 但是总数只要10个。
  with tmp as (select
      sku_id,order_count,
      rank() over(order by order_count desc) rn1,
      dense_rank() over(order by order_count desc) rn2,
      row_number() over(order by order_count desc) rn3
  from yp_dm.dm_sku)
  
  select * from tmp where rn <11;
  ```

- sql实现

  > 注意，==这里为了最终展示效果，保证有数据，特意在时间dt上做了特殊处理==。
  >
  > 本来是需要通过dt指定某一天数据的，这里忽略dt过滤 ，直接使用全部数据。
  >
  > ```
  > select * from yp_dws.dws_sku_daycount order by order_count desc;
  > 
  > 
  > select * from yp_dws.dws_sku_daycount where dt ='2021-08-31' order by order_count desc;
  > ```

  ```sql
  --商品销量TOPN
  insert into yp_rpt.rpt_goods_sale_topN
  select
      '2020-08-09' dt,
      sku_id,
      payment_count
  from
      yp_dws.dws_sku_daycount
  -- where
  --     dt='2020-08-09'
  order by payment_count desc
  limit 10;
  
  
  --商品收藏TOPN
  insert into yp_rpt.rpt_goods_favor_topN
  select
      '2020-08-09' dt,
      sku_id,
      favor_count
  from
      yp_dws.dws_sku_daycount 
  -- where
  --     dt='2020-08-09'
  order by favor_count desc
  limit 10;
  
  
  --商品加入购物车TOPN
  insert into yp_rpt.rpt_goods_cart_topN
  select
      '2020-08-09' dt,
      sku_id,
      cart_num
  from
      yp_dws.dws_sku_daycount
  -- where
  --     dt='2021-08-31'
  order by cart_num desc
  limit 10;
  
  --商品退款率TOPN
  insert into yp_rpt.rpt_goods_refund_topN
  select
      '2020-08-09',
      sku_id,
      cast(
        cast(refund_last_30d_count as DECIMAL(38,4)) / cast(payment_last_30d_count as DECIMAL(38,4))
        * 100
        as DECIMAL(5,2)
     ) refund_ratio
  from yp_dm.dm_sku 
  where payment_last_30d_count!=0
  order by refund_ratio desc
  limit 10;
  ```

### 4. 用户主题报表

- 需求

  > 活跃会员数、新增会员数、新增消费会员数、总付费会员数、总会员数、会员活跃率等。

- 建表

  ```sql
  --用户数量统计
  drop table if exists yp_rpt.rpt_user_count;
  create table yp_rpt.rpt_user_count(
      dt string COMMENT '统计日期',
      day_users BIGINT COMMENT '活跃会员数',
      day_new_users BIGINT COMMENT '新增会员数',
      day_new_payment_users BIGINT COMMENT '新增消费会员数',
      payment_users BIGINT COMMENT '总付费会员数',
      users BIGINT COMMENT '总会员数',
      day_users2users decimal(38,4) COMMENT '会员活跃率',
      payment_users2users decimal(38,4) COMMENT '总会员付费率',
      day_new_users2users decimal(38,4) COMMENT '会员新鲜度'
  )
  COMMENT '用户数量统计报表'
  ROW format delimited fields terminated BY '\t'
  stored AS orc tblproperties ('orc.compress' = 'SNAPPY');
  ```

- 实现思路

  > 业务解读

  ```shell
  #首先，确定干活统计的日期，比如2019-05-08
  
  #1、活跃会员数
  	活跃的业务解读：	
  		1、在一个月中累积登录次数大于某个值 叫做活跃  比如累积登录次数 >20
  		2、该用户的末次登陆时间为昨天（今天统计的是昨天的），昨天来过 就表示活跃
  	
  	本项目使用2：用户最后一次登录为统计日期之前一天的  表示活跃
  	
  #2、新增会员数
  	第一次登录为统计日期前一天的  表示新增
  	
  #3、新增消费会员数	
  	首次支付时间为统计日期前一天的
  
  #4、总付费会员数
  	支付次数大于0的
  	
  #5、总会员数
  
  #6、会员活跃率
  	最后一次登录时间为统计日期前一天的表示这个人很活跃  
  	除以总会员数即是会员活跃率
  	
  #7、总会员付费率
  	支付次数payment_count大于0次的表示该用户支付过  不管支付几次
  	除以总会员数即是总会员付费率
  	
  #8、会员新鲜度
  	在统计日期前一天中所有登录用户中，哪些是第一次登录的  占比即是新鲜度
  	login_date_last最后一次登录的时间
  	login_date_first 第一次登录的时间
  ```

  

- sql实现

  ```sql
  --用户数量统计
  insert into yp_rpt.rpt_user_count
  select
      '2019-05-08',
      sum(if(login_date_last='2019-05-07',1,0)), --活跃会员数
      sum(if(login_date_first='2019-05-07',1,0)),--新增会员数
      sum(if(payment_date_first='2019-05-07',1,0)), --新增消费会员数
      sum(if(payment_count>0,1,0)), --总付费会员数
      count(*), --总会员数
      if(
          sum(if(login_date_last = '2019-05-07', 1, 0)) = 0,
          null,
          cast(sum(if(login_date_last = '2019-05-07', 1, 0)) as DECIMAL(38,4))
      )/count(*), --会员活跃率
      if(
          sum(if(payment_count>0,1,0)) = 0,
          null,
          cast(sum(if(payment_count>0,1,0)) as DECIMAL(38,4))
      )/count(*), --总会员付费率
      if(
          sum(if(login_date_first='2019-05-07',1,0)) = 0,
          null,
          cast(sum(if(login_date_first='2019-05-07',1,0)) as DECIMAL(38,4))
      )/sum(if(login_date_last='2019-05-07',1,0)) --会员新鲜度
  from yp_dm.dm_user;
  ```

## II. Presto数据导出

### 1. RPT层数据至MySQL

- 新零售数仓架构图

  > 从数仓架构图上，感受为什么最终需要把拼接的数据导出存储在mysql。
  >
  > 报表系统直接从hive数仓RPT层中读取数据使用可不可以？  可以但是没必要。

  ![image-20211207145330730](assets/image-20211207145330730.png)

- step1：presto配置连接MySQL

  - 配置mysql Connector

    > 在每台Presto服务的==etc/catalog==目录下，新建文件==mysql.properties==，内容如下

    ```properties
    vim /export/server/presto/etc/catalog/mysql.properties
    
    connector.name=mysql
    connection-url=jdbc:mysql://192.168.88.80:3306?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=utf8
    connection-user=root
    connection-password=123456
    ```

  - 重启presto集群

    > /export/server/presto/bin/launcher restart

  - Datagrip中验证是否可以连接MySQL

    > 在presto中根据自己的需要选择需要刷新的catalog、schema等。

    ![image-20211017150803387](assets/image-20211017150803387.png)

- step2：MySQL中建库

  > 在DataGrip中==选中mysql数据源==,按下F4，在控制台中输入以下sql

  ```sql
  -- 建库
  CREATE DATABASE yp_olap DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  ```

  ![image-20211017151233258](assets/image-20211017151233258.png)

- step3：使用==Presto在MySQL中建表==

  > 建表时使用Presto来操作，create语法和hive大体相同，只需要将hive中的string类型改为varchar。
  >
  > 另外文件格式、压缩格式这些mysql没有的配置去掉就可以了。
  >
  > 注意==presto不能直接删除mysql的表或数据==。

  - 详细sql语句参考课程脚本资料。

  ![image-20211017151441279](assets/image-20211017151441279.png)

- step4：使用Presto将数据导出到MySQL中

  - 语法格式

    ```sql
    insert into mysql.yp_olap.rpt_sale_store_cnt_month 
    select  * from hive.yp_rpt.rpt_sale_store_cnt_month;
    ```

  - 完整版sql可以参考课程资料

    ![image-20211017151915476](assets/image-20211017151915476.png)

## III. 自动化调度方案

### 1. 工作流调度与Oozie

- workflow工作流的概念

  - 工作流（Workflow），指“==业务过程的部分或整体在计算机应用环境下的自动化==”。
  - 工作流解决的主要问题是：为了实现某个业务目标，利用计算机软件在多个参与者之间按某种预定规则自动传递文档、信息或者任务。
  - 核心概念:==依赖执行== ==周期重复执行==
  - DAG（有向无环图）

  ![image-20211207153527233](assets/image-20211207153527233.png)

- Apache Oozie介绍

  - Oozie是一个用来管理 Hadoop生态圈job的工作流调度系统。由Cloudera公司贡献给Apache。

  ![image-20211207153604869](assets/image-20211207153604869.png)

  - ==oozie本身单独使用极其不方便，配置文件极其繁琐==，不管是使用shell命令提交工作流还是使用java API提交工作流，都需要编写大量繁琐的xml配置文件；
  - 但是==oozie和hue整合==之后使用还是非常不错的，在hue页面上提供了拖拽功能，直接选择想要调度的脚本或者其他任务，还可以根据自己的需求编写定时规则。

- ==**栗子 1**==：在Hue上使用oozie提交一个shell脚本执行

  - step1：打开hue页面

    http://hadoop02:8889/hue    用户名、密码：hue

  - step2：上传一个shell脚本或者使用hue在线编写一个shell脚本

    ![image-20211207154319705](assets/image-20211207154319705.png)

  - step3：配置oozie调度任务

    ![image-20211207154407666](assets/image-20211207154407666.png)

    ![image-20211207154520342](assets/image-20211207154520342.png)

    ![image-20211207154608753](assets/image-20211207154608753.png)

    ![image-20211207154631536](assets/image-20211207154631536.png)

    ![image-20211207154729854](assets/image-20211207154729854.png)

    ![image-20211207154756388](assets/image-20211207154756388.png)

![image-20211207154936254](assets/image-20211207154936254.png)

![image-20211207155141788](assets/image-20211207155141788.png)

![image-20211207155209422](assets/image-20211207155209422.png)

- ==**栗子2**==：针对栗子1的调度任务，配置周期定时执行coordinator。

  > 刚才配置的workflow属于一次性的工作流，执行完就结束了。
  >
  > 可以==配置coordinator来控制workflow的执行周期和触发频率==。

  ![image-20211207155342016](assets/image-20211207155342016.png)

  ![image-20211207155435961](assets/image-20211207155435961.png)

  ![image-20211207155503337](assets/image-20211207155503337.png)

  ![image-20211207155712125](assets/image-20211207155712125.png)

  ![image-20211207155851433](assets/image-20211207155851433.png)

  ![image-20211207155910176](assets/image-20211207155910176.png)

### 2. shell基本知识回顾

- date命令

  ```shell
  #获取今天的日期
  date
  date +%Y%m%d
  
  #获取指定日期的年月日格式输出
  date -d "2014-11-12" +%Y%m%d
  
  #获取指定日期的星期（周几）格式输出
  date --date="2014-11-23" +%w
  
  #获取上周日期（day,month,year,hour）
  date -d "-1 week" +%Y%m%d
  
  #获取昨天日期
  date -d '-1 day' "+%Y-%m-%d"
  date --date="-24 hour" +%Y%m%d
  ```

- 变量提取、反引号的功能

  ```shell
  name="allen"
  echo ${name}
  
  date
  nowTime=date
  echo ${nowTime}
  
  date
  nowTime=`date` 
  echo ${nowTime}
  ```

- 数字运算

  ```shell
  #双小括号命令是用来执行数学表达式的，可以在其中进行各种逻辑运算、数学运算，也支持更多的运算符（如++、--等）
  
  echo $(((5 * 2)))
  
  i=5
  echo $(((i=$i*2))) #10
  echo $(((i=i*2)))  #20
  
  # $((( )))的缩写。
  echo $(((i*2))) #40
  echo $((i*2)) #40
  ```

- 串行与并行

  ```shell
  #shell脚本默认是按顺序串行执行的，使用&可以将一个命令放在后台运行，从而使shell脚本能够继续往后执行
  
  sleep 5 &
  echo "done"
  
  sleep 5
  echo "done"
  
  #上面的脚本执行后会立即打印出"done"，sleep命令被扔给后台执行，不会阻塞脚本执行。
  
  #如果想要在进入下个循环前，必须等待上个后台命令执行完毕，可以使用wait命令
  sleep 5 &
  wait
  echo "done"
  
  #这样，需要等待5s后才能在屏幕上看到"done"。
  ```

- shell动态传参

  > $1   $2
  >
  > $0
  >
  > $#
  >
  > $*

  ```shell
  [root@hadoop02 ~]# vim 4.sh
  #!/bin/bash
  echo "$1"
  echo "$3"
  echo "$0"
  echo "$#"
  echo "$*"
  
  [root@hadoop02 ~]# sh 4.sh  11 22 33 44
  11
  33
  4.sh
  4
  11 22 33 44
  ```

### 3. 脚本实现, 调度实现

## IV. 数据报表可视化 Data Visualization

### 1. 数据报表/可视化



### 2. Java后端, Vue前端(了解)



### 3. FineBI(理解)