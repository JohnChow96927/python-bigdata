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

> Apache Flink在阿里巴巴主要应用场景如下四类：[实时数仓、实时监控、实时报表、流数据分析	]()

![](assets/1614737695168.png)

> 官方提出三个方面，Flink框架应用场景：

![1633399009714](assets/1633399009714.png)

- 1）、事件驱动型应用：`Event-driven Applications`

[事件驱动表示一个事件会触发另一个或者很多个后续的事件，然后这一系列事件会形成一些信息，基于这些信息需要做一定的处理。]()

![](assets/1629903243124.png)

```
1、在社交场景下，以【微博】为例，当点击了一个关注之后，被关注人的粉丝数就会发生变化。之后如果被关注的人发了一条微博，关注他的粉丝也会收到消息通知，这是一个典型的事件驱动。

2、在网购的场景底下，如用户给商品做评价，这些评价一方面会影响店铺的星级，另外一方面有恶意差评的检测。此外，用户通过点击信息流，也可看到商品派送或其他状态，这些都可能触发后续的一系列事件。

3、金融反欺诈的场景，诈骗者通过短信诈骗，然后在取款机窃取别人的钱财。在这种场景底下，我们通过摄像头拍摄后，迅速反应识别出来，然后对犯罪的行为进  行相应的处理，一个典型的事件驱动型应用。
```

> **总结一下**，事件驱动型应用是一类具有**状态的应用**，会根据事件流中的事件触发计算、更新状态或进行外部系统操作。事件驱动型应用常见于实时计算业务中，比如：**实时推荐，金融反欺诈，实时规则预警**等。

- 2）、数据分析型应用：`Data Analytics Applications`

![](assets/1629903504528.png)

```
如双 11 成交额实时汇总，包括PV、UV 的统计；包括上方图中所示，是 Apache 开源软件在全世界不同地区的一个下载量，其实也是一个信息的汇总。
```

![](assets/1629903674802.png)

如上图所示，以双 11 为例，在 2020 年天猫双 11 购物节，阿里基于 Flink 的实时计算平台每秒处理的消息数达到了 40 亿条，数据体量达到 7TB，订单创建数达到 58 万/秒，计算规模也超过了 150 万核。

> 可以看到，这些应用的场景体量很大且对于实时性要求非常高 ，这也 是Apache Flink 非常擅长的场景。

- 3）、数据管道型应用 (ETL)，`Data Pipeline Applications`

> ETL（Extract-Transform-Load）是从数据源抽取/转换/加载/数据至目的端的过程。

![](assets/1629903804060.png)

- 传统的 ETL 使用离线处理，经常做的是小时级别或者天级别的 ETL。
- 但是，随着大数据处理呈现实时化趋势，也会有实时数仓的需求，要求在分钟级或者秒级就能够对数据进行更新，从而进行及时的查询，能够看到实时的指标，然后做更实时的判断和分析。

![1633489044621](assets/1633489044621.png)

> 在以上场景底下，Flink 能够最大限度地满足实时化的需求。

![](assets/1629903836486.png)

## II. Flink安装部署

### 1. 运行架构

> Flink Runtime运行时架构组成：==**JobManager（主节点**）和**TaskManager`s`（从节点）**==。

https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/concepts/flink-architecture/

![1633412578726](assets/1633412578726.png)

- 1）、==**JobManager**==：主节点Master，为每个Flink Job分配资源，管理和监控Job运行。
  - 主要负责调度 Flink Job 并协调 Task 做 checkpoint；
  - 从 Client 处接收到 Job 和JAR 包等资源后，会生成优化后的执行计划，并以 Task 为单元调度到各个 TaskManager去执行；

- 2）、==**TaskManager**==：从节点Workers，调度每个Job中Task任务执行，及负责Task监控和容错等。
  - 在启动的时候设置：`Slot 槽位数（资源槽）`，每个 slot 能启动 Task，其中Task 为线程。

![1633525750169](assets/1633525750169.png)

