package a_date;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class B_Simple_Date_Format {
    public static void main(String[] args) throws ParseException {
        // 目标1: 将目标Date对象转化成想要的字符串
        Date d1 = new Date();
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss_SSS");
        String formatDateStr = simpleDateFormat.format(d1);
        System.out.println(formatDateStr);

        // 目标2: 将日期字符串转换成想要的日期对象
        String targetStr = "2022-10-01_10/20/30";
        SimpleDateFormat simpleDateFormat1 = new SimpleDateFormat("yyyy-MM-dd_HH/mm/ss");
        Date d2 = simpleDateFormat1.parse(targetStr);
        System.out.println(d2);
    }
}
