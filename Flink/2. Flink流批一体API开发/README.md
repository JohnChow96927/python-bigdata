# Flink流批一体API开发

Apache Flink是一个面向分布式数据流处理和批量数据处理的开源计算平台，它能够基于同一个Flink运行时（Flink Runtime），提供支持流处理和批处理两种类型应用的功能。

![](assets/1602831101602.png)

## 回顾I. Java泛型

> 在Flink中几乎所有处理数据Function函数接口都是**泛型**，**创建子类时需要指定具体类型**。

![1652281242117](assets/1652281242117.png)

> 在Java集合类中：`List`列表就是泛型，指定列表存储数据类型；其中`add`方法，接收参数也是泛型，表示接收数据类型。

![1652281624626](E:/Heima/%E5%B0%B1%E4%B8%9A%E7%8F%AD%E6%95%99%E5%B8%88%E5%86%85%E5%AE%B9%EF%BC%88%E6%AF%8F%E6%97%A5%E6%9B%B4%E6%96%B0%EF%BC%89/NoSQL%20Flink/%E9%A2%84%E4%B9%A0%E8%B5%84%E6%96%99/Flink/fake_flink-%E7%AC%AC2%E5%A4%A9-%E9%A2%84%E4%B9%A0%E8%B5%84%E6%96%99/flink-%E7%AC%AC2%E5%A4%A9-%E9%A2%84%E4%B9%A0%E8%B5%84%E6%96%99/assets/1652281624626.png)

```Java
package cn.itcast.flink.test;

import java.util.ArrayList;
import java.util.List;

/**
 * Java中列表ArrayList就是泛型类
 */
public class JavaListTest {

	public static void main(String[] args) {
		// 创建列表
		List<String> list = new ArrayList<>() ;

		// 添加数据到列表中
		list.add("hello");
		list.add("world");
		list.add("word");
		list.add("count");

		// 打印数据
		System.out.println(list);
	}

}
```

## 回顾II. Java匿名内部类

> 在Java中OOP中，如果需要**创建接口Interface实现类对象**，有三种方式：**1、单独定义类创建，实例对象**、**2、直接创建匿名内部类对象**、**3、使用Lambda表达式**。

![1652306239945](assets/1652306239945.png)

> 以Java中创建线程启动为例，采用不同方式创建Runnable对象。

![1652306438488](assets/1652306438488.png)

- 方式1：**单独定义类创建，实例对象**

------

![1652306784456](assets/1652306784456.png)

```Java
package cn.itcast.flink.test;

public class JavaThreadTest {

	// 方式一：创建类，实现接口（属于内部类 -> 定义在类中的类）
	static class MyThread implements Runnable {
		@Override
		public void run() {
            long counter = 1 ;
			while (true){
				System.out.println(counter + "...........................");
				counter ++ ;
			}
		}
	}

	public static void main(String[] args) {
		// 创建一个线程, todo: 1、单独定义类创建，实例对象
		Thread thread = new Thread(new MyThread());
		// 启动线程
		thread.start();
	}

}
```

- 方式2：**直接创建匿名内部类对象**

------

![1652307032486](assets/1652307032486.png)

- 方式3：**使用Lambda表达式**

------

![1652307449759](assets/1652307449759.png)

> 将匿名内部类改为lambda表达式：代码简洁，Java8以后支持特性

```Java
		// 创建一个线程, todo: 3、使用Lambda表达式
		Thread thread = new Thread(
			() -> {
				long counter = 1 ;
				while (true){
					System.out.println(counter + "...........................");
					counter ++ ;
				}
			}
		);
```

![1652307642516](assets/1652307642516.png)

## 回顾III. MySQL JDBC

> 在Java中提供JDBC接口准备，方便对数据库进行操作，以MySQL为例，编写JDBC代码读写表数据。

- 创建表：

