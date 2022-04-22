package a_jdbc;

import utils.JDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;

/*
使用预编译进行数据库修改操作(CRUD)
 */
public class Demo1 {
    public static void main(String[] args) throws Exception {
        Connection conn = JDBCUtils.getConnection();
        String sql = "insert into users values(?, ?, ?);";
        PreparedStatement preparedStatement = conn.prepareStatement(sql);
        preparedStatement.setInt(1, 5);
        preparedStatement.setString(2, "正元");
        preparedStatement.setString(3, "123456");
        int result = preparedStatement.executeUpdate();
        System.out.println(result > 0 ? "添加成功" : "添加失败");
        JDBCUtils.release(null, preparedStatement, conn);
    }
}
