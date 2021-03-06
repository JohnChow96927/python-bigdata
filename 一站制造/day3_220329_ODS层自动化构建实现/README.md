# ODS层自动化构建实现

## I. 数仓分层回顾

- **目标**：**回顾一站制造项目分层设计**

- **实施**

  ![image-20210821102418366](assets/image-20210821102418366-1648541362548.png)

  - ODS层：原始数据层，所有从Oracle中同步过来的数据

  - 实现：101张表的数据和Schema信息已经存储在HDFS上

    - full_impl: 44张全量
    - incr_impl: 57张增量
    - avsc: 101张表的Schema[列的信息]文件

  - 目标
    - step1：建库建表

      - 建库

        ```sql
        create database if not exists 数据库名称;
        ```

      - 建表

        ```sql
        create table if not exists 数据库名.表名(
        	列名 列的类型 列的注释
            ......
        )
        location '表在HDFS上的地址';
        ```

    - step2：申明分区

      ```sql
      alter table add partition
      ```

- **小结**

  - 回顾一站制造项目分层设计

## II. Hive建表语法

- **目标**：**掌握Hive建表语法**

- **实施**

  ```sql
  CREATE [TEMPORARY] [EXTERNAL] TABLE [IF NOT EXISTS] [db_name.]table_name
  (
      col1Name col1Type [COMMENT col_comment],
      co21Name col2Type [COMMENT col_comment],
      co31Name col3Type [COMMENT col_comment],
      co41Name col4Type [COMMENT col_comment],
      co51Name col5Type [COMMENT col_comment],
      ……
      coN1Name colNType [COMMENT col_comment]
  
  )
  [COMMENT table_comment]
  [PARTITIONED BY (col_name data_type ...)]
  [CLUSTERED BY (col_name...) [SORTED BY (col_name ...)] INTO N BUCKETS]
  [ROW FORMAT row_format]
  	row format delimited fields terminated by 
  	lines terminated by
  [STORED AS file_format]
  [LOCATION hdfs_path]
  TBLPROPERTIES
  ```

  - **语法**

    - TEMPORARY：临时表
    - EXTERNAL：外部表
    - PARTITIONED：分区表
    - CLUSTERED：分桶表
    - ROW FORMAT：指定列【\001】或者行的分隔符【\n】
    - STORED AS：存储的文件类型，默认是TextFile
    - LOCATION：指定表对应的HDFS地址，默认地址/user/hive/warehouse/数据库目录/表的目录
    - TBLPROPERTIES：配置表的一些属性，例如压缩等等

  - **注意**：能在Hive中运行，通常都可以在SparkSQL中执行，但是Spark中语法有两个细节需要注意

    - Hive语法：支持数据类型比较少，建表语法严格要求顺序

      ```
      Spark：Integer
      Hive：int
      ```

    - SparkSQL语法：支持数据类型兼容Hive类型，顺序有些位置可以互换

    - 本次所有SQL[DDL+DML+DQL]：SparkSQL, 不要放在Hive中执行

- **小结**

  - 掌握Hive建表语法

## III. Avro建表语法

- **目标**：**掌握Hive中Avro建表方式及语法**

- **路径**

  - step1：指定文件类型
  - step2：指定Schema
  - step3：建表方式

