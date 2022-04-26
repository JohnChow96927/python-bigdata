package chow.pkage.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data   //set方法  get方法  toString方法  没有全餐构造
@AllArgsConstructor
@NoArgsConstructor
public class Person {
    private String name;
    private int age;
    private String sex;
}
