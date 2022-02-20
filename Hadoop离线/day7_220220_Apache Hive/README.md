# Hive SQL- DDL, DML语法

## I. HQL数据定义语言(DDL)概述

### 1. DDL语法的作用

数据定义语言 (Data Definition Language, DDL)，是SQL语言集中对数据库内部的对象结构进行创建，删除，修改等的操作语言，这些数据库对象包括database（schema）、table、view、index等。核心语法由**CREATE**、**ALTER**与**DROP**三个所组成。DDL并不涉及表内部数据的操作。

在某些上下文中，该术语也称为数据描述语言，因为它描述了数据库表中的字段和记录。

```sql
create table uits
(id integer,
name char(20),
semester integer,
year integer);
```

### 2. Hive中DDL使用

Hive SQL（HQL）与SQL的语法大同小异，基本上是相通的，学过SQL的使用者可以无痛使用Hive SQL。只不过在学习HQL语法的时候，特别要注意Hive自己特有的语法知识点，比如partition相关的DDL操作。

基于Hive的设计、使用特点，**HQL中create语法（尤其create table）将是学习掌握DDL语法的重中之重**。可以说建表是否成功直接影响数据文件是否映射成功，进而影响后续是否可以基于SQL分析数据。通俗点说，没有表，表没有数据，你分析什么呢？

选择正确的方向,往往比盲目努力重要。

## II. Hive DDL建表基础

### 1. 完整建表语法树

![1645323458904](assets/1645323458904.png)

> **蓝色**字体是建表语法的关键字，用于指定某些功能。

> **[ ]**中括号的语法表示可选。

> **|**表示使用的时候，左右语法二选一。

> 建表语句中的语法顺序要和上述语法规则保持一致。

### 2. Hive数据类型详解

#### 2.1. 整体概述

​	Hive中的数据类型指的是Hive表中的列字段类型。Hive数据类型整体分为两个类别：**原生数据类型**（primitive data type）和**复杂数据类型**（complex data type）。

​	原生数据类型包括：数值类型、时间类型、字符串类型、杂项数据类型；

​	复杂数据类型包括：array数组、map映射、struct结构、union联合体。

![1645328171790](assets/1645328171790.png)

​	Hive的数据类型: 

 		1. 英文字母大小写不敏感
 		2. 除SQL数据类型外, 还支持Java数据类型, 比如String
 		3. int和string是使用最多的数据类型, 大多数函数都支持
 		4. 复杂数据类型的使用通常需要和分隔符指定语法配合使用
 		5. 如果定义的数据类型和文件不一致, hive会尝试隐式转换, 但是不保证成功

#### 2.2. 原生数据类型

Hive支持的原生数据类型如下图所示：

![1645338929619](assets/1645338929619.png)

其中标注的数据类型是使用较多的，详细的描述请查询语法手册：

<https://cwiki.apache.org/confluence/display/Hive/LanguageManual+Types>

#### 2.3. 复杂数据类型

Hive支持的复杂数据类型如下图所示：

![1645338957967](assets/1645338957967.png)

其中标注的数据类型是使用较多的，详细的描述请查询语法手册：

<https://cwiki.apache.org/confluence/display/Hive/LanguageManual+Types>

#### 2.4. 数据类型隐式, 显示转换

与SQL类似，HQL支持隐式和显式类型转换。 

原生类型从窄类型到宽类型的转换称为隐式转换，反之，则不允许。 

下表描述了类型之间允许的隐式转换：

![1645338973650](assets/1645338973650.png)

<https://cwiki.apache.org/confluence/display/Hive/LanguageManual+Types>

显式类型转换使用CAST函数。

例如，CAST（'100'as INT）会将100字符串转换为100整数值。 如果强制转换失败，例如CAST（'INT'as INT），该函数返回NULL。

![1645338996504](assets/1645338996504.png)

### 3. Hive读写文件机制

#### 3.1. SerDe是什么

SerDe是Serializer、Deserializer的简称，目的是用于序列化和反序列化。序列化是对象转化为字节码的过程；而反序列化是字节码转换为对象的过程。

Hive使用SerDe（和FileFormat）读取和写入行对象。

![1645339033311](assets/1645339033311.png)

需要注意的是，“key”部分在读取时会被忽略，而在写入时key始终是常数。基本上**行对象存储在“value”中**。

