package a_date;

import utils.DateUtils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class D_Date_Utils_3 {
    public static void main(String[] args) throws ParseException {
        // 目标1: 将时间戳 转成 指定格式的时间字符串
        long timestamp = 1650245131000L;
        // 分解式
        Date d1 = new Date(timestamp);

        //System.out.println(d1);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String result = sdf.format(d1);

        // 合并式
        String result2 = DateUtils.timestamp2datestr(timestamp);

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
        long timestamp3 = DateUtils.datestr2timestamp(str);
        // System.out.println(timestamp3);

        // 问题1:
        String str2 = "2022/04/18 09:25:31";
        long timestamp5 = DateUtils.datestr2timestamp(str2, "yyyy/MM/dd HH:mm:ss");
        System.out.println(timestamp5);

        // 问题2: 想根据时间戳 要 时分秒
        long timestamp6 = 1650245131000L;
        String datestr6 = DateUtils.timestamp2datestr(timestamp6, "yyyy-MM-dd");
        System.out.println(datestr6);
    }
}
