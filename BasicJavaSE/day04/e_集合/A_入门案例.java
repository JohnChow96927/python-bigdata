package cn.itcast.day04.e_集合;

import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

public class A_入门案例 {
    @Test
    public void show1() {
        // 数组缺陷1: 数组类型固定
        // int[] arr = {11, 33, 55, "aa"};

        // 数组缺陷2: 长度固定, 数组的长度不能改
        int[] arr = {11, 33, 55};
        arr[10] = 100;
    }

    @Test
    public void show2() {
        // 集合 本质 容器, 主要操作 存 和 取
        // 创建集合
        List list = new ArrayList();

        // 解决缺陷1: 类型可以任意的
        list.add(11);
        list.add(33);
        list.add("aaaa");
        list.add(55);
        list.add('a');
        list.add(666);

        System.out.println(list);

    }

    @Test
    public void show3() {
        // 目标: 对集合内容累加
        List list = new ArrayList();
        list.add(10);
        list.add(20);
        list.add(30);

        Object o1 = list.get(0);
        Object o2 = list.get(1);
        Object o3 = list.get(2);

        int result = (int)o1 + (int)o2 + (int)o3;
        System.out.println(result);
    }

    @Test
    public void show4() {
        // 目标: 对集合内容累加
        // <integer> 作用: 约束集合元素的类型
        // List<Integer> list = new ArrayList<Integer>();
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
