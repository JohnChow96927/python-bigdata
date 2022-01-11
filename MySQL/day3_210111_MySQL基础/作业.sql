USE winfunc;


SELECT *
FROM emp
WHERE deptno = (
    SELECT deptno
    FROM dept
    WHERE dname = 'SALES'
);

SELECT *
FROM emp
WHERE salary > (
    SELECT AVG(salary)
    FROM emp
);

SELECT *,
       (
           SELECT AVG(salary)
           FROM emp) `avg_salary`,
       salary - (
           SELECT AVG(salary)
           FROM emp
       )             `difference`
FROM emp;


SELECT *,
       AVG(salary) OVER () `avg_salary`,
       salary - AVG(salary) OVER () `difference`
FROM emp;

SELECT *,
       AVG(salary) OVER (PARTITION BY deptno) `dept_avg_salary`,
       salary - AVG(salary) OVER (PARTITION BY deptno) `difference`
FROM emp;


SELECT *,
       DENSE_RANK() OVER (ORDER BY salary DESC) `dense_rank`
FROM emp;


SELECT *
FROM (SELECT *,
             DENSE_RANK() OVER (
                 PARTITION BY deptno
                 ORDER BY salary DESC) `dense_rank`
    FROM emp
         ) `d`
WHERE `dense_rank` = 1;

WITH ranking AS (
    SELECT *,
           DENSE_RANK() over (
               PARTITION BY deptno
               ORDER BY salary DESC ) `dense_rank`
    FROM emp
)
SELECT empno,
       empname,
       job,
       hiredate,
       salary,
       deptno
FROM ranking
WHERE `dense_rank` = 1;

SELECT department_id,
       `year`,
       amount,
       SUM(amount) OVER (
           PARTITION BY `year`
           ORDER BY `year`
           ROWS 2 PRECEDING
           ) `sum`
FROM revenue
WHERE department_id = 2;

SELECT department_id,
       `year`,
       amount,
       AVG(amount) OVER (
           PARTITION BY `department_id`
           ORDER BY `year`
           ) `avg`
FROM revenue
WHERE department_id = 1;