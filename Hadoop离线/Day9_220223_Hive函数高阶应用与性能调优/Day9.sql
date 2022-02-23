select explode(`array`(11,22,33)) as item;

create table the_nba_championship(
    team_name string,
    champion_year array<string>
) row format delimited
fields terminated by ','
collection items terminated by '|';

load data local inpath '/root/hivedata/The_NBA_Championship.txt'
    into table the_nba_championship;

select * from the_nba_championship;

select explode(champion_year) as champion_year from the_nba_championship;

select team_name, explode(champion_year) from the_nba_championship;

select a.team_name, b.year
from the_nba_championship a lateral view explode(champion_year) b as year order by b.year desc;


