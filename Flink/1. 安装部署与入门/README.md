# Flink: 安装部署及入门案例

Apache Flink是一个框架和分布式处理引擎，用于对无界和有界数据流进行有状态计算。Flink设计为在所有常见的集群环境中运行，以内存速度和任何规模执行计算。

![](assets/1602831101602.png)

## 大数据分析引擎

> 梳理整个大数据课程，分为四大阶段，具体如下所示：

```ini
1）、HADOOP 离线阶段：
	基础课程（LINUX + ZOOKEEPER + HADOOP + HIVE）和项目课程（亿品新零售）
	
2）、SPARK 内存分析阶段：
	基础课程（PySpark）和项目课程（一站制造项目）
	
3）、大数据实时存储阶段：
	Flume、Redis、Kafka、HBase、
	
4）、FLINK 流式计算阶段：
	基础课程（FLINK：流计算及SQL&Table API）和项目课程
```

![1633392172368](assets/1633392172368.png)

> 大数据分析领域，数据分析类型：==离线批处理分析（Batch）==和==实时流计算分析（Streaming）==。

```ini
离线分析：
	批处理（Batch Processing）
实时分析：
	流计算（Stream Processing）
	

MapReduce和Spark                        Flink
    批处理                                 流处理（流计算）
        每次处理多条数据                        每次处理1条数据
        很多条数据一起处理                      1条1条数据处理

    批处理                                 流计算
        实时性没有太多要求                      实时性要求很高
        当处理数据时，才运行Task                没有开始处理数据之前，运行Task
        
```

## I. Flink框架概述

### 1. 官方定义

Apache Flink 官网：https://flink.apache.org/

> [Apache Flink 是一个开源的、基于流的、有状态的计算框架。它是分布式地执行的，具备低延迟、高吞吐的优秀性能，并且非常擅长处理有状态的复杂计算逻辑场景。]()

![](assets/1614734097803.png)

> 官方定义：==**Apache Flink is a framework and distributed processing engine for stateful computations over *unbounded and bounded* data streams.**==

- 1）、计算框架：类似MapReduce框架，分析数据

- 2）、分布式计算框架

  - 分析处理数据时，可以启动多个任务Task，同时并行处理
  - [分布式计算思想：分而治之，先分，后合]()

- 3）、建立在==数据流（DataStream）==之上状态计算框架

  - 处理的数据为`数据流（DataStream）`

  - 在Flink框架中，将所有数据认为是数据流DataStream

    ![](assets/bounded-unbounded.png)

    - 静态数据：==Bounded Data Stream==，**有界数据流**
    - 动态数据：==Unbounded Data Stream==，**无界数据流，流式数据**

  > [Flink 计算引擎，针对流数据进行处理，来一条数据处理一条数据，所以有界流和无界流。]()

- 4）、状态计算：`Stateful Computions`
  - Flink程序在处理数据时（流式计算，针对无界流数据处理），记录状态State信息
  - 比如以词频统计为例，记录每个单词词频；

![1644719616023](assets/1644719616023.png)

> Apache Flink 是 Apache 开源软件基金会的一个**顶级项目**，和许多 Apache 顶级项目一样，如 Spark 起源于 UC 伯克利的实验室， Flink 也是起源于非常有名的大学的实验室——**柏林工业大学实验室**。

![](assets/1629899621701.png)

> Flink 诞生于欧洲的一个大数据研究项目 `StratoSphere`。早期，Flink 是做 Batch 计算的，但是在 2014 年， StratoSphere 里面的核心成员孵化出 Flink，同年将 Flink 捐赠 Apache，并在后来成为 Apache 的顶级大数据项目，同时 Flink计算的主流方向被定位为 Streaming， 即**用流式计算来做所有大数据的计算**，这就是 Flink 技术诞生的背景。

[项目最初的名称为 Stratosphere，目标是要让大数据的处理看起来更加地简洁。]()

![](assets/1614735779720.png)

> 由于 Flink 项目吸引了非常多贡献者参与，活跃度等方面也都非常优秀，它**在 2014 年 12 月成为了 Apache 的顶级项目**。成为顶级项目之后，它在一个月之后发布了**第一个 Release 版本 Flink 0.8.0**。在此之后，Flink 基本保持 4 个月 1 个版本的节奏，发展到今天。

![](assets/1614736092102.png)

> 当阿里收购Flink母公司以后，大力推广Flink使用，以及将内部`Blink`框架功能与Apache Flink框架整合，陆续发布：Flink 1.9.0 版本，Flink 1.10.0（稳当），Flink 1.11.0，Flink `1.12.0`（里程碑版本）。

![1633525384745](assets/1633525384745.png)

> Flink 框架尤其在2019年和2020年发展比较迅速，版本迭代更加频繁，尤其2020年底发布`Flink 1.12`版本，**里程碑版本**，`流批一体化编程模式`，并且`Flink Table API和SQL成熟稳定`，可以用于实际生产环境。

![](assets/1614734865437.png)

> 当Flink框架出现，并且成熟以后，未来的数据分析处理：**实时处理分析**，Flink框架首选。

![](assets/1614734748662.png)

### 2. 流式计算思想

> [Flink 流式计算程序，来一条处理一条数据，真正流计算。]()

![1633525474698](assets/1633525474698.png)

> Flink 框架进行流式计算时，整个流程分为：[数据源Source、数据转换Transformation和数据接收器Sink]()。

```ini
第一步、从数据源获取数据时，将数据封装到数据流
	DataStream
	实际项目，都是从Kafka 消息队列中消费数据
	
第二步、数据处理时，调用DataStream方法
	DataStream#transformation
	类似RDD中转换算子，比如map、flatMap、filter等等

第三步、将分析数据输出到外部存储
	DataStream#sink
	类似RDD中触发/输出算子，比如foreach.....
```

> Flink应用程序进行**分布式**流式计算时，如何做到[并行计算]()，如下图所示：

![1633525569335](assets/1633525569335.png)

> 对于Flink框架来说，每个Job运行时，==在处理第一条数据之前，首先需要获取资源，运行Task任务，准备数据到达，当数据到达时，一个个数据处理==。

- Operator：`无论是从数据源Source加载数据，还是调用方法转换Transformation处理数据，到最后数据终端Sink输出，都称为Operator`，分为：`Source Operator、Transformation Operator和Sink Operator` 。
- `Stream`：数据从一个Operator流向另一个Operator； 

![](assets/1629901961306.png)

[每个Operator可以设置并行度（`Parallelism`），假设【Source】、【map()】及【keyBy()/window()/apply()】三个Operator并行度设置为2，【Sink】Operator并行的设置为1，形成如下示意图：]()

![](assets/1629901989018.png)

> Flink 流式计算引擎特点：

![1633397327645](assets/1633397327645.png)

### 3. 应用场景



## II. Flink安装部署

### 1. 运行架构



### 2. 本地集群



### 3. Standalone集群



### 4. Standalone HA



### 5. Flink on YARN

#### 5.1. 运行流程



#### 5.2. Session模式运行



#### 5.3. Per-Job模式



#### 5.4. Application模式运行



## III. Flink入门案例

### 1. 编程模型



### 2. WordCount(批处理)



### 3. WordCount(流计算)



### 4. 打包部署运行



## 附I. 流计算引擎的演进



## 附II. Flink框架技术栈



## 附III. Flink拓展阅读



## 附IV. Flink Standalone集群回顾



## 附V. Hadoop YARN回顾复习



## 附VI. Flink on YARN三种部署模式