> ==**Flink Client**==：提交应用程序，给主节点JobManager
>
> - Client 为提交 Job 的客户端，可以是运行在任何机器上（与 JobManager 环境连通即可）。

![1633412935980](assets/1633412935980.png)

> Flink支持多种安装运行模式，可以将Flink程序运行在很多地方：

![1648421643678](assets/1648421643678.png)

- 第一、`Local 模式`

  [在Windows系统上IDEA集成开发环境编写Flink 代码程序，直接运行测试即为本地测试]()

  - 适用于本地开发和测试环境，占用的资源较少，部署简单
  - 本地模式LocalMode：JobManager和TaskManager运行在==同一个JVM进程==中

  ![1633414183605](assets/1633414183605.png)

- 第二、`Standalone 模式`

  [将JobManager和TaskManagers直接运行机器上，称为Standalone集群，Flink框架自己集群]()

  - 可以在测试环境功能验证完毕到版本发布的时候使用，进行性能验证

    https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/deployment/resource-providers/standalone/overview/

  - 高可用HA：Standalone Cluster HA

    https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/deployment/ha/zookeeper_ha/

- 第三、`Flink On Yarn 模式`

  [将JobManager和TaskManagers运行在NodeManage的Container容器中，称为Flink on YARN。]()

  - Flink使用YARN进行调度

    https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/deployment/resource-providers/yarn/

- 第四、`K8s 模式`

  [将JobManager和TaskManagers运行在Docker或K8s容器Container中。]()

  - 由于Flink使用的无状态模式，只需要kubernetes提供计算资源即可。会是Flink以后运行的主流方式，可以起到节约硬件资源和便于管理的效果。

    https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/deployment/resource-providers/native_kubernetes/

```ini
# Apache Flink 框架软件下载：
	https://flink.apache.org/downloads.html
	https://archive.apache.org/dist/flink/
	
# Aapche Flink 官方文档：
	https://ci.apache.org/projects/flink/flink-docs-release-1.13/
```

### 2. 本地集群

==Local Cluster 本地集群==：**将不同进程运行在同一台机器上，只有一台机器**。

> [针对Flink框架来说，进程分别为`JobManager`（主节点，管理者）和`TaskManager`（从节点，干活着）]()

![](assets/1614741619007.png)

> 提交Flink Job运行原理如下：

![](assets/1614741637978.png)

1. Flink程序（比如jar包）由`JobClient`进行提交；
2. JobClient将作业提交给`JobManager`；
3. JobManager负责**协调资源分配和作业执行**。资源分配完成后，任务将提交给相应的`TaskManager`；
4. TaskManager**启动一个线程以开始执行**。TaskManager会向JobManager报告状态更改，如开始执行，正在进行或已完成；
5. 作业执行完成后，结果将发送回客户端(JobClient)；

> 1）、上传软件及解压

```ini
[root@node1 ~]# cd /export/software/
[root@node1 software]# rz
	上传软件包：flink-1.13.1-bin-scala_2.11.tgz

[root@node1 software]# chmod u+x flink-1.13.1-bin-scala_2.11.tgz
[root@node1 software]# tar -zxf flink-1.13.1-bin-scala_2.11.tgz -C /export/server/	

[root@node1 ~]# cd /export/server/
[root@node1 server]# chown -R root:root flink-1.13.1
[root@node1 server]# mv flink-1.13.1 flink-local
```

[当将Flink软件压缩包解压以后，`默认配置，就是本地集群配置，可以直接启动服务即可`]()

```ini
# 目录结构
[root@node1 server]# cd flink-local/
[root@node1 flink-local]# ll
total 480
drwxrwxr-x  2 root root   4096 May 25 20:36 bin
drwxrwxr-x  2 root root    263 May 25 20:36 conf
drwxrwxr-x  7 root root     76 May 25 20:36 examples
drwxrwxr-x  2 root root   4096 May 25 20:36 lib
-rw-r--r--  1 root root  11357 Oct 29  2019 LICENSE
drwxrwxr-x  2 root root   4096 May 25 20:37 licenses
drwxr-xr-x  2 root root      6 Oct  5 10:25 log
-rw-rw-r--  1 root root 455180 May 25 20:37 NOTICE
drwxrwxr-x  3 root root   4096 May 25 20:36 opt
drwxrwxr-x 10 root root    210 May 25 20:36 plugins
-rw-r--r--  1 root root   1309 Jan 30  2021 README.txt
```

