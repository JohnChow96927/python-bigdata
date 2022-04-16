package d_if_switch_for;

public class Demo2_If_Single_Branch {
    public static void main(String[] args) {
        // 定义变量time表示时间, 如果它的范围是在[0,8]之间, 就打印早上好, 否则不操作
        int time = 15;

        if (time >= 0 && time <= 8) {
            System.out.println("早上好");
        }
    }
}
