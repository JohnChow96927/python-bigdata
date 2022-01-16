select  distinct 学号,
        case when 学号 = 's0001' then (select 成绩 from score_220114 where 学号 = 's0001' and 科目 = '语文')
            when 学号 = 's0002' then (select 成绩 from score_220114 where 学号 = 's0002' and 科目 = '语文')
end as '语文',
        case when 学号 = 's0001' then (select 成绩 from score_220114 where 学号 = 's0001' and 科目 = '数学')
            when 学号 = 's0002' then (select 成绩 from score_220114 where 学号 = 's0002' and 科目 = '数学')
end as '数学',
        case when 学号 = 's0001' then (select 成绩 from score_220114 where 学号 = 's0001' and 科目 = '英语')
            when 学号 = 's0002' then (select 成绩 from score_220114 where 学号 = 's0002' and 科目 = '英语')
end as '英语'
from score_220114
;