> 2）、启动Flink本地集群

```ini
[root@node1 ~]# cd /export/server/flink-local/

[root@node1 flink-local]# bin/start-cluster.sh

[root@node1 flink-local]# jps
3504 TaskManagerRunner
3239 StandaloneSessionClusterEntrypoint
3559 Jps
```

> 3）、访问Flink的Web UI：http://node1.itcast.cn:8081/#/overview

![1633419163511](assets/1633419163511.png)

> `slot`在Flink里面可以认为是资源组，Flink是通过将==任务（Task）分成子任务（SubTask）==并且将这些子任务分配到==slot==来并行执行程序。

![](assets/1628910791520.png)

[Slot 封装Task运行资源，可以认为Contanier容器，]()==同一个Slot资源槽中可以运行不同类型SubTask，相当于“猪槽，可以被多个PIG吃食。”==

> 4）、测试完成以后，关闭本地集群

```ini
 [root@node1 ~]# /export/server/flink-local/bin/stop-cluster.sh 
```

当本地集群启动以后，运行Flink应用程序，分别运行**流计算和批处理 词频统计**。

> 通过`flink` 脚本命令提交运行jar包程序，具体命令使用说明如下：

```ini
[root@node1 ~]# cd /export/server/flink-local/
[root@node1 flink-local]# bin/flink run --help

Action "run" compiles and runs a program.

  Syntax: run [OPTIONS] <jar-file> <arguments>
  "run" action options:
     -c,--class <classname>               Class with the program entry point
                                          ("main()" method). Only needed if the
                                          JAR file does not specify the class in
                                          its manifest.
     -C,--classpath <url>                 Adds a URL to each user code
                                          classloader  on all nodes in the
                                          cluster. The paths must specify a
                                          protocol (e.g. file://) and be
                                          accessible on all nodes (e.g. by means
                                          of a NFS share). You can use this
                                          option multiple times for specifying
                                          more than one URL. The protocol must
                                          be supported by the {@link
                                          java.net.URLClassLoader}.
     -d,--detached                        If present, runs the job in detached
                                          mode
     -p,--parallelism <parallelism>       The parallelism with which to run the
                                          program. Optional flag to override the
                                          default value specified in the
                                          configuration.

  Options for Generic CLI mode:
     -D <property=value>   Allows specifying multiple generic configuration
                           options. The available options can be found at
                           https://ci.apache.org/projects/flink/flink-docs-stabl
                           e/ops/config.html
     -t,--target <arg>     The deployment target for the given application,
                           which is equivalent to the "execution.target" config
                           option. For the "run" action the currently available
                           targets are: "remote", "local", "kubernetes-session",
                           "yarn-per-job", "yarn-session". For the
                           "run-application" action the currently available
                           targets are: "kubernetes-application".

  Options for yarn-cluster mode:
     -m,--jobmanager <arg>            Set to yarn-cluster to use YARN execution
                                      mode.
     -yid,--yarnapplicationId <arg>   Attach to running YARN session
     -z,--zookeeperNamespace <arg>    Namespace to create the Zookeeper
                                      sub-paths for high availability mode

  Options for default mode:
     -D <property=value>             Allows specifying multiple generic
                                     configuration options. The available
                                     options can be found at
                                     https://ci.apache.org/projects/flink/flink-
                                     docs-stable/ops/config.html
     -m,--jobmanager <arg>           Address of the JobManager to which to
                                     connect. Use this flag to connect to a
                                     different JobManager than the one specified
                                     in the configuration. Attention: This
                                     option is respected only if the
                                     high-availability configuration is NONE.
     -z,--zookeeperNamespace <arg>   Namespace to create the Zookeeper sub-paths
                                     for high availability mode
```

