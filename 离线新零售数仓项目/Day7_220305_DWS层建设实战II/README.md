# DWS层建设实战II

## I. DWS层构建

### 1. 商品主题统计宽表的实现

- 主题需求

  - 指标

    ```properties
    下单次数、下单件数、下单金额、被支付次数、被支付件数、被支付金额、被退款次数、被退款件数、被退款金额、被加入购物车次数、被加入购物车件数、被收藏次数、好评数、中评数、差评数
    
    --总共15个指标
    ```

  - 维度

    ```properties
    日期（day）+商品
    ```

- 本主题建表操作

  > 注意：建表操作需要在hive中执行，presto不支持hive的建表语法。

  ```sql
  create table yp_dws.dws_sku_daycount 
  (
      dt STRING,
      sku_id string comment 'sku_id',
      sku_name string comment '商品名称',
      order_count bigint comment '被下单次数',
      order_num bigint comment '被下单件数',
      order_amount decimal(38,2) comment '被下单金额',
      payment_count bigint  comment '被支付次数',
      payment_num bigint comment '被支付件数',
      payment_amount decimal(38,2) comment '被支付金额',
      refund_count bigint  comment '被退款次数',
      refund_num bigint comment '被退款件数',
      refund_amount  decimal(38,2) comment '被退款金额',
      cart_count bigint comment '被加入购物车次数',
      cart_num bigint comment '被加入购物车件数',
      favor_count bigint comment '被收藏次数',
      evaluation_good_count bigint comment '好评数',
      evaluation_mid_count bigint comment '中评数',
      evaluation_bad_count bigint comment '差评数'
  ) COMMENT '每日商品行为'
  --PARTITIONED BY(dt STRING)
  ROW format delimited fields terminated BY '\t'
  stored AS orc tblproperties ('orc.compress' = 'SNAPPY');
  
  ```

- 扩展知识：如何优雅的给变量起名字？

  > https://www.zhihu.com/question/21440067/answer/1277465532
  >
  > https://unbug.github.io/codelf/
  >
  > https://translate.google.cn/  

#### 1.1. 需求分析



#### 1.2. 下单, 支付, 退款统计



#### 1.3. 购物车, 收藏统计



#### 1.4. 好中差评



#### 1.5. Union all和full join合并的区别



#### 1.6. 完整SQL实现



### 2. 用户主题统计宽表的实现

#### 需求分析

## II. Hive优化 -- 索引

### 1. index索引问题



### 2. ORC文件格式的索引

#### 2.1. Row Group Index行组索引



#### 2.2. (Bloom Filter Index)布隆过滤器索引



### Hive相关配置参数

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
--分桶
set hive.enforce.bucketing=true;
set hive.enforce.sorting=true;
set hive.optimize.bucketmapjoin = true;
set hive.auto.convert.sortmerge.join=true;
set hive.auto.convert.sortmerge.join.noconditionaltask=true;
--并行执行
set hive.exec.parallel=true;
set hive.exec.parallel.thread.number=8;
--小文件合并
-- set mapred.max.split.size=2147483648;
-- set mapred.min.split.size.per.node=1000000000;
-- set mapred.min.split.size.per.rack=1000000000;
--矢量化查询
set hive.vectorized.execution.enabled=true;
--关联优化器
set hive.optimize.correlation=true;
--读取零拷贝
set hive.exec.orc.zerocopy=true;
--join数据倾斜
set hive.optimize.skewjoin=true;
-- set hive.skewjoin.key=100000;
set hive.optimize.skewjoin.compiletime=true;
set hive.optimize.union.remove=true;
-- group倾斜
set hive.groupby.skewindata=false;
```

