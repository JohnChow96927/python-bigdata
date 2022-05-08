# Kafka存储原理, 生产者与消费者

## I. Kafka存储原理

### 1. 存储结构

> Apache Kafka 集群架构：

![kafka](assets/kafka.png)

- Broker：物理存储节点，用于存储Kafka中Topic队列的每个分区数据
- Producer：生产者，向Topic队列中写入数据
- Consumer：消费者，从Topic队列中读取数据
- Topic：缓冲队列，用于区分不同数据的的存储
- Partition：Topic 对应子队列，一个topic可以设置为多个partition
  - 每个分区存储在Broker节点
  - 名称构成：**Topic名称+partition分区编号**

> Producer把日志信息推送（push）到Broker节点上，然后Consumer（可以是写入到hdfs或者其他的一些应用）再从Broker拉取（pull）信息。

![1651929402266](assets/1651929402266.png)

> 每个topic又可分为几个不同的partition，每一个partition实际上都是一个有序的，不可变的消息序列，producer发送到broker的消息会写入到相应的partition目录下，每个partition都会有一个有序的id（`offset`），这个offset确定这个消息在partition中的具体位置。

![log](assets/log.png)

> 每个分区partition存储时，有多个**segment** 文件组成：

![image-20210328164220108](assets/image-20210328164220108.png)

- Segment：分区段，每个分区的数据存储在1个或者多个Segment中，每个Segment由一对文件组成
  - `.log`：数据文件，以log日志形式存储
  - `.index`：索引文件，方便快速查询检索
  - `.timeindex`：时间索引文件

![1651929832643](assets/1651929832643.png)

> 总结：Kafka中每个队列Topic，分为多个分区Partition，每个分区数据存储时有多个Segment。

![preview](assets/2631159407-5e53669251881.png)

### 2. 写入流程

> **生产者Producer向Topic队列中发送数据【写入流程】：**

- **step1**：生产者生产每一条数据，将数据**放入一个batch批次**中，如果batch满了或者达到一定的时间，提交写入请求
- 批次大小：`batch.size`
  - 发送消息前等待时间：`linger.ms`

- **step2**：生产者根据规则确定写入分区Partition，获取对应的元数据，将请求提交给leader副本所在的Broker

  - 一个Topic的分区Partition会有多个副本，**只向写leader副本**

  - 从元数据中获取当前这个分区对应的leader副本的位置，提交写入请求

  - Kafka 元数据存储在ZK中

    ![1651932284307](assets/1651932284307.png)

- **step3**：数据先写入Broker的**PageCache【操作系统级别内存】**

  - Kafka使用**内存机制**来实现数据的快速的读写
  - 选用了操作系统自带的缓存区域：`PageCache`
  - ==由操作系统来管理所有内存，即使Kafka Broker故障，数据依旧存在PageCache中==

- **step4**：操作系统后台，自动将**页缓存PageCache**中的数据SYNC同步到磁盘文件中：**最新Segment的中.log**

  - Kafka通过操作系统内存刷新调用机制来实现：内存存储容量 + 时间
  - **顺序写磁盘**：不断将每一条数据追加到.log文件中

- **step5**：其他的Follower 副本到Leader 副本中同步数据

### 3. 读取流程

> Kafka中队列Topic每个分区Partition数据存储在磁盘上，分为很多Segment片段，包含数据文件和索引数据。
>
> - `.log`：存储真正的数据
> - `.index`：存储对应的.log文件的索引

- **Segment的划分规则**：满足任何一个条件都会划分segment

  - 按照时间周期生成

    ```properties
    #如果达到7天，重新生成一个新的Segment
    log.roll.hours = 168
    ```

  - 按照文件大小生成

    ```properties
    #如果一个Segment存储达到1G，就构建一个新的Segment
    log.segment.bytes = 1073741824  
    ```

- **Segment文件的命名规则**

  - 以**当前文件存储的最小offset**来命名的

    ```
    00000000000000000000.log			offset : 0 ~ 2344
    00000000000000000000.index
    
    00000000000000002345.log			offset : 2345 ~ 6788
    00000000000000002345.index
    
    00000000000000006789.log			offset : 6789 ~
    00000000000000006789.index
    ```

