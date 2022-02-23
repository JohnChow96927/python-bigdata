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