```SQL
-- 创建数据库
CREATE DATABASE IF NOT EXISTS db_flink ;
-- 创建表
CREATE TABLE IF NOT EXISTS db_flink.t_student (
                             id int(11) NOT NULL AUTO_INCREMENT,
                             name varchar(255) DEFAULT NULL,
                             age int(11) DEFAULT NULL,
                             PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- 插入数据
INSERT INTO db_flink.t_student VALUES ('1', 'jack', 18);
INSERT INTO db_flink.t_student VALUES ('1', 'jack', 18);
INSERT INTO db_flink.t_student VALUES ('2', 'tom', 19);
INSERT INTO db_flink.t_student VALUES ('3', 'rose', 20);
INSERT INTO db_flink.t_student VALUES ('4', 'tom', 19);

-- 查询数据
SELECT id, name, age FROM db_flink.t_student ;
```

- JDBC方式读取数据

```JAva
package cn.itcast.flink.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * 基于JDBC方式读取MySQL数据库表中数据
 */
public class MySQLJdbcReadTest {

	public static void main(String[] args) throws Exception{
		// step1、加载驱动
		Class.forName("com.mysql.jdbc.Driver") ;
		// step2、获取连接Connection
		Connection conn = DriverManager.getConnection(
			"jdbc:mysql://node1.itcast.cn:3306/?useSSL=false",
			"root",
			"123456"
		);
		// step3、创建Statement对象，设置语句（INSERT、SELECT）
		PreparedStatement pstmt = conn.prepareStatement("SELECT id, name, age FROM db_flink.t_student") ;
		// step4、执行操作，获取ResultSet对象
		ResultSet result = pstmt.executeQuery();
		// step5、遍历获取数据
		while (result.next()){
			// 获取每个字段的值
			int stuId = result.getInt("id");
			String stuName = result.getString("name");
			int stuAge = result.getInt("age");
			System.out.println("id = " + stuId + ", name = " + stuName + ", age = " + stuAge);
		}
		// step6、关闭连接
		result.close();
		pstmt.close();
		conn.close();
	}

}
```

- JDBC方式写入数据

```Java
package cn.itcast.flink.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

/**
 * 基于JDBC方式写入数据到MySQL数据库表中
 */
public class MySQLJdbcWriteTest {

	public static void main(String[] args) throws Exception{
		// step1、加载驱动
		Class.forName("com.mysql.jdbc.Driver") ;
		// step2、获取连接Connection
		Connection conn = DriverManager.getConnection(
			"jdbc:mysql://node1.itcast.cn:3306/?useSSL=false",
			"root",
			"123456"
		);
		// step3、创建Statement对象，设置语句（INSERT、SELECT）
		PreparedStatement pstmt = conn.prepareStatement("INSERT INTO db_flink.t_student(id, name, age) VALUES (?, ?, ?)") ;
		// step4、执行操作
		pstmt.setInt(1, 99);
		pstmt.setString(2, "Jetty");
		pstmt.setInt(3, 28);
		pstmt.executeUpdate();
		// step5、关闭连接
		pstmt.close();
		conn.close();
	}

}
```

## I. 基础概念

### 1. DataStream

在Flink计算引擎中，将数据当做：==数据流DataStream==，分为**有界数据流**和**无界数据流**。

> [任何类型的数据都可以形成一种事件流，如信用卡交易、传感器测量、机器日志、网站或移动应用程序上的==用户交互记录==，所有这些数据都形成一种流。]()

![](assets/1614992955800.png)

> - 1）、`有边界流（bounded stream`）：==有定义流的开始，也有定义流的结束。==有界流可以在摄取所有数据后再进行计算。有界流所有数据可以被排序，所以并不需要有序摄取。有界流处理通常被称为`批处理。`
> - 2）、`无边界流（unbounded stream）`：==有定义流的开始，但没有定义流的结束==。它们会无休止地产生数据。无界流的数据必须持续处理，即数据被摄取后需要立刻处理。不能等到所有数据都到达再处理，因为输入是无限的，在任何时候输入都不会完成。处理无界数据通常要求以特定顺序摄取事件，例如事件发生的顺序，以便能够推断结果的完整性。

`DataStream（数据流）`官方定义：

![](assets/1614993124158.png)

> `DataStream（数据流）`源码中定义：

![](assets/1630115685862.png)

> DataStream有如下几个子类：

![1633571725510](assets/1633571725510.png)

- 1）、`DataStreamSource`：
  - 表示从数据源直接获取数据流DataStream，比如从Socket或Kafka直接消费数据
