package com.johnchow.flink.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

/**
 * 基于JDBC方式写入数据到MySQL数据库表中
 */
public class MySQLJdbcWriteTest {

    public static void main(String[] args) throws Exception {
        // step1、加载驱动
        Class.forName("com.mysql.jdbc.Driver");
        // step2、获取连接Connection
        Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/?useSSL=false",
                "root",
                "123456"
        );
        // step3、创建Statement对象，设置语句（INSERT、SELECT）
        PreparedStatement pstmt = conn.prepareStatement("INSERT INTO db_flink.t_student(id, name, age) VALUES (?, ?, ?)");
        // step4、执行操作
        pstmt.setInt(1, 99);
        pstmt.setString(2, "Jetty");
        pstmt.setInt(3, 28);
        pstmt.executeUpdate();
        // step5、关闭连接
        pstmt.close();
        conn.close();
    }

}