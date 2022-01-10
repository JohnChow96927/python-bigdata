CREATE DATABASE IF NOT EXISTS itcast_demo;

USE itcast_demo;

CREATE TABLE t_user(
    id INT PRIMARY KEY AUTO_INCREMENT,
    gender CHAR(4),
    username VARCHAR(20),
    password VARCHAR(20)
);

INSERT INTO t_user(gender, username, password)
values
       ('男', 'zhangsan', '123123'),
       ('女', 'lisi', '000000'),
       ('男', 'wangwu', '000000');

SELECT username
FROM t_user
WHERE gender = '男';

SELECT
gender '性别',
COUNT(*) '人数'
FROM t_user
GROUP BY gender;

CREATE DATABASE IF NOT EXISTS db_student;

USE db_student;

CREATE TABLE IF NOT EXISTS  student(
    Id INT(10) PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(20) NOT NULL,
    Sex VARCHAR(4),
    Birth YEAR,
    Department VARCHAR(20) NOT NULL,
    Address VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Score(
    Id INT(10) PRIMARY KEY AUTO_INCREMENT,
    Stu_id INT(10) NOT NULL,
    C_name VARCHAR(20),
    Grade INT(10)
);

INSERT INTO student VALUES
                           (901, '张老大', '男', 1985, '计算机系', '北京市海淀区'),
                           (902, '张老二', '男', 1986, '中文系', '北京市昌平区'),
                           (903, '张三', '女', 1990, '中文系', '湖南省永州市'),
                           (904, '李四', '男', 1990, '英语系', '辽宁省阜新市'),
                           (905, '王五', '女', 1991, '英语系', '福建省厦门市'),
                           (906, '王六', '男', 1988, '计算机系', '湖南省衡阳市');

INSERT INTO Score(Stu_id, C_name, Grade) VALUES
                                                (901, '计算机', 98),
                                                (901, '英语', 80),
                                                (902, '计算机', 65),
                                                (902, '中文', 88),
                                                (903, '中文', 95),
                                                (904, '计算机', 70),
                                                (904, '英语', 92),
                                                (905, '英语', 94),
                                                (906, '计算机', 90),
                                                (906, '英语', 85);

SELECT
Department, COUNT(*)
FROM student
GROUP BY Department;

SELECT
C_name, MAX(Grade)
FROM Score
GROUP BY C_name;

SELECT
C_name, AVG(Grade)
FROM Score
GROUP BY C_name;

SELECT
Id, Stu_id, C_name, Grade
FROM Score
WHERE
C_name = '计算机'
ORDER BY Grade DESC;

CREATE DATABASE IF NOT EXISTS db_emp;

USE db_emp;

CREATE TABLE IF NOT EXISTS emp(
    empno INT PRIMARY KEY,
    empname VARCHAR(10) NOT NULL,
    job VARCHAR(10) NOT NULL,
    manager INT,
    hiredate DATE,
    salary DOUBLE,
    comm DOUBLE,
    deptno INT
);

CREATE TABLE IF NOT EXISTS dept(
    deptno INT PRIMARY KEY,
    dname VARCHAR(20) NOT NULL,
    loc VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS salgrade(
    grade INT PRIMARY KEY,
    losal DOUBLE,
    hisal DOUBLE
);

INSERT INTO emp VALUES (7369, 'SMITH', 'CLERK', 7902, '1980-12-17', 800, NULL, 20);
INSERT INTO emp VALUES (7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 1600, 300, 30);
INSERT INTO emp VALUES (7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250, 500, 30);
INSERT INTO emp VALUES (7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975, NULL, 20);
INSERT INTO emp VALUES (7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250, 1400, 30);
INSERT INTO emp VALUES (7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850, NULL, 30);
INSERT INTO emp VALUES (7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450, NULL, 10);
INSERT INTO emp VALUES (7788, 'SCOTT', 'ANALYST', 7566, '1987-07-03', 3000, NULL, 20);
INSERT INTO emp VALUES (7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000, NULL, 10);
INSERT INTO emp VALUES (7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 1500, NULL, 30);
INSERT INTO emp VALUES (7876, 'ADAMS', 'CLERK', 7788, '1987-07-13', 1100, NULL, 20);
INSERT INTO emp VALUES (7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 950, NULL, 30);
INSERT INTO emp VALUES (7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000, NULL, 20);
INSERT INTO emp VALUES (7934, 'MILLER', 'CLERK', 7782, '1981-01-23', 1300, NULL, 10);

INSERT INTO dept VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO dept VALUES (20, 'RESEARCH', 'DALLAS');
INSERT INTO dept VALUES (30, 'SALES', 'CHICAGO');
INSERT INTO dept VALUES (40, 'OPERATIONS', 'BOSTON');


INSERT INTO salgrade VALUES (1, 700, 1200);
INSERT INTO salgrade VALUES (2, 1200, 1400);
INSERT INTO salgrade VALUES (3, 1400, 2000);
INSERT INTO salgrade VALUES (4, 2000, 3000);
INSERT INTO salgrade VALUES (5, 3000, 19999);

SELECT empno, empname, job, manager, hiredate, salary, comm, deptno
FROM emp
ORDER BY job DESC , salary;

SELECT job, COUNT(*)
FROM emp
GROUP BY job
ORDER BY COUNT(*) DESC;

SELECT job, MAX(salary)
FROM emp
GROUP BY job;

SELECT empno, empname, job, manager, hiredate, salary, comm, emp.deptno, dname
FROM emp
LEFT JOIN dept d
ON emp.deptno = d.deptno;

SELECT
    e.empname, leader.empname
FROM emp e
LEFT JOIN emp leader
ON e.manager = leader.empno;