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



### 4. Redis哨兵集群



### 5. Redis分片集群



## II. HBase快速入门

### 1. HBase功能概述



### 2. HBase数据模型



### 3. HBase集群架构



### 4. HBase安装部署



## 附录部分: 注意事项及扩展内容