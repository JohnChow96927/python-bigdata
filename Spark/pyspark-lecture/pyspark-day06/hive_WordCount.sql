Create database if not exists db_test;
create table db_test.tb1_lines(line string);

load data LOCAL inpath '/root/words.txt' into table db_test.tb1_lines;
select * from db_test.tb1_lines;

select split(line, "\\s+") words
from db_test.tb1_lines;

select t.word, count(1) total
from (select explode(split(line, "\\s+")) as word from db_test.tb1_lines) t
group by t.word order by total desc limit 10;

with tmp as (
    select explode(split(line, '\\s+')) as word from db_test.tb1_lines
)
select t.word, count(1) total
from tmp t group by t.word order by total desc limit 10;