> 1）、流计算：WordCount词频统计，[运行流式计算程序，从TCP Socket 读取数据，进行词频统计。]()

![1633419832998](assets/1633419832998.png)

```ini
# 开启1个终端
nc -lk 9999

# 上传jar【StreamWordCount.jar】包至/export/server/flink-local目录
cd /export/server/flink-local
rz

# 再开启1个终端，运行流式应用
/export/server/flink-local/bin/flink run \
--class cn.itcast.flink.StreamWordCount \
/export/server/flink-local/StreamWordCount.jar \
--host node1.itcast.cn --port 9999
```

![1633420098242](assets/1633420098242.png)

> 2）、监控页面查看日志信息数据

![1633420117287](assets/1633420117287.png)

![1633420180093](assets/1633420180093.png)

> 查看TaskManager日志，每条数据处理结果：

![1633420246834](assets/1633420246834.png)

执行官方示例Example，**读取文本文件数据，进行词频统计WordCount，将结果打印控制台或文件**。

![1633420700445](assets/1633420700445.png)

> 1）准备文件`/root/words.txt`

```ini
[root@node1 ~]# vim /root/words.txt
添加数据
spark python spark hive spark hive
python spark hive spark python
mapreduce spark hadoop hdfs hadoop spark
hive mapreduce
```

> 2）批处理，执行如下命令

```ini
# 指定处理数据文件，通过参数 --input 传递
/export/server/flink-local/bin/flink run \
/export/server/flink-local/examples/batch/WordCount.jar --input /root/words.txt
```

![1633420505322](assets/1633420505322.png)

```ini
# 指定处理数据文件和输出数据目录，分别通过--input 和 --output 传递参数值
/export/server/flink-local/bin/flink run \
/export/server/flink-local/examples/batch/WordCount.jar \
--input /root/words.txt \
--output /root/out.txt
```

![1633420612315](assets/1633420612315.png)

### 3. Standalone集群

> **Flink Standalone集群**，类似Hadoop YARN集群，==管理集群资源和分配资源给Flink Job运行任务Task==。

![1644670949884](assets/1644670949884.png)

1. Client客户端提交任务给JobManager；
2. JobManager负责申请任务运行所需要的资源并管理任务和资源；
3. JobManager分发任务给TaskManager执行；
4. TaskManager定期向JobManager汇报状态；

> 0）、集群规划：

![](assets/1614743548233.png)

> 1）、上传软件及解压

```ini
[root@node1 ~]# cd /export/software/
[root@node1 software]# rz
	上传软件包：flink-1.13.1-bin-scala_2.11.tgz
	
[root@node1 software]# chmod u+x flink-1.13.1-bin-scala_2.11.tgz
[root@node1 software]# tar -zxf flink-1.13.1-bin-scala_2.11.tgz -C /export/server/	

[root@node1 ~]# cd /export/server/
[root@node1 server]# chown -R root:root flink-1.13.1
[root@node1 server]# mv flink-1.13.1 flink-standalone
```

> 2）、修改`flink-conf.yaml`

```ini
vim /export/server/flink-standalone/conf/flink-conf.yaml
修改内容：33行内容
	jobmanager.rpc.address: node1.itcast.cn
```

> 3）、修改`masters`

```ini
vim /export/server/ flink-standalone/conf/masters
修改内容：	
	node1.itcast.cn:8081
```

> 4）、修改`workers`

```ini
vim /export/server/ flink-standalone/conf/workers
修改内容：	
    node1.itcast.cn
    node2.itcast.cn
    node3.itcast.cn
```

