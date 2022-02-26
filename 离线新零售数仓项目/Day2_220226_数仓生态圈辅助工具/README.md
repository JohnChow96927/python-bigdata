# 数仓生态圈辅助工具

## 1. 数据分析交互平台Hue

### 1.1. Hue介绍

```properties
HUE=Hadoop User Experience

	Hue是一个开源的Apache Hadoop UI系统，由Cloudera Desktop演化而来，最后Cloudera公司将其贡献给Apache基金会的Hadoop社区，它是基于Python Web框架Django实现的。
	通过使用Hue，可以在浏览器端的Web控制台上与Hadoop集群进行交互，来分析处理数据，例如操作HDFS上的数据，运行MapReduce Job，执行Hive的SQL语句，浏览HBase数据库等等。
```

### 1.2. Hue功能

通过使用Hue，可以在浏览器端的Web控制台上与Hadoop集群进行交互，来分析处理数据，例如操作HDFS上的数据，运行MapReduce Job，执行Hive的SQL语句，浏览HBase数据库等等。

### 1.3. Hue架构原理

```properties
	Hue是一个友好的界面集成框架，可以集成各种大量的大数据体系软件框架，通过一个界面就可以做到查看以及执行所有的框架。
	Hue提供的这些功能相比Hadoop生态各组件提供的界面更加友好，但是一些需要debug的场景可能还是要使用原生系统才能更加深入的找到错误的原因。
```

![image-20211005174902119](assets/image-20211005174902119.png)

### 1.4. Hue安装与Web UI界面

- Hue安装

  - 官方下载源码包、手动编译安装

    ```
    最大的挑战在于软件之间的兼容性问题。
    ```

  - 使用CM集群在线安装

- Hue Web UI页面

  - 从CM集群页面进入

    http://hadoop01:7180/cmf  用户名密码：admin

    ![image-20211005180829367](assets/image-20211005180829367.png)

    ![image-20211005180840373](assets/image-20211005180840373.png)

  - 浏览器直接进入

    http://hadoop02:8889/hue   用户名密码：hue

  ![img](assets/hue-4.8.png)

### 1.5. Hue操作HDFS

- 进入HDFS管理页面

  ![image-20211005180936497](assets/image-20211005180936497.png)

  ![image-20211005180945676](assets/image-20211005180945676.png)

  ![image-20211005180954952](assets/image-20211005180954952.png)

- 新建文件、文件夹

- 上传、下载文件

- 查看文件内容

- 在线实时编辑文件内容

- 删除文件

- 修改文件权限

### 1.6.  Hue操作Hive

- 进入Hive面板

  ![image-20211005181140973](assets/image-20211005181140973.png)

- SQL编写、执行

## 2. 数据迁移同步工具Sqoop

### 2.1. 如何理解ETL



### 2.2. Apache Sqoop介绍与工作机制



### 2.3. 增量数据与全量数据



### 2.4. Sqoop数据导入至HDFS



### 2.5 Sqoop数据导入至Hive



### 2.6. Sqoop数据导入至Hive--HCatalog API



### 2.7. Sqoop数据导入--条件部分导入



### 2.8. Sqoop数据导入--增量导入



### 2.9. Sqoop数据导出



## 3. 工作流调度工具Oozie

### 3.1. 工作流介绍



### 3.2. Apache Oozie介绍与架构



### 3.3. Oozie工作流类型



### 3.4. Oozie使用案例





