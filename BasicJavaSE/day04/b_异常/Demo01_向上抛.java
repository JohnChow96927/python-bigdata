package cn.itcast.day04.b_异常;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Demo01_向上抛  {
    public static void main(String[] args) throws Exception {
        String str = "2020-09/08";

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        Date d1 = sdf.parse(str); // 报错了, 需要立刻处理这个异常

        System.out.println("8888888888888888888");

    }
}
