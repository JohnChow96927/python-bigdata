package cn.itcast.day04.b_异常;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Demo03_无论是否报异常都要释放资源 {
    public static void main(String[] args)  {
        String str = "2020-09-08";

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        try {
            Date d1 = sdf.parse(str); // 报错了, 需要立刻处理这个异常
            int j = 1/0;
            System.out.println("一切正常 ... ...");
        } catch (Exception e) {
            System.out.println("出现了问题  ... ...");
            e.printStackTrace();
        } finally {
            System.out.println("释放资源... ...");
        }

        System.out.println("666666666666666666");

    }
}
