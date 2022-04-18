package b_exception;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Demo2_Catch {
    public static void main(String[] args) {
        String str = "2020/09/08";

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        try {
            Date d1 = sdf.parse(str); // 报错了, 需要立刻处理这个异常
            System.out.println("一切正常 ... ...");
        } catch (ParseException e) {
            System.out.println("出现了问题  ... ...");
            e.printStackTrace();
        }

        System.out.println("666666666666666666");
    }
}
