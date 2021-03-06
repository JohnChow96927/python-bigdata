## I. HDFS其他功能

1. ### 不同集群之间的数据复制

   ##### 在我们实际工作当中，极有可能会遇到将测试集群的数据拷贝到生产环境集群，或者将生产环境集群的数据拷贝到测试集群，那么就需要我们在多个集群之间进行数据的远程拷贝，hadoop自带也有命令可以帮我们实现这个功能。

   1. #### 集群内布文件拷贝scp

      ```shell
      cd /export/softwares/
      scp -r jdk-8u141-linux-x64.tar.gz root@node2:/export/
      ```

   2. #### 跨集群之间的数据拷贝distcp

      ##### 用法：

      ```shell
      #同一个集群内 复制操作
      hadoop fs -cp /zookeeper.out /itcast
      
      #跨集群复制操作
      hadoop distcp hdfs://node1:8020/1.txt  hdfs:node5:8020/itcast
      ```

2. ### Archive档案的使用

   ​	HDFS并不擅长存储小文件，因为每个文件最少一个block，每个block的元数据都会在NameNode占用内存，如果存在大量的小文件，它们会吃掉NameNode节点的大量内存。

   ​	Hadoop Archives可以有效的处理以上问题，它可以把多个文件归档成为一个文件，归档成一个文件后还可以透明的访问每一个文件。

   1. #### 如何创建Archive

      Usage:

      ```shell
      hadoop archive -archiveName name -p <parent> <src>* <dest>
      ```

      ​           -archiveName 指要创建的存档的名称。扩展名应该是*.har。 

      ​           -p 指定文件档案文件src的相对路径。

      比如：

      ```shell
      -p /foo/bar a/b/c e/f/g
      ```

      这里的/foo/bar是a/b/c与e/f/g的父路径，所以完整路径为/foo/bar/a/b/c与/foo/bar/e/f/g。

      例如：如果你只想存档一个目录/input下的所有文件:

      ```shell
      hadoop archive -archiveName test.har -p /input  /outputdir
      ```

      这样就会在/outputdir目录下创建一个名为test.har的存档文件。

      ![1644978975660](assets/1644978975660.png)

      ![1644978983387](assets/1644978983387.png)

   2. #### 如何查看Archive

      ```shell
      hadoop fs -ls /outputdit/test/har
      ```

      ![1644979090296](assets/1644979090296.png)

      ​	这里可以看到har文件包括：两个索引文件，多个part文件（本例只有一个）以及一个标识成功与否的文件。part文件是多个原文件的集合，根据index文件去找到原文件。

      ​	例如上述的三个小文件1.txt 2.txt 3.txt内容分别为1，2，3。进行archive操作之后，三个小文件就归档到test.har里的part-0一个文件里。

      ![1644979210372](assets/1644979210372.png)

      ![1644979216346](assets/1644979216346.png)

      ​	archive作为文件系统层暴露给外界。所以所有的fs shell命令都能在archive上运行，但是要使用不同的URI。Hadoop Archives的URI是：

      ​	har://scheme-hostname:port/archivepath/fileinarchive   

      ​	scheme-hostname格式为hdfs-域名:端口，如果没有提供scheme-hostname，它会使用默认的文件系统。这种情况下URI是这种形式：

      ​	har:///archivepath/fileinarchive   

      ​	如果用har uri去访问的话，索引、标识等文件就会隐藏起来，只显示创建档案之前的原文件：

      ![1644979242344](assets/1644979242344.png)

      ![1644979248264](assets/1644979248264.png)

      ![1644979253977](assets/1644979253977.png)

   3. #### 如何解压Archive

      按顺序解压存档（串行）：

      Hadoop fs -cp har:///user/zoo/foo.har/dir1  hdfs:/user/zoo/newdir

      要并行解压存档，请使用DistCp：

      hadoop distcp har:///user/zoo/foo.har/dir1  hdfs:/user/zoo/newdir

   4. #### Archive注意事项

      1. Hadoop archives是特殊的档案格式。一个Hadoop archive对应一个文件系统目录。Hadoop archive的扩展名是*.har；

      2. 创建archives本质是运行一个Map/Reduce任务，所以应该在Hadoop集群上运行创建档案的命令； 

      3. 创建archive文件要消耗和原文件一样多的硬盘空间；

      4. archive文件不支持压缩，尽管archive文件看起来像已经被压缩过；

      5. archive文件一旦创建就无法改变，要修改的话，需要创建新的archive文件。事实上，一般不会再对存档后的文件进行修改，因为它们是定期存档的，比如每周或每日；

      6. 当创建archive时，源文件不会被更改或删除