- **索引内容**

  - 第一列：此条数据在`.log`文件中的位置，编号（序号），从1开始

  - 第二列：此条数据在`.log`文件中的物理偏移量，从0开始

    ```
    文件中的第几条,数据在这个文件中的物理位置
    1,0				--表示log文件中的第1条，在文件中的位置是第0个字节开始
    
    3,497			--表示这个文件中的第3条，在文件中的位置是第497个字节开始
    ```

![1635946713081](assets/1635946713081.png)

- 什么时候生成一条索引？

  - `.log`日志文件中数据每隔多久在`.index`文件添加一条索引

  ```properties
  #.log文件每增加4096字节，在.index中增加一条索引
  log.index.interval.bytes=4096
  ```

> **消费者Consumer从Topic队列中拉取数据【读取流程】：**

- **step1**：消费者根据**Topic、Partition、Offset**提交给Kafka请求读取数据
- **step2**：Kafka根据元数据信息，找到对应分区Partition对应的Leader副本节点
- **step3**：请求Leader副本所在的Broker，**先读PageCache**，通过**零拷贝机制**【Zero Copy】读取PageCache
  - 实现零磁盘读写
  - 直接将内存数据发送到网络端口，实现传输
- **step4**：如果PageCache中没有，读取Segment文件段，先根据offset找到要读取的Segment
  - 先根据offset和segment文件段名称定位这个offset在哪个segment文件段中
- **step5**：将.log文件对应的.index文件加载到内存中，根据.index中索引的信息找到Offset在.log文件中的最近位置
- **step6**：读取.log，根据索引读取对应Offset的数据

> 面试题：向Kafka中写入数据和读取数据，为什么很快？

- Kafka为什么写入很快？
  - [PageCahce + 顺序写]()
- Kafka为什么读取和快？
  - [PageCache + 零拷贝]()
  - [index索引机制 + offset]()

知乎文档：https://zhuanlan.zhihu.com/p/183808742

### 4. 数据清理

> Kafka消息队列Topic主要用于数据缓存，不需要永久性的存储数据，如何将过期数据进行清理？

- **属性配置**

  ```properties
  #开启清理
  log.cleaner.enable = true
  #清理规则
  log.cleanup.policy = delete | compact
  ```

- **清理规则：delete**

  - **基于存活时间规则：**

    ```properties
    log.retention.ms
    log.retention.minutes
    log.retention.hours=168/7天
    ```

  - **基于文件大小规则**

    ```properties
    #删除文件阈值，如果整个数据文件大小，超过阈值的一个segment大小，将会删除最老的segment,-1表示不使用这种规则
    log.retention.bytes = -1
    ```

  - **基于offset消费规则**

    - 功能：将明确已经消费的offset的数据删除

    - 如何判断已经消费到什么位置

      - step1：编写一个文件`offset.json`

        ```json
        {
          "partitions":[
             {"topic": "bigdata", "partition": 0,"offset": 2000},
             {"topic": "bigdata", "partition": 1,"offset": 2000}
           ],
           "version":1
        }
        ```

      - step2：指定标记这个位置

        ```shell
        kafka-delete-records.sh \
        --bootstrap-server node1.itcast.cn:9092,node2.itcast.cn:9092,node3.itcast.cn:9092 \
        --offset-json-file offset.json 
        ```

- **清理规则：compact**

  - 也称为压缩，==将重复的更新数据的老版本删除，保留新版本，要求每条数据必须要有Key，根据Key来判断是否重复==

  <img src="assets/image-20210330222244406.png" alt="image-20210330222244406" style="zoom:80%;" />

### 5. 分区副本概念: AR, ISR, OSR

> **问题**：Kafka中的分区数据如何保证数据安全？

- **分区副本机制**：每个kafka中分区都可以构建多个副本，相同分区的副本存储在不同的节点上

  - 为了**保证数据安全和写的性能**：分区有多个副本角色
  - leader副本：对外提供==读写数据==
  - follower副本：==与Leader同步数据==，如果leader故障，选举一个新的leader
  - 选举leader副本：Kafka主节点Controller实现

  ![1635976897508](assets/1635976897508.png)

