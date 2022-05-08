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



### 3. 读取流程



### 4. 数据清理



### 5. 分区副本概念: AR, ISR, OSR



### 6. 数据同步概念: HW, LEO, LSO



### 7. 可视化工具: Kafka Eagle



## II. Kafka Producer

### 1. ACK机制



### 2. 分区规则



### 3. 自定义分区器



### 4. 事务幂等性



## III. Kafka Consumer

### 1. 消费分配策略



### 2. 消费Offset



### 3. 消费Topic



### 4. 消费语义



## 附录: Kafka集群常用配置