## II. HDFS元数据管理机制

1. ### 元数据管理概述

   HDFS元数据，按类型分，主要包括以下几个部分： 

   1、文件、目录自身的属性信息，例如文件名，目录名，修改信息等。 

   2、文件记录的信息的存储相关的信息，例如存储块信息，分块情况，副本个数等。 

   3、记录HDFS的Datanode的信息，用于DataNode的管理。

   按形式分为内存元数据和元数据文件两种，分别存在**内存**和**磁盘**上。

   HDFS磁盘上元数据文件分为两类，用于持久化存储：

   **fsimage 镜像文件**：是元数据的一个持久化的检查点，包含Hadoop文件系统中的所有目录和文件元数据信息，但不包含文件块位置的信息。文件块位置信息只存储在内存中，是在 datanode加入集群的时候，namenode询问datanode得到的，并且间断的更新。

   **Edits 编辑日志**：存放的是Hadoop文件系统的所有更改操作（文件创建，删除或修改）的日志，文件系统客户端执行的更改操作首先会被记录到edits文件中。

   fsimage和edits文件都是经过序列化的，在NameNode启动的时候，它会将fsimage文件中的内容加载到内存中，之后再执行edits文件中的各项操作，使得内存中的元数据和实际的同步，存在内存中的元数据支持客户端的读操作，也是最完整的元数据。

   当客户端对HDFS中的文件进行新增或者修改操作，操作记录首先被记入edits日志文件中，当客户端操作成功后，相应的元数据会更新到内存元数据中。因为fsimage文件一般都很大（GB级别的很常见），如果所有的更新操作都往fsimage文件中添加，这样会导致系统运行的十分缓慢。

   HDFS这种设计实现着手于：一是内存中数据更新、查询快，极大缩短了操作响应时间；二是内存中元数据丢失风险颇高（断电等），因此辅佐元数据镜像文件（fsimage）+编辑日志文件（edits）的备份机制进行确保元数据的安全。

   **NameNode维护整个文件系统元数据**。因此，元数据的准确管理，影响着HDFS提供文件存储服务的能力。

2. ### 元数据目录相关文件

   在Hadoop的HDFS首次部署好配置文件之后，并不能马上启动使用，而是先要对文件系统进行格式化。需要在NameNode（NN）节点上进行如下的操作：

   $HADOOP_HOME/bin/hdfs namenode –format

   在这里要注意两个概念，一个是文件系统，此时的文件系统在物理上还不存在；二就是此处的格式化并不是指传统意义上的本地磁盘格式化，而是一些清除与准备工作。

   格式化完成之后，将会在$dfs.namenode.name.dir/current目录下创建如下的文件结构，这个目录也正是namenode元数据相关的文件目录：

   ![1644981944378](assets/1644981944378.png)

   其中的dfs.namenode.name.dir是在hdfs-site.xml文件中配置的，默认值如下：

   ![1644981961440](assets/1644981961440.png)

   dfs.namenode.name.dir属性可以配置多个目录，各个目录存储的文件结构和内容都完全一样，相当于备份，这样做的好处是当其中一个目录损坏了，也不会影响到Hadoop的元数据，特别是当其中一个目录是NFS（网络文件系统Network File System，NFS）之上，即使你这台机器损坏了，元数据也得到保存。

   下面对$dfs.namenode.name.dir/current/目录下的文件进行解释。

   **VERSION** 

   namespaceID=934548976

   clusterID=CID-cdff7d73-93cd-4783-9399-0a22e6dce196

   cTime=0

   storageType=NAME_NODE

   blockpoolID=BP-893790215-192.168.24.72-1383809616115

   layoutVersion=-47

   namespaceID/clusterID/blockpoolID 这些都是HDFS集群的唯一标识符。标识符被用来防止DataNodes意外注册到另一个集群中的namenode上。这些标识在联邦（federation）部署中特别重要。联邦模式下，会有多个NameNode独立工作。每个的NameNode提供唯一的命名空间（namespaceID），并管理一组唯一的文件块池（blockpoolID）。clusterID将整个集群结合在一起作为单个逻辑单元，在集群中的所有节点上都是一样的。

   storageType说明这个文件存储的是什么进程的数据结构信息（如果是DataNode，storageType=DATA_NODE）；

   cTime NameNode存储系统创建时间，首次格式化文件系统这个属性是0，当文件系统升级之后，该值会更新到升级之后的时间戳；

   layoutVersion表示HDFS永久性数据结构的版本信息，是一个负整数。

   补充说明：

   *格式化集群的时候，可以指定集群的cluster_id，但是不能与环境中其他集群有冲突。如果没有提供cluster_id，则会自动生成一个唯一的ClusterID。*

   *$HADOOP_HOME/bin/hdfs namenode -format -clusterId <cluster_id>*

   **seen_txid**

   $dfs.namenode.name.dir/current/seen_txid非常重要，是存放transactionId的文件，format之后是0，它代表的是namenode里面的edits_*文件的尾数，namenode重启的时候，会按照seen_txid的数字，循序从头跑edits_0000001~到seen_txid的数字。所以当你的hdfs发生异常重启的时候，一定要比对seen_txid内的数字是不是你edits最后的尾数。

   **Fsimage & edits**

   $dfs.namenode.name.dir/current

   目录下在format的同时也会生成fsimage和edits文件，及其对应的md5校验文件。