- **实施**

  - Hive官网：https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-CreateTable

  - DataBrics官网：https://docs.databricks.com/spark/2.x/spark-sql/language-manual/create-table.html

  - Avro用法：https://cwiki.apache.org/confluence/display/Hive/AvroSerDe

  - **指定文件类型**

    - 方式一：指定类型

      ```sql
      stored as avro
      ```

    - 方式二：指定解析类

      ```sql
      --解析表的文件的时候，用哪个类来解析
      ROW FORMAT SERDE
        'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
      --读取这张表的数据用哪个类来读取
      STORED AS INPUTFORMAT
        'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
      --写入这张表的数据用哪个类来写入
      OUTPUTFORMAT
        'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
      ```

  - **指定Schema**

    - 方式一：手动定义Schema

      ```sql
        CREATE TABLE embedded
      COMMENT "这是表的注释"
        ROW FORMAT SERDE
          'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
        STORED AS INPUTFORMAT
          'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
        OUTPUTFORMAT
          'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
        TBLPROPERTIES (
          'avro.schema.literal'='{
            "namespace": "com.howdy",
            "name": "some_schema",
            "type": "record",
            "fields": [ { "name":"string1","type":"string"}]
          }'
        );
      ```

      - ==方式二：加载Schema文件==

      ```sql
      CREATE TABLE embedded
      COMMENT "这是表的注释"
        ROW FORMAT SERDE
        'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
        STORED as INPUTFORMAT
          'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
        OUTPUTFORMAT
          'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
        TBLPROPERTIES (
         'avro.schema.url'='file:///path/to/the/schema/embedded.avsc'
        );
      ```

  - **建表语法**

    - 方式一：指定类型和加载Schema文件

      ```sql
        create external table one_make_ods_test.ciss_base_areas
      comment '行政地理区域表'
        PARTITIONED BY (dt string)
      stored as avro
        location '/data/dw/ods/one_make/full_imp/ciss4.ciss_base_areas'
        TBLPROPERTIES ('avro.schema.url'='/data/dw/ods/one_make/avsc/CISS4_CISS_BASE_AREAS.avsc');
      ```

    - ==方式二：**指定解析类和加载Schema文件**==

      ```sql
        create external table one_make_ods_test.ciss_base_areas
      comment '行政地理区域表'
        PARTITIONED BY (dt string)
      ROW FORMAT SERDE
          'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
        STORED AS INPUTFORMAT
          'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
        OUTPUTFORMAT
          'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
        location '/data/dw/ods/one_make/full_imp/ciss4.ciss_base_areas'
        TBLPROPERTIES ('avro.schema.url'='/data/dw/ods/one_make/avsc/CISS4_CISS_BASE_AREAS.avsc');
      ```

    - 与普通建表语法的区别

      1. 指定文件的格式为AVRO格式

         ```
         ROW FORMAT SERDE
             'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
           STORED AS INPUTFORMAT
             'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
           OUTPUTFORMAT
             'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
         ```

      2. 不用申明表的字段信息, 直接加载Schema文件

         ```
         TBLPROPERTIES ('avro.schema.url'='/data/dw/ods/one_make/avsc/CISS4_CISS_BASE_AREAS.avsc');
         ```

- **小结**

  - 掌握Hive中Avro建表方式及语法

## IV. ODS层自动化构建

### 1. 需求分析

- **目标**：掌握ODS层的实现需求

- **路径**

  - step1：目标
  - step2：问题
  - step3：需求
  - step4：分析

