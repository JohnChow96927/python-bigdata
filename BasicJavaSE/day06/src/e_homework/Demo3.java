package e_homework;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;

public class Demo3 {
    //3. 随机点名器案例.
    //提示: 高效的字符流一次读写一行.
        /*
            项目下有一个names.txt, 里边记录的是学员的名字, 格式如下(一个名字占一行)
                张三
                李四
                王五
                赵六
                ...
            将上述所有数据读取出来, 存放到ArrayList<String>集合中, 然后随机从中获取一个名字即可.
        */
    public static void main(String[] args) throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new FileReader("day06/data/names.txt"));
        String name;
        ArrayList<String> names = new ArrayList<>();
        while ((name = bufferedReader.readLine()) != null) {
            names.add(name);
        }
        Random r = new Random();
        int target = r.nextInt(names.size());
        System.out.println("被点到名字的是" + names.get(target));
        bufferedReader.close();
    }
}