3. ### Fsimage、Edits

   1. #### 概述

      **fsimage**文件其实是Hadoop文件系统元数据的一个永久性的检查点，其中包含Hadoop文件系统中的所有目录和文件idnode的序列化信息；

      fsimage包含Hadoop文件系统中的所有目录和文件idnode的序列化信息；对于文件来说，包含的信息有修改时间、访问时间、块大小和组成一个文件块信息等；而对于目录来说，包含的信息主要有修改时间、访问控制权限等信息。

       

      **edits**文件存放的是Hadoop文件系统的所有更新操作的路径，文件系统客户端执行的所以写操作首先会被记录到edits文件中。

      NameNode起来之后，HDFS中的更新操作会重新写到edits文件中，因为fsimage文件一般都很大（GB级别的很常见），如果所有的更新操作都往fsimage文件中添加，这样会导致系统运行的十分缓慢，但是如果往edits文件里面写就不会这样，每次执行写操作之后，且在向客户端发送成功代码之前，edits文件都需要同步更新。如果一个文件比较大，使得写操作需要向多台机器进行操作，只有当所有的写操作都执行完成之后，写操作才会返回成功，这样的好处是任何的操作都不会因为机器的故障而导致元数据的不同步。

   2. #### 内容查看

      fsimage、edits两个文件中的内容使用普通文本编辑器是无法直接查看的，幸运的是hadoop为此准备了专门的工具用于查看文件的内容，这些工具分别为**oev**和**oiv**，可以使用hdfs调用执行。

      oev是offline edits viewer（离线edits查看器）的缩写，该工具只操作文件因而并不需要hadoop集群处于运行状态。

         hdfs oev   -i edits_0000000000000000081-0000000000000000089 -o edits.xml   

      -i,--inputFile <arg>   

      -o,--outputFile <arg>  Name of output file.

      在输出文件中，每个

      RECORD

      记录了一次操作, 示例如下：

      ![1644982058984](assets/1644982058984.png)

      oiv是offline image viewer的缩写，用于将fsimage文件的内容转储到指定文件中以便于阅读，该工具还提供了只读的WebHDFS API以允许离线分析和检查hadoop集群的命名空间。oiv在处理非常大的fsimage文件时是相当快的，如果该工具不能够处理fsimage，它会直接退出。该工具不具备向后兼容性，比如使用hadoop-2.4版本的oiv不能处理hadoop-2.3版本的fsimage，只能使用hadoop-2.3版本的oiv。同oev一样，就像它的名称所提示的（offline），oiv也不需要hadoop集群处于运行状态。

      ​	hdfs oiv   -i fsimage_0000000000000000115 -p XML -o fsimage.xml

      ![1644982140761](assets/1644982140761.png)

