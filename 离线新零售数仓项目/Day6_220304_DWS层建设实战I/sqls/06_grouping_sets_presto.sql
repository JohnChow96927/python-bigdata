--下面这个是hive sql语法
select
    month,day,count(cookieid)
from test.t_cookie
    group by month,day
grouping sets ((month),(day),(month,day));

--下面这个是presto的语法
--最大的区别是 group by 后面不需要在加字段了
select
    month,day,
    grouping(month,day) as type,
    count(cookieid)
from test.t_cookie
    group by grouping sets ((month),(day),(month,day));

create table  dws_user_daycount(
    month string,
    day string,
    type string,
    total_cnts int
 )


 ---
 select
    month,day,
    count(cookieid)
from test.t_cookie
    group by grouping sets ((month),(day),(month,day));