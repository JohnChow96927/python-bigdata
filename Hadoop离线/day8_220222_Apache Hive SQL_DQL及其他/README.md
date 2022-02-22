# Apache Hive DQL及其他

## I. HQL数据查询(DQL)语句

### 1. 基础查询

#### 1.1. 语法树

```sql
[WITH CommonTableExpression (, CommonTableExpression)*] 
SELECT [ALL | DISTINCT] select_expr, select_expr, ...
  FROM table_reference
  [WHERE where_condition]
  [GROUP BY col_list]
  [ORDER BY col_list]
  [CLUSTER BY col_list
    | [DISTRIBUTE BY col_list] [SORT BY col_list]
  ]
 [LIMIT [offset,] rows]
```

table_reference指示查询的输入。它可以是普通物理表，视图，join查询结果或子查询结果。

表名和列名不区分大小写。

#### 1.2. 案例: 美国Covid-19新冠select查询

在附件资料中有一份数据文件"us-covid19-counties.dat"，里面记录了2021-01-28美国各个县累计新冠确诊病例数和累计死亡病例数。

在Hive中创建表，加载该文件到表中：

```sql
--step1:创建普通表t_usa_covid19
drop table t_usa_covid19;
CREATE TABLE  t_usa_covid19(
       count_date string,
       county string,
       state string,
       fips int,
       cases int,
       deaths int)
row format delimited fields terminated by ",";
--将源数据load加载到t_usa_covid19表对应的路径下
load data local inpath '/root/hivedata/us-covid19-counties.dat' into table t_usa_covid19;

--step2:创建一张分区表 基于count_date日期,state州进行分区
CREATE TABLE itcast.t_usa_covid19_p(
     county string,
     fips int,
     cases int,
     deaths int)
partitioned by(count_date string,state string)
row format delimited fields terminated by ",";

--step3:使用动态分区插入将数据导入t_usa_covid19_p中
set hive.exec.dynamic.partition.mode = nonstrict;

insert into table t_usa_covid19_p partition (count_date,state)
select county,fips,cases,deaths,count_date,state from t_usa_covid19;
```

![1645499602054](assets/1645499602054.png)

#### 1.3. select_expr



### 2. 高阶查询

#### 2.1. sort/order/cluster/distributed by



#### 2.2. union联合查询



#### 2.3. Common Table Expressions(CTE)



## II. HQL join连接查询

### 1. join概念回顾



### 2. Hive join语法

#### 2.1. 规则树



#### 2.2. 语法丰富



### 3. join查询数据环境准备



### 4. Hive inner join



### 5. Hive left join



### 6. Hive right join



### 7. Hive full outer join



### 8. Hive left semi join



### 9. Hive cross join



### 10 Hive join使用注意事项



## III. Hive参数配置

### 1. CLIs and Commands客户端和命令

#### 1.1. Hive CLI



#### 1.2. Beeline CLI



### 2. Configuration Properties配置属性

#### 2.1. 配置属性概述



#### 2.2. 修改配置属性方式



## IV. Hive内置运算符

### 1. 关系运算符



### 2. 算术运算符



### 3. 逻辑运算符



## V. Hive函数入门

### 1. 函数概述



### 2. 函数分类概述



### 3. 内置函数分类



### 4. 用户自定义函数分类

#### 4.1. UDF普通函数



#### 4.2. UDAF聚合函数



#### 4.3. UDTF表生成函数