- **实施**

  - **目标**：将已经采集同步成功的101张表的数据加载到Hive的ODS层数据表中

  - **问题**

    - 难点1：表太多，如何构建每张表？

      - 表比较少: 从业务系统中将每张表的建表语句导出来, 改成Hive语法, 封装成SQL脚本
      - 表比较多: 实现自动化建表

    - 难点2：自动化建表时，哪些是动态变化的？

      ```sql
      create external table one_make_ods_test.ciss_base_areas
      comment '行政地理区域表'
      PARTITIONED BY (dt string)
      ROW FORMAT SERDE
      'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
      STORED AS INPUTFORMAT
      'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
      OUTPUTFORMAT
      'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
      location '/data/dw/ods/one_make/full_imp/ciss4.ciss_base_areas'
      TBLPROPERTIES ('avro.schema.url'='/data/dw/ods/one_make/avsc/CISS4_CISS_BASE_AREAS.avsc');
      ```

      - 表名
      - 表的注释
      - 表对应的HDFS目录
      - 表对应的Schema文件

    - 难点3：如果使用自动建表，如何获取每张表的字段信息？

      - 直接加载表对应的Schema文件

    - 难点4：表的注释怎么得到？

      - Oracle中有: 从Oracle中根据表名获取这张表的源数据信息
        - 表的名称
        - 表的注释
        - 字段信息: 字段名称, 字段类型, 字段长度, 字段精度, 字段注释

  - **需求**：加载Sqoop生成的Avro的Schema文件，实现自动化建表

  - **分析**

    - step0：本质上就是在执行SQL语句，代码中提交SQL流程

    - step1：代码中构建一个Hive/SparkSQL的连接

    - step2：创建ODS层数据库

      ```sql
      create database if not exists one_make_ods;
      ```

    - step3：创建ODS层全量表:44张表

      ```sql
      create external table one_make_ods_test.ciss_base_areas
      comment '行政地理区域表'
      PARTITIONED BY (dt string)
      ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
      STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
      OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
      location '/data/dw/ods/one_make/full_imp/ciss4.ciss_base_areas'
      TBLPROPERTIES ('avro.schema.url'='hdfs://bigdata.itcast.cn:9000/data/dw/ods/one_make/avsc/CISS4_CISS_BASE_AREAS.avsc');
      ```

      - 读取全量表表名

        - 文件: 包含了表名
        - 读取: 放入一个变量中: List

      - 获取表的注释

        - 根据表名从Oracle中获取

      - 获取表的目录：/data/dw/ods/one_make/full_imp/表名

      - 获取表的Schema：/data/dw/ods/one_make/avsc/表名.avsc

      - 拼接建表字符串

        - 拼接建表字符串

          ```
          sql = "create external table if not exists" + dbname + "." + tabname......
          ```

        - 简单拼接：str3 = str1+str2

          ```
          str1 = "I love"
          str2 = "China"
          str3 = str1 +" "+str2
          ```

        - 复杂拼接：将要拼接的所有元素放入一个列表，将列表转换为字符串

          ```
          str1 = "I love"
          str2 = "China"
          strlist = list()
          strlist.append(str1)
          strlist.append(str2)
          str=" ".join(strlist)
          ```

      - 执行建表SQL语句

    - step4：创建ODS层增量表:57张表

      - 读取增量表表名：**不同的列表中**
      - 获取表的目录：/data/dw/ods/one_make/**incr**_imp/表名
      - 获取表的Schema: /data/dw/ods/one_make/avsc/表名.avsc

    - 要想实现上面这个功能，推断一些类和方法？

      1. 一定要读取表名的文件
         - 工具类: 读文件中的表名放入一个列表中
      2. 需要连接SparkSQL和Oracle
         - 工具类: 获取数据库的连接
         - 工具类: 从Oracle中根据表名获取表的元数据

      ......

- **小结**

  - 掌握ODS层的实现需求 

### 2. 创建项目环境

- **目标**：**实现Pycharm中工程结构的构建**

- **实施**

  - **安装Python3.7环境**

    ![image-20211102182605596](assets/image-20211102182605596.png)

    - 项目使用的Python3.7的环境代码，所以需要在Windows中安装Python3.7，与原先的Python高版本不冲突，正常安装即可

  - **创建Python工程**

    <img src="./assets/image-20210930150438112.png" alt="image-20210930150438112" style="zoom:80%;" />

  - **安装PyHive、cx_Oracle库**

    - step1：在Windows的用户家目录下创建pip.ini文件

      - 例如：**C:\Users\Frank\pip\pip.ini**

      - 内容：指定pip安装从阿里云下载

        ```properties
        [global]
        
        index-url=http://mirrors.aliyun.com/pypi/simple/
        
        [install]
        
        trusted-host=mirrors.aliyun.com
        ```

    - step2：将文件添加到Windows的**Path环境变量**中

      ![image-20210930150905946](assets/image-20210930150905946.png)

    - step3：进入项目环境目录

      - 例如我的项目路径是：**D:\PythonProject\OneMake_Spark\venv\Scripts**

        ![image-20210930151306714](assets/image-20210930151306714.png)

      - 将提供的**sasl-0.2.1-cp37-cp37m-win_amd64.whl**文件放入Scripts目录下

        ![image-20210930151549478](assets/image-20210930151549478.png)

      - 在CMD中执行以下命令，切换到Scripts目录下

        ```shell
        #切换到D盘
        D:
        #切换到项目环境的Scripts目录下
        cd D:\PythonProject\OneMake_Spark\venv\Scripts
        ```

        ![image-20210930151448348](assets/image-20210930151448348.png)

  - step4：CMD中依次执行以下安装命令

    ```python
      # 安装sasl包 -> 使用pycharm安装，会存在下载失败情况，因此提前下载好，对应python3.7版本
      pip install sasl-0.2.1-cp37-cp37m-win_amd64.whl
      
      # 安装thrift包
      pip install thrift
      
      # 安装thrift sasl包
      pip install thrift-sasl
      
      # 安装python操作oracle包
      pip install cx-Oracle
      
      # 安装python操作hive包，也可以操作sparksql
      pip install pyhive
    ```

      ![image-20210930152134126](assets/image-20210930152134126.png)

- step5：验证安装结果

<img src="./assets/image-20210930152732079.png" alt="image-20210930152732079" style="zoom:80%;" />

- **小结**
  - 实现Pycharm中工程结构的构建

### 3. 代码导入

- **目标**：**实现Python项目代码的导入及配置**

- **实施**

  - **Oracle本地驱动目录**：将提供的**instantclient_12_2**目录放入D盘的根目录下

    ![image-20210930153737086](assets/image-20210930153737086-1648541786622.png)

  - **PyHive本地连接配置**：将提供的CMU目录放入C盘的根目录下

    ![image-20210930153652800](assets/image-20210930153652800-1648541784345.png)

  - **auto_create_hive_table包**

    - **创建路径包**

      ![image-20210930153142799](assets/image-20210930153142799-1648541782332.png)

      ```
      auto_create_hive_table.cn.itcast.datatohive
      ```

      ![image-20210930154056029](assets/image-20210930154056029-1648541778762.png)

      - 在datatohive的init文件中放入如下代码

        ```python
        from auto_create_hive_table.cn.itcast.datatohive import LoadData2DWD
        from auto_create_hive_table.cn.itcast.datatohive.CHiveTableFromOracleTable import CHiveTableFromOracleTable
        from auto_create_hive_table.cn.itcast.datatohive.CreateHiveTablePartition import CreateHiveTablePartition
        ```

      - 其他包的init都放入如下内容

        ```python
        #!/usr/bin/env python
        # @desc :
        __coding__ = "utf-8"
        __author__ = "itcast"
        ```

    - **将对应的代码文件放入对应的包或者目录中**

      - step1：从提供的代码中复制config、log、resource这三个目录直接粘贴到**auto_create_hive_table**包下

        ![image-20210930155013278](assets/image-20210930155013278-1648541773599.png)

      - step2：从提供的代码中复制entity、utils、EntranceApp.py这三个直接粘贴到**itcast**包下

        ![image-20210930155111676](assets/image-20210930155111676-1648541771440.png)

      - step3：从提供的代码中复制fileformat等文件直接粘贴到**datatohive**包下

        ![image-20210930155239773](assets/image-20210930155239773-1648541769728.png)

  - **DW归档目录**：将提供的代码中的dw目录直接粘贴到项目中

    ![image-20210930155529688](assets/image-20210930155529688-1648541767078.png)

- **小结**

  - 实现Python项目代码的导入及配置

### 4. 代码结构

- **目标**：了解整个自动化代码的项目结构及实现配置修改

- **路径**

  - step1：工程代码结构
  - step2：代码模块功能

- **实施**

  - **工程代码结构**

    ![image-20211009173309532](assets/image-20211009173309532.png)

  - **代码模块功能**

    - `auto_create_hive_table`：用于实现ODS层与DWD层的建库建表的代码

      - `cn.itcast`

        - `datatohive`

          ```properties
          CHiveTableFromOracleTable.py: 用于创建Hive数据库、以及获取Oracle表的信息创建Hive表等
          CreateMetaCommon.py: 定义了建表时固定的一些字符串数据，数据库名称、分层名称、文件类型属性等
          CreateHiveTablePartition.py: 用于手动申明ODS层表的分区元数据
          LoadData2DWD.py: 用于实现将ODS层的数据insert到DWD层表中
          ```

        - `fileformat`

          ```properties
          AvroTableProperties.py: Avro文件格式对象，用于封装Avro建表时的字符串
          OrcTableProperties.py: Orc文件格式对象，用于封装Orc建表时的字符串
          OrcSnappyTableProperties.py: Orc文件格式加Snappy压缩的对象
          TableProperties.py: 用于获取表的属性的类
          ```

      - `entity`

        ```properties
        TableMeta.py: Oracle表的信息对象：用于将表的名称、列的信息、表的注释进行封装
        ColumnMeta.py: Oracle列的信息对象：用于将列的名称、类型、注释进行封装
        ```

      - `utils`

        ```properties
        OracleHiveUtil.py: 用于获取Oracle连接、Hive连接
        FileUtil.py: 用于读写文件，获取所有Oracle表的名称
        TableNameUtil.py: 用于将全量表和增量表的名称放入不同的列表中
        ConfigLoader.py: 用于加载配置文件，获取配置文件信息
        OracleMetaUtil.py: 用于获取Oracle中表的信息：表名、字段名、类型、注释等
        ```

        - **EntranceApp.py**：程序运行入口，核心调度运行的程序

          ```python
          # todo:1-获取Oracle、Hive连接，获取所有表名
          # todo:2-创建ODS层数据库
          # todo:3-创建ODS层数据表
          # todo:4-手动申明ODS层分区数据
          # todo:5-创建DWD层数据库以及数据表
          # todo:6-加载ODS层数据到DWD层
          # todo:7-关闭连接，释放资源
          ```

    - `resource`

      ```properties
      config.txt: Oracle、Hive、SparkSQL的地址、端口、用户名、密码配置文件
      ```

    - `config`

      ```properties
      common.py: 用于获取日志的类
      settings.py: 用于配置日志记录方式的类
      ```

    - `log`

      ```properties
      itcast.log: 日志文件
      ```

  - `dw`：用于存储每一层构建的核心配置文件等

    - 重点关注：**dw.ods.meta_data.tablenames.txt**：存储了整个ODS层的表的名称

- **小结**

  - 了解整个自动化代码的项目结构

### 5. 代码修改

- **目标**：**实现配置修改**

- **实施**

  - 修改1：auto_create_hive_table.cn.itcast.EntranceApp.py

    ```python
    # 46行：修改为你实际的项目路径对应的表名文件
    tableList = FileUtil.readFileContent("C:\\GitHub Desktop\\ITheima_python_bigdata\\OneMake_Spark\\dw\\ods\\meta_data\\tablenames.txt")
    ```

  - 修改2：auto_create_hive_table.cn.itcast.utils.ConfigLoader

    ```python
    # 10行：修改为实际的连接属性配置文件的地址
    config.read('C:\\GitHub Desktop\\ITheima_python_bigdata\\OneMake_Spark\\auto_create_hive_table\\resources\\config.txt')
    ```

- **小结**

  - 实现配置修改

### 6. 连接代码及测试

- **目标**：**阅读连接代码及实现连接代码测试**

- **路径**

  - step1：连接代码讲解
  - step2：连接代码测试

- **实施**

  - **为什么要获取连接？**

    - 实现自动化建表，需要将建表语句提交给SparkSQL的ThriftServer
    - 构建ThriftServer连接
    - 构建Oracle连接

  - **连接代码讲解**

    - step1：怎么获取连接？
      - Oracle: 安装cx_Oracle
      - SparkSQL, Hive: 安装PyHive
    - step2：连接时需要哪些参数？
      - Oracle：hostname/port/username/password/sid
      - SparkSQL、Hive：hostname/port/username/password
    - step3：如果有100个代码都需要构建Hive连接，怎么解决呢？
      - 把连接的参数放在配置文件中, 通过工具类读取配置文件
    - step4：在ODS层建101张表，表名怎么动态获取呢？
      - 表名存储在文件中, 通过工具类, 将表名读取放入一个列表中
    - step5：ODS层的表分为全量表与增量表，怎么区分呢？
      - 全量表的表名放在一个列表中: tableNameList[0]
      - 增量表的表名放在一个列表中: tableNameList[1]

  - **连接代码测试**

    - 启动虚拟运行环境

      ![image-20210930160404445](assets/image-20210930160404445.png)

    - 运行测试代码

      - 注释掉第2 ~ 第6阶段的内容
      - 取消测试代码的注释
      - 执行代码观察结果

      ![image-20211009151713201](assets/image-20211009151713201.png)

- **小结**

  - 阅读连接代码及实现连接代码测试

### 7. 建库代码及测试

- **目标**：阅读ODS建库代码及实现测试

- **路径**

  - step1：代码讲解
  - step2：代码测试

- **实施**

  - **代码讲解**

    - step1：ODS层的数据库名称叫什么？

      ```sql
      create database if not exists one_make_ods;
      ```

    - step2：如何使用PyHive创建数据库？

      - 先获取连接
      - 再获取游标, 利用游标执行SQL语句
      - 关闭资源

  - **代码测试**

    - 注释掉第3 ~ 第6阶段的内容

  - 运行代码，查看结果

    ![image-20211009153910448](assets/image-20211009153910448.png)

- **小结**

  - 阅读ODS建库代码及实现测试

### 8. 建表实现分析

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

    ![image-20211009162716532](assets/image-20211009162716532.png)

- **小结**

  - 阅读ODS建表代码及实现测试

### 9. 获取Oracle表元数据

- **目标**：**理解ODS层获取Oracle元数据**

- **实施**

  - 从Oracle中获取：从系统表中获取某张表的信息和列的信息

    ```sql
    select
           columnName, dataType, dataScale, dataPercision, columnComment, tableComment
    from
    (
        select
               column_name columnName,
               data_type dataType,
               DATA_SCALE dataScale,
               DATA_PRECISION dataPercision,
               TABLE_NAME
        from all_tab_cols where 'CISS_CSP_WORKORDER' = table_name) t1
        left join (
            select
                   comments tableComment,TABLE_NAME
            from all_tab_comments WHERE 'CISS_CSP_WORKORDER' = TABLE_NAME) t2
            on t1.TABLE_NAME = t2.TABLE_NAME
        left join (
            select comments columnComment, COLUMN_NAME
            from all_col_comments WHERE TABLE_NAME='CISS_CSP_WORKORDER') t3
            on t1.columnName = t3.COLUMN_NAME;
    ```

    ![image-20211009154553669](assets/image-20211009154553669.png)

    - 如何获取元数据？
      - 从Oracle中查询得到的
    - 将查询的结果进行保存？
      - 将每张表元数据存储在TableMeta的对象中

- **小结**

  - 理解ODS层获取Oracle元数据

### 10. 申明分区代码及测试

- **目标**：阅读ODS申明分区的代码及实现测试

- **路径**

  - step1：代码讲解
  - step2：代码测试

- **实施**

  - **代码讲解**

    - step1：为什么要申明分区？
    - step2：怎么申明分区？
    - step3：如何自动化实现每个表的分区的申明？

  - **代码测试**

    - 注释掉第5 ~ 第6阶段的内容
    - 运行代码，查看结果

    ![image-20211103172953111](assets/image-20211103172953111.png)

- **小结**

  - 阅读ODS申明分区的代码及实现测试

## 附一: 面向对象的基本应用

1. **常见编程语言**

   - C语言：面向过程，实现一个功能，细化到每一步都要自己实现
     - 特点：更接近于底层
     - 缺点：编程十分麻烦
     - 应用：硬件开发
   - Java：面向对象【强】，万物皆对象，用人的思维去编程，高级语言
     - 特点：软件设计非常方便
     - 缺点：做数据处理不方便
     - 应用：软件开发
   - Python：面向对象【弱】 + 面向函数，所有功能都封装成函数
     - 特点：简洁，适合做数据处理
     - 缺点：过于灵活，没有很多规则

2. **面向对象：实体【Entity】类**

   - 功能：用于封装一个类型，代表一个对象，**存储对象的数据**

   - 包含：属性和方法

     ```
     class Name：
     	// 类的属性
     	// 类的方法
     ```

   - 举例：张三吃莴笋

     - 几个实体？

       - 人
       - 蔬菜

     - 构建两个实体类

       ```python
       class Person:
       	#属性
       	id = None
       	name = None
       	age = None
       	gender = None
           
       	# 方法
           # 读写属性的方法
           def __init__(self,id,name,age,gender):
               self.id = id
               self.name = name
               ……
           
           def setId(self,newId):
               self.id = newId
               
           def getId(self):
               return self.id
           ……
           # 其他动作方法
           def eat(self,anything):
               print(self.name + " eating " + anything.name)
               
       class Veg:
           #属性
           name = None
           color = None
           ……
           
           #方法
           def __init__(self,name,color):
               self.name = name
               self.color = color
           # 读写属性方法
           ……
           # 其他动作：光合作用
       ```

     - 实现需求

       ```python
       # 构建类的实例对象
       p1 = Person("1","zhangsan"……)
       wosun = Veg("莴笋","green")
       # 行程实体关系
       if (wosun.color == "green"):
       	p1.eat(wosun)
       ```

3. **面向对象：工具类**：xxxxUtils

   - 功能：主要提供一些**公共的工具方法**

   - 包含：方法

   - 举例

     - 人吃人

     - 狗吃骨头

     - 兔子吃胡萝卜

     - 实现：将吃这个方法封装到一个工具类中

       ```python
       # 实体类
       class Person
       class Animal
       # 工具类
       class GeneralUtil:
       	# 吃的方法
       	def eat(A,B):
               print(A +" eating " + B)
             
           
       class EntranceRun:
           p1 = Person(张三)
           p2 = Person(李四)
           a1 = Animal(狗)
           v1 = Veg(柳树)
           GeneralUtil.eat(p1,p2)
           GeneralUtil.eat(a1,p2)
           GeneralUtil.eat(p2,v1)
           GeneralUtil.eat(a1,v1)
       ```

4. **面向对象：常量类**:xxxxCommon

   - 功能：一般用于提供一些**公共的固定不变的变量 = 常量**

   - 包含：属性

   - 举个栗子

     - 代码1.py：将每天的UV写入MySQL：tb1中

       ```
       df1.write.jdbc("jdbc:mysql://node1:3306/db_rs","tb_uv","root","123456")
       ```

     - 代码2.py：将每天的PV写入MySQL：tb2中

       ```
       df2.write.jdbc("jdbc:mysql://node1:3306/db_rs","tb_pv","root","123456")
       ```

- ……

- 代码100.py

  - 问题

    - 写很多遍，容易写错
    - 数据库配置如果发生改变，需要挨个修改

  - 解决：将数据库的配置信息，放到一个公共的地方，用到的时候调用这个公共的地方

  - 常量类

    ```
    class JDBCCommon:
    	jdbc_url = "jdbc:mysql://node1:3306/db_rs"
    	username = "root"
    	password = "123456"
    ```

  - 代码1.py：将每天的UV写入MySQL：tb1中

    ```
    df1.write.jdbc(JDBCCommon.jdbc_url,"tb_uv",JDBCCommon.username,JDBCCommon.password)
    ```

  - 代码2.py：将每天的PV写入MySQL：tb2中

    ```
    df2.write.jdbc(JDBCCommon.jdbc_url,"tb_pv",JDBCCommon.username,JDBCCommon.password)
    ```

  - ……

  - 代码100.py

## 附二: 代码操作数据库

- **规律**：所有数据库，都有一个服务端，代码中构建一个服务端连接，提交SQL给这个服务端

  

- **步骤**

  - step1：构建连接：指定数据库地址+认证

    

    ```python
    #  MySQL
    conn = PyMySQL.connect(host=node1, port=3306, username='root', password='123456')
    # Oracle
    conn = cxOracle.connect(host=node1, port=1521, username='root', password='123456', dsn=helowin)
    # ThriftServer/HiveServer2
    ```

  - step2：执行操作

    ```python
    # 构建SQL语句
    sql = 'select * from db_emp.tb_emp'
    # Oracle
    cursor = conn.cursor
    # 执行SQL语句
    cursor.execute(sql)
    ```

  - step3：释放资源

    ```python
    cursor.close()
    conn.close()
    ```

    