- 2）、`KeyedStream`：
  - 当DataStream数据流进行分组时（调用keyBy），产生流称为KeyedStream，按照指定Key分组；
  - 通常情况下数据流被分组以后，需要进行窗口window操作或聚合操作。
- 3）、`SingleOutputStreamOperator`：
  - 当DataStream数据流没有进行keyBy分组，而是使用转换函数，产生的流称为SingleOutputStreamOperator。
  - 比如使用filter、map、flatMap等函数，产生的流就是`SingleOutputStreamOperator`
- 4）、`IterativeStream`：迭代流，表示对流中数据进行迭代计算，比如机器学习，图计算等。

> `DataStream`类是泛型（类型参数），数据类型支持如下所示：

![1633533861903](assets/1633533861903.png)

> 在Flink计算引擎中，提供4个层次API，如下所示：

![](assets/levels_of_abstraction.svg)

> Flink中流计算DataStream层次API在使用时，还是包括三个方面：`Source/Transformation/Sink`

![](assets/1614758699392.png)

> 基于Flink开发流式计算程序五个步骤：

```ini
# 1）、Obtain an execution environment,
	执行环境-env：StreamExecutionEnvironment
	
# 2）、Load/create the initial data,
    数据源-source：DataStream
    
# 3）、Specify transformations on this data,
    数据转换-transformation：DataStream API（算子，Operator）
    
# 4）、Specify where to put the results of your computations,
    数据接收器-sink
	
# 5）、Trigger the program execution
	触发执行-execute
```

![](assets/1614758736610.png)

> 在IDEA中创建Flink Stream流计算编程模板：`FlinkClass`

![1652279769455](assets/1652279769455.png)

模块中内容：`FlinkClass`

```java
#if (${PACKAGE_NAME} && ${PACKAGE_NAME} != "") package ${PACKAGE_NAME};#end

import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

public class ${NAME} {

	public static void main(String[] args) throws Exception {
		// 1. 执行环境-env
		StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
		
		// 2. 数据源-source
		
		// 3. 数据转换-transformation
		
		// 4. 数据终端-sink
		
		// 5. 触发执行-execute
		env.execute("${NAME}") ;
	}

}  
```

> 依据上述定义FlinkStream模块Template，创建Flink Stream编程类：`StreamDemo`

![1652307926272](assets/1652307926272.png)

### 2. 并行度设置

> 一个Flink程序由多个Operator组成(`source、transformation和 sink`)。

![](assets/1630241888273.png)

> 一个Operator由多个并行的SubTask（以线程方式）来执行， 一个Operator的并行SubTask(数目就被称为该Operator(任务)的**并行度**(`Parallelism`)。

![](assets/1630241797904.png)

在Flink 中，并行度设置可以从4个层次级别指定，具体如下所示：

![](assets/1630243097602.png)

- 1）、==Operator Level（算子级别）==(可以使用)

> 一个operator、source和sink的并行度可以通过调用 `setParallelism()`方法来指定。

![1630243927963](assets/1630243927963.png)

- 2）、==Execution Environment Level==（Env级别，可以使用)

> 执行环境并行度可以通过调用`setParallelism()`方法指定。

![1630243963333](assets/1630243963333.png)

- 3）、==Client Level==(客户端级别，推荐使用)

> 并行度可以在客户端将job提交到Flink时设定，对于CLI客户端，可以通过`-p`参数指定并行度

![1630244027260](assets/1630244027260.png)

- 4）、==System Level==（系统默认级别，尽量不使用）

> 在系统级可以通过设置`flink-conf.yaml`文件中的`parallelism.default`属性来指定所有执行环境的默认并行度。

总结：并行度的优先级：`算子级别 > env级别 > Client级别 > 系统默认级别` 

- 1）、如果source不可以被并行执行，即使指定了并行度为多个，也不会生效
- 2）、实际生产中，推荐`在算子级别显示指定各自的并行度`，方便进行显示和精确的资源控制。
- 3）、slot是静态的概念，是**指taskmanager具有的并发执行能力**； `parallelism`是动态的概念，是指`程序运行时实际使用的并发能力`。



### 3. 资源槽Slot

![1633569666984](assets/1633569666984.png)

> Flink中运行Task任务（SubTask）在Slot资源槽中：
> [Slot为子任务SubTask运行资源抽象，每个TaskManager运行时设置Slot个数。]()