- **AR：All - Replicas**（`Assigned Replicas`）

  - 所有副本：**一个分区在所有节点上的副本**

    ```ini
    Partition: 0   Replicas: 1,0 
    ```

- **ISR：In - Sync - Replicas**

  - ==可用副本==：所有正在与Leader同步的Follower副本

    ```ini
    Partition: 0    Leader: 1       Replicas: 1,0   Isr: 1,0
    ```

  - 列表中：按照优先级排列【Controller根据副本同步状态以及Broker健康状态】，越靠前越会成为leader

  - 如果leader故障，是从ISR列表中选择新的leader

- **OSR：Out - Sync  - Replicas**

  - ==不可用副本==：与Leader副本的同步差距很大，成为一个OSR列表的不可用副本

  - 原因：**网路故障等外部环境因素，某个副本与Leader副本的数据差异性很大**

  - 判断是否是一个OSR副本？

    - 0.9之前：时间和数据差异

      ```ini
      replica.lag.time.max.ms = 10000   # 可用副本的同步超时时间
      replica.lag.max.messages = 4000   # 可用副本的同步记录差，该参数在0.9以后被删除
      ```

    - 0.9以后：只按照时间来判断

      ```ini
      replica.lag.time.max.ms = 10000   # 可用副本的同步超时时间
      ```

> **小结**：Kafka中的分区数据如何保证数据安全：[分区副本机制]()

```ini
AR：所有副本
ISR：可用副本
OSR：不可用副本
AR = ISR + OSR
```

![img](assets/20201218173735296.png)

### 6. 数据同步概念: HW, LEO, LSO

> **Topic队列分区Partition副本同步过中的概念：HW、LEO和LSO。**

- 什么是HW、LEO？

  ```ini
  # HW：High Watermark的缩写，俗称高水位
  	标识一个特定的消息偏移量（offset），消费者只能拉取到这个offset之前的消息。
  	HW = 当前这个分区所有副本同步的最低位置 + 1
  		消费者能消费到的最大位置
  
  
  # LEO：Log End Offset 缩写
  	标识当前日志文件中下一条待写入消息的offset
  	LEO = 当前每个副本已经写入数据的最新位置 + 1
  
  ```

  <img src="assets/image-20210331153446511.png" alt="image-20210331153446511" style="zoom:80%;" />

  ```ini
  # 假设topic 分区有3个副本
  	Leader：0 1 2 3 4 5 6 7 8 
  		LEO：9
  	Follower1: 0  1 2  3 4 5
  		LEO：6
  	Follower2：0  1  2  3  4  5 6
  		LEO = 7
  	HW = 6
  	
  
  # 分区HW高水位 =  所有副本中LEO最小值
      low_watermark：最低消费的offset
      high_watermark：最高消费的offset
  ```

![img](assets/1387008-20210827185057588-2029732907.png)

- **数据写入Leader及同步过程**

  ![1635978562469](assets/1635978562469.png)

- step1、数据写入分区的Leader副本

<img src="assets/image-20210331153522041.png" alt="image-20210331153522041" style="zoom:80%;" />

```ini
leader：LEO = 5 
follower1：LEO = 3
follower2：LEO = 3
```

- step2：Follower到Leader副本中同步数据

  <img src="assets/image-20210331153541554.png" alt="image-20210331153541554" style="zoom:80%;" />

```ini
  leader：LEO = 5 
  follower1：LEO = 5
  follower2：LEO = 4
```

- step3：所有的副本都成功写入了消息3和消息4，整个分区的HW和LEO都变为5，因此消费者可以消费到offset为4的消息。

![1635978717791](assets/1635978717791.png)

```ini
leader：LEO = 5 
follower1：LEO = 5
follower2：LEO = 5
  
HW = LEO = 5
```

### 7. 可视化工具: Kafka Eagle

