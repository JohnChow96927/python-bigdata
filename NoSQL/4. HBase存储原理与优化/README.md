# HBase存储原理与优化

## I. HBase存储原理

### 1. Table、Region、RS

> **问题**：客户端操作的是表，数据最终存在RegionServer中，表和RegionServer的关系是什么？

- **Table：是一个逻辑对象**，物理上不存在，供用户实现逻辑操作，存储在元数据的一个概念

  - 数据写入表以后的物理存储：分区Region

  2. 一张表会有多个分区Region，每个分区存储在不同的机器上
  3. 默认每张表只有1个Region分区

- **Region：Hbase中数据`负载均衡`的最小单元**

  - 类似于HDFS中Block,用于实现Hbase中分布式

- 就是分区的概念，每张表都可以划分为多个Region，实现分布式存储，默认一张表只有一个分区

  3. 每个Region由一台RegionServer所管理，Region存储在RegionServer
  4. 一台RegionServer可以管理多个Region

  ![image-20210524171757479](assets/image-20210524171757479.png)

- **RegionServer：是一个物理对象**，Hbase中的一个进程，管理一台机器的存储

  - 类似于HDFS中DataNode或者Kafka中的Broker

- 一个Regionserver可以管理多个Region

  - 一个Region只能被一个RegionServer所管理

  ![1636214450123](assets/1636214450123.png)

> 创建表后，打开HBase WEB UI页面，查看表的分区Region信息

![image-20210525114439044](assets/image-20210525114439044.png)

![image-20210525114753868](assets/image-20210525114753868.png)

```ini
# t1,,1636172386242.9acd323bdbd17d77edda298c2dfaf32f.
    表的名称：
        t1
  Region管理数据起始RowKey
        如果是表的第1个Region，值为空
    时间戳
        Long类型数值，表示的是Region被RS管理时间（上线online时间）
    Region唯一标识符
        字符串，随机生成的
```

> 总结：HBase中Table与Region、RegionServer三者之间的关系是什么？

```ini
# Table：提供用户读写的逻辑概念
 
# Region：分区的概念
	一张表可以划分为多个分区
	每个分区都被某一台Regionserver所管理
 
# RegionServer：真正存储数据的物理概念
```

![image-20210524171650278](assets/image-20210524171650278.png)

### 2. Region划分规则

> **问题**：一张表划分为多个Region，划分的规则是什么？写一条数据到表中，这条数据会写入哪个Region，分配规则是什么？

- **回顾HDFS和Redis划分规则**

  ```ini
  # 1. HDFS：划分分区的规则，按照大小划分
  	文件按照每128M划分一个Block
  	
  # 2. Redis：将0 ~ 16383划分成多个段，每个小的集群分配一个段的内容
  	CRC16（K） & 16383
  ```

- **HBase分区划分规则**：**范围划分【根据Rowkey范围】**

  ```ini
  # 1. 任何一个Region都会对应一个范围
    	如果只有一个Region，范围：-oo  ~  +oo
  	
  # 2. 范围划分：从整个-oo ~  +oo区间上进行范围划分
  
  #3. 每个分区都会有一个范围：根据Rowkey属于哪个范围就写入哪个分区
  	[startKey,stopKey)	 -> 前闭后开区间
  	
  默认：一张表创建时，只有一个Region，范围：-oo  ~ +oo
  ```

![image-20210926112849026](assets/image-20210926112849026.png)

- 自定义：创建表时，指定有多少个分区，每个分区的范围

  ```ini
  创建一张表，有2个分区Region
  	create 't3', 'f1', SPLITS => ['50']
  分区范围
    	region0：-oo ~  50
    	region1：50  ~ +oo
  ```

- 数据分配的规则：**==根据Rowkey属于哪个范围就写入哪个分区==**

```ini
# 举个栗子：创建一张表，有4个分区Region，20,40,60
  	create 'itcast:t3', {SPLITS => [20, 40, 60]}
  	
# 规则：前闭后开
	region0：-oo ~ 20
	region1：20   ~ 40
	region2：40   ~ 60
	region3：60  ~ +oo

# 写入数据的rowkey：
	# 比较是按照ASCII码比较的，不是数值比较
	# 比较规则：ASCII码逐位比较
    A1234：region3
    c6789：region3
    00000001：region0
    2：region0
    99999999：region3
	
```

> 创建表后，打开HBase WEB UI页面，查看表的分区Region信息

```ini
# 1. 默认只有1个分区

# 2. 注意：随着数据越来越多，达到阈值，这个分区会自动分裂为两个分裂
```

![image-20210525120031461](assets/image-20210525120031461.png)

```ini
# 3. 手动创建多个分区
create 'itcast:t3','cf',SPLITS => ['20', '40', '60', '80']
```

![image-20210525120214465](assets/image-20210525120214465.png)

```ini
# 4. 写入数据
put 'itcast:t3','0300000','cf:name','laoda'
put 'itcast:t3','7890000','cf:name','laoer'
```

![image-20210525120338729](assets/image-20210525120338729.png)

### 3. Region内部结构

> **问题**：数据在Region的内部是如何存储的？