```ini
官方建议：
	Slot资源槽个数  =  CPU Core核数
也就是说，
    分配给TaskManager多少CPU Core核数，可以等价为Slot个数
```

![](assets/1626485199097.png)

> 每个TaskManager运行时设置内存大小：[TaskManager中内存==平均==划分给Slot]()。

```
举例说明：
	假设TaskManager中分配内存为：4GB，Slot个数为4个，此时每个Slot分配内存就是 4GB / 4 = 1GB 内存	
```

> 每个Slot中运行SubTask子任务，以线程Thread方式运行。
>
> - 不同类型SubTask任务，可以运行在同一个Slot中，称为：[Slot Sharded 资源槽共享]()
> - 相同类型SubTask任务必须运行在不同Slot中。

![](assets/1630759894498.png)

## II. Data Source & Data Sink

### 1. 基本数据源

针对Flink 流计算来说，数据源可以是**有界数据源（静态数据）**，也可以是**无界数据源（流式数据）**，原因在于Flink框架中，==将数据统一封装称为`DataStream`数据流==。

https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/dev/datastream/overview/#data-sources

![](assets/1630118613881.png)

```ini
1、基于File文件数据源
	readTextFile(path)

2、Sockect 数据源
	socketTextStream 
	
3、基于Collection数据源
	fromCollection(Collection)
	fromElements(T ...)
	fromSequence(from, to)，相当于Python中range

4、自定义Custom数据源
	env.addSource()
	官方提供接口：
		SourceFunction			非并行
		RichSourceFunction 
		
		ParallelSourceFunction  并行
		RichParallelSourceFunction 
```

> 基于==集合Collection==数据源Source，一般用于学习测试。

![1633532195634](assets/1633532195634.png)

```java
package cn.itcast.flink.source;

import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

import java.util.Arrays;

/**
 * Flink 流计算数据源：基于集合的Source，分别为可变参数、集合和自动生成数据
 *      TODO: 基于集合数据源Source构建DataStream，属于有界数据流，当数据处理完成以后，应用结束
 */
public class StreamSourceCollectionDemo {

	public static void main(String[] args) throws Exception {
		// 1. 执行环境-env
		StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
		env.setParallelism(1) ;

		// 2. 数据源-source
		// 方式一：可变参数
		DataStreamSource<String> dataStream01 = env.fromElements("spark", "flink", "mapreduce");
		dataStream01.print();

		// 方式二：集合对象
		DataStreamSource<String> dataStream02 = env.fromCollection(Arrays.asList("spark", "flink", "mapreduce"));
		dataStream02.printToErr();

		// 方式三：自动生成序列数字
		DataStreamSource<Long> dataStream03 = env.fromSequence(1, 10);
		dataStream03.print();

		// 5. 触发执行-execute
		env.execute("StreamSourceCollectionDemo") ;
	}

}
```

> 基于文件数据源， 一般用于学习测试，演示代码如下所示：

![](assets/1630897373473.png)

> 从文本文件加载数据时，可以是压缩文件，支持压缩格式如下图。

![1633532375484](assets/1633532375484.png)

> 案例演示代码：`StreamSourceFileDemo`

```java
package cn.itcast.flink.source;

import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

/**
 * Flink 流计算数据源：基于文件的Source
 */
public class StreamSourceFileDemo {

	public static void main(String[] args) throws Exception {
		// 1. 执行环境-env
		StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
		env.setParallelism(1) ;

		// 2. 数据源-source
		// 方式一：读取文本文件
		DataStreamSource<String> dataStream01 = env.readTextFile("datas/words.txt");
		dataStream01.printToErr();

		// 方式二：读取压缩文件
		DataStreamSource<String> dataStream02 = env.readTextFile("datas/words.txt");
		dataStream02.print();

		// 5. 触发执行-execute
		env.execute("StreamSourceFileDemo") ;
	}

}
```

### 2. 自定数据源

> 在Flink 流计算中，提供**数据源Source**接口，用户实现自定义数据源，可以从任何地方获取数据。

![](assets/1630119138251.png)

