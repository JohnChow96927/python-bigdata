--------------------------------hive行列转换-------------------------------------------------------

--1、多行转多列
--case when 语法1
select
    id,
    case
        when id < 2 then 'a'
        when id = 2 then 'b'
        else 'c'
        end as caseName
from tb_url;

--case when 语法2
select
    id,
    case id
        when 1 then 'a'
        when 2 then 'b'
        else 'c'
        end as caseName
from tb_url;


--建表
create table row2col1(
                         col1 string,
                         col2 string,
                         col3 int
) row format delimited fields terminated by '\t';
--加载数据到表中
load data local inpath '/root/hivedata/r2c1.txt' into table row2col1;

select *
from row2col1;

--sql最终实现
select
    col1 as col1,
    max(case col2 when 'c' then col3 else 0 end) as c,
    max(case col2 when 'd' then col3 else 0 end) as d,
    max(case col2 when 'e' then col3 else 0 end) as e
from
    row2col1
group by
    col1;



--2、多行转单列
select * from row2col1;
select concat("it","cast","And","heima");
select concat("it","cast","And",null);

select concat_ws("-","itcast","And","heima");
select concat_ws("-","itcast","And",null);

select collect_list(col1) from row2col1;
select collect_set(col1) from row2col1;



--建表
create table row2col2(
                         col1 string,
                         col2 string,
                         col3 int
)row format delimited fields terminated by '\t';

--加载数据到表中
load data local inpath '/root/hivedata/r2c2.txt' into table row2col2;

select * from row2col2;

describe function extended concat_ws;

--最终SQL实现
select
    col1,
    col2,
    concat_ws(',', collect_list(cast(col3 as string))) as col3
from
    row2col2
group by
    col1, col2;


--3、多列转多行
select 'b','a','c'
union
select 'a','b','c'
union
select 'a','b','c';



--创建表
create table col2row1
(
    col1 string,
    col2 int,
    col3 int,
    col4 int
) row format delimited fields terminated by '\t';

--加载数据
load data local inpath '/root/hivedata/c2r1.txt'  into table col2row1;

select *
from col2row1;

--最终实现
select col1, 'c' as col2, col2 as col3 from col2row1
UNION ALL
select col1, 'd' as col2, col3 as col3 from col2row1
UNION ALL
select col1, 'e' as col2, col4 as col3 from col2row1;


--4、单列转多行
select explode(split("a,b,c,d",","));

--创建表
create table col2row2(
                         col1 string,
                         col2 string,
                         col3 string
)row format delimited fields terminated by '\t';

--加载数据
load data local inpath '/root/hivedata/c2r2.txt' into table col2row2;

select * from col2row2;

select explode(split(col3,',')) from col2row2;

--SQL最终实现
select
    col1,
    col2,
    lv.col3 as col3
from
    col2row2
        lateral view
            explode(split(col3, ',')) lv as col3;


--------------------------------hive json格式数据处理-------------------------------------------------------
--get_json_object
--创建表
create table tb_json_test1 (
    json string
);

--加载数据
load data local inpath '/root/hivedata/device.json' into table tb_json_test1;

select * from tb_json_test1;


select
    --获取设备名称
    get_json_object(json,"$.device") as device,
    --获取设备类型
    get_json_object(json,"$.deviceType") as deviceType,
    --获取设备信号强度
    get_json_object(json,"$.signal") as signal,
    --获取时间
    get_json_object(json,"$.time") as stime
from tb_json_test1;

--json_tuple
--单独使用
select
    --解析所有字段
    json_tuple(json,"device","deviceType","signal","time") as (device,deviceType,signal,stime)
from tb_json_test1;

--搭配侧视图使用
select
    json,device,deviceType,signal,stime
from tb_json_test1
         lateral view json_tuple(json,"device","deviceType","signal","time") b
         as device,deviceType,signal,stime;


--JsonSerDe
--创建表
create table tb_json_test2 (
                               device string,
                               deviceType string,
                               signal double,
                               `time` string
)
    ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
    STORED AS TEXTFILE;

load data local inpath '/root/hivedata/device.json' into table tb_json_test2;

select *
from tb_json_test2;