```ini
put tbname, rowkey, cf:col, value

# tbname：决定了这张表的数据最终要读写哪些分区
# rowkey：决定了具体读写哪个分区
# cf：决定具体写入哪个Store
```

- Region：对整张表的数据划分，按照范围划分，实现分布式存储     

![](assets/image-20210524171934125.png)

```ini
# Store：
    对分区的数据进行划分，按照列族划分，一个列族对应一个Store
    不同列族的数据写入不同的Store中，实现了按照列族将列进行分组
    根据用户查询时指定的列族，可以快速的读取对应的store

# MemStore：
    每个Store都有一个: 内存存储区域
    数据写入memstore就直接返回

# StoreFile：
    每个Store中可能有0个或者多个StoreFile文件
    逻辑上：Store
    物理上：HDFS，HFILE【二进制文件】
```

> **问题：Hbase的数据在HDFS中是如何存储的？**

- 整个Hbase在HDFS中的存储目录

  ```properties
  hbase.rootdir=hdfs://node1.itcast.cn:8020/hbase
  ```

  ![image-20210625154845286](assets/image-20210625154845286.png)

  - NameSpace：目录结构

![image-20210625154914849](assets/image-20210625154914849.png)

- Table：目录结构

  ![image-20210625154949303](assets/image-20210625154949303.png)

- Region：目录结构

  ![image-20210625155037410](assets/image-20210625155037410.png)

- Store/ColumnFamily：目录结构

  ![image-20210625155222749](assets/image-20210625155222749.png)

- StoreFile

  ![image-20210625155242858](assets/image-20210625155242858.png)

  - 如果HDFS上没有storefile文件，可以通过flush，手动将表中的数据从内存刷写到HDFS中

    ```
    flush 'itcast:t3'    
    ```

> Region的内部存储结构是什么样的？

```ini
# 1. NS:Table|RegionServer：整个Hbase数据划分

# 2. Region：划分表的数据，按照Rowkey范围划分
      - Store：划分分区数据，按照列族划分
        - MemStore：物理内存存储
        - StoreFile：物理磁盘存储
          - 逻辑：Store
          - 物理：HDFS[HFile]
```

![1651416286339](assets/1651416286339.png)

### 4. Store内部原理: MemStore Flush

> Hbase利用Flush实现**将内存数据溢写到HDFS**，保持内存中不断存储最新的数据。

![1651446902140](assets/1651446902140.png)

- **将内存memstore中的数据溢写到HDFS中变成磁盘文件storefile【HFILE】**
  - 关闭集群：自动Flush
  - 参数配置：自动触发机制

- 自动触发机制：HBase 2.0之前参数

  ```properties
  #region的memstore的触发
  #判断如果某个region中的某个memstore达到这个阈值，那么触发flush，flush这个region的所有memstore
  hbase.hregion.memstore.flush.size=128M
  
  #region的触发级别：如果没有memstore达到128，但是所有memstore的大小加在一起大于等于128*4
  #触发整个region的flush
  hbase.hregion.memstore.block.multiplier=4
  
  #regionserver的触发级别：所有region所占用的memstore达到阈值，就会触发整个regionserver中memstore的溢写
  #从memstore占用最多的Regin开始flush
  hbase.regionserver.global.memstore.size=0.4 --RegionServer中Memstore的总大小
  
  #低于水位后停止
  hbase.regionserver.global.memstore.size.upper.limit=0.99
  hbase.regionserver.global.memstore.size.lower.limit = 0.4*0.95 =0.38
  ```

- 自动触发机制：HBase 2.0之后

  ```properties
  #设置了一个flush的最小阈值
  #memstore的判断发生了改变：max("hbase.hregion.memstore.flush.size / column_family_number",hbase.hregion.percolumnfamilyflush.size.lower.bound.min)
  #如果memstore高于上面这个结果，就会被flush，如果低于这个值，就不flush，如果整个region所有的memstore都低于，全部flush
  #水位线 = max（128 / 列族个数,16）,列族一般给3个 ~ 42M
  #如果memstore的空间大于42,就flush，如果小于就不flush；如果都小于，全部flush
  
  举例：3个列族，3个memstore,90/30/30   90会被Flush
  
  举例：3个列族，3个memstore,30/30/30   全部flush
  
  hbase.hregion.percolumnfamilyflush.size.lower.bound.min=16M
  ```

  ```ini
  # 2.x中多了一种机制：In-Memory-compact,如果开启了【不为none】，会在内存中对需要flush的数据进行合并
  #合并后再进行flush，将多个小文件在内存中合并后再flush
    hbase.hregion.compacting.memstore.type=None|basic|eager|adaptive
  ```

> **注意**：工作中一般进行手动Flush

- 原因：避免大量的Memstore将大量的数据同时Flush到HDFS上，占用大量的内存和磁盘的IO带宽，会影响业务

- 解决：手动触发，定期执行

  ```shell
  hbase> flush 'TABLENAME'
  hbase> flush 'REGIONNAME'
  hbase> flush 'ENCODED_REGIONNAME'
  hbase> flush 'REGION_SERVER_NAME'
  ```

- 封装一个文件，通过`hbase shell filepath`来定期的运行这个脚本