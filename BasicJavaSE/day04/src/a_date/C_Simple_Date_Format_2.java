package a_date;

import java.text.SimpleDateFormat;
import java.util.Date;

public class C_Simple_Date_Format_2 {
    public static void main(String[] args) throws Exception {
        // 问题: 默认日期对象的格式不是需求的
        Date d1 = new Date();
        System.out.println(d1);
        // 目标1: 将日期Date对象转化成想要的字符串
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat();
        String formatDateStr = simpleDateFormat.format(d1);
        System.out.println(formatDateStr);

        // 目标2: 将日期字符串转成想要的日期对象
        String targetStr = "22-4-18 上午9:45";
        SimpleDateFormat simpleDateFormat1 = new SimpleDateFormat();
        Date d2 = simpleDateFormat1.parse(targetStr);
        System.out.println(d2);
    }
}
