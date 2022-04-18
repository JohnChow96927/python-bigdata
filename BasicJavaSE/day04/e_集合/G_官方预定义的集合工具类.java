package cn.itcast.day04.e_集合;

import org.junit.Test;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class G_官方预定义的集合工具类 {

    @Test
    public void show1() {
        List<Integer> list = new ArrayList<>();
        // 存
        // list.add(11);
        // list.add(100);
        // 扩展 存
        Collections.addAll(list, 100, 20, 70, 80, 50);

        // 对集合排序
        Collections.sort(list);

        // 对集合内容反转
        Collections.reverse(list);

        // 将集合元素内容打散(洗牌)
        Collections.shuffle(list);

        System.out.println(list);
    }
}
