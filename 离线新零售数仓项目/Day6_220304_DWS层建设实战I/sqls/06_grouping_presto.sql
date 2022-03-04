select month,day,count(cookieid)
from test.t_cookie
group by
grouping sets ((month,day), month, day, ());


--grouping函数功能：用于判断指定的字段是否在分组条件中，
--如果在 返回0，没有的话才返回1  而且注意0 1是二进制的位
select
    grouping(month) as m,
    grouping(day) as d,
    grouping(month,day) as m_d,
    count(cookieid)
from test.t_cookie
group by
grouping sets ((month,day), month, day, ());


--问题：如何使用grouping实现精准判断
grouping sets((A),(A,B),(A,C),(B,C),(A,B,C),())

--如何精准识别出 是根据(B,C)进行分组聚合的。
--使用grouping如何判断？
grouping(C) = 0  --这个可以吗？  肯定不可以  因为多个分组中都包含C

grouping(A,B,C) =  100(2)  4(10)

grouping(A,B,C) = 4  --意味着什么？  分组中肯定没有A  一定有B  C

--
(A)  011 3
(A,B) 001 1
(A,C) 010 2
(B,C) 100 4
(A,B,C) 000 0
() 111 7
---
grouping(A,B,C) = 0,1,2,3,4,7



