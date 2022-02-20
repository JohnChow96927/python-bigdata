INSERT INTO table_name ( field1, field2,...fieldN )
VALUES
( value1, value2,...valueN );

---------hive中insert+values----------------
create table t_test_insert(id int,name string,age int);

insert into table t_test_insert values(1,"allen",18);

select * from t_test_insert;

----------hive中insert+select-----------------
--语法规则
INSERT OVERWRITE TABLE tablename1 [PARTITION (partcol1=val1, partcol2=val2 ...) [IF NOT EXISTS]] select_statement1 FROM from_statement;

INSERT INTO TABLE tablename1 [PARTITION (partcol1=val1, partcol2=val2 ...)] select_statement1 FROM from_statement;


--step1:创建一张源表student
drop table if exists student;
create table student(num int,name string,sex string,age int,dept string)
row format delimited
fields terminated by ',';
--加载数据
load data local inpath '/root/hivedata/students.txt' into table student;

select * from student;

--step2：创建一张目标表  只有两个字段
create table student_from_insert(sno int,sname string);


insert into table  student_from_insert
select name,num from student;






--使用insert+select插入数据到新表中
insert into table student_from_insert
select num,name from student;

select *
from student_from_insert;


------------multiple inserts----------------------
--当前库下已有一张表student
create table student(num int,name string,sex string,age int,dept string)
row format delimited
--创建两张新表
create table student_insert1(sno int);
create table student_insert2(sname string);




--正常思路来讲
insert into student_insert1
select num  from student;

insert into student_insert2
select name  from student;




--多重插入  一次扫描 多次插入
from student
insert overwrite table student_insert1
select num
insert overwrite table student_insert2
select name;


---------------动态分区插入--------------------
--背景：静态分区
drop table if exists student_HDFS_p;
create table student_HDFS_p(Sno int,Sname string,Sex string,Sage int,Sdept string) partitioned by(country string) row format delimited fields terminated by ',';
--注意 分区字段country的值是在导入数据的时候手动指定的 China
LOAD DATA INPATH '/students.txt' INTO TABLE student_HDFS_p partition(country ="China");


FROM page_view_stg pvs
INSERT OVERWRITE TABLE page_view PARTITION(dt='2008-06-08', country)
SELECT pvs.viewTime, pvs.userid, pvs.page_url, pvs.referrer_url, null, null, pvs.ip, pvs.cnt
--在这里，country分区将由SELECT子句（即pvs.cnt）的最后一列动态创建。
--而dt分区是手动指定写死的。
--如果是nonstrict模式下，dt分区也可以动态创建。

-----------案例：动态分区插入-----------
--1、首先设置动态分区模式为非严格模式 默认已经开启了动态分区功能
set hive.exec.dynamic.partition = true;
set hive.exec.dynamic.partition.mode = nonstrict;

--2、当前库下已有一张表student
select * from student;

--3、创建分区表 以sdept作为分区字段
create table student_partition(Sno int,Sname string,Sex string,Sage int) partitioned by(Sdept string);

--4、执行动态分区插入操作
insert into table student_partition partition(Sdept)
select num,name,sex,age,dept from student;
--其中，num,name,sex,age作为表的字段内容插入表中
--dept作为分区字段值

select *
from student_partition;

show partitions student_partition;




-----------------导出数据-------------------
--标准语法:
INSERT OVERWRITE [LOCAL] DIRECTORY directory1
    [ROW FORMAT row_format] [STORED AS file_format] (Note: Only available starting with Hive 0.11.0)
SELECT ... FROM ...

--Hive extension (multiple inserts):
FROM from_statement
INSERT OVERWRITE [LOCAL] DIRECTORY directory1 select_statement1
[INSERT OVERWRITE [LOCAL] DIRECTORY directory2 select_statement2] ...

--row_format
: DELIMITED [FIELDS TERMINATED BY char [ESCAPED BY char]] [COLLECTION ITEMS TERMINATED BY char]
[MAP KEYS TERMINATED BY char] [LINES TERMINATED BY char]


--导出操作演示
--当前库下已有一张表student
select * from student;

--1、导出查询结果到HDFS指定目录下
insert overwrite directory '/tmp/hive_export/e1' select num,name,age from student limit 2;

--2、导出时指定分隔符和文件存储格式
insert overwrite directory '/tmp/hive_export/e2' row format delimited fields terminated by ','
stored as orc
select * from student;

--3、导出数据到本地文件系统指定目录下
insert overwrite local directory '/root/hive_export/e1' select * from student;
