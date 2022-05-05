package com.johnchow.phoenix;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class PhoenixJdbcDemo {
    public static void main(String[] args) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet result = null;
        try {
            // 加载驱动类
            Class.forName("org.apache.phoenix.jdbc.PhoenixDriver");
            // 获取连接
            conn = DriverManager.getConnection("jdbc:phoenix:node1.itcast.cn,node2.itcast.cn,node3.itcast.cn:2181");

            // 创建statement对象
            pstmt = conn.prepareStatement("SELECT USER_ID, PAYWAY, CATEGORY FROM ORDER_INFO LIMIT 10");

            // 执行操作
            result = pstmt.executeQuery();

            // 获取数据
            while (result.next()) {
                String userId = result.getString("USER_ID");
                String payway = result.getString("PAYWAY");
                String category = result.getString("CATEGORY");
                System.out.println(userId + ", " + payway + ", " + category);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 关闭连接(栈式退出)
            if (null != result) result.close();
            if (null != pstmt) pstmt.close();
            if (null != conn) conn.close();
        }
    }
}