## III. Secondary NameNode

![1644982670663](assets/1644982670663.png)

NameNode职责是管理元数据信息，DataNode的职责是负责数据具体存储，那么SecondaryNameNode的作用是什么？对很多初学者来说是非常迷惑的。它为什么会出现在HDFS中。从它的名字上看，它给人的感觉就像是NameNode的备份。但它实际上却不是。

当HDFS集群运行一段时间后，就会出现下面一些问题：

l  edit logs文件会变的很大，怎么去管理这个文件是一个挑战。

l  NameNode重启会花费很长时间，因为有很多改动要合并到fsimage文件上。

l  如果NameNode挂掉了，那就丢失了一些改动。因为此时的fsimage文件非常旧。

因此为了克服这个问题，我们需要一个易于管理的机制来帮助我们**减小edit logs文件的大小和得到一个最新的fsimage文件**，这样也会减小在NameNode上的压力。这跟Windows的恢复点是非常像的，Windows的恢复点机制允许我们对OS进行快照，这样当系统发生问题时，我们能够回滚到最新的一次恢复点上。

SecondaryNameNode就是来帮助解决上述问题的，它的职责是合并NameNode的edit logs到fsimage文件中。

![1644982716609](assets/1644982716609.png)

1. ### Checkpoint

   每达到触发条件，会由secondary namenode将namenode上积累的所有edits和一个最新的fsimage下载到本地，并加载到内存进行merge（这个过程称为checkpoint），如下图所示：

   ![1644982803672](assets/1644982803672.png)

   1. #### Checkpoint详细步骤

      l  NameNode管理着元数据信息，其中有两类持久化元数据文件：edits操作日志文件和fsimage元数据镜像文件。新的操作日志不会立即与fsimage进行合并，也不会刷到NameNode的内存中，而是会先写到edits中(因为合并需要消耗大量的资源)，操作成功之后更新至内存。

      l  有dfs.namenode.checkpoint.period和dfs.namenode.checkpoint.txns 两个配置，只要达到这两个条件任何一个，secondarynamenode就会执行checkpoint的操作。

      l  当触发checkpoint操作时，NameNode会生成一个新的edits即上图中的edits.new文件，同时SecondaryNameNode会将edits文件和fsimage复制到本地（HTTP GET方式）。

      l  secondarynamenode将下载下来的fsimage载入到内存，然后一条一条地执行edits文件中的各项更新操作，使得内存中的fsimage保存最新，这个过程就是edits和fsimage文件合并，生成一个新的fsimage文件即上图中的Fsimage.ckpt文件。

      l  secondarynamenode将新生成的Fsimage.ckpt文件复制到NameNode节点。

      l  在NameNode节点的edits.new文件和Fsimage.ckpt文件会替换掉原来的edits文件和fsimage文件，至此刚好是一个轮回，即在NameNode中又是edits和fsimage文件。

      等待下一次checkpoint触发SecondaryNameNode进行工作，一直这样循环操作。

   2. #### Checkpoint触发条件

      Checkpoint操作受两个参数控制，可以通过core-site.xml进行配置：

      ```xml
      <property>
        <name> dfs.namenode.checkpoint.period</name>
         <value>3600</value>
       	<description>
      		两次连续的checkpoint之间的时间间隔。默认1小时
      	</description>
      </property>
      <property>
        <name>dfs.namenode.checkpoint.txns</name>
        <value>1000000</value>
        <description>
      		最大的没有执行checkpoint事务的数量，满足将强制执行紧急checkpoint，即使尚未达到检查点	周期。默认设置为100万。  
      	</description>
      </property>
      ```

      从上面的描述我们可以看出，SecondaryNamenode根本就不是Namenode的一个热备，其只是将fsimage和edits合并。其拥有的fsimage不是最新的，因为在他从NameNode下载fsimage和edits文件时候，新的更新操作已经写到edit.new文件中去了。而这些更新在SecondaryNamenode是没有同步到的！当然，**如果NameNode中的fsimage真的出问题了，还是可以用SecondaryNamenode中的fsimage替换一下NameNode上的fsimage，虽然已经不是最新的fsimage，但是我们可以将损失减小到最少！**