可以通过desc formatted tablename查看表的相关SerDe信息。默认如下：

![1645339070559](assets/1645339070559.png)

#### 3.2. Hive读写文件流程



#### 3.3. SerDe相关语法



#### 3.4. LazySimpleSerDe分隔符指定



#### 3.5. 默认分隔符



### 4. Hive数据存储路径

#### 4.1. 默认存储路径



#### 4.2. 指定存储路径



### 5. 案例: 王者荣耀

#### 5.1. 原生数据类型案例



#### 5.2. 复杂数据类型案例



#### 5.3. 默认分隔符案例



## III. Hive DDL建表高阶

### 1. Hive内, 外部表

#### 1.1. 什么是内部表

**内部表（Internal table）**也称为被Hive拥有和管理的托管表（Managed table）。默认情况下创建的表就是内部表，Hive拥有该表的结构和文件。换句话说，Hive完全管理表（元数据和数据）的生命周期，类似于RDBMS中的表。

当删除内部表时，它会删除数据以及表的元数据。

```sql
create table student(
    num int,
    name string,
    sex string,
    age int,
    dept string) 
row format delimited 
fields terminated by ',';
```

#### 1.2. 什么是外部表

**外部表（External table）**中的数据不是Hive拥有或管理的，只管理表元数据的生命周期。要创建一个外部表，需要使用EXTERNAL语法关键字。

删除外部表只会删除元数据，而不会删除实际数据。在Hive外部仍然可以访问实际数据。

而且外部表更为方便的是可以搭配location语法指定数据的路径。

```sql
create external table student_ext(
    num int,
    name string,
    sex string,
    age int,
    dept string)
row format delimited
fields terminated by ','
location '/stu';
```

#### 1.3. 内部表, 外部表差异

无论内部表还是外部表，Hive都在Hive Metastore中管理表定义及其分区信息。删除内部表会从Metastore中删除表元数据，还会从HDFS中删除其所有数据/文件。

**删除外部表，只会从Metastore中删除表的元数据**，并保持HDFS位置中的实际数据不变。

![1645328926146](assets/1645328926146.png)

#### 1.4. 如何选择内部表, 外部表

当需要通过Hive完全管理控制表的整个生命周期时，请使用内部表。

当文件已经存在或位于远程位置时，请使用外部表，因为即使删除表，文件也会被保留。

### 2. Hive分区表

#### 2.1. 分区表的引入与产生背景

现有6份数据文件，分别记录了《王者荣耀》中6种位置的英雄相关信息。现要求通过建立一张表**t_all_hero**，把6份文件同时映射加载。

```sql
create table t_all_hero(
    id int,
    name string,
    hp_max int,
    mp_max int,
    attack_max int,
    defense_max int,
    attack_range string,
    role_main string,
    role_assist string
)
row format delimited
fields terminated by "\t";
```

加载数据文件到HDFS指定路径下：

![1645329311100](assets/1645329311100.png)

现要求查询role_main主要定位是射手并且hp_max最大生命大于6000的有几个，sql语句如下：

```sql
select count(*) from t_all_hero where role_main="archer" and hp_max >6000;
```

where语句的背后需要进行全表扫描才能过滤出结果，对于hive来说需要扫描表下面的每一个文件。如果数据文件特别多的话，效率很慢也没必要。本需求中，只需要扫描archer.txt文件即可，需要优化可以加快查询，减少全表扫描.

#### 2.2. 分区表的概念与创建

当Hive表对应的数据量大、文件多时，为了避免查询时全表扫描数据，Hive支持根据用户指定的字段进行分区，分区的字段可以是日期、地域、种类等具有标识意义的字段。比如把一整年的数据根据月份划分12个月（12个分区），后续就可以查询指定月份分区的数据，尽可能避免了全表扫描查询。

![1645329419091](assets/1645329419091.png)

分区表建表语法:

```sql
CREATE TABLE table_name (column1 data_type, column2 data_type) PARTITIONED BY (partition1 data_type, partition2 data_type,….);
```

针对《王者荣耀》英雄数据，重新创建一张分区表**t_all_hero_part**，以role角色作为分区字段。

