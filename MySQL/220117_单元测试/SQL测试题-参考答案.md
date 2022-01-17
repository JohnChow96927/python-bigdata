[TOC]

## SQL 综合测试题

> 考试时间：90分钟
>
> 注意：考试结束之后，将答案写到每题的下方，文件名改成自己的姓名，进行提交

### 1. 简答题（每题5分，共10分）

1）数据库事务的作用？事务的四大特性是什么？- (5分)

```bash
# 你的答案
作用：保证一组sql操作，同时成功，或同时失败。
四大特性：
* A：原子性
* C：一致性
* I：隔离性
* D：持久性
```

2）数据库索引的作用是什么？- (5分)

```bash
# 你的答案
作用：使用索引字段查询，提高 SQL 的查询效率
```

### 2. 基本查询和子查询（每题5分，共35分）

> 利用 sql_exam 数据库中的 dept(部门表) 和 emp(员工表) 完成如下查询。

1）查询没有上级的员工全部信息（mgr是空的）（5分）

```sql
SELECT 
	*
FROM emp
WHERE MGR is NULL; 
```

2）列出20号部门所有员工的姓名、薪资  （5分）

```sql
SELECT
	ENAME,
	SAL
FROM emp
WHERE DEPTNO = 20;
```

3）查询薪资最低的员工编号、姓名、薪资  （5分）

```sql
SELECT
	EMPNO,
	ENAME,
	SAL
FROM emp
ORDER BY SAL
LIMIT 1;
或
-- 建议写这个
SELECT
	EMPNO,
	ENAME,
	SAL
FROM emp
WHERE SAL = (SELECT MIN(SAL) FROM emp);
```

4）查询20号部门的平均薪资、最高薪资、最低薪资  （5分）

```sql
SELECT
	AVG(SAL) AS `avg_salary`,
	MAX(SAL) AS `max_salary`,
	MIN(SAL) AS `min_salary`
FROM emp
WHERE DEPTNO = 20;
```

5）查询姓名包含 'A' 的员工姓名、部门名称  （5分）

```sql
SELECT
	e.ENAME,
	d.DNAME
FROM emp e
JOIN dept d
ON e.DEPTNO = d.DEPTNO
WHERE e.ENAME like '%A%';
```

6）列出薪资高于公司平均薪资的所有员工姓名、薪资。  （5分）

```sql
SELECT
	ENAME,
	SAL
FROM emp
WHERE SAL > (SELECT AVG(SAL) FROM emp);
```

7）查询薪资最高的员工编号、姓名、薪资。    （5分）

```sql
SELECT
	EMPNO,
	ENAME,
	SAL
FROM emp
ORDER BY SAL DESC
LIMIT 1;
或
-- 建议写这个
SELECT
	EMPNO,
	ENAME,
	SAL
FROM emp
WHERE SAL = (SELECT MAX(SAL) FROM emp);
```

### 3. 窗口函数（每题10分，共30分）

**数据表介绍**： 

> 注意：下面的 3 张表都在 winfunc 数据库中

* 电影表(movie)：保存了电影相关的信息，字段如下：
  * id：电影ID 
  * title：电影名称 
  * release_year：上映年份 
  * genre：电影类型 
  * rating：电影的编辑评分(0-10) 
* ⽤户评分表(review)：包含了⽤户对电影的评分信息，字段如下： 
  * id：评分ID 
  * rating：具体评分(0-10) 
  * customer_id：评价⽤户ID
  * movie_id：被评价的电影ID
* ⽤户表(register)：保存注册⽤户的基本信息，字段如下： 
  * id：⽤户ID 
  * username：用户名 
  * join_date：注册⽇期 

1）第一题

> 需求：统计每部电影的编辑评分和同类型电影的平均编辑评分的差值
>
> 查询结果字段： 
>
> * title(电影名称)、editor_rating(电影编辑评分)、genre(电影类型)、difference(当前电影编辑评分和同类型电影平均编辑评分的差值)

```sql
# 你的答案
SELECT
	title,
	editor_rating,
	genre,
	editor_rating - AVG(editor_rating) OVER(PARTITION BY genre) AS `difference`
FROM movie;
```

2）第二题

