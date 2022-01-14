## I. MySQL常用内置函数

1. ### 时间日期函数

    - ##### 获取当前时间的函数

    ```mysql
    -- 1. 获取当前时间
    
    -- 获取当前datetime类型的时间
    SELECT NOW();
    
    -- 获取当前date类型的时间
    SELECT CURRENT_DATE();
    
    -- 获取当前time类型的时间
    SELECT CURRENT_TIME();
    
    -- 获取当前操作系统时间
    SELECT SYSDATE();
    
    -- NOW()和SYSDATE()对比: NOW不变, SYSDATE动态变化
    SELECT NOW(), SLEEP(2), NOW();
    SELECT SYSDATE(), SLEEP(2), SYSDATE();
    ```

    - ##### 计算时间差的相关函数

    ```mysql
    -- 2. 计算时间差
    
    -- 计算指定间隔的时间日期
    SELECT DATE_ADD('2007-9-27', INTERVAL 90 DAY );
    
    -- 示例：获取当前时间3个小时以前的时间
    SELECT DATE_ADD(NOW(), INTERVAL -3 HOUR);
    
    -- 计算两个时间日期之间的天数差
    SELECT DATEDIFF('2021-03-22 09:00:00', '2018-03-20 07:00:00');
    
    -- 计算两个时间日期之间的时间差(自定义时间单位)
    SELECT TIMESTAMPDIFF(MONTH, '2021-03-22 09:00:00', '2018-03-20 07:00:00');
    
    -- 示例：使用TIMESTAMPDIFF函数计算当前时间距离1989年3月9日有多少天
    SELECT TIMESTAMPDIFF(DAY, '1989-03-09', NOW());
    ```

    - ##### 获取年月日的函数

    ```mysql
    -- 3. 提取时间日期中的年月日
    
    -- 获取当前日期中的年份
    SELECT YEAR(NOW());
    
    -- 获取2021-10-02 09:00中月份
    SELECT MONTH('2021-10-02 09:00');
    
    -- 获取时间日期中的日
    SELECT DAY('2021-10-02 09:00');
    
    -- 提取时间日期中的时分秒
    -- 分别运行下面的SQL语句
    SELECT HOUR('2021-10-02 09:01:30');
    SELECT MINUTE('2021-10-02 09:01:30');
    SELECT SECOND('2021-10-02 09:01:30');
    
    -- 计算时间日期是星期几(0是周一，1是周二，依次类推)'
    SELECT WEEKDAY('2021-12-03');
    ```

    - ##### 时间转换函数

    ```mysql
    -- 4. 时间日期转换
    
    -- 时间格式化(时间转字符串)
    SELECT DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i:%s');
    SELECT DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i');
    SELECT DATE_FORMAT(NOW(),'%Y年%m月%d日 %H时%i分%s秒');
    
    -- 字符串转时间
    SELECT STR_TO_DATE('2021-01-20 16:01:45', '%Y-%m-%d %H:%i:%s');
    SELECT STR_TO_DATE('2021-01-20 16:01:45', '%Y-%m-%d');
    
    -- 时间或字符串转时间戳
    -- 时间戳是一个数字，代表距1970-01-01 00:00:00的秒数(UTC时区,与数据库配置时的时区有关)
    SELECT UNIX_TIMESTAMP(NOW());
    select UNIX_TIMESTAMP('2012-12-20');
    
    -- 时间戳转字符串
    select FROM_UNIXTIME(1355932800, '%Y-%m-%d');
    ```

    重点函数: NOW(), DATE_ADD(), DATEDIFF(), YEAR(), MONTH(), DAY()

2. ### 字符串函数

    - 大小写转换, 反转

    ```mysql
    -- 1. 大小写转换
    -- 转换为小写
    SELECT LOWER('Hello World!');
    
    -- 转换为大写
    SELECT UPPER('Hello World!');
    
    -- 2. 字符串反转
    SELECT REVERSE('123456');
    ```

    - 字符串拼接, 局部替换

    ```mysql
    -- 3. 字符串拼接
    -- 多个相同字符串拼接
    SELECT REPEAT('象飞田', 3);
    
    -- 字符串拼接
    SELECT CONCAT('马走日', '象飞田');
    SELECT CONCAT(10.15, '%');
    
    -- 指定分隔符拼接字符串
    SELECT CONCAT_WS('^_^', '马走日', '象飞田');
    
    -- 4. 字符串替换
    SELECT REPLACE('赢赢赢士角炮巡河车赢', '赢', '');
    SELECT REPLACE('赢赢赢士角炮巡河车赢', '赢', '输');
    ```

    - 获取子串, 截取, 计算字符个数

    ```mysql
    -- 5. 字符串截取
    -- SUBSTR(str, n, m)：从 str 字符串的第 n 个字符(注意：n不是下标)往后截取 m 个字符，返回子串；m可省略，表示截取到末尾。
    SELECT SUBSTR('五七炮屏风马', 3, 1);
    SELECT SUBSTR('五七炮屏风马', 4);
    SELECT SUBSTRING('五七炮屏风马', 4, 3); -- SUBSTRING与SUBSTR相同
    
    
    -- 从左或右截取n个字符
    SELECT LEFT('仙人指路，急进中兵', 4);
    SELECT RIGHT('仙人指路，急进中兵', 4);
    
    -- 5. 字符串长度和存储大小
    
    SELECT CHAR_LENGTH('仙人指路，急进中兵');
    SELECT LENGTH('仙人指路，急进中兵'); -- utf8编码格式一个中文占3个字节
    ```

3. ### 数学函数

    ```mysql
    -- ROUND(X, n)：对 X 进行四舍五入，保留 n 位小数，默认n为0
    SELECT ROUND(1.6);
    SELECT ROUND(1.333, 2);
    SELECT ROUND(2.689, 2);
    
    -- FORMAT(X, n)：对 X 进行四舍五入，保留 n 位小数，以##,###,###.###格式显示
    SELECT FORMAT(1001.6, 2);
    SELECT FORMAT(123456.333, 2);
    SELECT FORMAT(234567.689, 2);
    
    -- FLOOR(x)：向下取整
    SELECT FLOOR(-1.5);
    
    -- CEIL(X)：向上取整
    SELECT CEIL(2.1);
    
    -- GREATEST(expr1, expr2, expr3, ...)：返回列表中的最大值
    SELECT GREATEST(3, 12, 34, 8, 25);
    
    -- LEAST(expr1, expr2, expr3, ...)：返回列表中的最小值
    SELECT LEAST(3, 12, 34, 8, 25);
    ```

## II. 事务vs索引

1. ### 事务

    **事务应用场景**: 一组SQL操作, 同时成功或同时失败, 比如: 转账

    ##### 转账基本流程: 

    1. 开启事务
    2. 减少转出账户余额
    3. 增加转入账户余额
    4. 提交事务

    ##### 事务四大特性: ACID

    - Atomicity原子性: 原子是最小单位, 说明事务是一个整体, 不会部分成功部分失败
    - Consistency一致性: 事务保存数据库总一个一致性状态转移到另一个一致性状态
    - Isolation隔离性: 一个事务提交之前对另一个事务是不可见的
    - Durability持久性: 事务一旦提交, 结果便会被永久保存

2. ### 索引

    加快数据查询效率

## III. PyMySQL模块

1. ### 模块简介

    > ```python
    > pip install pymysql==1.0.2
    > ```

2. ### 查询操作

    

3. ### 增删改操作

    

    

