package cn.itcast.day02.a_while;

public class Demo03_while_03 {
    public static void main(String[] args) {
        // 需求: 0.1毫米的纸张 折多少次 会超过珠穆拉玛峰的高度 8848米 = 8848 000
        /*
            0.1     0.2     0.4     0.8     1.6
            3.2     6.4     12.8    25.6    51.2
            102.4   204.8   409.6   819.2   1600
            3200    6400    12800   25600   51200
            102400  204800  409600  819 200  1600 000
            3200 000    6400 000    12800 000
         */
        int zhi = 1;
        int zhumu = 88480000;
        int count = 0;

        while(zhi <= zhumu) {
            zhi *= 2;
            count++;
        }

        System.out.println("折了多少次? " + count);
        System.out.println("折完后, 纸的高度: " + zhi);
    }
}
