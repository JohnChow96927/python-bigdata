# Apache Hadoop

## I. Apache Hadoop

1. ### Hadoop介绍

   Hadoop是Apache旗下一个用Java实现的开源软件框架，是一个开发和运行处理大规模数据的软件平台。允许使用简单的编程模型在==**大量计算机集群**==上对大型数据集进行==**分布式处理**==。

   Hadoop的核心组件有：

   ##### 	HDFS（分布式文件系统）：解决海量数据存储

   ##### 	YARN（作业调度和集群资源管理的框架）：解决资源任务调度

   ##### 	MAPREDUCE（分布式运算编程框架）：解决海量数据计算

   ![1644715808108](assets/1644715808108.png)

   广义上说，Hadoop也指==**Hadoop生态圈**==：

   ![1644715869982](assets/1644715869982.png)

   当下的Hadoop已经成长为一个庞大的体系，随着生态系统的成长，新出现的项目越来越多，其中不乏一些非Apache主管的项目，这些项目对HADOOP是很好的补充或者更高层的抽象。

2. ### Hadoop发展简史

   ​	Hadoop是Apache Lucene创始人 Doug Cutting 创建的。最早起源于Nutch，它是Lucene的子项目。Nutch的设计目标是构建一个大型的全网搜索引擎，包括网页抓取、索引、查询等功能，但随着抓取网页数量的增加，遇到了严重的可扩展性问题：如何解决数十亿网页的存储和索引问题。

   ​	2003年Google发表了一篇论文为该问题提供了可行的解决方案。论文中描述的是谷歌的产品架构，该架构称为：谷歌分布式文件系统（GFS）,可以解决他们在网页爬取和索引过程中产生的超大文件的存储需求。

   ​	2004年 Google发表论文向全世界介绍了谷歌版的MapReduce系统。

   ​	同时期，Nutch的开发人员完成了相应的开源实现HDFS和MAPREDUCE，并从Nutch中剥离成为独立项目HADOOP，到2008年1月，HADOOP成为Apache顶级项目，迎来了它的快速发展期。

   ​	2006年Google发表了论文是关于BigTable的，这促使了后来的Hbase的发展。

   ​	因此，Hadoop及其生态圈的发展离不开Google的贡献。

3. ### Hadoop特性优点

   Scalable扩容能力：Hadoop是在可用的计算机集群间分配数据并完成计算任务的，这些集群可以方便地扩展到数以千计的节点中。

   Economical经济（成本低）：Hadoop通过普通廉价的及其组成服务器集群来分发以及处理数据，所以成本很低。

   Efficient效率高：通过并发数据，Hadoop可以在节点之间动态并行地移动数据，所以速度非常快。

   Reliable可靠性高：能自动维护数据的多份复制，并且在任务失败后能自动地重新部署（redeploy）计算任务，所以Hadoop的按位存储和处理数据的能力值得人们信赖。

4. ### Hadoop国内外应用

   ​	不管是国内还是国外，Hadoop最受青睐的行业是互联网领域，可以说互联网公司是hadoop的主要使用力量。

   ​	国外来说，Yahoo、Facebook、IBM等公司都大量使用hadoop集群来支撑业务。比如：

   ​		Yahoo的Hadoop应用在支持广告系统、用户行为分析、支持Web搜索等。

   ​		Facebook主要使用Hadoop存储内部日志与多维数据，并以此作为报告、分析和机器学习的数据源。

   ​		国内来说，BAT领头的互联网公司是当仁不让的Hadoop使用者、维护者。比如Ali云梯（14年国内最大Hadoop集群）、百度的日志分析平台、推荐引擎系统等。

   ![1644717252091](assets/1644717252091.png)

   ​	国内其他非互联网领域也有不少hadoop的应用，比如：

   ​		金融行业： 个人征信分析

   ​		证券行业： 投资模型分析

   ​		交通行业： 车辆、路况监控分析

   ​		电信行业： 用户上网行为分析

   ​	总之：hadoop并不会跟某种具体的行业或者某个具体的业务挂钩，它只是一种用来做海量数据分析处理的工具。

## II. Hadoop集群搭建

