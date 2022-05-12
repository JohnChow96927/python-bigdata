package com.johnchow.flink.test;

import java.util.ArrayList;
import java.util.List;

public class JavaListTest {
    public static void main(String[] args) {
        List<String> list = new ArrayList<>();

        list.add("hello");
        list.add("shuang!");
        list.add("word");
        list.add("count");

        System.out.println(list);
    }
}