> **Kafka Eagle 监控工具**：可以管理监控kafka集群，面板可视化，管理Kafka主题（包含查看、删除、创建等）、消费者组合消费者实例监控、消息阻塞告警、Kafka集群健康状态查看等，告警功能，同时支持邮件、微信、钉钉告警通知。

```ini
# 官网：
	https://www.kafka-eagle.org/
# 文档：
	https://www.kafka-eagle.org/articles/docs/documentation.html
# 下载：
	http://download.kafka-eagle.org/
```

- 1、下载解压，在node3集群

  ```shell
  cd /export/software/
  rz
  
  tar -zxvf kafka-eagle-web-1.4.6-bin.tar.gz -C /export/server/
  cd /export/server/kafka-eagle-web-1.4.6
  ```

- 2、准备数据库：存储eagle的元数据，在Mysql中创建一个数据库

  ```ini
  [root@node1 ~]# mysql -uroot -p123456
  ```

  ```sql
  CREATE DATABASE eagle;
  ```

- 3、修改配置文件：

  ```shell
  cd /export/server/kafka-eagle-web-1.4.6/conf/
  vim  system-config.properties
  ```

  ```properties
  ######################################
  # multi zookeeper & kafka cluster list
  ######################################
  kafka.eagle.zk.cluster.alias=cluster1
  node1.itcast.cn:2181,node2.itcast.cn:2181,node3.itcast.cn:2181/kafka
  
  ######################################
  # broker size online list
  ######################################
  cluster1.kafka.eagle.broker.size=20
  
  ######################################
  # zk client thread limit
  ######################################
  kafka.zk.limit.size=25
  
  ######################################
  # kafka eagle webui port
  ######################################
  kafka.eagle.webui.port=8048
  
  ######################################
  # kafka offset storage
  ######################################
  cluster1.kafka.eagle.offset.storage=kafka
  cluster2.kafka.eagle.offset.storage=zk
  
  ######################################
  # kafka metrics, 30 days by default
  ######################################
  kafka.eagle.metrics.charts=true
  kafka.eagle.metrics.retain=30
  
  
  ######################################
  # kafka sql topic records max
  ######################################
  kafka.eagle.sql.topic.records.max=5000
  kafka.eagle.sql.fix.error=false
  
  ######################################
  # delete kafka topic token
  ######################################
  kafka.eagle.topic.token=keadmin
  
  ######################################
  # kafka sasl authenticate
  ######################################
  cluster1.kafka.eagle.sasl.enable=false
  cluster1.kafka.eagle.sasl.protocol=SASL_PLAINTEXT
  cluster1.kafka.eagle.sasl.mechanism=SCRAM-SHA-256
  cluster1.kafka.eagle.sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="kafka" password="kafka-eagle";
  cluster1.kafka.eagle.sasl.client.id=
  cluster1.kafka.eagle.sasl.cgroup.enable=false
  cluster1.kafka.eagle.sasl.cgroup.topics=
  
  ######################################
  # kafka mysql jdbc driver address
  ######################################
  kafka.eagle.driver=com.mysql.jdbc.Driver
  kafka.eagle.url=jdbc:mysql://node1.itcast.cn:3306/eagle?useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull
  kafka.eagle.username=root
  kafka.eagle.password=123456
  ```

- 4、配置环境变量

  ```shell
  vim /etc/profile
  ```

  ```ini
  # KE_HOME
  export KE_HOME=/export/server/kafka-eagle-web-1.4.6
  export PATH=$PATH:$KE_HOME/bin
  ```

  ```ini
  source /etc/profile
  ```

- 5、添加执行权限

  ```shell
  chmod u+x /export/server/kafka-eagle-web-1.4.6/bin/ke.sh
  ```

- 6、启动服务

  ```ini
  /export/server/kafka-eagle-web-1.4.6/bin/ke.sh start
  ```

  ![1651940329029](assets/1651940329029-1651998823008.png)

- 7、登陆

  ```ini
  # 网页：
  	http://node3.itcast.cn:8048/ke
  # 用户名：
  	admin
  # 密码：
  	123456
  ```

![image-20210402102447211](assets/image-20210402102447211-1651998818529.png)