1. ### 发行版本

   Hadoop发行版本分为开源**社区版**和**商业版**。

   社区版是指由Apache软件基金会维护的版本，是官方维护的版本体系。

   <https://hadoop.apache.org/>

   ![1644717876627](assets/1644717876627.png)

   商业版Hadoop是指由第三方商业公司在社区版Hadoop基础上进行了一些修改、整合以及各个服务组件兼容性测试而发行的版本，比较著名的有**cloudera的CDH**、mapR、hortonWorks等。

   <https://www.cloudera.com/products/open-source/apache-hadoop/key-cdh-components.html>

   ![1644717889683](assets/1644717889683.png)

   Hadoop的版本很特殊，是由多条分支并行的发展着。大的来看分为3个大的系列版本：1.x、2.x、3.x。

   Hadoop1.0由一个分布式文件系统HDFS和一个离线计算框架MapReduce组成。架构落后，已经淘汰。

   Hadoop 2.0则包含一个分布式文件系统HDFS，一个资源管理系统YARN和一个离线计算框架MapReduce。相比于Hadoop1.0，Hadoop 2.0功能更加强大，且具有更好的扩展性、性能，并支持多种计算框架。

   ![1644717907800](assets/1644717907800.png)
        Hadoop 3.0相比之前的Hadoop 2.0有一系列的功能增强。目前已经趋于稳定，可能生态圈的某些组件还没有升级、整合完善。

   ![1644717918203](assets/1644717918203.png)

   课程中使用的是：Apache Hadoop 3.3.0。

2. ### 集群简介

   HADOOP集群具体来说包含两个集群：HDFS集群和YARN集群，两者逻辑上分离，但物理上常在一起。

   HDFS集群负责海量数据的存储，集群中的角色主要有：

   NameNode、DataNode、SecondaryNameNode

   YARN集群负责海量数据运算时的资源调度，集群中的角色主要有：

   ResourceManager、NodeManager

   ![1644718157441](assets/1644718157441.png)

   那mapreduce是什么呢？它其实是一个分布式运算编程框架，是应用程序开发包，由用户按照编程规范进行程序开发，后打包运行在HDFS集群上，并且受到YARN集群的资源调度管理。

   Hadoop部署方式分三种，Standalone mode（独立模式）、Pseudo-Distributed mode（伪分布式模式）、Cluster mode（群集模式），其中前两种都是在单机部署。

   独立模式又称为单机模式，仅1个机器运行1个java进程，主要用于调试。

   伪分布模式也是在1个机器上运行HDFS的NameNode和DataNode、YARN的 ResourceManger和NodeManager，但分别启动单独的java进程，主要用于调试。

   集群模式主要用于生产环境部署。会使用N台主机组成一个Hadoop集群。这种部署模式下，主节点和从节点会分开部署在不同的机器上。

   我们以3节点为例进行搭建，角色分配如下：

   node1	NameNode	DataNode	ResourceManager

   node2	DataNode	NodeManager	SecondaryNameNode

   node3	DataNode	NodeManager

3. ### 服务器基础环境准备

4. ### JDK环境安装

5. ### Hadoop重新编译

6. ### Hadoop安装包目录结构

7. ### Hadoop配置文件修改

   1. #### hadoop-env.sh

   2. #### core-site.xml

   3. #### hdfs-site.xml

   4. #### mapred-site.xml

   5. #### yarn-site.xml

   6. #### workers

8. ### scp同步安装包

9. ### Hadoop环境变量

## III. Hadoop集群启动、初体验

1. ### 启动方式

   1. 单节点逐个启动
   2. 脚本一键启动

2. ### 集群web-ui

3. ### Hadoop初体验

   1. HDFS使用
   2. 运行MapReduce程序

## IV. MapReduce jobHistory

1. ### 修改mapred-site.xml

2. ### 分发配置到其他机器

3. ### 启动jobHistoryServer服务进程

4. ### 页面访问jobhistoryserver

## V. HDFS的垃圾桶机制

1. ### 垃圾桶机制解析

2. ### 垃圾桶机制配置

3. ### 垃圾桶机制验证