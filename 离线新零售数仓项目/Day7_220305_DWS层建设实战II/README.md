# DWS层建设实战I

## I. DWS层构建

### 1. 商品主题统计宽表的实现

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

