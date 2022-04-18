package e_set;

import org.junit.Test;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class A_Beginning {
    @Test
    public void show1() {
        // 集合: 本质是容器, 主要操作为: 存, 取
        // 数组缺陷1: 数组类型固定
        // 数组缺陷2: 数组长度固定
        int[] arr = {11, 33, 55};
        arr[10] = 100;  // 报错
    }

    @Test
    public void show2() {
        List list = new ArrayList();

        // 解决缺陷一: 类型任意
        list.add(11);
        list.add("abc");
        list.add('a');
        list.add(1);

        System.out.println(list);
    }

    @Test
    public void show3() {
        // 目标: 对集合内容进行累加
        List<Integer> list = new ArrayList<Integer>();
        list.add(10);
        list.add(20);
        list.add(30);

        Integer o1 = list.get(0);
        Integer o2 = list.get(1);
        Integer o3 = list.get(2);

        Integer result = o1 + o2 + o3;
        System.out.println(result);

        Integer sum = 0;
        for (Integer element : list) {
            sum += element;
        }
        System.out.println(sum);
    }

    @Test
    public void show4() {
        List<Integer> list = new ArrayList<>();
        list.add(10);
        list.add(20);
        list.add(30);

        Integer o1 = list.get(0);
        Integer o2 = list.get(1);
        Integer o3 = list.get(2);

        Integer result = o1 + o2 + o3;
        System.out.println(result);
    }


}
