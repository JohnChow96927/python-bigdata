# ODS, DWD与DWS层自动化构建实现

## I. ODS层

### 1. 建表实现分析

- **目标**：阅读ODS建表代码及实现测试

- **实施**

  - **代码讲解**

    - step1：表名怎么获取?

    - step2：建表的语句是什么，哪些是动态变化的？

      ```sql
      create external table 数据库名称.表名
      comment '表的注释'
      partitioned by
      ROW FORMAT SERDE
        'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
      STORED AS INPUTFORMAT
        'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
      OUTPUTFORMAT
        'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
      location '这张表在HDFS上的路径'
      TBLPROPERTIES （'这张表的Schema文件在HDFS上的路径'）
      ```

    - step3：怎么获取表的注释？

    - step4：全量表与增量表有什么区别？

    - step5：如何实现自动化建表？

  - **代码测试**

    - 注释掉第4~ 第6阶段的内容
    - 运行代码，查看结果

    ![image-20211009162716532](assets/image-20211009162716532-1648601849727.png)

- **小结**

  - 阅读ODS建表代码及实现测试

### 2. 获取Oracle表元数据



### 3. 申明分区代码及测试



### 4. ODS层与DWD层区别



## II. DWD层

### 1. 建库实现测试



### 2. 建表实现测试



### 3. 数据抽取分析



### 4. 数据抽取测试



## III. 维度建模

### 1. 维度建模建模流程



### 2. 业务主题划分



### 3. 业务维度设计



### 4. 业务主题维度矩阵