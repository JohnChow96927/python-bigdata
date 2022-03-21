# Spark高级特性与内核调度

## I. Spark高级特性

### 1. RDD持久化



### 2. RDD Checkpoint



### 3. Spark累加器



### 4. Spark广播变量



## II. Spark内核调度

### 1. 应用提交流程

> 当开发完成Spark程序以后，使用`spark-submit`提交执行时，2件事情：

- 第一、申请资源，运行Driver和Executors 进程
- 第二、调度Job，执行Task任务

![1635026414304](assets/1635026414304.png)

> 1、使用spark-submit脚本，提交应用执行，比如以==**yarn-cluster**==方式执行

![1635027406252](assets/1635027406252.png)

> 2、启动运行Driver Program进程，执行MAIN方法代码，先创建SparkContext对象，申请资源，运行Executors

![1635025559972](assets/1635025559972.png)

> 3、当应用的Executors启动运行后，向Driver Program反向注册，等待发送Task任务执行

![1635027035738](assets/1635027035738.png)

- **主节点：ResourceManager，管理节点，集群老大**
  1. 接受客户端Client请求应用Application请求
  2. 管理从节点NodeManager，分配容器启动AppMaster
- **从节点：NodeManager，工作节点，集群小弟**
  1. 管理当前节点资源，包含Memory内存和CPU Core核数
  2. 接收老大ResourceManager和应用管理者AppMaster请求，分配资源到Container容器，运行对应进程
- **应用管理者：DriverProgram/AppMaster，应用老大**
  1. yarn-cluster时，由ResourceManager分配资源，在NodeManager的容器Container，启动JVM进程
  2. 向主节点ResourceManager申请资源，在NodeManager的容器Container中启动运行Executors
  3. 调度应用中每个Job执行执行（Job划分Stage，Stage划分Task任务及Task任务运行Executor）
- **应用执行进程：Executors，应用小弟**
  1. 运行在从节点NodeManager容器Container中JVM进程，每个应用都有自己Executors进程
  2. 执行应用中各个Job生成Task任务
  3. 缓存RDD中数据

> 4、继续执行MAIN方法代码，比如创建RDD、调用RDD转换算子和触发算子，当**RDD调用`foreach`触发函数**，触发Job执行，生成DAG图，划分Stage阶段，计算Task任务，调度到Executors中执行。

![1639130727465](assets/1639130727465.png)

### 2. RDD依赖关系



### 3. Spark Shuttle



### 4. Job调度流程