## IV. HDFS安全模式

1. ### 安全模式概述（可读不可写）

   安全模式是HDFS所处的一种特殊状态，在这种状态下，文件系统只接受读数据请求，而不接受删除、修改等变更请求，是一种保护机制，用于保证集群中的数据块的安全性。

   在NameNode主节点启动时，HDFS首先进入安全模式，集群会开始检查数据块的完整性。DataNode在启动的时候会向namenode汇报可用的block信息，当整个系统达到安全标准时，HDFS自动离开安全模式。

   假设我们设置的副本数（即参数dfs.replication）是5，那么在Datanode上就应该有5个副本存在，假设只存在3个副本，那么比例就是3/5=0.6。在配置文件hdfs-default.xml中定义了一个最小的副本的副本率（即参数dfs.namenode.safemode.threshold-pct）0.999。

   我们的副本率0.6明显小于0.99，因此系统会自动的复制副本到其他的DataNode,使得副本率不小于0.999.如果系统中有8个副本，超过我们设定的5个副本，那么系统也会删除多余的3个副本。

   如果HDFS处于安全模式下，不允许HDFS客户端进行任何修改文件的操作, 包括上传文件，删除文件，重命名，创建文件夹,修改副本数等操作。

2. ### 安全模式配置

   与安全模式相关主要配置在hdfs-site.xml文件中，主要有下面几个属性:

   dfs.namenode.replication.min: 每个数据块最小副本数量，默认为1. 在上传文件时，达到最小副本数，就认为上传是成功的。

   dfs.namenode.safemode.threshold-pct: 达到最小副本数的数据块的百分比。默认为0.999f。当小于这个比例，那就将系统切换成安全模式，对数据块进行复制；当大于该比例时，就离开安全模式，说明系统有足够的数据块副本数，可以对外提供服务。小于等于0意味不进入安全模式，大于1意味一直处于安全模式。

   dfs.namenode.safemode.min.datanodes: 离开安全模式的最小可用datanode数量要求，默认为0.也就是即使所有datanode都不可用，仍然可以离开安全模式。

   dfs.namenode.safemode.extension: 当集群可用block比例，可用datanode都达到要求之后，如果在extension配置的时间段之后依然能满足要求，此时集群才离开安全模式。单位为毫秒，默认为30000.也就是当满足条件并且能够维持30秒之后，离开安全模式。 这个配置主要是对集群稳定程度做进一步的确认。避免达到要求后马上又不符合安全标准。

   总结一下，要离开安全模式，需要满足以下条件： 

   1）达到副本数量要求的block比例满足要求； 

   2）可用的datanode节点数满足配置的数量要求； 

   3） 1、2 两个条件满足后维持的时间达到配置的要求

3. ### 安全模式命令

   手动进入安全模式

      hdfs dfsadmin -safemode enter   

   手动进入安全模式对于集群维护或者升级的时候非常有用，因为这时候HDFS上的数据是只读的。手动退出安全模式可以用下面命令：

      hdfs dfsadmin -safemode leave   

   如果你想获取到集群是否处于安全模式，可以用下面的命令获取：

      hdfs dfsadmin -safemode get

## V. 初识Hadoop MapReduce

