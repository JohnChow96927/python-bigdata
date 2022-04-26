package chow.pkage.pojo;

import org.junit.Test;

import static org.junit.Assert.*;

public class PersonTest {
    @Test
    public void testPerson() {
        Person p = new Person();
        p.setName("霜");
        p.setAge(18);
        p.setSex("女");

        System.out.println(p.getName());
        System.out.println(p);
    }
}