select explode(`array`(11, 22, 33)) as item;

select explode(`map`("id", 10086, "name", "zhangsan", "age", 18));

--step1:建表
create table the_nba_championship
(
    team_name     string,
    champion_year array<string>
) row format delimited
    fields terminated by ','
    collection items terminated by '|';

load data local inpath '/root/hivedata/The_NBA_Championship.txt'
    into table the_nba_championship;

select *
from the_nba_championship;
-- 使用explode函数对champion_year进行拆分 俗称炸开
select explode(champion_year) as champion_year
from the_nba_championship;


-- [42000][10081] Error while compiling statement:
-- FAILED: SemanticException [Error 10081]:
-- UDTF's are not supported outside the SELECT clause,
-- nor nested in expressions
-- select team_name, explode(champion_year) from the_nba_championship;

select a.team_name, b.year
from the_nba_championship a lateral view explode(champion_year) b as year
order by b.year desc;


------- 行列转换
-- 多行转单列
-- concat
select concat('it', 'cast', 'and', 'heima');

select concat('it', 'cast', null, 'heima');
-- null

-- concat_ws
select concat_ws('?', 'john', 'chow');

select concat_ws('?', 'john', null, 'chow');

create table row2col1
(
    col1 string,
    col2 string,
    col3 int
) row format delimited fields terminated by '\t';
load data local inpath '/root/hivedata/r2c1.txt' into table row2col1;
-- collect_list
select collect_list(col1)
from row2col1;

-- collect_set
select collect_set(col1)
from row2col1;


--建表
create table row2col2
(
    col1 string,
    col2 string,
    col3 int
) row format delimited fields terminated by '\t';

--加载数据到表中
load data local inpath '/root/hivedata/r2c2.txt' into table row2col2;

select col1,
       col2,
       concat_ws(',', collect_list(cast(col3 as string))) as col3
from row2col2
group by col1, col2;


--创建表
create table if not exists col2row2
(
    col1 string,
    col2 string,
    col3 string
) row format delimited fields terminated by '\t';


--加载数据
load data local inpath '/root/hivedata/c2r2.txt' into table col2row2;

select col1,
       col2,
       lv.col3 as col3
from col2row2
         lateral view
             explode(split(col3, ',')) lv as col3;

------------- json数据处理 ---------
-- get_json_object
--创建表
create table tb_json_test1
(
    json string
);
--加载数据
load data local inpath '/root/hivedata/device.json' into table tb_json_test1;
select *
from tb_json_test1;
select json,
       get_json_object(json, "$.device") as device
from tb_json_test1;
select json,
       get_json_object(json, "$.device") as device,
       get_json_object(json, "$.signal") as signal
from tb_json_test1;

select get_json_object(json, "$.device")     as device,
       get_json_object(json, "$.deviceType") as devicetype,
       get_json_object(json, "$.signal")     as signal,
       get_json_object(json, "$.time")       as stime
from tb_json_test1;

-- json_tuple
select json_tuple(json, "device", "signal") as (device, signal)
from tb_json_test1;

select json_tuple(json, "device", "deviceType", "signal", "time")
           as (device, deviceType, signal, stime)
from tb_json_test1;

select json, device, deviceType, signal, stime
from tb_json_test1
lateral view
json_tuple(json, "device", "deviceType", "signal", "time") b
as device, deviceType, signal, stime;


-- json Serde
create table tb_json_test2(
    device string,
    deviceType string,
    signal double,
    `time` string
)
row format serde 'org.apache.hive.hcatalog.data.JsonSerDe'
stored as TEXTFILE;

load data local inpath '/root/hivedata/device.json' into table tb_json_test2;
select *
from tb_json_test2;

-- 窗口函数
create table website_pv_info(
    cookieid string,
    createtime string,
    pv int
) row format delimited
fields terminated by ',';

create table website_url_info(
    cookieid string,
    createtime string,
    url string
) row format delimited
fields terminated by ',';

load data local inpath '/root/hivedata/website_pv_info.txt' into table website_pv_info;
load data local inpath '/root/hivedata/website_url_info.txt' into table website_url_info;

select * from website_pv_info;
select *
from website_url_info;

-- 窗口聚合函数
-- 求出每个用户总pv数, sum+group by常规聚合操作
select cookieid, sum(pv) as total_pv from website_pv_info group by cookieid;

-- 求出网站总的pv数, 所有用户所有访问加起来
-- sum(...) over() 对表所有行求和
select cookieid, createtime, pv, sum(pv) over() as total_pv
from website_pv_info
group by cookieid, createtime, pv;

