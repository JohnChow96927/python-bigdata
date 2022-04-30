# HBase分布式数据库

## I. Redis分布式缓存

### 1. RDB持久化

> RDB全称Redis Database Backup file（Redis数据备份文件），也被叫做Redis数据快照。简单来说就是[把内存中的所有数据都记录到磁盘中]()。
>
> - 当Redis实例故障重启后，从磁盘读取快照文件，恢复数据。
> - 快照文件称为RDB文件，默认是保存在当前运行目录。
> - RDB持久化在四种情况下会执行：
>   - 执行save命令
>   - 执行bgsave命令
>   - Redis停机时
>   - 触发RDB条件时

**1）save命令**

执行下面的命令，可以立即执行一次RDB, save命令会导致主进程执行RDB，这个过程中其它所有命令都会被阻塞。只有在数据迁移时可能用到。

**2）bgsave命令**

命令：`bgsave` 可以异步执行RDB, 这个命令执行后会开启独立进程完成RDB，主进程可以持续处理用户请求，不受影响。

**3）停机时**

Redis停机时会执行一次save命令，实现RDB持久化。

**4）触发RDB条件**

Redis内部有触发RDB的机制，可以在redis.conf文件中找到，格式如下：

```properties
# 900秒内，如果至少有1个key被修改，则执行bgsave ， 如果是save "" 则表示禁用RDB
save 900 1  
save 300 10  
save 60 10000 
```

RDB的其它配置也可以在redis.conf文件中设置：

```properties
# 是否压缩 ,建议不开启，压缩也会消耗cpu，磁盘的话不值钱
rdbcompression yes

# RDB文件名称
dbfilename dump.rdb  

# 文件保存的路径目录
dir ./ 
```

> bgsave开始时会fork主进程得到子进程，子进程共享主进程的内存数据。完成fork后读取内存数据并写入 RDB 文件。

fork采用的是copy-on-write技术：

- 当主进程执行读操作时，访问共享内存；
- 当主进程执行写操作时，则会拷贝一份数据，执行写操作。

![image-20210725151319695](assets/image-20210725151319695.png)

### 2. AOF持久化

> AOF全称为Append Only File（追加文件）。Redis处理的**每一个写命令都会记录在AOF文件**，可以看做是**命令日志文件**。

![image-20210725151543640](assets/image-20210725151543640.png)

AOF默认是关闭的，需要修改redis.conf配置文件来开启AOF：

```properties
# 是否开启AOF功能，默认是no
appendonly yes
# AOF文件的名称
appendfilename "appendonly.aof"
```

AOF的命令记录的频率也可以通过redis.conf文件来配：

```properties
# 表示每执行一次写命令，立即记录到AOF文件
appendfsync always 
# 写命令执行完先放入AOF缓冲区，然后表示每隔1秒将缓冲区数据写到AOF文件，是默认方案
appendfsync everysec 
# 写命令执行完先放入AOF缓冲区，由操作系统决定何时将缓冲区内容写回磁盘
appendfsync no
```

三种策略对比：

![image-20210725151654046](assets/image-20210725151654046.png)

> RDB和AOF各有自己的优缺点，如果对数据安全性要求较高，在实际开发中往往会**结合**两者来使用。

![image-20210725151940515](assets/image-20210725151940515.png)

### 3. Redis集群: 主从复制

> 单节点Redis的**并发能力**是有上限的，要进一步提高Redis的并发能力，就需要搭建**主从集群Master-Slaves**，实现**读写分离ReadWrite**。

![image-20210725152037611](assets/image-20210725152037611.png)

> 三个节点：一个主节点Master、两个从节点Slave

|              IP               | PORT |  角色  |
| :---------------------------: | :--: | :----: |
| 192.168.88.100/nod1.itcast.cn | 6379 | master |
| 192.168.88.101/nod2.itcast.cn | 6379 | slave  |
| 192.168.88.102/nod3.itcast.cn | 6379 | slave  |

- 1、解压和重命名

```ini
[root@node1 ~]# cd /root
[root@node1 ~]# rz
	redis-5.0.8-bin.tar.gz

[root@node1 ~]# tar -zxf redis-5.0.8-bin.tar.gz 
[root@node1 ~]# mv redis redis-replica
```

- 2、修改配置文件：`redis.conf`

```ini
# 69 行
bind 0.0.0.0

# 263 行
dir /root/redis-replica/datas

# 493 行
replica-announce-ip 192.168.88.100
```

- 3、发送其他机器

```ini
scp -r /root/redis-replica root@node2.itcast.cn:/root

scp -r /root/redis-replica root@node2.itcast.cn:/root
```

- 4、node2和node3修改配置

node2配置文件修改

```ini
vim /root/redis-replica/redis.conf

# 493 行
replica-announce-ip 192.168.88.101
```

node3配置文件修改

```ini
vim /root/redis-replica/redis.conf

# 493 行
replica-announce-ip 192.168.88.102
```

- 5、启动服务

每台机器单独启动服务

```ini
 /root/redis-replica/bin/redis-server /root/redis-replica/redis.conf
```

> 三个实例没有任何关系，配置主从：`replicaof` 或`slaveof`（5.0以前）命令，有临时和永久两种模式：

- 修改配置文件（永久生效）

  - 在`redis.conf`中添加一行配置：```slaveof <masterip> <masterport>```

- 使用`redis-cli`客户端连接到redis服务，执行slaveof命令（重启后失效）：

  ```ini
  slaveof <masterip> <masterport>
  ```

- 6、添加node2为从节点

```ini
[root@node2 ~]# redis-replica/bin/redis-cli 
127.0.0.1:6379> KEYS *
(empty list or set)
127.0.0.1:6379> 
127.0.0.1:6379> slaveof 192.168.88.100 6379
OK
127.0.0.1:6379> 
```

node1上Redis服务日志：Master

![1651212740650](assets/1651212740650.png)

node2上Redis服务日志：Slave

![1651212785373](assets/1651212785373.png)

- 7、添加node3为从节点

```ini
[root@node3 ~]# redis-replica/bin/redis-cli 
127.0.0.1:6379> KEYS *
(empty list or set)
127.0.0.1:6379> 
127.0.0.1:6379> SLAVEOF 192.168.88.100 6379
OK
127.0.0.1:6379> 
```

node1上Redis服务日志：Master

![1651212822994](assets/1651212822994.png)

node3上Redis服务日志：Slave

![1651212841467](assets/1651212841467.png)

- 8、node1主节点查看集群状态

```ini
[root@node1 ~]# cd redis-replica/
[root@node1 redis-replica]# 
[root@node1 redis-replica]# bin/redis-cli   
127.0.0.1:6379> 
127.0.0.1:6379> INFO replication
```

![1651213169854](assets/1651213169854.png)

- 9、测试

```ini
# node1 主节点设置值
set name zhangsan
# node2和node3 从节点获取值
get name
```

![1651212952726](assets/1651212952726.png)

### 4. Redis哨兵集群



### 5. Redis分片集群



## II. HBase快速入门

### 1. HBase功能概述



### 2. HBase数据模型



### 3. HBase集群架构



### 4. HBase安装部署



## 附录部分: 注意事项及扩展内容