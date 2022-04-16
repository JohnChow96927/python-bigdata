1. 已知有猫类和狗类, 它们都有姓名和年龄, 都要吃饭, 不同的是猫吃鱼, 狗吃肉. 
   它们都有跑步的功能, 而且仅仅是跑步, 并无任何区别. 
   猫独有自己的功能: 抓老鼠catchMouse(), 狗独有自己的功能: 看家lookHome()
   部分的猫和狗经过马戏团的训练后, 学会了跳高jump(), 请用所学, 模拟该知识.
   
   public abstract class Animal {
	   //属性
	   private String name;
	   private int age;
	   
	   //构造方法, 空参, 全参.
	   
	   //getXxx(), setXxx()
	   
	   //行为
	   public abstract void eat();   //抽象方法, 强制要求子类必须完成某些事儿.
	   
	   public void run() {			 //非抽象方法, 让子类继承, 提高代码的复用性.
		   sop("动物会跑"); 
	   }
   }
   
   public class Cat extends Animal{
	   //构造方法, 子空 -> 父空, 子全 -> 父全
	   
	   //猫独有自己的功能: 抓老鼠catchMouse()
	   public void catchMouse() {
		   sop("抓老鼠");
	   }
	   
	   //重写Animal类的eat()
   }
   
   public interface Jumping{
	   void jump();
   }
   
   public class JumpCat extends Cat implements  Jumping {   //跳高猫
		//构造方法, 子空 -> 父空, 子全 -> 父全
		
		//重写Jumping接口的jump()
   }
   
   
   Jumping jm = new JumpCat();
   Jumping jm = new JumpDog();  //接口多态.
   
   
   public static void printJump(Jumping jm) {	//Jumping jm = new JumpCat()
	   jm.jump();
   }
   
   //分析依据: 抽象类(整个继承体系的 共性内容), 接口(整个继承体系的 扩展内容)
   
   
2. 已知有乒乓球运动员(PingPangPlayer)和篮球运动员(BasketballPlayer), 乒乓球教练(PingPangCoach)和篮球教练(BasketballCoach). 
   他们都有姓名和年龄, 都要吃饭, 但是吃的东西不同. 
   乒乓球教练教如何发球, 篮球教练教如何运球和投篮.
   乒乓球运动员学习如何发球, 篮球运动员学习如何运球和投篮. 
   为了出国交流, 跟乒乓球相关的人员都需要学习英语. 
   请用所学, 模拟该知识. 
   
   
3. 已知传智播客公司有基础班老师(BasicTeacher)和就业班老师(WorkTeacher), 基础班学生(BasicStudent)和就业班学生(WorkStudent).
   他们都有姓名, 年龄, 都要吃饭, 不同的是学生吃牛肉, 老师喝牛肉汤. 
   老师有自己的额外属性: 工资(salary), 且老师需要讲课(基础班老师讲JavaSE, 就业班老师讲JavaEE, Hadoop, Hive, Scala, Flink, Spark等).   
   基础班学生学习JavaSE, 就业班学生学习JavaEE, Hadoop, Hive, Scala, Flink, Spark等.
   为了扩大就业市场, 跟就业班相关的人员都需要学习英语. 
   请用所学, 模拟该知识. 