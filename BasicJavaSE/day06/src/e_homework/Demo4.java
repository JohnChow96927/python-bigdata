package e_homework;

import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class Demo4 {
    //4. 已知项目下有个a.txt文本文件，里边有两行数据，如下：
    //		a,c,d,e,g,h
    //		a,g,b,o,q,r
    //
    //	需求：
    //		创建输入流，读取这两行数据，对这些元素进行去重操作，然后将去重后的结果写入到项目下的b.txt文本文件中, 格式如下:
    //			//可以不是如下的顺序, 但是要一个字符占一行.
    //			a
    //			b
    //			c
    //			d
    //			e
    //			...
    public static void main(String[] args) throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new FileReader("day06/data/a.txt"));
        ArrayList<String> content = new ArrayList<>();
        String line;
        while ((line = bufferedReader.readLine()) != null) {
            content.add(line);
        }
        String deli = ",";
        Set<String> chars = new HashSet<>();    // 集合天生有去重的特性
        for (int i = 0; i < content.size(); i++) {
            for (String ch : content.get(i).split(deli)) {
                chars.add(ch);
            }
        }
        BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter("day06/data/b.txt"));
        for (String c : chars) {
            bufferedWriter.write(c);
            bufferedWriter.newLine();
        }
        bufferedReader.close();
        bufferedWriter.close();
    }
}
