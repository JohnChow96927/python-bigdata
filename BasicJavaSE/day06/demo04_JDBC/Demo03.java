package cn.itcast.demo04_JDBC;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Scanner;

/*
    案例: 演示SQL注入攻击问题.

    SQL注入攻击问题:
		概述:
			指的是如果我们的SQL语句中部分代码是要求用户录入的, 当用户录入一些非法字符或者非法值的时候,
			被我们的SQL语句识别了, 从而改变了SQL语句的结构, 就会引发一系列的安全问题, 这些安全问题就叫:
			SQL注入攻击问题.
*/
public class Demo03 {
    public static void main(String[] args) throws Exception {
        //1. 提示用户录入账号和密码, 并接收.
        Scanner sc = new Scanner(System.in);
        System.out.println("请录入您的账号: ");
        String uname = sc.nextLine();
        System.out.println("请录入您的密码: ");
        String pwd = sc.nextLine();

        //2. 判断用户是否登录成功.
        //2.1. 注册驱动.
        //2.2. 获取连接对象.
        Connection conn = JDBC.getConnection();
        //2.3. 根据连接对象, 获取可以执行SQL语句的对象.
        Statement stat = conn.createStatement();

        //2.4. 执行SQL语句, 获取结果集.
        String sql = "select * from users where username = '" + uname + "' and password = '" + pwd + "';";
        ResultSet rs = stat.executeQuery(sql);

        //2.5. 操作结果集.
        System.out.println(rs.next() ? "登录成功" : "登录失败");

        //2.6. 释放资源.
        JDBCUtils.release(null, stat, conn);
    }
}
