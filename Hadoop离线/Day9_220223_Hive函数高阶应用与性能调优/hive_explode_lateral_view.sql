--step1:建表
create table the_nba_championship(
           team_name string,
           champion_year array<string>
) row format delimited
fields terminated by ','
collection items terminated by '|';

--step2:加载数据文件到表中
load data local inpath '/root/hivedata/The_NBA_Championship.txt' into table the_nba_championship;

--step3:验证
select *
from the_nba_championship;

--step4:使用explode函数对champion_year进行拆分 俗称炸开
select explode(champion_year) from the_nba_championship;

--想法是正确的 sql执行确实错误的
select team_name,explode(champion_year) from the_nba_championship;


--step5: lateral view +explode
select a.team_name,b.year
from the_nba_championship a lateral view explode(champion_year) b as year
order by b.year desc;



--lateral view侧视图基本语法如下
select …… from tabelA lateral view UDTF(xxx) 别名 as col1,col2,col3……;


select a.team_name ,b.year
from the_nba_championship a lateral view explode(champion_year) b as year;

--根据年份倒序排序
select a.team_name ,b.year
from the_nba_championship a lateral view explode(champion_year) b as year
order by b.year desc;

--统计每个球队获取总冠军的次数 并且根据倒序排序
select a.team_name ,count(*) as nums
from the_nba_championship a lateral view explode(champion_year) b as year
group by a.team_name
order by nums desc;




describe function extended explode;

select explode(`array`(11,22,33,44,55));

select explode(`map`("id",10086,"name","allen","age",18));