package h_stringbuilder;

public class Demo1 {
    public static void main(String[] args) {
        // StringBuilder是啥?
        long start = System.currentTimeMillis();
        String str = "";
        for (int i = 0; i < 1000; i++) {
            str += i;
        }
        long end = System.currentTimeMillis();

        System.out.println("耗时" + (end - start) + "毫秒");
        // 这样太耗时间了
    }
}
