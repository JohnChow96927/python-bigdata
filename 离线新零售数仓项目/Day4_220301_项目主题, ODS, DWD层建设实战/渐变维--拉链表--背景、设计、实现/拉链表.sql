--------------------------------hive 拉链表设计实现-------------------------------------------------------

--Step1：创建拉链表

create table dw_zipper(
                          userid string,
                          phone string,
                          nick string,
                          gender int,
                          addr string,
                          starttime string,
                          endtime string
) row format delimited fields terminated by '\t';

--加载模拟数据
load data local inpath '/root/hivedata/zipper.txt' into table dw_zipper;

--使用put也可以
hadoop fs -put zipper.txt /user/hive/warehouse/test.db/dw_zipper

--查询
select userid,nick,addr,starttime,endtime from dw_zipper;


--Step2：模拟增量数据采集

create table ods_zipper_update(
                                  userid string,
                                  phone string,
                                  nick string,
                                  gender int,
                                  addr string,
                                  starttime string,
                                  endtime string
) row format delimited fields terminated by '\t';

load data local inpath '/root/hivedata/update.txt' into table ods_zipper_update;
--使用put也可以
hadoop fs -put update.txt /user/hive/warehouse/test.db/ods_zipper_update

select * from ods_zipper_update;


--Step3：创建临时表
create table tmp_zipper(
                           userid string,
                           phone string,
                           nick string,
                           gender int,
                           addr string,
                           starttime string,
                           endtime string
) row format delimited fields terminated by '\t';

--Step4：合并拉链表与增量表
insert overwrite table tmp_zipper
select
    userid,
    phone,
    nick,
    gender,
    addr,
    starttime,
    endtime
from ods_zipper_update
union all
--查询原来拉链表的所有数据，并将这次需要更新的数据的endTime更改为更新值的startTime
select
    a.userid,
    a.phone,
    a.nick,
    a.gender,
    a.addr,
    a.starttime,
    --如果这条数据没有更新或者这条数据不是要更改的数据，就保留原来的值，否则就改为新数据的开始时间-1
    if(b.userid is null or a.endtime < '9999-12-31', a.endtime , date_sub(b.starttime,1)) as endtime
from dw_zipper a  left join ods_zipper_update b
                            on a.userid = b.userid ;



--Step5：覆盖拉链表
insert overwrite table dw_zipper
select * from tmp_zipper;