- 8、Kafka Eagle使用

  - 监控Kafka集群

    ![image-20210402102510140](assets/image-20210402102510140-1651998815607.png)

    ![image-20210402102529749](assets/image-20210402102529749-1651998813447.png)

  - 监控Zookeeper集群

    ![image-20210402102553266](assets/image-20210402102553266-1651998811174.png)

    ![image-20210402102600285](assets/image-20210402102600285-1651998808648.png)

  - 监控Topic

    ![image-20210402102615411](assets/image-20210402102615411-1651998806700.png)

    ![image-20210402102626221](assets/image-20210402102626221-1651998802676.png)

    ![image-20210402102656476](assets/image-20210402102656476-1651998800578.png)

    ![image-20210402102812506](assets/image-20210402102812506-1651998791823.png)

  - **查看数据积压**

    - 现象：消费跟不上生产速度，导致处理的延迟
    - **原因**
      - 消费者组的并发能力不够
    - 消费者处理失败

- 网络故障，导致数据传输较慢

- 解决

  - 提高消费者组中消费者的并行度

  - 分析处理失败的原因

  - 找到网络故障的原因

  - 查看监控

    ![image-20210402102945675](assets/image-20210402102945675-1651998788519.png)

    ![image-20210402103024311](assets/image-20210402103024311-1651998785995.png)

- 检查集群状态情况报表

  ![image-20210402103550318](assets/image-20210402103550318-1651998781496.png)

## II. Kafka Producer

### 1. ACK机制

> **ack机制**：producer发送消息的确认机制，会影响到kafka的消息吞吐量和安全可靠性。

![1635918368067](assets/1635918368067.png)

- 参数：`ack`，数据传输的**确认码**，用于==定义生产者如何将数据写入Kafka==
  - `0`：生产者发送一条数据写入Kafka，不管Kafka有没有写入这条数据，都直接发送下一条【**快，不安全，不用的**】
  - `1`：中和性方案，生产者发送一条数据写入Kafka，Kafka将这条数据写入对应分区Leader副本，就返回一个ack，生产者收到ack，发送下一条【**性能和安全性之间做了权衡**】
  - `all/-1`：生产者发送一条数据写入Kafka，Kafka将这条数据写入对应分区Leader副本，并且等待所有Follower同步成功，就返回一个ack，生产者收到ack，发送下一条【**安全，慢**】
  - [如果ack为-1或者为all，生产者没有收到ack，就认为数据丢失，重新发送这条数据]()

```Java
package cn.itcast.kafka.producer;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;

import java.util.Properties;

/**
 * 使用Java API开发Kafka 生产者，发送数据到Topic队列
 */
public class KafkaWriteAckTest {

	public static void main(String[] args) {
		// TODO: 1. 构建KafkaProducer对象
		Properties props = new Properties() ;
		// Kafka Brokers地址
		props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "node1.itcast.cn:9092,node2.itcast.cn:9092,node3.itcast.cn:9092") ;
		// 写入数据时Key和Value类型
		props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringSerializer") ;
		props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringSerializer") ;
		// TODO: 设置数据发送确认机制ack
		props.put(ProducerConfig.ACKS_CONFIG, "-1") ;
		// 传递属性，创建对象
		KafkaProducer<String, String> kafkaProducer = new KafkaProducer<String, String>(props) ;

		// TODO: 2. 构建ProducerRecord实例，封装数据
		ProducerRecord<String, String> producerRecord = new ProducerRecord<>("test-topic", "hello world");

		// TODO: 3. 调用send方法，发送数据至Topic
		kafkaProducer.send(producerRecord);

		// TODO: 4. 关闭资源
		kafkaProducer.close();
	}

}
```

> **面试题**：Kafka的生产者如何保证生产数据不丢失的机制原理：**ACK + 重试机制**