```ini
1、SourceFunction：
	非并行数据源(并行度parallelism=1)

2、RichSourceFunction：
	多功能非并行数据源(并行度parallelism=1)

3、ParallelSourceFunction：
	并行数据源(并行度parallelism>=1)

4、RichParallelSourceFunction：
	多功能并行数据源(parallelism>=1)，Kafka数据源使用该接口
```

> 实际项目中，如果需要自定义数据源，实现接口：RichSourceFunction或`RichParallelSourceFunction`。

![1630897568085](assets/1630897568085.png)

> 查看`SourceFunction`接口中方法：

![](assets/1630978997414.png)

```ini
# 第一个方法：run
	实时从数据源端加载数据，并且发送给下一个Operator算子，进行处理
	实时产生数据

# 第二个方法：cancel
	字面意思：取消
	当将Job作业取消时，不在从数据源端读取数据
	
# 总结：当基于数据源接口自定义数据源时，只要实现上述2个 方法即可。
```

![](assets/1630979179210.png)

> 需求：==每隔1秒随机生成一条订单信息(订单ID、用户ID、订单金额、时间戳)==

![1614999061257](assets/1614999061257.png)

> 创建类：`OrderSource`，实现接口【`RichParallelSourceFunction`】，实现其中`run`和`cancel`方法。

![1630897686112](assets/1630897686112.png)

> 编程实现自定义数据源：`StreamSourceOrderDemo`，实时产生交易订单数据。

```java
package cn.itcast.flink.source;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.functions.source.RichParallelSourceFunction;

import java.util.Random;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * 每隔1秒随机生成一条订单信息(订单ID、用户ID、订单金额、时间戳)
	 * - 随机生成订单ID：UUID
	 * - 随机生成用户ID：0-2
	 * - 随机生成订单金额：0-100
	 * - 时间戳为当前系统时间：current_timestamp
 */
public class StreamSourceOrderDemo {

	@Data
	@NoArgsConstructor
	@AllArgsConstructor
	public static class Order {
		private String id;
		private Integer userId;
		private Double money;
		private Long orderTime;
	}

	/**
	 * 自定义数据源，继承抽象类：RichParallelSourceFunction，并行的和富有的
	 */
	private static class OrderSource extends RichParallelSourceFunction<Order> {
		// 定义变量，用于标识是否产生数据
		private boolean isRunning = true ;

		// 表示产生数据，从数据源Source源源不断加载数据
		@Override
		public void run(SourceContext<Order> ctx) throws Exception {
			Random random = new Random();
			while (isRunning){
				// 产生交易订单数据
				Order order = new Order(
					UUID.randomUUID().toString(), //
					random.nextInt(2), //
					(double)random.nextInt(100), //
					System.currentTimeMillis()
				);
				// 发送交易订单数据
				ctx.collect(order);

				// 每隔1秒产生1条数据，休眠1秒钟
				TimeUnit.SECONDS.sleep(1);
			}
		}

		// 取消从数据源加载数据
		@Override
		public void cancel() {
			isRunning = false ;
		}
	}

	public static void main(String[] args) throws Exception {
		// 1. 执行环境-env
		StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment() ;
		env.setParallelism(1);

		// 2. 数据源-source
		DataStreamSource<Order> orderDataStream = env.addSource(new OrderSource());

		// 3. 数据转换-transformation
		// 4. 数据接收器-sink
		orderDataStream.printToErr();

		// 5. 触发执行-execute
		env.execute("StreamSourceOrderDemo") ;
	}

}
```

运行流式计算程序，查看模拟产生订单数据：

![](assets/1614999562804.png)

### 3. MySQL Source

> 需求：==从MySQL中实时加载数据，要求MySQL中的数据有变化，也能被实时加载出来==

![](assets/1630120717030.png)

- 1）、数据准备

```SQL
CREATE DATABASE IF NOT EXISTS db_flink ;


CREATE TABLE IF NOT EXISTS db_flink.t_student (
                             id int(11) NOT NULL AUTO_INCREMENT,
                             name varchar(255) DEFAULT NULL,
                             age int(11) DEFAULT NULL,
                             PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT INTO db_flink.t_student VALUES ('1', 'jack', 18);
INSERT INTO db_flink.t_student VALUES ('2', 'tom', 19);
INSERT INTO db_flink.t_student VALUES ('3', 'rose', 20);
INSERT INTO db_flink.t_student VALUES ('4', 'tom', 19);

INSERT INTO db_flink.t_student VALUES ('5', 'jack', 18);
INSERT INTO db_flink.t_student VALUES ('6', 'rose', 20);
```

