package e_set;

import org.junit.Test;
import pojo.Student;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class F_Map {
    @Test
    public void show1() {
        // 1.定义Map集合, 键是学号, 值是学生的名字. (键值都是字符串类型).
        // 2.往Map集合中添加3对元素.
        // 3.打印Map集合对象.
        // 第一步: 创建一个容器
        Map<Integer, String> map = new HashMap<>();

        // 第二步: 保存数据
        map.put(101, "张三");
        map.put(102, "李四");
        map.put(103, "王五");

        // 第三步: 打印测试
        System.out.println(map);

    }

    @Test
    public void show2() {
        // 注意: map中的key是唯一的, 如果后面的key跟前面的key一样, 后面的value 覆盖前面的value
        // 第一步: 创建一个容器
        Map<Integer, String> map = new HashMap<>();

        // 第二步: 保存数据
        map.put(101, "张三");
        map.put(102, "李四");
        map.put(103, "王五");
        map.put(103, "赵六");
        map.put(103, "麻七");
        map.put(103, "张三");

        // 第三步: 打印测试
        System.out.println(map);
    }

    @Test
    public void show3() {
        // 遍历
        // 第一步: 创建一个容器
        Map<Integer, String> map = new HashMap<>();

        // 第二步: 保存数据
        map.put(101, "张三");
        map.put(102, "李四");
        map.put(103, "王五");

        // 遍历方式一 每次获取一对值的集合, 遍历集合, 获取key和value
        Set<Map.Entry<Integer, String>> entrySet = map.entrySet();
        for (Map.Entry<Integer, String> entry : entrySet) {
            Integer key = entry.getKey();
            String value = entry.getValue();
            System.out.println(key + " === " + value);
        }

        System.out.println("=================");

        // 遍历方式二: 先获取所有的key集合, 遍历 再根据key 获取值
        Set<Integer> keySet = map.keySet();
        for (Integer key : keySet) {
            String value = map.get(key);
            System.out.println(key + " ======== " + value);
        }
    }

    @Test
    public void show4() {
        // 第一步: 创建一个容器
        Map<Integer, String> map = new HashMap<>();

        // 第二步: 保存数据
        // V put(K key,V value)	添加元素
        map.put(101, "张三");
        map.put(102, "李四");
        map.put(103, "王五");

        // V remove(Object key)	根据键删除键值对元素
        // map.remove(102);
        // System.out.println(map);

        // void clear()	移除所有的键值对元素
        // System.out.println(map);
        // map.clear();
        // System.out.println(map);

        // boolean containsKey(Object key)	判断集合是否包含指定的键
        // System.out.println(map.containsKey(102));
        // System.out.println(map.containsKey(202));

        // boolean containsValue(Object value)	判断集合是否包含指定的值
        // System.out.println(map.containsValue("李四"));
        // System.out.println(map.containsValue("李四一"));

        // boolean isEmpty()	判断集合是否为空
        // map.clear();
        // System.out.println(map);
        // System.out.println(map.isEmpty());

        // int size()	集合的长度，也就是集合中键值对的个数
        System.out.println(map);
        System.out.println(map.size());
    }

    @Test
    public void show5() {
        // 1.创建HashMap集合, 键是学号(String), 值是学生对象(Student).
        Map<String, Student> map = new HashMap<>();

        // 2.往HashMap集合中添加3组数据.
        map.put("S101", new Student("张三", 13));
        map.put("S102", new Student("李四", 14));
        map.put("S103", new Student("王五", 15));

        // 3.遍历HashMap集合.
        Set<Map.Entry<String, Student>> entrySet = map.entrySet();
        for (Map.Entry<String, Student> entry : entrySet) {
            String key = entry.getKey();
            Student student = entry.getValue();
            System.out.println(key + " ==== " + student);
        }
    }

    @Test
    public void show6() {
        //4.6.2 键是Student值是String
        // 1.创建HashMap集合, 键是学号(String), 值是学生对象(Student).
        Map<Student, String> map = new HashMap<>();

        // 2.往HashMap集合中添加3组数据.
        map.put(new Student("张三", 13), "S101");
        map.put(new Student("李四", 14), "S102");
        map.put(new Student("王五", 15), "S103");

        // 3.遍历HashMap集合.
        Set<Map.Entry<Student, String>> entrySet = map.entrySet();
        for (Map.Entry<Student, String> entry : entrySet) {
            Student key = entry.getKey();
            String value = entry.getValue();
            System.out.println(key + " ==== " + value);
        }
    }

    @Test
    public void show7() {
        // 1.键盘录入一个字符串，要求统计字符串中每个字符出现的次数。
        // 2.举例：键盘录入“aababcabcdabcde” 在控制台输出：“a(5)b(4)c(3)d(2)e(1)”
        String str = "aababcabcdabcde";

        // 0 声明一个 map 容器, a (a, 1),  a (a, 2), a (a, 3), b (b, 1)
        Map<Character, Integer> map = new HashMap<>();

        // 1 将 字符串 转成 字符数组
        char[] charArr = str.toCharArray();

        // 2 遍历 字符数组
        for (char c : charArr) {
            // 2.1 判断 map的key中是否包含当前字符, 如果没有, 初始化值为1; 如果已存在, 让值+1
            if(!map.containsKey(c)) {
                map.put(c, 1);
            } else {
                Integer val = map.get(c);
                map.put(c, val + 1);
            }
        }
        System.out.println(map);


        // 3 录入“aababcabcdabcde” 在控制台输出：“a(5)b(4)c(3)d(2)e(1)”
        StringBuilder sb = new StringBuilder();
        Set<Map.Entry<Character, Integer>> entrySet = map.entrySet();
        for (Map.Entry<Character, Integer> entry : entrySet) {
            Character key = entry.getKey();
            Integer value = entry.getValue();

            sb.append(key).append("(").append(value).append(")");
        }

        String result = sb.toString();
        System.out.println(result);
    }
}
