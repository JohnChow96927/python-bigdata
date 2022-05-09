# 实时日志采集及综合案例

## I. Flume快速上手

![image-20210507095910117](assets/image-20210507095910117.png)

### 1. 功能概述

> Aapche Flume是由Cloudera提供的一个高可用的，高可靠的，分布式的海量日志采集、聚合和传输的软件，网址：<http://flume.apache.org/>

![1652021798246](assets/1652021798246.png)

> Apache Flume的核心是**把数据从数据源(source)收集过来，再将收集到的数据送到指定的目的地(sink)**。为了保证输送的过程一定成功，在送到目的地(sink)之前，会**先缓存数据(channel)**，待数据真正到达目的地(sink)后，flume在删除自己缓存的数据。

![1652021842687](assets/1652021842687.png)

- 当前Flume有两个版本：Flume 0.9X版本的统称Flume OG（original generation）和Flume1.X版本的统称Flume NG（next generation）。
- 由于Flume NG经过核心组件、核心配置以及代码架构重构，与Flume OG有很大不同。改动的另一原因是将Flume纳入 apache 旗下，Cloudera Flume 改名为 Apache Flume。

> Flume系统中核心的角色是**agent**，agent本身是**一个Java进程**，一般运行在日志收集节点。

![image-20210507100111078](assets/image-20210507100111078.png)

每一个agent相当于一个数据传递员，内部有三个组件：

- **Source**：采集源，用于跟数据源对接，以获取数据；
- **Sink**：下沉地，采集数据的传送目的，用于往下一级agent或者往最终存储系统传递数据；
- **Channel**：agent内部的数据传输通道，用于从source将数据传递到sink；

> 在整个数据的传输的过程中，流动的是**event**，它是Flume内部数据传输的最基本单元。

![1652022107268](assets/1652022107268.png)

[event将传输的数据进行封装，如果是文本文件，通常是一行记录，event也是事务的基本单位。]()event从source，流向channel，再到sink，本身为一个字节数组，并可携带headers(头信息)信息。**event代表着一个数据的最小完整单元，从外部数据源来，向外部的目的地去。**

![1652022137616](E:/Heima/%E5%B0%B1%E4%B8%9A%E7%8F%AD%E6%95%99%E5%B8%88%E5%86%85%E5%AE%B9%EF%BC%88%E6%AF%8F%E6%97%A5%E6%9B%B4%E6%96%B0%EF%BC%89/NoSQL%20Flink/%E9%A2%84%E4%B9%A0%E8%B5%84%E6%96%99/fake_nosql-%E7%AC%AC8%E5%A4%A9-%E9%A2%84%E4%B9%A0%E8%B5%84%E6%96%99/nosql-%E7%AC%AC8%E5%A4%A9-%E9%A2%84%E4%B9%A0%E8%B5%84%E6%96%99/assets/1652022137616.png)

[一个完整的event包括：event headers、event body，其中event body是flume收集到的日记记录。]()

> Flume 应用场景：

- 场景一：实时数据采集
- 场景二：数据量很大，实时的小部分小部分的采集，节省时间

```ini
# 美团的Flume设计架构
https://tech.meituan.com/2013/12/09/meituan-flume-log-system-architecture-and-design.html
```

### 2. 安装部署

> Apache Flume 的安装非常简单，直接解压，然后配置JDK环境变量即可。

- 1、上传安装包，node1机器上安装

  ```ini
  cd /export/software/
  rz
  ```

  ![1652023242381](assets/1652023242381.png)

- 2、解压安装

  ```shell
  tar -zxf apache-flume-1.9.0-bin.tar.gz -C /export/server/
  
  cd /export/server
  ln -s apache-flume-1.9.0-bin flume
  
  chown -R root:root flume/
  ```

- 3、修改Flume环境变量

  ```shell
  cd /export/server/flume/conf/
  mv flume-env.sh.template flume-env.sh
  vim flume-env.sh 
  ```

  ```ini
  # 修改22行
  export JAVA_HOME=/export/server/jdk
  # 修改34行
  export HADOOP_HOME=/export/server/hadoop
  ```

- 4、集成HDFS，拷贝HDFS配置文件

  ```shell
  cp /export/server/hadoop/etc/hadoop/core-site.xml /export/server/hadoop/etc/hadoop/hdfs-site.xml /export/server/flume/conf/
  ```

  ![1652023585122](assets/1652023585122.png)

- 5、删除Flume自带的guava包，替换成Hadoop的

  ```ini
  # 删除低版本jar包
  rm -rf /export/server/flume/lib/guava-11.0.2.jar
  
  # 拷贝高版本jar包
  cp /export/server/hadoop/share/hadoop/common/lib/guava-27.0-jre.jar /export/server/flume/lib/
  ```

> Flume Agent开发步骤：编写Agent配置文件和启动运行Agent程序。

![image-20210507100111078](assets/image-20210507100111078.png)

- **step1：编写Agent配置文件**
  - 在配置文件中定义Agent，定义这个agent的名称，定义agent的三个基本组件
  - Source是什么？
    - 决定程序**从哪里采集数据**
    - https://flume.apache.org/releases/content/1.7.0/FlumeUserGuide.html#flume-sources
  - Channel是什么？
    - 决定程序**将采集到的数据缓存在什么地方**
    - https://flume.apache.org/releases/content/1.7.0/FlumeUserGuide.html#flume-channels
  - Sink是什么？
    - 决定程序**将数据发送到什么地方**
    - https://flume.apache.org/releases/content/1.7.0/FlumeUserGuide.html#flume-sinks 

- **step2：运行Agent程序**

  - 用法

    ```ini
    Usage:  flume-ng <command> [options]...
    ```

  - 使用

    ```ini
    flume-ng agent  -c Flume配置文件目录 -f 指定运行的文件 -n 运行的Agent的名称
    ```

  - 案例

    ```ini
    flume-ng agent -n xx_name -c /export/server/flume/conf -f xxx.properties
    ```

### 3. 入门案例



### 4. Taildir Source



### 5. Channel缓存



### 6. HDFS Sink



## II. 陌陌综合案例

### 1.  业务需求



### 2. 实时采集日志



### 3. 实时存储HBase



### 4. Hive离线分析



### 5. Phoenix即席查询



## 附录:

### 1. 案例Maven依赖



### 2. 完整代码