- 2）、自定义数据源：`MySQLSource`

> 实现`run`方法，实现每隔1秒加载1次数据库表数据，此时数据有更新都会即使查询。

```scala
package cn.itcast.flink.source;

import lombok.* ;
import org.apache.flink.configuration.Configuration;
import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.functions.source.RichParallelSourceFunction;

import java.sql.* ;
import java.util.concurrent.TimeUnit;

/**
 * 从MySQL中实时加载数据：要求MySQL中的数据有变化，也能被实时加载出来
 */
public class StreamSourceMySQLDemo {

	@Data
	@NoArgsConstructor
	@AllArgsConstructor
	public static class Student {
		private Integer id;
		private String name;
		private Integer age;
	}

	/**
	 * 自定义数据源，从MySQL表中加载数据，并且实现增量加载
	 */
	private static class MySQLSource extends RichParallelSourceFunction<Student> {
		// 定义变量，标识是否加载数据
		private boolean isRunning = true ;

		// 定义变量，open方法初始化，close方法关闭连接
		private Connection conn = null ;
		private PreparedStatement pstmt = null ;
		private ResultSet result = null ;

		// 初始化方法，在获取数据之前，准备工作
		@Override
		public void open(Configuration parameters) throws Exception {
			// step1、加载驱动
			Class.forName("com.mysql.jdbc.Driver") ;
			// step2、获取连接Connection
			conn = DriverManager.getConnection(
				"jdbc:mysql://node1.itcast.cn:3306/?useSSL=false",
				"root",
				"123456"
			);
			// step3、创建Statement对象，设置语句（INSERT、SELECT）
			pstmt = conn.prepareStatement("SELECT id, name, age FROM db_flink.t_student") ;
		}

		@Override
		public void run(SourceContext<Student> ctx) throws Exception {
			while (isRunning){
				// step4、执行操作，获取ResultSet对象
				result = pstmt.executeQuery();
				// step5、遍历获取数据
				while (result.next()){
					// 获取每个字段的值
					int stuId = result.getInt("id");
					String stuName = result.getString("name");
					int stuAge = result.getInt("age");
					// 构建实体类对象
					Student student = new Student(stuId, stuName, stuAge);
					// 发送数据
					ctx.collect(student);
				}

				// 每隔5秒加载一次数据库，获取数据
				TimeUnit.SECONDS.sleep(5);
			}
		}

		@Override
		public void cancel() {
			isRunning = false ;
		}

		// 收尾工作，当不再加载数据时，一些善后工作
		@Override
		public void close() throws Exception {
			// step6、关闭连接
			if(null != result) result.close();
			if(null != pstmt) pstmt.close();
			if(null != conn) conn.close();
		}
	}

	public static void main(String[] args) throws Exception {
		// 1. 执行环境-env
		StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment() ;
		env.setParallelism(1);

		// 2. 数据源-source
		DataStreamSource<Student> studentDataStream = env.addSource(new MySQLSource());

		// 3. 数据转换-transformation
		// 4. 数据终端-sink
		studentDataStream.printToErr();

		// 5. 触发执行-execute
		env.execute("StreamSourceMySQLDemo") ;
	}
}
```

### 4. MySQL Sink

> Flink 流计算中数据接收器Sink，基本数据保存和自定义Sink保存。

https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/dev/datastream/overview/#data-sinks

![1633559866553](assets/1633559866553.png)

```ini
# 1、写入文件，API已经过时，不推荐使用
	writeAsText
	writeAsCsv
	
# 2、打印控制台，开发测试使用
	print，标准输出
	printToErr,错误输出
	
# 3、写入Socket
	很少使用
	
# 4、自定义数据接收器Sink
	Sink接口：SinkFunction、RichSinkFunction
	datastream.addSink 添加流式数据输出Sink
	
	# 需求：Flink 流式计算程序，实时从Kafka消费数据（保险行业），将数据ETL转换，存储到HBase表
		Flink 1.10版本中，DataStream未提供与HBase集成Connector连接器
		自定实现SinkFunction接口，向HBase表写入数据即可
		https://www.jianshu.com/p/1c29750ed814
```

