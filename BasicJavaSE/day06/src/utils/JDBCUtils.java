package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

//自定义的工具类, 操作JDBC的.
public class JDBCUtils {
    //1. 构造方法私有化.
    private JDBCUtils() {
    }

    //2. 定义成员变量, 记录数据库连接的一些值.
    private static final String driverName = "com.mysql.jdbc.Driver";
    private static final String url = "jdbc:mysql:///day06";
    private static final String username = "root";
    private static final String pasword = "123456";

    //3. 注册驱动
    static {    //静态代码块, 随着类的加载而加载
        try {
            Class.forName(driverName);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    //4. 提供方法, 获取连接对象.
    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(url, username, pasword);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }

        //如果有问题, 就返回null
        return null;
    }

    //5. 提供方法, 释放资源.
    public static void release(ResultSet rs, Statement stat, Connection conn) {
        try {
            if (rs != null) {
                rs.close();
                rs = null;   //GC会优先回收null对象.
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (stat != null) {
                    stat.close();
                    stat = null;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                try {
                    if (conn != null) {
                        conn.close();
                        conn = null;
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