> 需求：查询电影编辑评分排名第2的电影信息 
>
> 查询结果字段： 
>
> * id(电影ID)、title(电影名称)

```sql
# 你的答案
WITH ranking AS (
	SELECT
		id,
		title,
		DENSE_RANK() OVER(ORDER BY editor_rating DESC) AS `dense_rank`
	FROM movie
)
SELECT
	id,
	title
FROM ranking
WHERE `dense_rank` = 2;
```

3）第三题

> 需求：分析注册⽤户的情况，统计截止到每个月的注册用户数
>
> 查询结果字段： 
>
> * join_month(注册年月)、count(当月注册用户数)、running_total(截止当月累计注册用户数)

```sql
# 你的答案
WITH user_register AS (
    -- 添加注册年月列
    SELECT
        DATE_FORMAT(join_date, '%Y-%m') AS `join_month`,
        id,
        username
    FROM register
), month_register AS (
    -- 统计每个月的注册用户数
    SELECT
        join_month,
        COUNT(*) AS `count`
    FROM user_register
    GROUP BY join_month
)
SELECT
    join_month,
    count,
    SUM(count) OVER(
        ORDER BY join_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        -- 或 RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        -- 或 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW这句也可以没有，此处默认window frame也可以
    ) AS `running_total`
FROM month_register;
```

### 4. 表关联操作（共15分）

现有数据表结构如下：

* 班级表 t_class(class_id, class_name)
* 教师表 t_teacher(teac_id, teac_name)
* 学生表 t_student(stu_id, stu_name, class_id)
* 课程表 t_course(course_id, course_name, teac_id)
* 成绩表 t_score(stu_id, course_id, score)

查询"高三一班数学成绩(course_id=2)排序顺序第三名(连续不重复)的同学"，结果字段如下：

* class_name、stu_name、teac_name、course_name、score

```sql
# 你的答案
WITH ranking AS (
    SELECT
        t_class.class_name,
        t_student.stu_name,
    	t_teacher.teac_name,
        t_course.course_name,
        t_score.score,
        ROW_NUMBER() OVER(ORDER BY score DESC) AS `row_number`
    FROM t_student 
    JOIN t_score
    ON t_student.stu_id = t_score.stu_id
    JOIN t_class
    ON t_student.class_id = t_class.class_id
    JOIN t_course
    ON t_score.course_id = t_course.course_id
    JOIN t_teacher
    ON t_course.teac_id = t_teacher.teac_id
    WHERE class_name = "高三一班" AND course_id = 2
)
SELECT
	class_name,
	stu_name,
	teac_name,
	course_name,
	score
FROM ranking
WHERE `row_number` = 3;

或

SELECT
    t_class.class_name,
    t_student.stu_name,
    t_teacher.teac_name,
    t_course.course_name,
    t_score.score,
ROW_NUMBER() OVER(ORDER BY score DESC) AS `row_number`
FROM t_student 
JOIN t_score
ON t_student.stu_id = t_score.stu_id
JOIN t_class
ON t_student.class_id = t_class.class_id
JOIN t_course
ON t_score.course_id = t_course.course_id
JOIN t_teacher
ON t_course.teac_id = t_teacher.teac_id
WHERE class_name = "高三一班" AND course_id = 2
ORDER BY score DESC
LIMIT 2, 1;
```

### 5. 列转行操作（共10分）

现有一个数据表 tb_sales 数据如下：

```bash
year	month	amount
1991	1		1.1
1991	2		1.2
1991	3		1.3
1991	4		1.4
1992	1		2.1
1992	2		2.2
1992	3		2.3
1992	4		2.4
```

写一个 SQL 语句，将上表查询成下面的结果：

```
year	 m1	 m2	 m3	 m4
1991	1.1	1.2	1.3	1.4
1992	2.1	2.2	2.3	2.4
```

```sql
# 你的答案
SELECT
    year,
    SUM(CASE
        WHEN month=1 THEN amount
    END) AS `m1`,
    SUM(CASE
        WHEN month=2 THEN amount
    END) AS `m2`,
    SUM(CASE
        WHEN month=3 THEN amount
    END) AS `m3`,
    SUM(CASE
        WHEN month=4 THEN amount
    END) AS `m4`
FROM tb_sales
GROUP BY year;
```
