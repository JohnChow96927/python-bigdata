# HBase CRUD

## I. HBase命令行操作



## II. HBase Java API



## 附录: 注意事项及拓展内容

### 1. 服务启动停止命令

> 查看集群所有机器启动Java服务进程命令：`jpsall.sh`

- 上传脚本

```ini
[root@node1 ~]# cd /export/server/jdk/bin/

[root@node1 bin]# rz

[root@node1 bin]# chmod u+x jpsall.sh
```

- 测试脚本

------

```ini
[root@node1 ~]# jpsall.sh 
====================== node1.itcast.cn ====================
2108 Jps
====================== node2.itcast.cn ====================
2188 Jps
====================== node3.itcast.cn ====================
2230 Jps
```

> Zookeeper集群一键启动和停止命令：`start-zk.sh` 和 `stop-zk.sh`

- 上传脚本

```ini
[root@node1 ~]# cd /export/server/zookeeper/bin

[root@node1 bin]# rz

[root@node1 bin]# chmod u+x start-zk.sh 

[root@node1 bin]# chmod u+x stop-zk.sh 
```

- 测试脚本

```ini
[root@node1 ~]# start-zk.sh 
JMX enabled by default
Using config: /export/server/zookeeper/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED
node1.itcast.cn starting...............................
JMX enabled by default
Using config: /export/server/zookeeper/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED
node2.itcast.cn starting...............................
JMX enabled by default
Using config: /export/server/zookeeper/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED
node3.itcast.cn starting...............................
```

### 2. HBase Maven依赖