- 第一点：**ACK 机制**

  - [生产者生产数据写入kafka，等待kafka返回ack确认，收到ack，生产者发送下一条]()
  - **0**：不等待ack，直接发送下一条
    - 优点：快
    - 缺点：数据易丢失
  - **1**：生产者将数据写入Kafka，Kafka等待这个分区Leader副本，返回ack，发送下一条
    - 优点：性能和安全做了中和的选项
    - 缺点：依旧存在一定概率的数据丢失的情况
  - **all**：生产者将数据写入Kafka，Kafka等待这个分区所有ISR副本同步成功，返回ack，发送下一条
    - 优点：安全
    - 缺点：性能比较差
    - 问题：如果ISR中只有leader一个，leader写入成功，直接返回，leader故障数据丢失怎么办？
    - 解决：搭配`min.insync.replicas`来使用，表示最少要有几个ISR的副本

- 第二点：**重试机制**

  ```ini
  retries = 0 发送失败的重试次数
  ```

  ![1651942276749](assets/1651942276749.png)

### 2. 分区规则

> **问题**：当Producer生产者向Topic队列中发送数据时，如何确定发送到哪个分区Partition呢？

- 第1、**如果指定分区：写入所指定的分区中**

  ![image-20210531095525775](assets/image-20210531095525775.png)

- 第2、如果没指定分区：默认调用的是`DefaultPartitioner`分区器中`partition`这个方法

  ![image-20210531095726567](assets/image-20210531095726567.png)

  - 第一点、**如果指定Key：按照Key的Hash取余分区的个数，来写入对应的分区**

  - 第二点、 **如果没有指定Key：按照黏性分区**

    ![image-20210531100112872](assets/image-20210531100112872.png)

    > 在Kafka 不同版本中，Produer生产者发送数据时，如果没有分区和Key时，分区规则有区别的。

    - **2.4之前：轮询分区**，数据分配相对均衡

      ```ini
      Topic			part		key		value
      test-topic		0			1		itcast1
      test-topic		1			2		itcast2
      test-topic		2			3		itcast3
      
      test-topic		0			4		itcast4
      test-topic		1			5		itcast5
      test-topic		2			6		itcast6
      
      test-topic		0			7		itcast7
      test-topic		1			8		itcast8
      test-topic		2			9		itcast9
      ```

      - 缺点：性能非常差

      ```ini
      # step1：先将数据放入一个批次中，判断是否达到条件，达到条件才将整个批次的数据写入kafka
      	批次满【batch.size】
      	达到一定时间【linger.ms】
      
      # step2：根据数据属于哪个分区，就与分区构建一个连接，发送这个分区的批次的数据
          第一条数据：先构建0分区的连接，第二条不是0分区的，所以直接构建一个批次，发送第一条
          第二条数据：先构建1分区的连接，第三条不是1分区的，所以直接构建一个批次，发送第二条
          ……
          每条数据需要构建一个批次，9条数据，9个批次，每个批次一条数据
          
          # 批次多，每个批次数据量少，性能比较差
      ```

  - **2.4之后：黏性分区**，==实现少批次多数据==

    - 规则：**判断缓存中是否有这个topic的分区连接，如果有，直接使用，如果没有随机写入一个分区，并且放入缓存**

      ![image-20210531100940160](assets/image-20210531100940160.png)

      ![image-20210531101042589](assets/image-20210531101042589.png)      

    - 第一次：将所有数据随机选择一个分区，全部写入这个分区中，将这次的分区编号放入缓存中

      ```
      test-topic	1	37	null	itcast0
      test-topic	1	38	null	itcast1
      test-topic	1	39	null	itcast2
      test-topic	1	40	null	itcast3
      test-topic	1	41	null	itcast4
      test-topic	1	42	null	itcast5
      test-topic	1	43	null	itcast6
      test-topic	1	44	null	itcast7
      test-topic	1	45	null	itcast8
      test-topic	1	46	null	itcast9
      ```

    - 第二次开始根据缓存中是否有上一次的编号

      ```ini
      # 有：
      	直接使用上一次的编号
      
      # 没有：
      	重新随机选择一个
      ```

### 3. 自定义分区器



### 4. 事务幂等性



## III. Kafka Consumer

### 1. 消费分配策略



### 2. 消费Offset



### 3. 消费Topic



### 4. 消费语义



## 附录: Kafka集群常用配置