![](assets/1615018013630.png)

> 将数据写入文件方法：`writeAsText`和`writeAsCsv`全部过时，提供新的Connector：`StreamingFileSink`

![](assets/1630126098791.png)

> **需求**：将Flink集合中的数据集DataStream，通过自定义Sink保存到MySQL。

```ini
CREATE DATABASE IF NOT EXISTS db_flink ;


CREATE TABLE IF NOT EXISTS db_flink.t_student (
    id int(11) NOT NULL AUTO_INCREMENT,
    name varchar(255) DEFAULT NULL,
    age int(11) DEFAULT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT INTO db_flink.t_student VALUES ('100', 'zhangsan', 24);
```

> [当自定义Flink中Sink时，需要实现接口：`SinkFunction`或`RichSinkFunction`]()

```java
package cn.itcast.flink.sink;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.flink.configuration.Configuration;
import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.functions.sink.RichSinkFunction;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

/**
 * 案例演示：自定义Sink，将数据保存至MySQL表中，继承RichSinkFunction
 */
public class StreamSinkMySQLDemo {

	@Data
	@NoArgsConstructor
	@AllArgsConstructor
	private static class Student {
		private Integer id;
		private String name;
		private Integer age;
	}

	/**
	 * 自定义Sink接收器，将DataStream中数据写入到MySQL数据库表中
	 */
	private static class MySQLSink extends RichSinkFunction<Student> {
		// 定义变量，在open方法实例化，在close方法关闭
		private Connection conn = null ;
		private PreparedStatement pstmt = null ;

		// 初始化工作
		@Override
		public void open(Configuration parameters) throws Exception {
			// step1、加载驱动
			Class.forName("com.mysql.jdbc.Driver") ;
			// step2、获取连接Connection
			conn = DriverManager.getConnection(
				"jdbc:mysql://node1.itcast.cn:3306/?useSSL=false",
				"root",
				"123456"
			);
			// step3、创建Statement对象，设置语句（INSERT）
			pstmt = conn.prepareStatement("INSERT INTO db_flink.t_student(id, name, age) VALUES (?, ?, ?)");
		}

		// TODO：数据流中每条数据进行输出操作，调用invoke方法
		@Override
		public void invoke(Student student, Context context) throws Exception {
			// step4、执行操作
			pstmt.setInt(1, student.id);
			pstmt.setString(2, student.name);
			pstmt.setInt(3, student.age);

			pstmt.executeUpdate();
		}

		// 收尾工作
		@Override
		public void close() throws Exception {
			// step5、关闭连接
			if(null != pstmt) pstmt.close();
			if(null != conn) conn.close();
		}
	}

	public static void main(String[] args) throws Exception {
		// 1. 执行环境-env
		StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
		env.setParallelism(1);

		// 2. 数据源-source
		DataStreamSource<Student> inputDataStream = env.fromElements(
			new Student(13, "wangwu", 20),
			new Student(14, "zhaoliu", 19),
			new Student(15, "laoda", 25),
			new Student(16, "laoer", 23)
		);
		// inputDataStream.printToErr();

		// 3. 数据转换-transformation

		// 4. 数据终端-sink
		MySQLSink mySQLSink = new MySQLSink();
		inputDataStream.addSink(mySQLSink) ;

		// 5. 触发执行-execute
		env.execute("StreamSinkMySQLDemo");
	}

}
```

## III. DataStream Transformations

### 1. 算子概述

> 从DataStream数据流转换角度看Transformation算子（函数），有如下四类操作：

文档：https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/dev/datastream/operators/overview/

![](assets/1615012994651.png)

- 1）、第一类是对于`单条记录的操作`，比如筛除掉不符合要求的记录（Filter 操作），或者将每条记录都做一个转换（Map 操作）

- 2）、第二类是对`多条记录的操作`。比如说统计一个小时内的订单总成交量，就需要将一个小时内的所有订单记录的成交量加到一起。为了支持这种类型的操作，就得通过 Window 将需要的记录关联到一起进行处理