--需求：求出每个用户总pv数
--sum(...) over( partition by... )，同组内所行求和
select cookieid,createtime,pv,
       sum(pv) over(partition by cookieid) as total_pv
from website_pv_info;

--需求：求出每个用户截止到当天，累积的总pv数
--sum(...) over( partition by... order by ... )，在每个分组内，连续累积求和
select cookieid,createtime,pv,
       sum(pv) over(partition by cookieid order by createtime) as current_total_pv
from website_pv_info;

-- 窗口表达式
--第一行到当前行
select cookieid,createtime,pv,
       sum(pv) over(partition by cookieid order by createtime rows between unbounded preceding and current row) as pv2
from website_pv_info;

--向前3行至当前行
select cookieid,createtime,pv,
       sum(pv) over(partition by cookieid order by createtime rows between 3 preceding and current row) as pv4
from website_pv_info;

--向前3行 向后1行
select cookieid,createtime,pv,
       sum(pv) over(partition by cookieid order by createtime rows between 3 preceding and 1 following) as pv5
from website_pv_info;

--当前行至最后一行
select cookieid,createtime,pv,
       sum(pv) over(partition by cookieid order by createtime rows between current row and unbounded following) as pv6
from website_pv_info;

--第一行到最后一行 也就是分组内的所有行
select cookieid,createtime,pv,
       sum(pv) over(partition by cookieid order by createtime rows between unbounded preceding  and unbounded following) as pv6
from website_pv_info;

-- 窗口排序函数
-----窗口排序函数
SELECT cookieid,
       createtime,
       pv,
       RANK() OVER (PARTITION BY cookieid ORDER BY pv desc)       AS rn1,
       DENSE_RANK() OVER (PARTITION BY cookieid ORDER BY pv desc) AS rn2,
       ROW_NUMBER() OVER (PARTITION BY cookieid ORDER BY pv DESC) AS rn3
FROM website_pv_info
WHERE cookieid = 'cookie1';


-- 窗口分析函数
-----------窗口分析函数----------
--LAG
SELECT cookieid,
       createtime,
       url,
       ROW_NUMBER() OVER (PARTITION BY cookieid ORDER BY createtime)                              AS rn,
       LAG(createtime, 1, '1970-01-01 00:00:00') OVER (PARTITION BY cookieid ORDER BY createtime) AS last_1_time,
       LAG(createtime, 2) OVER (PARTITION BY cookieid ORDER BY createtime)                        AS last_2_time
FROM website_url_info;


--LEAD
SELECT cookieid,
       createtime,
       url,
       ROW_NUMBER() OVER (PARTITION BY cookieid ORDER BY createtime)                               AS rn,
       LEAD(createtime, 1, '1970-01-01 00:00:00') OVER (PARTITION BY cookieid ORDER BY createtime) AS next_1_time,
       LEAD(createtime, 2) OVER (PARTITION BY cookieid ORDER BY createtime)                        AS next_2_time
FROM website_url_info;

--FIRST_VALUE
SELECT cookieid,
       createtime,
       url,
       ROW_NUMBER() OVER (PARTITION BY cookieid ORDER BY createtime)     AS rn,
       FIRST_VALUE(url) OVER (PARTITION BY cookieid ORDER BY createtime) AS first1
FROM website_url_info;

--LAST_VALUE
SELECT cookieid,
       createtime,
       url,
       ROW_NUMBER() OVER (PARTITION BY cookieid ORDER BY createtime)    AS rn,
       LAST_VALUE(url) OVER (PARTITION BY cookieid ORDER BY createtime) AS last1
FROM website_url_info;

-- TEXTFILE
create table log_text (
track_time string,
url string,
session_id string,
referer string,
ip string,
end_user_id string,
city_id string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE ;

load data local inpath '/root/hivedata/log.data' into table log_text ;

create table log_orc(
track_time string,
url string,
session_id string,
referer string,
ip string,
end_user_id string,
city_id string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS orc;

insert into table log_orc select * from log_text ;

create table log_parquet(
track_time string,
url string,
session_id string,
referer string,
ip string,
end_user_id string,
city_id string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS PARQUET ;

insert into table log_parquet select * from log_text ;

select count(*) from log_text;

select count(*) from log_orc;

select count(*) from log_parquet;

create table log_orc_none(
track_time string,
url string,
session_id string,
referer string,
ip string,
end_user_id string,
city_id string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS orc tblproperties ("orc.compress"="NONE");

insert into table log_orc_none select * from log_text ;

create table log_orc_snappy(
track_time string,
url string,
session_id string,
referer string,
ip string,
end_user_id string,
city_id string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS orc tblproperties ("orc.compress"="SNAPPY");
insert into table log_orc_snappy select * from log_text ;
