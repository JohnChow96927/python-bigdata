-- 建表
-- 学生表
CREATE TABLE `Student`
(
    `s_id`    VARCHAR(20),
    `s_name`  VARCHAR(20) NOT NULL DEFAULT '',
    `s_birth` VARCHAR(20) NOT NULL DEFAULT '',
    `s_sex`   VARCHAR(10) NOT NULL DEFAULT '',
    PRIMARY KEY (`s_id`)
);
-- 课程表
CREATE TABLE `Course`
(
    `c_id`   VARCHAR(20),
    `c_name` VARCHAR(20) NOT NULL DEFAULT '',
    `t_id`   VARCHAR(20) NOT NULL,
    PRIMARY KEY (`c_id`)
);
-- 教师表
CREATE TABLE `Teacher`
(
    `t_id`   VARCHAR(20),
    `t_name` VARCHAR(20) NOT NULL DEFAULT '',
    PRIMARY KEY (`t_id`)
);
-- 成绩表
CREATE TABLE `Score`
(
    `s_id`    VARCHAR(20),
    `c_id`    VARCHAR(20),
    `s_score` INT(3),
    PRIMARY KEY (`s_id`, `c_id`)
);
-- 插入学生表测试数据
insert into Student
values ('01', '赵雷', '1990-01-01', '男');
insert into Student
values ('02', '钱电', '1990-12-21', '男');
insert into Student
values ('03', '孙风', '1990-05-20', '男');
insert into Student
values ('04', '李云', '1990-08-06', '男');
insert into Student
values ('05', '周梅', '1991-12-01', '女');
insert into Student
values ('06', '吴兰', '1992-03-01', '女');
insert into Student
values ('07', '郑竹', '1989-07-01', '女');
insert into Student
values ('08', '王菊', '1990-01-20', '女');
-- 课程表测试数据
insert into Course
values ('01', '语文', '02');
insert into Course
values ('02', '数学', '01');
insert into Course
values ('03', '英语', '03');

-- 教师表测试数据
insert into Teacher
values ('01', '张三');
insert into Teacher
values ('02', '李四');
insert into Teacher
values ('03', '王五');

-- 成绩表测试数据
insert into Score
values ('01', '01', 80);
insert into Score
values ('01', '02', 90);
insert into Score
values ('01', '03', 99);
insert into Score
values ('02', '01', 70);
insert into Score
values ('02', '02', 60);
insert into Score
values ('02', '03', 80);
insert into Score
values ('03', '01', 80);
insert into Score
values ('03', '02', 80);
insert into Score
values ('03', '03', 80);
insert into Score
values ('04', '01', 50);
insert into Score
values ('04', '02', 30);
insert into Score
values ('04', '03', 20);
insert into Score
values ('05', '01', 76);
insert into Score
values ('05', '02', 87);
insert into Score
values ('06', '01', 31);
insert into Score
values ('06', '03', 34);
insert into Score
values ('07', '02', 89);
insert into Score
values ('07', '03', 98);

-- 1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数
SELECT st.*,
       sc.s_score  '语文',
       sc2.s_score '数学'
FROM Student st
         LEFT JOIN Score sc ON sc.s_id = st.s_id AND sc.c_id = '01'
         LEFT JOIN Score sc2 ON sc2.s_id = st.s_id and sc2.c_id = '02'
WHERE sc.s_score > sc2.s_score;

-- 2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数
SELECT st.*,
       sc.s_score  `01课程成绩`,
       sc2.s_score `02课程成绩`
FROM Student st
         LEFT JOIN Score sc on st.s_id = sc.s_id AND sc.c_id = '01'
         LEFT JOIN Score sc2 ON sc2.s_id = st.s_id AND sc2.c_id = '02'
WHERE sc.s_score < sc2.s_score
;

-- 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
WITH temp_tb AS (SELECT DISTINCT s.s_id                                                `学生编号`,
                                 s.s_name                                              `学生姓名`,
                                 ROUND(AVG(sc.s_score) OVER (PARTITION BY sc.s_id), 2) `平均成绩`
                 FROM Student s
                          JOIN Score sc on s.s_id = sc.s_id)
SELECT *
FROM temp_tb
WHERE 平均成绩 >= 60
;


-- 4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩
-- (包括有成绩的和无成绩的)
WITH temp_tb AS (SELECT DISTINCT s.s_id                                                    `学生编号`,
                                 s.s_name                                                  `学生姓名`,
                                 IF(ROUND(AVG(sc.s_score) OVER (PARTITION BY sc.s_id), 2) IS NULL, 0,
                                    ROUND(AVG(sc.s_score) OVER (PARTITION BY sc.s_id), 2)) `平均成绩`
                 FROM Student s
                          JOIN Score sc on s.s_id = sc.s_id)
SELECT *
FROM temp_tb
WHERE 平均成绩 < 60
   OR 平均成绩 = 0
;


-- 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩
SELECT st.s_id                                  `学生编号`,
       st.s_name                                `学生姓名`,
       COUNT(S.c_id)                            `选课总数`,
       SUM(IF(S.s_score IS NULL, 0, S.s_score)) `课程总成绩`
FROM Student st
         LEFT JOIN Score S on st.s_id = S.s_id
GROUP BY st.s_id, st.s_name;

-- 6、查询"李"姓老师的数量
SELECT COUNT(*)
FROM Teacher
WHERE t_name LIKE '李%'
;

-- 7、查询学过"张三"老师授课的同学的信息
SELECT st.*
FROM Student st
         LEFT JOIN Score S on st.s_id = S.s_id
         LEFT JOIN Course C on S.c_id = C.c_id
         LEFT JOIN Teacher T on C.t_id = T.t_id
WHERE T.t_name = '张三';

-- 8、查询没学过"张三"老师授课的同学的信息
