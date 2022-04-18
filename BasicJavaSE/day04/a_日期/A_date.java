package cn.itcast.day04.a_日期;

import java.util.Date;

public class A_date {
    public static void main(String[] args) {
        // 目标1: 获取日期对象
        Date d1 = new Date();
        System.out.println(d1);

        // 目标2: 获取日期对应的毫秒值(时间戳)
        long timestamp = d1.getTime();
        System.out.println(timestamp);

        // 目标3: 根据时间戳获取对应的日期对象
        Date d2 = new Date(timestamp);
        System.out.println(d2);
    }
}
