package c_transaction;

import utils.JDBCUtils;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

/*
事务介绍:
    概述: 事务指的是逻辑上的一组操作, 组成该操作各个逻辑单元, 要么全部执行成功, 要么全部执行失败
    特征(ACID):
        1. 原子性: 指的就是组成事务的各个逻辑单元已经是最小单位, 且不可分割
        2. 一致性: 指的是事务执行前后, 数据要保持一致
        3. 隔离性: 指的是事务执行的时候, 不应该受到其他事务的影响
        4. 持久性: 无论是否执行成功, 结果都会永久的储存到数据表中
    如果考虑隔离性, 程序会发生如下问题:
        脏读: 一个事务读取到另外一个事务未提交的数据, 导致多次查询结果不一致
        不可重复读: 一个事务读取到了另外一个事务已经提交(update)的数据, 导致一个事务中多次查询结果不一致
        虚读/幻读: 一个事务读取到了另一个事务已经提交(insert)的数据, 导致一个事务中多次查询结果不一致
    隔离级别:
        read uncommitted: 读未提交, 一个事务督导另一个事务没有提交的数据
        read committed: 读已提交, 一个事务读到另一个事务已经提交的数据
        repeatable read: 可重复读, 在一个事务中读到的数据始终保持一致, 无论事务是否提交
        serializable: 串行化, 同时只能执行一个事务, 相当于事务中的单线程
        安全性：serializable > repeatable read > read committed > read uncommitted
        性能： serializable < repeatable read < read committed < read uncommitted

 */
public class Demo1 {
    public static void main(String[] args) {
        Connection conn = null;
        Statement statement = null;
        try {
            // 1. 获取连接对象
            conn = JDBCUtils.getConnection();
            // 2. 获取可以执行SQL语句的对象
            statement = conn.createStatement();
            // 3. 执行SQL语句, 获取结果集
            String sql1 = "update account set money = money - 1000 where id = 1;";
            String sql2 = "update account set money = money + 1000 where id = 2;";
            // 3.1. 关闭事务的提交功能(默认是开启)
            conn.setAutoCommit(false);
            // 3.2. 执行sql语句
            int line_num1 = statement.executeUpdate(sql1);
            int line_num2 = statement.executeUpdate(sql2);
            // 3.3. 操作结果集
            if (line_num1 + line_num2 == 2) {
                System.out.println("转账成功");
                // 3.4. 提交事务
                conn.commit();
            }
            // 4. 如果提交有异常, 则回滚
            // 5. 释放资源

        } catch (Exception e) {
            try {
                conn.rollback();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        } finally {
            JDBCUtils.release(null, statement, conn);
            System.out.println("资源已释放");
        }
    }
}