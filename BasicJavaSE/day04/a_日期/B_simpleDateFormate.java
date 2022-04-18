package cn.itcast.day04.a_日期;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class B_simpleDateFormate {
    public static void main(String[] args) throws Exception {
        // 问题: 默认日期对象的格式 不是我们想要的
        Date d1 = new Date();
        System.out.println(d1);
        // 目标1: 将日期Date对象 转化成 想要的字符串
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss_SSS");
        String formatDateStr = simpleDateFormat.format(d1);
        System.out.println(formatDateStr);

        // 目标2: 将日期字符串 转成 想要的日期对象
        String targetStr = "2022-10-01_10_20_30";
        SimpleDateFormat simpleDateFormat2 = new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss");
        Date d2 = simpleDateFormat2.parse(targetStr);
        System.out.println(d2);
    }
}
