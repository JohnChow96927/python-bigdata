package cn.itcast.day01.d;

public class Demo04_if_多分支 {
    public static void main(String[] args) {
        /*
            1.小明快要期末考试了，小明爸爸对他说，会根据他的考试成绩，送他不同的礼物.
            2.假如你可以控制小明的得分，请用程序实现小明到底该获得什么样的礼物，并在控制台输出。
            3.礼物标准如下:
                –95~100 山地自行车一辆
                –90~94 游乐场玩一次
                –80~89 变形金刚玩具一个
                –80以下 胖揍一顿
         */
        int score = 120;

        if(score>=0 && score<=100) {
            if(score>=95 && score<=100) {
                System.out.println("1. 奖励 山地自行车一辆");
            } else if(score>=90 && score<=94) {
                System.out.println("2. 奖励 游乐场玩一次");
            } else if(score>=80 && score<=89) {
                System.out.println("3. 奖励 变形金刚玩具一个");
            } else  {
                System.out.println("4. 惩罚 胖揍一顿");
            }
        } else {
            System.out.println("请输入正确的分数 [0 ~ 100]!");
        }

    }
}
