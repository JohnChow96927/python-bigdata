# 数据仓库与Apache Hive

## I. 数据仓库

1. ### 数据仓库的基本概念

   ##### 数据仓库(Data Warehouse, 数仓, DW)是一个用于存储, 分析, 报告的数据系统.

   ##### 数据仓库的目的是构建面向分析的集成化数据环境, 分析结果为企业提供决策支持.

   ##### 数据仓库本身并不"生产"任何数据, 也不"消费"任何数据, 数据来源于外部且开放给外部应用.

2. ### 数据仓库的主要特征

   1. #### 面向主题(Sub-Oriented)

      

   2. #### 集成性(Integrated)

      

   3. #### 非易失性(不可更新性)(Non-Volatile)

      

   4. #### 时变性(Time-Variant)

      

3. ### 数据仓库与数据库的区别

   

4. ### 数据仓库分层架构

   

5. ### ETL与ELT

   1. #### ETL

      

   2. #### ELT

      

## II. Apache Hive

1. ### Hive简介

   1. #### 什么是Hive

      

   2. #### 为什么使用Hive

      

2. ### Hive架构

   1. #### Hive架构图

      

   2. #### Hive组件

      

   3. #### Hive与Hadoop的关系

      

3. ### Hive与传统数据库对比

   

## III. Hive安装部署

1. ### metadata与metastone

   

2. ### metastore三种配置方式

   1. #### 内嵌模式

      

   2. #### 本地模式

      

   3. #### 远程模式

      

3. ### Hive metastore远程模式与安装部署

   1. #### Hadoop中添加用户代理配置

      

   2. #### 上传安装包并解压

      

   3. #### 修改配置文件hive-env.sh

      

   4. #### 添加配置文件hive-site.xml

      

   5. #### 上传MySQL驱动

      

   6. #### 初始化元数据

      

   7. #### 创建hive存储目录

      

4. ### metasore的启动方式

   

5. ### Hive Client与Beeline Client

   1. #### 第一代客户端Hive Client

      

   2. #### 第二代客户端Hive Beeline Client

      

