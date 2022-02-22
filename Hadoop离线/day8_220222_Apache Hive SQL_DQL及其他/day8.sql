use itcast;

drop table if exists t_usa_covid19;
create table t_usa_covid19(
    count_date string,
    county string,
    state string,
    fips int,
    cases int,
    deaths int
)
row format delimited fields terminated by ",";

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

--select_expr
--查询所有字段或者指定字段
select * from t_usa_covid19_p;
select county, cases, deaths from t_usa_covid19_p;

--查询匹配正则表达式的所有字段
SET hive.support.quoted.identifiers = none; --带反引号的名称被解释为正则表达式
select `^c.*` from t_usa_covid19_p;
--查询当前数据库
select current_database(); --省去from关键字
--查询使用函数
select count(county) from t_usa_covid19_p;

--ALL DISTINCT
--返回所有匹配的行
select state
from t_usa_covid19_p;
--相当于
select all state
from t_usa_covid19_p;
--返回所有匹配的行 去除重复的结果
select distinct state
from t_usa_covid19_p;
--多个字段distinct 整体去重
select distinct county,state from t_usa_covid19_p;






