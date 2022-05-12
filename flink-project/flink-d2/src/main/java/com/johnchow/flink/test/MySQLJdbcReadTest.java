package com.johnchow.flink.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MySQLJdbcReadTest {
    public static void main(String[] args) throws Exception {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/?useSSL=false",
                "root",
                "123456"
        );
        PreparedStatement pstmt = conn.prepareStatement("SELECT id, name, age FROM db_flink.t_student");
        ResultSet result = pstmt.executeQuery();
        while (result.next()) {
            int stuId = result.getInt("id");
            String stuName = result.getString("name");
            int stuAge = result.getInt("age");
            System.out.println("id = " + stuId + ", name = " + stuName + ", age = " + stuAge);
        }
        result.close();
        pstmt.close();
        conn.close();
    }
}
