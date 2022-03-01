-- 1. 创建拉链表
create table dw_zipper
(
    userid    string,
    phone     string,
    nick      string,
    gender    int,
    addr      string,
    starttime string,
    endtime   string
)
    row format delimited fields terminated by '\t';

-- -- 加载测试数据(cdh封装原因无法使用load)
-- load data local inpath '/root/hivedata/zipper.txt' into table dw_zipper;
-- --使用put也可以
-- hadoop fs -put zipper.txt /user/hive/warehouse/test.db/dw_zipper



-- 创建模拟增量表
create table ods_zipper_update
(
    userid    string,
    phone     string,
    nick      string,
    gender    int,
    addr      string,
    starttime string,
    endtime   string
) row format delimited fields terminated by '\t';


-- -- 加载更新测试数据(cdh封装原因无法使用load)
-- load data local inpath '/root/hivedata/update.txt' into table ods_zipper_update;
-- --使用put也可以
-- hadoop fs -put update.txt /user/hive/warehouse/test.db/ods_zipper_update


select *
from ods_zipper_update;


create table tmp_zipper
(
    userid    string,
    phone     string,
    nick      string,
    gender    int,
    addr      string,
    starttime string,
    endtime   string
) row format delimited fields terminated by '\t';

insert overwrite table tmp_zipper
select userid,
       phone,
       nick,
       gender,
       addr,
       starttime,
       endtime
from ods_zipper_update
union all
select a.userid,
       a.phone,
       a.nick,
       a.gender,
       a.addr,
       a.starttime,
       -- 首先判断右表是否为空, 若为空则说明未修改, endtime不变, 若不为空则判断左表(拉链表)对应userid所在行是否为最后生效的一行, 若不是则endtime不变, 若是则将该行endtime置为修改生效日期前一天(date_sub)
       if(b.userid is null or a.endtime < '9999-12-31', a.endtime, date_sub(b.starttime, 1)) as endtime
from dw_zipper a
         left join ods_zipper_update b on a.userid = b.userid;


-- union 和 union all的区别: union会排除相同数据, 并进行排序, union all直接全部拼接并不排序
select userid,
       phone,
       nick,
       gender,
       addr,
       starttime,
       endtime
from ods_zipper_update
union
select a.userid,
       a.phone,
       a.nick,
       a.gender,
       a.addr,
       a.starttime,
       -- 首先判断右表是否为空, 若为空则说明未修改, endtime不变, 若不为空则判断左表(拉链表)对应userid所在行是否为最后生效的一行, 若不是则endtime不变, 若是则将该行endtime置为修改生效日期前一天(date_sub)
       if(b.userid is null or a.endtime < '9999-12-31', a.endtime, date_sub(b.starttime, 1)) as endtime
from dw_zipper a
         left join ods_zipper_update b on a.userid = b.userid;


-- 覆盖原拉链表
insert overwrite table dw_zipper
select userid,
       phone,
       nick,
       gender,
       addr,
       starttime,
       endtime
from tmp_zipper;
