package b_Exception;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Demo1_Throw {
    public static void main(String[] args) throws Exception{
        String str = "2020-09/08";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        Date d1 = sdf.parse(str);

        System.out.println("8888");
    }
}
