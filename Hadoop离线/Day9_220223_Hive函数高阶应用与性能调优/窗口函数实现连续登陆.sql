----------------------窗口函数应用实例-------------------------------------------------------
--1、连续登陆用户
--建表
create table tb_login
(
    userid    string,
    logintime string
) row format delimited fields terminated by '\t';

load data local inpath '/root/hivedata/login.log' into table tb_login;

select *
from tb_login;

----窗口函数实现
--连续登陆2天
select userid,
       logintime,
       --本次登陆日期的第二天
       date_add(logintime, 1)                                              as nextday,
       --按照用户id分区，按照登陆日期排序，取下一次登陆时间，取不到就为0
       lead(logintime, 1, 0) over (partition by userid order by logintime) as nextlogin
from tb_login;

--实现
with t1 as (
    select userid,
           logintime,
           --本次登陆日期的第二天
           date_add(logintime, 1)                                              as nextday,
           --按照用户id分区，按照登陆日期排序，取下一次登陆时间，取不到就为0
           lead(logintime, 1, 0) over (partition by userid order by logintime) as nextlogin
    from tb_login)
select distinct userid
from t1
where nextday = nextlogin;


--连续3天登陆
select userid,
       logintime,
       --本次登陆日期的第三天
       date_add(logintime, 2)                                              as nextday,
       --按照用户id分区，按照登陆日期排序，取下下一次登陆时间，取不到就为0
       lead(logintime, 2, 0) over (partition by userid order by logintime) as nextlogin
from tb_login;

--实现
with t1 as (
    select userid,
           logintime,
           --本次登陆日期的第三天
           date_add(logintime, 2)                                              as nextday,
           --按照用户id分区，按照登陆日期排序，取下下一次登陆时间，取不到就为0
           lead(logintime, 2, 0) over (partition by userid order by logintime) as nextlogin
    from tb_login)
select distinct userid
from t1
where nextday = nextlogin;

--连续N天
select userid,
       logintime,
       --本次登陆日期的第N天
       date_add(logintime, N - 1)                                              as nextday,
       --按照用户id分区，按照登陆日期排序，取下下一次登陆时间，取不到就为0
       lead(logintime, N - 1, 0) over (partition by userid order by logintime) as nextlogin
from tb_login;

-- 连续登录四天
with tmp as (
    select userid,
           logintime,
           date_add(logintime, 3) as tgtime,
           lead(logintime, 3, 0) over (partition by userid order by logintime) as nextlogin
    from tb_login
)
select distinct userid
from tmp
where tgtime = nextlogin;