1. ### mapReduce计算模型介绍

   1. #### 理解MapReduce思想

      MapReduce的思想核心是“**分而治之**”。

      所谓“分而治之”就是把一个复杂的问题按一定的“分解”方法分为规模较小的若干部分，然后逐个解决，分别找出各部分的解，再把把各部分的解组成整个问题的解。

      这种朴素的思想来源于人们生活与工作的经验，也完全适合于技术领域。诸如软件的体系结构设计、模块化设计都是分而治之的具体表现。即使是发布过论文实现分布式计算的谷歌也只是实现了这种思想，而不是自己原创。

      概况起来，MapReduce所包含的思想分为两步：

      Map负责“分”，即把复杂的任务分解为若干个“简单的任务”来并行处理。可以进行拆分的前提是这些小任务可以并行计算，彼此间几乎没有依赖关系。

      Reduce负责“合”，即对map阶段的结果进行全局汇总。

      这两个阶段合起来正是MapReduce思想的体现。

      ![1644995888894](assets/1644995888894.png)

      还有一个比较形象的语言解释MapReduce：要数停车场中的所有停放车的总数量。

      你数第一列，我数第二列…这就是Map阶段，人越多，能够同时数车的人就越多，速度就越快。

      数完之后，聚到一起把所有人的统计数加在一起。这就是Reduce合并汇总阶段。

      ![1644995909764](assets/1644995909764.png)

   2. #### MapReduce设计构思

      MapReduce是一个分布式运算程序的编程框架，核心功能是将用户编写的业务逻辑代码和自带默认组件整合成一个完整的分布式运算程序，并发运行在Hadoop集群上。

      既然是做计算的框架，那么表现形式就是有个输入（input），MapReduce操作这个输入（input），通过本身定义好的计算模型，得到一个输出（output）。

      对许多开发者来说，自己完完全全实现一个并行计算程序难度太大，而MapReduce就是一种简化并行计算的编程模型，降低了开发并行应用的入门门槛。

      Hadoop MapReduce构思体现在如下的三个方面：

      l  如何对付大数据处理：分而治之

      对相互间不具有计算依赖关系的大数据，实现并行最自然的办法就是采取分而治之的策略。并行计算的第一个重要问题是如何划分计算任务或者计算数据以便对划分的子任务或数据块同时进行计算。不可分拆的计算任务或相互间有依赖关系的数据无法进行并行计算！

      l  构建抽象模型：Map和Reduce

      MapReduce借鉴了函数式语言中的思想，用Map和Reduce两个函数提供了高层的并行编程抽象模型。

      Map: 对一组数据元素进行某种重复式的处理；

      Reduce: 对Map的中间结果进行某种进一步的结果整理。

      MapReduce中定义了如下的Map和Reduce两个抽象的编程接口，由用户去编程实现:

      map: (k1; v1) → [(k2; v2)]

      reduce: (k2; [v2]) → [(k3; v3)]

      Map和Reduce为程序员提供了一个清晰的操作接口抽象描述。通过以上两个编程接口，大家可以看出MapReduce处理的数据类型是<key,value>键值对。

      l  统一构架，隐藏系统层细节

      如何提供统一的计算框架，如果没有统一封装底层细节，那么程序员则需要考虑诸如数据存储、划分、分发、结果收集、错误恢复等诸多细节；为此，MapReduce设计并提供了统一的计算框架，为程序员隐藏了绝大多数系统层面的处理细节。

      MapReduce最大的亮点在于通过抽象模型和计算框架把需要做什么(what need to do)与具体怎么做(how to do)分开了，为程序员提供一个抽象和高层的编程接口和框架。程序员仅需要关心其应用层的具体计算问题，仅需编写少量的处理应用本身计算问题的程序代码。

      如何具体完成这个并行计算任务所相关的诸多系统层细节被隐藏起来, 交给计算框架去处理：从分布代码的执行，到大到数千小到单个节点集群的自动调度使用。

