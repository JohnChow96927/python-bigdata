package e_set;

import org.junit.Test;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

public class G_Set_Util_By_Official {
    @Test
    public void show1() {
        List<Integer> list = new ArrayList<>();
        Collections.addAll(list, 100, 20, 70, 80, 50);

        // 对集合排序
        Collections.sort(list);
        System.out.println(list);

        // 对集合内容反转
        Collections.reverse(list);
        System.out.println(list);

        // 将集合元素内容打散
        Collections.shuffle(list);
        System.out.println(list);
    }
}
