package b_Exception;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Demo3_Finally {
    public static void main(String[] args) {
        String str = "2020-09-08";

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        try {
            Date d1 = sdf.parse(str);
            System.out.println(d1);
            int j = 1/0;
            System.out.println("没毛病!");
        } catch (Exception e) {
            System.out.println("出事了.");
            e.printStackTrace();
        } finally {
            System.out.println("释放资源!");
        }

        System.out.println("6666666");
    }
}