2. ### 官方MapReduce示例

   在Hadoop的安装包中，官方提供了MapReduce程序的示例examples，以便快速上手体验MapReduce。

   该示例是使用java语言编写的，被打包成为了一个jar文件。

   /export/server/hadoop-3.3.0/share/hadoop/mapreduce

   ![1644996143002](assets/1644996143002.png)

   运行该jar包程序，可以传入不同的参数实现不同的处理功能。

   hadoop jar hadoop-mapreduce-examples-3.3.0.jar args…

   1. #### 评估圆周率π(PI)

      圆周率π大家都不陌生，如何去估算π的值呢？

      Monte Carlo方法的基本思想：

      当所求解问题是某种随机事件出现的概率，或者是某个随机变量的期望值时，通过某种“实验”的方法，以这种事件出现的频率估计这一随机事件的概率，或者得到这个随机变量的某些数字特征，并将其作为问题的解。

      ​                                                  ![1644996193401](assets/1644996193401.png)

      假设正方形边长为1，圆半径也为1，那么1/4圆的面积为：

      ![1644996213608](assets/1644996213608.png)

      在正方形内随机撒点，分布于1/4圆内的数量假设为a ，分布于圆外的数量为b，N则是所产生的总数：N=a+b。

      那么数量a与N的比值应与1/4圆面积及正方形面积成正比，于是：

      ![1644996220705](assets/1644996220705.png)

      下面来运行MapReduce程序评估一下圆周率的值，执行中可以去YARN页面上观察程序的执行的情况。

      ```shell
      [root@node1 mapreduce]# pwd
      /export/server/hadoop-3.3.0/share/hadoop/mapreduce
      [root@node1 mapreduce]# hadoop jar hadoop-mapreduce-examples-3.3.0.jar pi 10 50
      ```

         [root@node1 mapreduce]# pwd   /export/server/hadoop-3.3.0/share/hadoop/mapreduce   [root@node1 mapreduce]# hadoop jar   hadoop-mapreduce-examples-3.3.0.jar pi 10 50   

      第一个参数pi：表示MapReduce程序执行圆周率计算；

      第二个参数：用于指定map阶段运行的任务次数，并发度，这是是10；

      第三个参数：用于指定每个map任务取样的个数，这里是50。

      ![1644996276753](assets/1644996276753.png)

      ![1644996283506](assets/1644996283506.png)

      ![1644996288660](assets/1644996288660.png)

      ![1644996294947](assets/1644996294947.png)

   2. #### 单词词频统计WordCount

      WordCount算是大数据统计分析领域的经典需求了，相当于编程语言的HelloWorld。其背后的应用场景十分丰富，比如统计页面点击数，搜索词排行榜等跟count相关的需求。

      其最基本的应用雏形就是统计文本数据中，相同单词出现的总次数。用SQL的角度来理解的话，相当于根据单词进行group by分组，相同的单词分为一组，然后每个组内进行count聚合统计。

      对于MapReduce乃至于大数据计算引擎来说，业务需求本身是简单的，重点是当数据量大了之后，如何使用分而治之的思想来处理海量数据进行单词统计。

      ![1644997123681](assets/1644997123681.png)

      上传课程资料中的文本文件到HDFS文件系统的/input目录下，如果没有这个目录，使用shell创建：

      ```shell
      hadoop fs -mkdir /input
      
      hadoop fs -put 1.txt /input
      ```

      准备好之后，执行官方MapReduce实例，对上述文件进行单词次数统计:

      ```shell
      [root@node1 mapreduce]# pwd
      /export/server/hadoop-3.3.0/share/hadoop/mapreduce
      [root@node1 mapreduce]# hadoop jar hadoop-mapreduce-examples-3.3.0.jar wordcount /input /output
      ```

      第一个参数：wordcount表示执行单词统计

      第二个参数：指定输入文件的路径

      第三个参数：指定输出结果的路径（该路径不能已存在）

      ![1644997208394](assets/1644997208394.png)

      ![1644997212780](assets/1644997212780.png)

