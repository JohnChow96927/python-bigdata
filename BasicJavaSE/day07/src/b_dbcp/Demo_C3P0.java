package b_dbcp;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import utils.C3P0Utils;
import utils.JDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Demo_C3P0 {
    public static void main(String[] args) throws SQLException {
        // 创建数据库连接池对象, 它会自动去src目录下读取配置信息
        ComboPooledDataSource cpds = new ComboPooledDataSource();
        // 获取连接对象
        Connection conn = C3P0Utils.getConnection();
        // 执行sql
        String sql = "insert into users values (null, ?, ?)";
        PreparedStatement preparedStatement = conn.prepareStatement(sql);
        preparedStatement.setString(1, "zzy");
        preparedStatement.setString(2, "123456");
        int i = preparedStatement.executeUpdate();
        System.out.println("影响的函数: " + i);
        ResultSet rs = null;
        JDBCUtils.release(rs, preparedStatement, conn);
    }
}
