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

2. ### 元数据目录相关文件

3. ### Fsimage、Edits

   1. #### 概述

   2. #### 内容查看

## III. Secondary NameNode

1. ### Checkpoint

   1. #### Checkpoint详细步骤

   2. #### Checkpoint触发条件

## IV. HDFS安全模式

1. ### 安全模式概述

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

