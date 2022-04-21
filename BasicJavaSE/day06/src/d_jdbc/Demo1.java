package d_jdbc;

import com.mysql.cj.jdbc.Driver;
import org.junit.Test;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

/*
    案例: 演示JDBC入门案例.

    JDBC简介:
        概述:
            全称叫Java DataBase Connectivity, Java数据库连接, 就是通过Java代码操作不同的数据库.
        原理:
            由Sun公司提供统一的规则,规范(JDBC规范), 具体的实现和体现交给不同的数据库厂商来做.
            即: 我们要连接哪个数据库, 只要导入它的驱动(数据库厂商提供)即可.
        核心作用:
            1. 连接不同的数据库.
            2. 向数据库发送指令(SQL语句).
            3. 接收返回的结果集.
        JDBC入门案例:
            JDBC查询表数据.
        JDBC的核心步骤:
            0. 导入指定数据库的驱动(就是 jar包), 即: 连接哪个库, 就导入谁的驱动.
            1. 注册驱动.
            2. 获取连接对象.
            3. 根据连接对象, 获取可以执行SQL语句的对象.
            4. 执行SQL语句, 获取结果集.
            5. 操作结果集.
            6. 释放资源.

 */
public class Demo1 {
    @Test
    public void show1() throws Exception {
        // 1. 注册驱动
        DriverManager.registerDriver(new Driver());
        // 2. 获取连接对象
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/day06", "root", "123456");
        // 3. 根据连接对象, 获取可以执行SQL语句的对象
        Statement stat = conn.createStatement();
        // 4. 执行SQL语句, 获取结果集
        String sql = "select * from users;";
        ResultSet rs = stat.executeQuery(sql);
        // 5. 操作结果集
        while (rs.next()) {
            int uid = rs.getInt("uid");
            String username = rs.getString("username");
            String password = rs.getString("password");
            System.out.println(uid + ", " + username + ", " + password);
        }

        // 6. 释放资源
        rs.close();
        stat.close();
        conn.close();
    }

    @Test
    public void show2() throws Exception {
        // 1. 反射注册驱动Driver
        Class.forName("com.mysql.jdbc.Driver");

        // 2. 获取连接对象
        Connection conn = DriverManager.getConnection("jdbc:mysql:///day06", "root", "123456");

        // 3. 获取连接对象, 获取可以执行SQL语句的对象
        Statement stat = conn.createStatement();

        // 4. 执行SQL语句, 获取结果集
        String sql = "select * from users;";
        ResultSet resultSet = stat.executeQuery(sql);

        //5. 操作结果集.
        while (resultSet.next()) {      //类似于Iterator#hasNext()
            int uid = resultSet.getInt("uid");
            String username = resultSet.getString("username");
            String password = resultSet.getString("password");
            System.out.println(uid + ", " + username + ", " + password);
        }
        //6. 释放资源.
        resultSet.close();
        stat.close();
        conn.close();
    }

    @Test
    public void show3() throws Exception {
        //1. 注册驱动.
        Class.forName("com.mysql.jdbc.Driver");

        //2. 获取连接对象.
        Connection conn = DriverManager.getConnection("jdbc:mysql:///day06", "root", "123456");

        //3. 根据连接对象, 获取可以执行SQL语句的对象.
        Statement stat = conn.createStatement();
        //4. 执行SQL语句, 获取结果集.
        String sql = "select username, uid, password from users;";
        ResultSet rs = stat.executeQuery(sql);


        //5. 操作结果集.
        while (rs.next()) {
            //方式1: 根据列的编号获取.
            /*int uid = rs.getInt(1);
            String username = rs.getString(2);
            String password = rs.getString(3);*/

            //方式2: 根据列的名字获取.
            int uid = rs.getInt("uid");
            String username = rs.getString("username");
            String password = rs.getString("password");
            System.out.println(uid + ", " + username + ", " + password);
        }


        //6. 释放资源.
        rs.close();
        stat.close();
        conn.close();
    }
}
