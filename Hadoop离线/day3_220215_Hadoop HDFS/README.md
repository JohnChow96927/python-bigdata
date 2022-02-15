# Apache Hadoop HDFS

## I. HDFS入门

1. ### HDFS基本概念

   1. #### HDFS介绍

      HDFS(Hadoop Distributed File System)，Hadoop分布式文件系统。是Hadoop核心组件之一，作为**最底层**的分布式存储服务而存在。

      HDFS解决的问题就是大数据存储。它们是横跨在多台计算机上的存储系统。分布式文件系统在大数据时代有着广泛的应用前景，它们为存储和处理超大规模数据提供所需的扩展能力。

      ![1644891972945](assets/1644891972945.png)

   2. #### HDFS设计目标

      1. **故障的检测和自动快速恢复**是HDFS的核心架构目标

2. ### HDFS重要特性

   1. #### master/slave架构

   2. #### 分块存储

   3. #### NameSpace名字空间

   4. #### NameNode元数据管理

   5. #### DataNode数据存储

   6. #### 副本机制

   7. #### 一次写入，多次读出

3. ### HDFS基本操作

   1. #### Shell命令行客户端

   2. #### Shell命令选项

   3. #### Shell常用命令介绍

## II. HDFS基本原理

1. ### NameNode概述

2. ### DataNode概述

3. ### HDFS的工作机制

   1. #### HDFS写数据流程

   2. #### HDFS读数据流程

      

## III. HDFS其他功能

1. ### 不同集群之间的数据复制

   1. #### 集群内布文件拷贝scp

   2. #### 跨集群之间的数据拷贝distcp

2. ### Archive档案的使用

   1. #### 如何创建Archive

   2. #### 如何查看Archive

   3. #### 如何解压Archive

   4. #### Archive注意事项

## IV. HDFS元数据管理机制

1. ### 元数据管理概述

2. ### 元数据目录相关文件

3. ### Fsimage、Edits

   1. #### 概述

   2. #### 内容查看

## V. Secondary NameNode

1. ### Checkpoint

   1. #### Checkpoint详细步骤

   2. #### Checkpoint触发条件

## VI. HDFS安全模式

1. ### 安全模式概述

2. ### 安全模式配置

3. ### 安全模式命令