3. ### MapReduce Python接口接入

   1. #### 前言

      虽然Hadoop是用Java编写的一个框架, 但是并不意味着他只能使用Java语言来操作, 在Hadoop-0.14.1版本后, Hadoop支持了Python和C++语言, 在Hadoop的文档中也表示可以使用Python进行开发。

      <https://hadoop.apache.org/docs/r3.3.0/hadoop-streaming/HadoopStreaming.html>

      在Hadoop的文档中提到了Hadoop Streaming, 我们可以使用流的方式来操作它.

      ```shell
      [root@node1 lib]# pwd
      /export/server/hadoop-3.3.0/share/hadoop/tools/lib
      [root@node1 lib]# hadoop jar hadoop-streaming-3.3.0.jar
        -input InputDirs \
        -output OutputDir \
        -mapper xxx \
        -reducer xxx
      ```

      在python中的sys包中存在stdin和stdout输入输出流, 可以利用这个方式来进行MapReduce的编写.

   2. #### 代码实现

      mapper.py

      ```python
      # -*- coding:utf-8 -*-
      # @Time : 2021/6/21 16:04
      # @Author: itcast
      # @File : mapper.py
      import sys
      
      for line in sys.stdin:
          # 捕获输入流
          line = line.strip()
          # 根据分隔符切割单词
          words = line.split()
          # 遍历单词列表 每个标记1
          for word in words:
              print("%s\t%s" % (word, 1))
      ```

      reducer.py

      ```python
      # -*- coding:utf-8 -*-
      # @Time : 2021/6/21 16:04
      # @Author: itcast
      # @File : reducer.py
      import sys
      # 保存单词次数的字典 key:单词 value：总次数
      word_dict = {}
      
      for line in sys.stdin:
      
          line = line.strip()
          word, count = line.split('\t')
      
          # count类型转换
          try:
              count = int(count)
          except ValueError:
              continue
          # 如果单词位于字典中 +1，如果不存在 保存并设初始值1
          if word in word_dict:
              word_dict[word] += 1
          else:
              word_dict.setdefault(word, 1)
      # 结果遍历输出
      for k, v in word_dict.items():
          print('%s\t%s' % (k, v))
      ```

   3. #### 程序执行

      方式1：本地测试Python脚本逻辑是否正确。

      方式2：使用hadoop streaming提交Python脚本集群运行。

      注意：不管哪种方式执行，都需要提前在Centos系统上安装好Python3.

      本地测试:

      ```shell
      #上传待处理文件 和Python脚本到Linux上
      [root@node2 ~]# pwd
      /root
      [root@node2 ~]# ll
      -rw-r--r--  1 root  root        105 May 18 15:12 1.txt
      -rwxr--r--  1 root  root        340 Jul 21 16:16 mapper.py
      -rwxr--r--  1 root  root        647 Jul 21 16:18 reducer.py
      
      #使用shell管道符运行脚本测试
      [root@node2 ~]# cat 1.txt | python mapper.py |sort|python reducer.py 
      allen   4
      apple   3
      hadoop  1
      hello   5
      mac     1
      spark   2
      tom     2
      ```

      Hadoop streaming提交

      ```shell
      #上传处理的文件到hdfs、上传Python脚本到linux
      
      #提交程序执行
      hadoop jar /export/server/hadoop-3.3.0/share/hadoop/tools/lib/hadoop-streaming-3.3.0.jar \
      -D mapred.reduce.tasks=1 \
      -mapper "python mapper.py" \
      -reducer "python reducer.py" \
      -file mapper.py -file reducer.py \
      -input /input/* \
      -output /outpy
      ```

      执行结果:

      ![1644998523271](assets/1644998523271.png)

      ![1644998532575](assets/1644998532575.png)

## VI. Hadoop MapReduce基本原理

1. ### 整体执行流程图

   ![1645001636692](assets/1645001636692.png)

   ![1645001675999](assets/1645001675999.png)

2. ### Map阶段执行流程

   - 第一阶段：把输入目录下文件按照一定的标准逐个进行**逻辑切片**，形成切片规划。

   默认Split size = Block size，每一个切片由一个MapTask处理。（getSplits）

   - 第二阶段：对切片中的数据按照一定的规则读取解析返回<key,value>对。

   默认是**按行读取数据**。key是每一行的起始位置偏移量，value是本行的文本内容。（TextInputFormat）

   - 第三阶段：调用Mapper类中的**map方法处理数据**。

   每读取解析出来的一个<key,value> ，调用一次map方法。

   - 第四阶段：按照一定的规则对Map输出的键值对进行**分区partition**。默认不分区，因为只有一个reducetask。

   分区的数量就是reducetask运行的数量。

   - 第五阶段：Map输出数据写入**内存缓冲区**，达到比例溢出到磁盘上。**溢出spill**的时候**根据key进行排序sort**。

   默认根据key字典序排序。

   - 第六阶段：对所有溢出文件进行最终的**merge合并**，成为一个文件。

   ![1645002448005](assets/1645002448005.png)

3. ### Reduce阶段执行流程

   - 第一阶段：ReduceTask会主动从MapTask**复制拉取**其输出的键值对。

   - 第二阶段：把复制到Reducer本地数据，全部进行**合并merge**，即把分散的数据合并成一个大的数据。再对合并后的数据**排序**。

   - 第三阶段是对排序后的键值对**调用reduce方法**。键相等的键值对调用一次reduce方法。最后把这些输出的键值对写入到HDFS文件中。

     ![1645002816542](assets/1645002816542.png)
