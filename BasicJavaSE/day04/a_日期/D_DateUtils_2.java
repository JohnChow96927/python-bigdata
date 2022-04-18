package cn.itcast.day04.a_日期;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class D_DateUtils_2 {
    public static void main(String[] args) throws Exception {
        // 目标1: 将时间戳 转成 指定格式的时间字符串
        long timestamp = 1650245131000L;
        // 分解式
        Date d1 = new Date(timestamp);

        //System.out.println(d1);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String result = sdf.format(d1);

        // 合并式
        String result2 = timestamp2datestr(timestamp);

        // System.out.println(result);
        // System.out.println(result2);

        // 目标2: 将指定格式的时间字符串 转成 时间戳
        String str = "2022-04-18 09:25:31";

        // 分解式
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date d2 = sdf2.parse(str);
        long timestamp2 = d2.getTime();
        // System.out.println(timestamp2);

        // 合并式
        long timestamp3 = datestr2timestamp(str);
        // System.out.println(timestamp3);

        // 问题1:
        String str2 = "2022/04/18 09:25:31";
        long timestamp5 = datestr2timestamp(str2, "yyyy/MM/dd HH:mm:ss");
        System.out.println(timestamp5);

        // 问题2: 想根据时间戳 要 时分秒
        long timestamp6 = 1650245131000L;
        String datestr6 = timestamp2datestr(timestamp6, "yyyy-MM-dd");
        System.out.println(datestr6);

    }

    // 目标: 将日期字符串 转成 时间戳
    public static long datestr2timestamp(String str) throws ParseException {
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(str).getTime();
    }

    // 目标2: 将日期字符串 转成 时间戳
    public static long datestr2timestamp(String str, String pattern) throws ParseException {
        return new SimpleDateFormat(pattern).parse(str).getTime();
    }

    // 目标: 将时间戳 转成 日期字符串
    public static String timestamp2datestr(long timestamp) {
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(timestamp));
    }

    // 目标: 将时间戳 转成 日期字符串
    public static String timestamp2datestr(long timestamp, String pattern) {
        return new SimpleDateFormat(pattern).format(new Date(timestamp));
    }
}
