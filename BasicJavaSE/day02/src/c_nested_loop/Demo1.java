package c_nested_loop;

public class Demo1 {
    public static void main(String[] args) {
        // 需求: 输出2020 ~ 2025年的月份, 输出格式: yyyy年MM月
        for (int i = 2020; i < 2026 ; i++) {
            for (int j = 1; j < 13; j++) {
                String month = String.format("%02d", j);
                System.out.println(i + "年" + month + "月");
            }
        }
    }
}
