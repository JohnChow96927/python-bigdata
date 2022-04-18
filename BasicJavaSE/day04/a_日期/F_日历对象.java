package cn.itcast.day04.a_日期;

import java.util.Calendar;

public class F_日历对象 {
    public static void main(String[] args) {
        // 目标:获取指定年份的2月份有多少天
        int year = 2030;

        Calendar cal = Calendar.getInstance();

        cal.set(year, 3-1, 1);
        // 设置日期为 2020年3月1日

        // 3月1日 -1 天
        cal.add(Calendar.DAY_OF_MONTH, -1);

        System.out.println(cal.get(Calendar.DAY_OF_MONTH));
    }
}
