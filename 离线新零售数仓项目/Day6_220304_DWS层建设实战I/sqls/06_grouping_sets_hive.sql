select *
from t_cookie;

--分别按照月month）、天（day）、月和天（month,day）统计来访用户cookieid个数，并获取三者的结果集（一起插入到目标宽表中）。
--目标表：month day   cnt_nums

--方式1： 普通分组聚合+祖传的union all
--维度：月 month
select
    month,
    count(cookieid) as cnt_nums
from t_cookie group by month;

--维度：天 day
select
    day,
    count(cookieid) as cnt_nums
from t_cookie group by day;

--维度：月 month、天 day
select
    month,
    day,
    count(cookieid) as cnt_nums
from t_cookie group by month,day;

--使用union all合并
--注意事项：使用union all要求各个结果集字段数量、顺序、类型 保持一致
--如果不一致怎么办？ 缺啥null补上
select
    month,
    null as day,
    count(cookieid) as cnt_nums
from t_cookie group by month
union all
select
    null as month,
    day,
    count(cookieid) as cnt_nums
from t_cookie group by day
union all
select
    month,
    day,
    count(cookieid) as cnt_nums
from t_cookie group by month,day;

---方式2  使用grouping sets进行操作
select
    month,day,count(cookieid)
from test.t_cookie
    group by month,day
grouping sets ((month),(day),(month,day));
