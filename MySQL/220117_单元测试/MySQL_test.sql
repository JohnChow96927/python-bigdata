SELECT e.*
FROM emp e
WHERE e.MGR IS NULL;

SELECT e.ENAME `员工姓名`,
       e.SAL   `员工薪资`
FROM emp e
WHERE e.DEPTNO = 20;

SELECT e.EMPNO `员工编号`,
       e.ENAME `员工姓名`,
       e.SAL   `员工薪资`
FROM emp e
WHERE e.SAL = (
    SELECT MIN(SAL)
    FROM emp
)
;

SELECT AVG(SAL) `平均薪资`,
       MAX(SAL) `最高薪资`,
       MIN(SAL) `最低薪资`
FROM emp
WHERE DEPTNO = 20
;

SELECT e.ENAME `员工姓名`,
       d.DNAME `部门名称`
FROM emp e
         JOIN dept d ON e.DEPTNO = d.DEPTNO
WHERE e.ENAME LIKE '%A%';

SELECT e.ENAME `员工姓名`,
       e.SAL   `员工薪资`
FROM emp e
WHERE e.SAL > (
    SELECT AVG(SAL)
    FROM emp
);

SELECT EMPNO `员工编号`,
       ENAME `员工姓名`,
       SAL   `员工薪资`
FROM emp
WHERE SAL = (
    SELECT MAX(SAL)
    FROM emp
)
;


SELECT title                                         `电影名称`,
       editor_rating                                 `电影编辑评分`,
       genre                                         `电影类型`,
       editor_rating - AVG(editor_rating)
                           OVER (PARTITION BY genre) `difference`
FROM movie;

WITH rank_movie AS (
    SELECT id                                        `电影ID`,
           title                                     `电影名称`,
           RANK() over (ORDER BY editor_rating DESC) `rank`
    FROM movie
)
SELECT 电影ID,
       电影名称
FROM rank_movie
WHERE `rank` = 2
;

WITH `register_per_month` AS (
    SELECT DISTINCT CONCAT(YEAR(join_date), '-', MONTH(join_date))                           `注册年月`,
                    COUNT(id) OVER (PARTITION BY MONTH(join_date) ORDER BY MONTH(join_date)) `当月注册数`
    FROM register
)
SELECT 注册年月,
       当月注册数,
       SUM(当月注册数) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) `截止当月注册用户数`
FROM register_per_month
;


-- 第一步: 查询高三一班数学成绩表
WITH temp_tb AS (
    SELECT tc.class_name                               `class_name`,
           ts.stu_name                                 `stu_name`,
           tea.teac_name                               `teac_name`,
           tc.course_name                              `course_name`,
           tsc.score                                   `score`,
           ROW_NUMBER() OVER (ORDER BY tsc.score DESC) `排序顺序`
    FROM t_class tcl
             JOIN t_student ts ON ts.class_id = tcl.class_id
             JOIN t_score tsc ON tsc.stu_id = ts.stu_id
             JOIN t_course tc ON tc.course_id = tsc.course_id
             JOIN t_teacher tea ON tea.teac_id = tc.teac_id
    WHERE tsc.course_id = 2
      AND tc.class_name = '高三一班'
)
SELECT class_name,
       stu_name,
       teac_name,
       course_name,
       score
FROM temp_tb
WHERE 排序顺序 = 3
;

-- 第二步: 查询上表中

# SELECT tc.class_name,
#        ts.stu_name,
#        tt.teac_name,
#        tcs.course_name,
#        tsc.score
# FROM t_class tc
#          JOIN t_student ts ON ts.class_id = tc.class_name
#          JOIN t_score tsc ON tsc.stu_id = ts.stu_id
#          JOIN t_course tcs ON tcs.course_id = tsc.course_id
#          JOIN t_teacher tt ON tt.teac_id = tcs.teac_id
# WHERE course_id = 2 AND


SELECT `year`,
       SUM(CASE
               WHEN `month` = 1
                   THEN `amount` END) `m1`,
       SUM(CASE
               WHEN `month` = 2
                   THEN `amount` END) `m2`,
       SUM(CASE
               WHEN `month` = 3
                   THEN `amount` END) `m3`,
       SUM(CASE
               WHEN `month` = 4
                   THEN `amount` END) `m4`,
FROM tb_sales
GROUP BY `year`;


