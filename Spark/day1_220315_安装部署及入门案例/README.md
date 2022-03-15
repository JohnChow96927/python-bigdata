# PySpark安装部署及入门案例

## 大数据技术框架

> 整个大数据技术框架学习，可以划分为4个阶段：==离线分析、内存分析、实时存储和实时分析。==

![1632034215148](assets/1632034215148.png)

```ini
# 第1部分、离线分析（Batch Processing）
	分布式协作服务框架Zookeeper
	大数据基础框架Hadoop（HDFS、MapReduce和YARN）
	大数据数仓框架Hive
	大数据辅助框架：FLUME、SQOOP、Oozie和Hue

# 第2部分、内存分析（In-Memory Processing）
	Apache Spark（Environment环境、Core、SQL等），属于批处理，相比MapReduce快
	将分析数据封装到数据结构：RDD（分布式集合），类似Python中列表list，调用函数处理数据

# 第3部分、实时存储
	基于Key-Value内存数据Redis
	大数据NoSQL海量数据库HBase
	分布式消息队列Kafka
	
# 第4部分、实时计算
	Apache Flink（实时流式计算框架，天猫双十一实时大屏）：Environment、DataStream和Table API & SQL
		数据流封装DataStream，调用函数处理
		Table API和SQL批处理和流计算
```

## 集中式计算和分布式计算

> ​	对于数据的计算形式可以多种多样，如果从数据处理的历史进程来划分，可以分为：**大数据时代之前的集中式数据计算**和**大数据时代的分布式数据计算**。

![](assets/v2-c732dee1a13a520463f2926803e40c85_1440w-1641901526259.jpg)

​																		[数据计算定义：将特定数据集处理成业务需要的样子。]()

> 1、集中式计算：在大数据时代之前的数据计算，可以称之为集中式计算，所谓集中式，意思就是**单个进程内部或者单机内部对数据进行计算**。

![1641901717471](assets/1641901717471.png)



- 最大的瓶颈是**只能利用单台服务器的资源**，因此其计算规模很容易达到极限。

> 2、分布式计算：**针对一类数据进行计算过程中，将共性部分进行抽象形成的软件框架叫做计算引擎**。

- MapReduce 作为大数据时代分布式计算的开山鼻祖，具有划时代意义，**最核心的思想就是：分而治之**。
- 原来一台机器搞不定，那就多台机器一起帮忙，**每台机器计算一部分，然后将每台机器计算的结果再传到其中的一台或者几台机器进行汇总，最终得出计算结果**。
- 对于大数据时代而言，其**数据计算的共性部分就是map跟reduce**。注意，这里的map跟reduce是广义的。

![preview](assets/v2-496101d5459108cfa3d14efc62976125_r-1641901814662.jpg)

## Spark框架概述

### Spark发展及概念

​			Apache  Spark是一个开源的类似于Hadoop MapReduce的==通用的并行计算框架==，Spark基于map reduce算法实现的分布式计算，拥有Hadoop MapReduce所具有的优点；**但不同于MapReduce的**是Spark中的Job中间输出和结果**可以保存在内存中**，从而不再需要频繁读写磁盘，因此Spark能更好地适用于数据挖掘与机器学习等需要迭代的map reduce的算法。

![1632036270601](assets/1632036270601.png)

- 2009年Spark诞生于伯克利AMPLab，伯克利大学的研究性项目
- 2010年通过BSD 许可协议正式对外开源发布
- 2012年Spark第一篇论文发布，第一个正式版（Spark 0.6.0）发布
- 2013年Databricks公司成立并将Spark捐献给Apache软件基金会
- 2014年2月成为Apache顶级项目，同年5月发布Spark 1.0正式版本
- 2015年引入DataFrame大数据分析的设计概念
- 2016年引入DataSet更强大的数据分析设计概念并正式发布Spark2.0
- 2017年Structured streaming 发布，统一化实时与离线分布式计算平台
- 2018年Spark2.4.0发布，成为全球最大的开源项目
- 2019年11月Spark官方发布3.0预览版
- 2020年6月Spark发布3.0.0正式版

​	Aapche Spark 是一种快速、通用、可扩展的**大数据分析引擎**，2009 年诞生于加州大学伯克利分校 AMPLab，2010 年开源， 2013年6月成为Apache孵化项目，2014年2月成为 Apache 顶级项目，`用 Scala进行编写项目框架`。

![1632036659980](assets/1632036659980.png)

​	从世界著名的开发者论坛，Stack Overflow的数据可以看出，2015年开始Spark每月的问题提交数量已经超越Hadoop，而2018年Spark Python版本的API PySpark每月的问题提交数量也已超过Hadoop。2019年排名Spark第一，PySpark第二；而十年的累计排名是Spark第一，PySpark第三。按照这个趋势发展下去，**Spark和PySpark在未来很长一段时间内应该还会处于垄断地位。**

![1632036345336](assets/1632036345336.png)

> Apache Spark是用于**大规模数据（large-scala data）**处理的**统一（unified）**分析引擎。

![1634652202045](assets/1634652202045.png)

- 1、Apache Spark 官网：http://spark.apache.org/
- 2、Databricks 官网：https://databricks.com/spark/about

![1632036755656](assets/1632036755656.png)

```ini
Aapche Spark 是一种快速、通用、可扩展的大数据分析引擎，基于内存分析数据，可以处理任何类型业务分析。

# 1、分析引擎（计算引擎）
	分析处理数据，类似MapReduce框架(分布式处理框架，分而治之思想)
# 2、大规模数据
	海量数据，数据很多，多数据源（存储在任何地方数据）
# 3、统一的分析引擎
	离线分析
	实时计算
	机器学习
	图形计算
	科学计算
# 4、分布式并行计算
	分而治之思想，与MapReduce计算思想完全一致
```

> Spark具有**运行速度快、易用性好、通用性强和随处运行**等特点。http://spark.apache.org/

![1638430946793](assets/1638430946793.png)

- **Batch/Streaming data**：统一化离线计算和实时计算开发方式，支持多种开发语言
- **SQL analytics**：通用的SQL分析快速构建分析报表，运行速度快于大多数数仓计算引擎
- **Data science at scale**：大规模的数据科学引擎，支持PB级别的数据进行探索性数据分析
- **Machine learning**：支持在笔记本电脑上训练机器学习算法，并使用相同的代码扩展到数千台机器的集群

> Spark编程支持5种语言：`Java、Scala、Python、R及SQL`，满足各种分析需求，目前Python语言全球最多

![1634682118832](assets/1634682118832.png)

> Spark框架中，最核心要点：抽象，称为`RDD`，相当于集合，比如列表List，存储数据

![1632105293517](assets/1632105293517.png)



> Spark程序无处不在运行【`Runs Everywhere`】

- 1、数据存储

  [Spark分析的数据在哪里？任何地方都是可以，最主要还是HDFS、Hive、HBase、Kafka等等]()

  ![Spark - Apache Spark](assets/largest-open-source-apache-spark.png)

  

- 2、程序运行

  **Spark 编程代码，在何处执行，分析数据？？**

  [本地模式、集群模式【Hadoop `YARN`、Mesos、Standalone】、`容器（K8s）`]()

  ![1632037265093](assets/1632037265093.png)

### ★Spark vs MapReduce



### Spark框架模块



### ★Spark应用组成



### Spark运行模式

## Spark快速入门

### ★Anaconda软件安装



### ★Spark Python Shell



### 词频统计WordCount



### 运行圆周率PI



## Standalone集群

### 架构及安装部署



### 服务启动及测试



### ★应用运行架构



### 高可用HA