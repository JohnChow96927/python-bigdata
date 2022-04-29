# Redis内存数据库

## I. 初识Redis

### 1. Redis概述

> 官方定义：**Redis 是一个开源（BSD许可）的，内存中的数据结构存储系统，它可以用作数据库、缓存和消息中间件。** 
>
> - ==所有数据存储在内存中==，并且有**持久化机制**
> - 每次redis重启，会从文件中重新加载数据到内存，**所有读写都只基于内存**

1. 支持多种类型的数据结构，字符串（strings）， 散列（hashes）， 列表（lists）， 集合（sets）， 有序集合（sorted sets） 与范围查询， bitmaps， hyperloglogs 和 地理空间（geospatial） 索引半径查询。
2. Redis 内置了 复制（replication），LUA脚本（Lua scripting）， LRU驱动事件（LRU eviction），事务（transactions） 和不同级别的 磁盘持久化（persistence）， 并通过 Redis哨兵（Sentinel）和自动 分区（Cluster）提供高可用性（high availability）。

> Redis 数据库主要应用场景：

- **缓存**：用于实现大数据量高并发的大数据量缓存【临时性存储】

  - 网站架构中：接受高并发的缓存读写请求

- **数据库**：用于实现高性能的小数据量读写【永久性存储】

  - 大数据平台中：高性能，一般用于作为实时计算结果的存储

  ![1635635712839](assets/1635635712839.png)

### 2. Redis安装

> 大多数企业都是基于Linux服务器来部署项目，而且Redis官方也没有提供Windows版本的安装包。因此课程中基于Linux系统来安装Redis，此处选择的Linux版本为CentOS 7。
>
> 下载地址：https://download.redis.io/releases/

![1651137156112](assets/1651137156112.png)

- **安装依赖**

  Redis是基于C语言编写的，因此首先需要安装Redis所需要的gcc依赖：

  ```ini
  yum -y install gcc-c++ tcl
  ```

  ![1651137726674](assets/1651137726674.png)

- **上传**源码

  ```ini
  cd /export/software/
  rz
  	redis-5.0.8.tar.gz
  ```

![1651137790674](assets/1651137790674.png)

- **解压**

  ```ini
  tar -zxvf redis-5.0.8.tar.gz -C /export/server/
  ```

- **编译安装**

  ```ini
  # 进入源码目录
  cd /export/server/redis-5.0.8/
  
  # 编译
  make
  ```

![1651138298705](assets/1651138298705.png)

```ini
# 安装，并指定安装目录
make PREFIX=/export/server/redis install
```

![1651138367157](assets/1651138367157.png)

- **修改配置**

  - 复制配置文件

    ```bash
    cp /export/server/redis-5.0.8/redis.conf /export/server/redis/
    ```

    ![1651138461547](assets/1651138461547.png)

  - 创建目录

    ```shell
    # redis日志目录
    mkdir -p /export/server/redis/logs
    # redis数据目录
    mkdir -p /export/server/redis/datas
    ```

    ![1651138500373](assets/1651138500373.png)

  - 修改配置

    ```bash
    vim /export/server/redis/redis.conf
    ```

    ```shell
    ## 69行，配置redis服务器接受链接的网卡
    bind 0.0.0.0
    
    ## 136行，redis是否后台运行，设置为yes
    daemonize yes
    
    ## 171行，设置redis服务日志存储路径
    logfile "/export/server/redis/logs/redis.log"
    
    ## 263行，设置redis持久化数据存储目录
    dir /export/server/redis/datas/
    ```

  - 配置环境变量

    ```bash
    vim /etc/profile
    ```

    ```bash
    # REDIS HOME
    export REDIS_HOME=/export/server/redis
    export PATH=:$PATH:$REDIS_HOME/bin
    ```

    ```bash
    source /etc/profile
    ```

- **服务启动**

  ```bash
  # 启动，指定配置文件
  /export/server/redis/bin/redis-server /export/server/redis/redis.conf
  # 查看启动
  ps -ef|grep redis
  ```

![1651139267929](assets/1651139267929.png)

- 命令行客户端

  ```bash
  redis-cli -h node1.itcast.cn -p 6379
  ```

  ![1651139469460](assets/1651139469460.png)

- 测试

  ![1651139544751](assets/1651139544751.png)

- 关闭服务

  - 方式一：客户端中

  ```bash
  shutdown
  ```

  - 方式二：Linux命令行

  ```bash
  kill -9 redis的pid
  ```

  - 方式三：通过客户端命令进行关闭

  ```bash
  redis-cli -h node1.itcast.cn -p 6379  shutdown
  ```

- 启动脚本

  ```bash
  vim /export/server/redis/bin/redis-start.sh
  ```

  添加内容

  ```bash
  #!/bin/bash
  
  REDIS_HOME=/export/server/redis
  ${REDIS_HOME}/bin/redis-server ${REDIS_HOME}/redis.conf
  ```

  执行权限

  ```bash
  chmod u+x /export/server/redis/bin/redis-start.sh 
  ```

### 3. Redis客户端

> 安装完成Redis，可以操作Redis，实现数据的CRUD，需要用到Redis客户端，包括：
>
> - 命令行客户端
> - 图形化桌面客户端
> - 编程客户端

#### Redis命令行客户端

Redis安装完成后就自带了命令行客户端：`redis-cli`，使用方式如下：

```shell
redis-cli [options] [commonds]
```

其中常见的options有：

- `-h node1.itcast.cn`：指定要连接的redis节点的IP地址，默认是127.0.0.1
- `-p 6379`：指定要连接的redis节点的端口，默认是6379

其中的commonds就是Redis的操作命令，例如：

- `ping`：与redis服务端做心跳测试，服务端正常会返回`pong`

不指定commond时，会进入`redis-cli`的交互控制台：

![1651140295579](assets/1651140295579.png)

#### 图形化桌面客户端

GitHub上的大神编写了Redis的图形化桌面客户端，地址：https://github.com/uglide/RedisDesktopManager

不过该仓库提供的是**RedisDesktopManager**的源码，并未提供windows安装包。

在下面这个仓库可以找到安装包：https://github.com/lework/RedisDesktopManager-Windows/releases

![image-20211211111351885](assets/image-20211211111351885.png)

> 安装RedisDesktopManager

在课程【05_软件及配置】中可以找到Redis的图形化桌面客户端：

![image-20211214154938770](assets/image-20211214154938770.png)

解压缩后，运行安装程序即可安装，此处略。

![image-20211214155123841](assets/image-20211214155123841.png)

安装完成后，在安装目录下找到rdm.exe文件：

![image-20211211110935819](assets/image-20211211110935819.png)

双击即可运行：

![image-20211214155406692](assets/image-20211214155406692.png)

> 建立连接

点击左上角的`连接到Redis服务器`按钮：

![image-20211214155424842](assets/image-20211214155424842.png)

在弹出的窗口中填写Redis服务信息：

![image-20211211111614483](assets/image-20211211111614483.png)

点击确定后，在左侧菜单会出现这个链接：

![image-20211214155804523](assets/image-20211214155804523.png)

点击即可建立连接了：

![image-20211214155849495](assets/image-20211214155849495.png)

Redis默认有16个仓库，编号从0至15，配置文件可以设置仓库数量，但是不超过16，并且不能自定义仓库名称。

## II. Redis常见命令



## III. Jedis客户端

