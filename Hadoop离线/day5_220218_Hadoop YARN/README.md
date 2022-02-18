## I. Shuffle机制

**map阶段处理的数据如何传递给reduce阶段**，是MapReduce框架中最关键的一个流程，这个流程就叫**shuffle**。

shuffle: 洗牌、发牌——（核心机制：**数据分区，排序，合并**）。

![1645147353873](assets/1645147353873.png)

shuffle是Mapreduce的核心，它分布在Mapreduce的map阶段和reduce阶段。一般把从**Map产生输出开始到Reduce取得数据作为输入之前的过程称作shuffle**。

Map阶段Shuffle: 

1. Collect阶段：将MapTask的结果输出到默认大小为100M的**环形缓冲区**，保存的是key/value，Partition分区信息等。

2. Spill阶段：当**内存**中的数据量达到一定的阀值的时候，就会将数据写入**本地磁盘**，在将数据写入磁盘之前需要对数据进行一次排序的操作，如果配置了combiner，还会将有相同分区号和key的数据进行排序。 

3. Merge阶段：把所有溢出的临时文件进行一次合并操作，以确保一个MapTask最终只产生一个中间数据文件。

Reduce阶段Shuffle:

4. Copy阶段： ReduceTask启动Fetcher线程到已经完成MapTask的节点上复制一份属于自己的数据，这些数据默认会保存在**内存**的缓冲区中，当内存的缓冲区达到一定的阀值的时候，就会将数据写到**磁盘**之上。

5. Merge阶段：在ReduceTask远程复制数据的同时，会在后台开启两个线程对**内存**到**本地**的数据文件进行合并操作。

6. Sort阶段：在对数据进行合并的同时，会进行排序操作，由于MapTask阶段已经对数据进行了局部的排序，ReduceTask只需保证Copy的数据的最终整体有效性即可。

Shuffle中的缓冲区大小会影响到mapreduce程序的执行效率，原则上说，缓冲区越大，磁盘io的次数越少，执行速度就越快, **Shuffle中频繁涉及数据在内存, 磁盘之间的多次往复**

### MR的弊端: 1. Shuffle过程繁琐; 2. 磁盘内存间反复横跳; 3. 业务复杂, 一个MR处理不完, 只能创建多个MR串行处理.

## II. Apache Hadoop YARN

### Yet Another Resource Negotiator, 一种新的Hadoop资源管理器

1. ### YARN通俗介绍

   ![1645154946084](assets/1645154946084.png)

   YARN是一个**通用**资源管理系统和**调度**平台，可为上层应用提供统一的**资源管理**和**调度**，它的引入为集群在**利用率、资源统一管理和数据共享等方面**带来了巨大好处。

   可以把yarn理解为相当于一个分布式的操作系统平台，而mapreduce等运算程序则相当于运行于操作系统之上的应用程序，Yarn为这些程序提供运算所需的资源（内存、cpu）。

   - yarn并不清楚用户提交的程序的运行机制

   - yarn只提供运算资源的调度（用户程序向yarn申请资源，yarn就负责分配资源）

   - yarn中的主管角色叫ResourceManager

   - yarn中具体提供运算资源的角色叫NodeManager

   - yarn与运行的用户程序**完全解耦**，意味着yarn上可以运行各种类型的分布式运算程序，比如**mapreduce、storm，spark，tez**……

   - **spark**、**storm**等运算框架都可以整合在yarn上运行，只要他们各自的框架中有符合yarn规范的资源请求机制即可

   YARN成为一个通用的资源调度平台.企业中以前存在的各种运算集群都可以整合在一个物理集群上，提高资源利用率，方便数据共享

2. ### YARN基本架构

   ![1645155672538](assets/1645155672538.png)

   YARN是一个资源管理、任务调度的框架，主要包含三大模块：ResourceManager（RM）、NodeManager（NM）、ApplicationMaster（AM）。

   **ResourceManager**负责所有资源的监控、分配和管理；

   **ApplicationMaster**负责每一个具体应用程序的调度和协调；

   **NodeManager**负责每一个节点的维护。

   对于所有的applications，RM拥有绝对的控制权和对资源的分配权。而每个AM则会和RM协商资源，同时和NodeManager通信来执行和监控task

3. ### YARN三大组件

   1. #### ResourceManager

      

   2. #### NodeManager

      

   3. #### ApplicationMaster

      

4. ### YARN运行流程

   

5. ### YARN调度器Scheduler

   1. #### FIFO Scheduler

      

   2. #### Capacity Scheduler

      

   3. #### Fair Scheduler

      

   4. #### 示例: Capacity调度器配置使用

      

## III. Hadoop High Availability(HA)

1. ### NameNode HA

   1. #### NameNode HA

      

   2. #### Failover Controller

      

2. ### YARN HA

   

3. ### Hadoop HA集群的搭建

   