> 5）、添加`HADOOP_CONF_DIR`环境变量(**集群所有机器**）

```ini
vim /etc/profile
	添加内容：
	export HADOOP_CONF_DIR=/export/server/hadoop/etc/hadoop
# 执行生效
source /etc/profile
```

> 6）、将Flink依赖Hadoop 框架JAR包上传至`/export/server/flink-standalone/lib`目录

![1633421482610](assets/1633421482610.png)

```ini
[root@node1 ~]# cd /export/server/flink-standalone/lib/

[root@node1 lib]# rz
	commons-cli-1.4.jar
	flink-shaded-hadoop-3-uber-3.1.1.7.2.1.0-327-9.0.jar
```

> 7）、分发到集群其他机器

```ini
scp -r /export/server/flink-standalone root@node2.itcast.cn:/export/server
scp -r /export/server/flink-standalone root@node3.itcast.cn:/export/server
```

接下来，启动服务进程，运行批处理程序：词频统计WordCount。

> 1）、启动HDFS集群，在`node1.itcast.cn`上执行如下命令

```ini
# NameNode 主节点
hadoop-daemon.sh start namenode

# 所有DataNodes从节点
hadoop-daemons.sh start datanode
```

> 2）、启动集群，执行如下命令

```ini
# 一键启动所有服务JobManager和TaskManagers
[root@node1 ~]# /export/server/flink-standalone/bin/start-cluster.sh 
Starting cluster.
Starting standalonesession daemon on host node1.itcast.cn.
Starting taskexecutor daemon on host node1.itcast.cn.
Starting taskexecutor daemon on host node2.itcast.cn.
Starting taskexecutor daemon on host node3.itcast.cn.
```

![1633421994734](assets/1633421994734.png)

> 3）、访问Flink UI界面：http://node1.itcast.cn:8081/#/overview

![1633422040826](assets/1633422040826.png)

![1633422420531](assets/1633422420531.png)

> 4）、执行官方测试案例

```ini
# 准备测试数据
[root@node1 ~]# hdfs dfs -mkdir -p /wordcount/input/
[root@node1 ~]# hdfs dfs -put /root/words.txt /wordcount/input/
```

![1633422301964](assets/1633422301964.png)

```ini
# 运行程序，使用--input指定处理数据文件路径
/export/server/flink-standalone/bin/flink run \
/export/server/flink-standalone/examples/batch/WordCount.jar \
--input hdfs://node1.itcast.cn:8020/wordcount/input/words.txt
```

![1633422457779](assets/1633422457779.png)

```ini
# 使用--output指定处理结果数据存储目录
/export/server/flink-standalone/bin/flink run \
/export/server/flink-standalone/examples/batch/WordCount.jar \
--input hdfs://node1.itcast.cn:8020/wordcount/input/words.txt \
--output hdfs://node1.itcast.cn:8020/wordcount/output/result

[root@node1 ~]# hdfs dfs -text /wordcount/output/result
```

![1633422618479](assets/1633422618479.png)

> 5）、关闭Standalone集群服务

```ini
# 一键停止所有服务JobManager和TaskManagers
[root@node1 ~]# /export/server/flink-standalone/bin/stop-cluster.sh 
Stopping taskexecutor daemon (pid: 6600) on host node1.itcast.cn.
Stopping taskexecutor daemon (pid: 3016) on host node2.itcast.cn.
Stopping taskexecutor daemon (pid: 3034) on host node3.itcast.cn.
Stopping standalonesession daemon (pid: 6295) on host node1.itcast.cn.
```

> **补充**：Flink Standalone集群启动与停止，也可以逐一服务启动

```ini
# 每个服务单独启动
# 在node1.itcast.cn上启动
/export/server/flink-standalone/bin/jobmanager.sh start
# 在node1.itcast.cn、node2.itcast.cn、node3.itcast.cn
/export/server/flink-standalone/bin/taskmanager.sh start  # 每台机器执行

# ===============================================================
# 每个服务单独停止
# 在node1.itcast.cn上停止
/export/server/flink-standalone/bin/jobmanager.sh stop
# 在node1.itcast.cn、node2.itcast.cn、node3.itcast.cn
/export/server/flink-standalone/bin/taskmanager.sh stop 
```

### 4. Standalone HA

> 从Standalone架构图中，可发现JobManager存在`单点故障（SPOF`），一旦JobManager出现意外，整个集群无法工作。为了确保集群的高可用，需要搭建Flink的Standalone HA。

![1644670949884](assets/1644670949884.png)

> Flink Standalone HA集群，类似YARN HA 集群安装部署，可以[启动多个主机点JobManager，使用Zookeeper集群监控JobManagers转态，进行选举leader，实现自动故障转移。]()

![1644670962923](assets/1644670962923.png)

在 Zookeeper 的协助下，一个 Standalone的Flink集群会同时有多个活着的 JobManager，其中**只有一个处于Active工作状态，其他处于 Standby 状态。**当工作中的 JobManager 失去连接后(如宕机或 Crash)，Zookeeper 会从 Standby 中选一个新的 JobManager 来接管 Flink 集群。

> 1）、集群规划

![](assets/1614744989801.png)

```ini
# 在node1.itcast.cn上复制一份standalone
[root@node1 ~]# cd /export/server/
[root@node1 server]# cp -r flink-standalone flink-ha

# 删除日志文件
[root@node1 ~]# rm -rf /export/server/flink-ha/log/*
```

> 2）、启动ZooKeeper，在`node1.itcast.cn`上启动

```ini
zookeeper-daemons.sh start
```

> 3）、启动HDFS，在`node1.itcast.cn`上启动，**如果没有关闭，不用重启**

```ini
hadoop-daemon.sh start namenode
hadoop-daemons.sh start datanode
```

> 4）、停止集群，在`node1.itacast.cn`操作，进行HA高可用配置

```ini
/export/server/flink-standalone/bin/stop-cluster.sh 
```

> 5）、修改`flink-conf.yaml`，在`node1.itacast.cn`操作

```ini
vim /export/server/flink-ha/conf/flink-conf.yaml
	修改内容：
jobmanager.rpc.address: node1.itcast.cn	

high-availability: zookeeper
high-availability.storageDir: hdfs://node1.itcast.cn:8020/flink/ha/
high-availability.zookeeper.quorum: node1.itcast.cn:2181,node2.itcast.cn:2181,node3.itcast.cn:2181
high-availability.zookeeper.path.root: /flink
high-availability.cluster-id: /cluster_standalone

state.backend: filesystem
state.backend.fs.checkpointdir: hdfs://node1.itcast.cn:8020/flink/checkpoints
state.savepoints.dir: hdfs://node1.itcast.cn:8020/flink/savepoints
```



> 6）、修改`masters`，在`node1.itacast.cn`操作

```ini
vim /export/server/flink-ha/conf/masters
	修改内容：
	node1.itcast.cn:8081
	node2.itcast.cn:8081
```

> 7）、分发到集群其他机器，在`node1.itacast.cn`操作

```ini
scp -r /export/server/flink-ha root@node2.itcast.cn:/export/server/
scp -r /export/server/flink-ha root@node3.itcast.cn:/export/server/
```

> 8）、修改`node2.itcast.cn`上的`flink-conf.yaml`

```ini
[root@node2 ~]# vim /export/server/flink-ha/conf/flink-conf.yaml 
	修改内容：33 行
	jobmanager.rpc.address: node2.itcast.cn   
```

> 9）、重新启动Flink集群

```ini
# node1.itcast.cn和node2.itcast.cn上执行
/export/server/flink-ha/bin/jobmanager.sh start

# node1.itcast.cn和node2.itcast.cn、node3.itcast.cn执行
/export/server/flink-ha/bin/taskmanager.sh start  # 每台机器执行
```

![1633424157381](assets/1633424157381.png)

运行批处理词频统计WordCount，在Standalone HA高可用集群上：

> 1）、访问WebUI

![1633424730324](assets/1633424730324.png)

> 2）、执行批处理词频统计WordCount

```ini
/export/server/flink-ha/bin/flink run \
/export/server/flink-ha/examples/batch/WordCount.jar \
--input hdfs://node1.itcast.cn:8020/wordcount/input/words.txt
```

![1633424799351](assets/1633424799351.png)

> 3）、kill掉其中一个master，再次运行批处理词频统计

```ini
/export/server/flink-ha/bin/flink run \
/export/server/flink-ha/examples/batch/WordCount.jar \
--input hdfs://node1.itcast.cn:8020/wordcount/input/words.txt
```

![1633424955842](assets/1633424955842.png)

> 查看node2.itcast.cn上JobManager监控页面：

![1633425037238](assets/1633425037238.png)

> 4）、关闭集群服务：Standalone 服务、Zookeeper 服务和HDFS服务

```ini
# JM和TMs服务(node2.itcast.cn)
/export/server/flink-ha/bin/stop-cluster.sh

# Zookeeper服务（node1.itcast.cn)
zookeeper-daemons.sh stop

# HDFS服务（node1.itcast.cn)
hadoop-daemon.sh stop namenode
hadoop-daemons.sh stop datanode
```

### 5. Flink on YARN

#### 5.1. 运行流程

在一个企业中，为了==最大化的利用集群资源==，一般都会在一个集群中同时运行多种类型的Workload，因此 Flink 也支持在 Yarn 集群运行。

> 为什么使用`Flink on Yarn或Spark on Yarn?`

- 1）、Yarn的资源可以按需使用，提高集群的资源利用率

- 2）、Yarn的任务有优先级，根据优先级运行作业

- 3）、基于Yarn调度系统，能够自动化地处理各个角色的 Failover(容错)

  `当应用程序（MR、Spark、Flink）运行在YARN集群上时，可以实现容灾恢复。`

> Flink on YARN本质：[将JobManager和TaskManager`s`运行在YARN Contanier容器中]()。

![1633428933682](assets/1633428933682.png)

- 1）、JobManager 进程和 TaskManager 进程都由 Yarn NodeManager 监控；

  [JobManager和TaskManager都是运行NodeManager容器Contanier中]()

- 2）、如果 JobManager 进程异常退出，则 Yarn ResourceManager 会重新调度 JobManager到其他机器；

  - [JobManager和AppMaster运行在同一个Container容器中]()

  ![](assets/1629929588137.png)

  `max-attempts`默认值：`2`，实际生产环境，可以调整大一点，比如：`4`

- 3）、如果 TaskManager 进程异常退出，JobManager 会收到消息并重新向 Yarn ResourceManager 申请资源，重新启动 TaskManager；

> Flink on YARN 运行机制示意图：[将JobManager和TaskManagers运行到YARN Container容器中。]()

![](assets/1614763576727.png)

1. 客户端Client上传`jar包和配置文件`到HDFS集群上；
   - 当启动一个Flink Yarn会话时，客户端首先会检查本次请求的资源是否足够；资源足够再上传。
   - YARN Client上传完成jar包和配置文件以后，再向RM提交任务；
2. [Client向YARN ResourceManager提交应用并申请资源；]()
   - ResourceManager在NodeManager上启动容器，运行AppMaster，相当于JobManager进程。
3. [ResourceManager分配Container资源并启动ApplicationMaster，然后AppMaster加载Flink的Jar包和配置构建环境，启动JobManager；]()
   - JobManager和ApplicationMaster运行在同一个Container上；
   - 一旦JobManager被成功启动，AppMaster就知道JobManager的地址(AM它自己所在的机器)；
   - 它就会为TaskManager生成一个新的Flink配置文件，此配置文件也被上传到HDFS上；
   - 此外，AppMaster容器也提供了Flink的web服务接口；
   - YARN所分配的所有端口都是临时端口，这允许用户并行执行多个Flink
4. [ApplicationMaster向ResourceManager申请工作资源，NodeManager加载Flink的Jar包和配置
   构建环境并启动TaskManager（多个）。]()
5. TaskManager启动后向JobManager发送心跳包，并等待JobManager向其分配任务；

![1633433408535](assets/1633433408535.png)

#### 5.2. 安装部署

> Flink on YARN安装配置，此处考虑高可用HA配置，集群机器安装软件框架示意图：

![1633437485506](assets/1633437485506.png)

> - 1）、关闭YARN的内存检查（`node1.itcast.cn`操作）

```ini
# yarn-site.xml中添加配置
vim /export/server/hadoop/etc/hadoop/yarn-site.xml
	添加如下内容：
<!-- 关闭yarn内存检查 -->
<property>
    <name>yarn.nodemanager.pmem-check-enabled</name>
    <value>false</value>
</property>
<property>
    <name>yarn.nodemanager.vmem-check-enabled</name>
    <value>false</value>
</property>	
```

> - 2）、 配置Application最大的尝试次数（`node1.itcast.cn`操作）

```ini
# yarn-site.xml中添加配置
vim /export/server/hadoop/etc/hadoop/yarn-site.xml
	添加如下内容：
<property>
	<name>yarn.resourcemanager.am.max-attempts</name>
	<value>4</value>
</property>
```

> - 3）、同步yarn-site.xml配置文件（`node1.itcast.cn`操作）

```ini
cd /export/server/hadoop/etc/hadoop
scp -r yarn-site.xml root@node2.itcast.cn:$PWD
scp -r yarn-site.xml root@node3.itcast.cn:$PWD
```

> - 4）、启动HDFS集群和YARN集群（`node1.itcast.cn`操作）

```ini
[root@node1 ~]# hadoop-daemon.sh start namenode 
[root@node1 ~]# hadoop-daemons.sh start datanode 

[root@node1 ~]# /export/server/hadoop/sbin/start-yarn.sh
```

> - 5）、添加`HADOOP_CONF_DIR`环境变量(**集群所有机器**）

```ini
# 添加环境变量
 vim /etc/profile
	添加内容：
	export HADOOP_CONF_DIR=/export/server/hadoop/etc/hadoop
	
# 环境变量生效	
source /etc/profile
```

> - 6）、上传软件及解压（`node1.itcast.cn`操作）

```ini
[root@node1 ~]# cd /export/software/
[root@node1 software]# rz
	上传软件包：flink-1.13.1-bin-scala_2.11.tgz
	
[root@node1 software]# chmod u+x flink-1.13.1-bin-scala_2.11.tgz
[root@node1 software]# tar -zxf flink-1.13.1-bin-scala_2.11.tgz -C /export/server/	

[root@node1 ~]# cd /export/server/
[root@node1 server]# chown -R root:root flink-1.13.1
[root@node1 server]# mv flink-1.13.1 flink-yarn
```

> - 7）、将Flink依赖Hadoop 框架JAR包上传至`/export/server/flink-yarn/lib`目录

![1633421482610](assets/1633421482610.png)

```ini
[root@node1 ~]# cd /export/server/flink-yarn/lib/
[root@node1 lib]# rz
	commons-cli-1.4.jar
	flink-shaded-hadoop-3-uber-3.1.1.7.2.1.0-327-9.0.jar
```

> - 8）、配置HA高可用，依赖Zookeeper及重试次数（`node1.itcast.cn`操作）

```ini
# 修改配置文件
vim /export/server/flink-yarn/conf/flink-conf.yaml
 	添加如下内容：
high-availability: zookeeper
high-availability.storageDir: hdfs://node1.itcast.cn:8020/flink/yarn-ha/
high-availability.zookeeper.quorum: node1.itcast.cn:2181,node2.itcast.cn:2181,node3.itcast.cn:2181
high-availability.zookeeper.path.root: /flink-yarn-ha
high-availability.cluster-id: /cluster_yarn

yarn.application-attempts: 10
```

> - 9）、集群所有机器，同步分发Flink 安装包，便于任意机器提交运行Flink Job。

```ini
scp -r /export/server/flink-yarn root@node2.itcast.cn:/export/server/
scp -r /export/server/flink-yarn root@node3.itcast.cn:/export/server/
```

> - 10）、启动Zookeeper集群（`node1.itcast.cn`操作）

```ini
zookeeper-daemons.sh start
```

> 在Flink中执行应用有如下三种部署模式（Deployment  Mode）：

![1633435043735](assets/1633435043735.png)

#### 5.3. Session模式运行



#### 5.4. Per-Job模式



#### 5.5. Application模式运行



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