- 3）、第三类是对`多个流进行操作并转换为单个流`。例如，多个流可以通过 Union、Join 或Connect 等操作合到一起。这些操作合并的逻辑不同，但是它们最终都会产生了一个新的统一的流，从而可以进行一些跨流的操作。

- 4）、第四类是DataStream支持与合并对称的`拆分操作`，即`把一个流按一定规则拆分为多个流`（Split 操作），每个流是之前流的一个子集，这样我们就可以对不同的流作不同的处理。

> 先讲解一些DataStream中最基本Operator算子使用，也是使用比较多。

![1633557641897](assets/1633557641897.png)

### 2. map 算子

> `map`函数使用说明：

![](assets/1614826981456.png)

> **需求**：将读取文本文件数据，每行JSON格式数据，转换为**ClickLog**对象，使用`map`函数完成。

[将JSON格式字符串，解析转换为JavaBean对象，使用库：`fastJson`库]()

```java
package cn.itcast.flink.transformation;

import com.alibaba.fastjson.JSON;
import lombok.Data;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.apache.flink.api.common.functions.FilterFunction;
import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.util.Collector;

/**
 * Flink中流计算DataStream转换函数：map、flatMap和filter
 */
public class TransformationBasicDemo {

	@Data
	private static class ClickLog {
		//频道ID
		private long channelId;
		//产品的类别ID
		private long categoryId;

		//产品ID
		private long produceId;
		//用户的ID
		private long userId;
		//国家
		private String country;
		//省份
		private String province;
		//城市
		private String city;
		//网络方式
		private String network;
		//来源方式
		private String source;
		//浏览器类型
		private String browserType;
		//进入网站时间
		private Long entryTime;
		//离开网站时间
		private Long leaveTime;
	}

	public static void main(String[] args) throws Exception {
		// 1. 执行环境-env
		StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
		env.setParallelism(1);

		// 2. 数据源-source
		DataStream<String> inputDataStream = env.readTextFile("datas/click.log");

		// 3. 数据转换-transformation
		// TODO: 函数一【map函数】，将JSON转换为JavaBean对象
		DataStream<ClickLog> clickDataStream = inputDataStream.map(new MapFunction<String, ClickLog>() {
			@Override
			public ClickLog map(String line) throws Exception {
				return JSON.parseObject(line, ClickLog.class);
			}
		});
		clickDataStream.printToErr();

		// 5. 触发执行-execute
		env.execute("TransformationBasicDemo") ;
	}

}
```

### 3. flatMap 算子

> `flatMap`：将集合中的每个元素变成一个或多个元素，并返回扁平化之后的结果，==flatMap = map + flattern==

![](assets/1614827326944.png)

> **案例演示说明**：依据`访问网站时间戳`转换为不同时间日期格式数据

```ini
Long类型日期时间：	1577890860000  
				|
				|进行格式
				|
String类型日期格式
		yyyy-MM-dd-HH
		yyyy-MM-dd
		yyyy-MM
```

![1652309341621](assets/1652309341621.png)

```java
		// TODO: 函数二【flatMap】，每条数据转换为日期时间格式
		/*
		Long类型日期时间：	1577890860000
							|
							|进行格式
							|
		String类型日期格式
				yyyy-MM-dd-HH
				yyyy-MM-dd
				yyyy-MM
		 */
		DataStream<String> flatMapDataStream = clickDataStream.flatMap(new FlatMapFunction<ClickLog, String>() {
			@Override
			public void flatMap(ClickLog clickLog, Collector<String> out) throws Exception {
				// 获取访问数据
				Long entryTime = clickLog.getEntryTime();
				// 格式一：yyyy-MM-dd-HH
				String hour = DateFormatUtils.format(entryTime, "yyyy-MM-dd-HH");
				out.collect(hour);

				// 格式二：yyyy-MM-dd
				String day = DateFormatUtils.format(entryTime, "yyyy-MM-dd");
				out.collect(day);

				// 格式三：yyyy-MM
				String month = DateFormatUtils.format(entryTime, "yyyy-MM");
				out.collect(month);
			}
		});
		//flatMapDataStream.printToErr();
```



## 附I. Maven模块



## 附II. Lombok使用及插件安装







