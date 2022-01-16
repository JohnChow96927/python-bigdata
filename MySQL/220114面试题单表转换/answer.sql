# 1
SELECT 学号,
       SUM(CASE
               WHEN 科目 = '语文'
                   THEN 成绩 END) `语文`,
       SUM(CASE
               WHEN 科目 = '数学'
                   THEN 成绩 END) `数学`,
       SUM(CASE
               WHEN 科目 = '英语'
                   THEN 成绩 END) `英语`

FROM score_220114
GROUP BY 学号;

# 2
CREATE TABLE w_score AS
SELECT 学号,
       SUM(CASE
               WHEN 科目 = '语文'
                   THEN 成绩 END) `语文`,
       SUM(CASE
               WHEN 科目 = '数学'
                   THEN 成绩 END) `数学`,
       SUM(CASE
               WHEN 科目 = '英语'
                   THEN 成绩 END) `英语`

FROM score_220114
GROUP BY 学号;

SELECT 学号,
       '语文' `科目`,
       语文 `成绩`
FROM w_score
UNION
SELECT 学号,
       '数学' `科目`,
       数学 `成绩`
FROM w_score
UNION
SELECT 学号,
       '英语' `科目`,
       英语 `成绩`
FROM w_score
ORDER BY 学号;