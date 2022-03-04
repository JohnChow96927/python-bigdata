select month,day,count(cookieid)
from test.t_cookie
group by
cube (month, day);

--虽然只写了两个维度 但是cube的含义是把这两个维度的所有组合都计算
--[]
--[month],[day]
--[month,day]

--上述sql等价于
select month,day,count(cookieid)
from test.t_cookie
group by
grouping sets ((month,day), month, day, ());