```sql
create table t_all_hero_part(
       id int,
       name string,
       hp_max int,
       mp_max int,
       attack_max int,
       defense_max int,
       attack_range string,
       role_main string,
       role_assist string
) partitioned by (role string)
row format delimited
fields terminated by "\t";
```

需要注意：**分区字段不能是表中已经存在的字段**，因为分区字段最终也会以虚拟字段的形式显示在表结构上。

![1645329475471](assets/1645329475471.png)

#### 2.3. 分区表数据加载--静态分区(手动分区)

所谓**静态分区**指的是分区的字段值是由用户在加载数据的时候手动指定的。

语法如下：

```sql
load data [local] inpath ' ' into table tablename partition(分区字段='分区值'...);
```

Local表示数据是位于本地文件系统还是HDFS文件系统。关于load语句后续详细展开讲解。

静态加载数据操作如下，文件都位于Hive服务器所在机器本地文件系统上。

![1645329943380](assets/1645329943380.png)

```sql
load data local inpath '/root/hivedata/archer.txt' into table t_all_hero_part partition(role='sheshou');
load data local inpath '/root/hivedata/assassin.txt' into table t_all_hero_part partition(role='cike');
load data local inpath '/root/hivedata/mage.txt' into table t_all_hero_part partition(role='fashi');
load data local inpath '/root/hivedata/support.txt' into table t_all_hero_part partition(role='fuzhu');
load data local inpath '/root/hivedata/tank.txt' into table t_all_hero_part partition(role='tanke');
load data local inpath '/root/hivedata/warrior.txt' into table t_all_hero_part partition(role='zhanshi');
```

#### 2.4. 分区表数据加载--动态分区



#### 2.5. 分区表的本质

外表上看起来分区表好像没多大变化，只不过多了一个分区字段。实际上在底层管理数据的方式发生了改变。这里直接去HDFS查看区别。

非分区表：**t_all_hero**

![1645330634185](assets/1645330634185.png)

分区表：**t_all_hero_part**

![1645330643042](assets/1645330643042.png)

![1645330650366](assets/1645330650366.png)

分区的概念提供了一种将Hive表数据分离为多个文件/目录的方法。**不同分区对应着不同的文件夹，同一分区的数据存储在同一个文件夹下**。只需要根据分区值找到对应的文件夹，扫描本分区下的文件即可，避免全表数据扫描。

#### 2.6.分区表的使用

分区表的使用重点在于：

一、建表时根据业务场景设置合适的分区字段。比如日期、地域、类别等；

二、查询的时候尽量先使用where进行分区过滤，查询指定分区的数据，避免全表扫描。

比如：查询英雄主要定位是射手并且最大生命大于6000的个数。使用分区表查询和使用非分区表进行查询，SQL如下：

```sql
--非分区表 全表扫描过滤查询
select count(*) from t_all_hero where role_main="archer" and hp_max >6000;
--分区表 先基于分区过滤 再查询
select count(*) from t_all_hero_part where role="sheshou" and hp_max >6000;
```

#### 2.7. 分区表的注意事项



#### 2.8. 多重分区表



### 3. Hive分桶表

#### 3.1. 分桶表的概念



#### 3.2. 分桶表的语法



#### 3.3. 分桶表的创建



#### 3.4. 分桶表的数据加载



#### 3.5. 分桶表的使用好处



## IV. Hive DDL其他语法

### 1. Database|schema(数据库) DDL操作

#### 1.1. create database



#### 1.2. describe database



#### 1.3. use database



#### 1.4. drop database



#### 1.5 alter database



### 2. Table(表) DDL操作

#### 2.1. describe table



#### 2.2. drop table



#### 2.3. truncate table



#### 2.4. alter table



### 3. Partition(分区) DDL操作

#### 3.1. add partition



#### 3.2. rename partition



#### 3.3. delete partition



#### 3.4. msck partition



#### 3.5. alter partition



## V. Hive Show显示语法



## VI. HQL数据操作语言(DML)

### 1. DML-Load加载数据

#### 1.1. 背景



#### 1.2. Load语法



#### 1.3. 案例: Load加载数据到Hive表



### 2. DML-Insert插入数据

#### 2.1. 背景: RDBMS中insert使用(insert+values)



#### 2.2. insert+select



#### 2.3. multiple inserts 多重插入



#### 2.4. dynamic partition insert 动态分区插入



#### 2.5. insert+directory 导出数据

