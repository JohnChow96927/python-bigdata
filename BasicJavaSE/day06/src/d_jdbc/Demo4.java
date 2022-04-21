package d_jdbc;

import utils.JDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Scanner;

/*
    解决SQL注入攻击问题, 采用PreparedStatement的预编译功能

    Connection接口的成员方法:
        public PreparedStatement prepareStatement(String sql);
           获取可以执行SQL语句的对象, 有预编译功能, 不会发生SQL注入攻击问题.
           PreparedStatement接口是Statement接口的子接口.

    预编译解释:
        即: 预先对SQL语句进行一次编译, 此时已经决定了SQL语句的格式, 把需要用户传入的内容用占位符替代即可, 预编译之后,
        不管用户传入什么内容, 都只会当做普通字符处理.

    细节:
        如果用PreparedStatement接口的预编译功能, 因为已经预先传入SQL语句了, 所以执行SQL语句的时候, 不需要额外传入SQL语句.
 */
public class Demo4 {
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
        Connection conn = JDBCUtils.getConnection();

        //2.3. 根据连接对象, 获取可以执行SQL语句的对象.
        String sql = "select * from users where username = ? and password=? ;";
        assert conn != null;
        PreparedStatement ps = conn.prepareStatement(sql);

        //给占位符填充值.
        ps.setString(1, uname);
        ps.setString(2, pwd);

        //2.4. 执行SQL语句, 获取结果集.
        //ResultSet rs = ps.executeQuery(sql);        //预编译之后, 不要再传入了, 否则报错.
        ResultSet rs = ps.executeQuery();

        //2.5. 操作结果集.
        System.out.println(rs.next() ? "登录成功" : "登录失败");

        //2.6. 释放资源.
        JDBCUtils.release(null, ps, conn);

    }
}
