package a_date;

import java.util.Calendar;

public class F_Calendar {
    public static void main(String[] args) {
        int year = 2020;

        Calendar cal = Calendar.getInstance();

        cal.set(year, 3-1, 1);

        cal.add(Calendar.DAY_OF_MONTH, -1);

        System.out.println(cal.get(Calendar.DAY_OF_MONTH));
    }
}
