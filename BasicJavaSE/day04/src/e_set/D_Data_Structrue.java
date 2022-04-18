package e_set;

public class D_Data_Structrue {
    public static void main(String[] args) {
        // 目标: 栈(先进后出)
        b();
    }

    private static void b() {
        System.out.println("调用b方法 ... ...");
        c();
    }

    private static void c() {
        System.out.println("调用c方法 ... ...");
        d();
    }

    private static void d() {
        System.out.println("调用d方法 ... ...");
    }
}
