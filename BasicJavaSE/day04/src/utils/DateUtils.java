package utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {
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
