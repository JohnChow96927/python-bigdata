# I. Linux用户与权限

- ## 用户、用户组的概念

  ```shell
  # 用户 user
  Linux可以创建不同的用户, 不同用户具有不同的权限
  权限最高的用户为root, 其为超级管理员用户
  可以通过root管理其他用户及权限
  
  # 用户组 usergroup
  多个用户组成一组, 同组用户拥有相同权限
  
  # 文件归属可以分为三类
  1. 所属用户 user
  2. 所属用户组 group
  3. 其他用户组 other
  ```

- ## 文件权限

  ```shell
  - 读 read r
  - 写 write w
  - 执行 execute x
  ```

- ## 权限的分配和管理

  - ### Linux中的文件与文件夹划分为3个归属

    ```shell
    文件(夹)拥有者 user
    拥有者所在用户组 group
    其他用户组 others
    ```

  - ### 查看权限: `ls -l`也就是`ll`

    ```shell
    [root@node1 linux02]# ll
    total 8
    -rw-r--r--. 1 root root   47 May 18 11:23 1.txt
    
    -rw-r--r-- 就是权限位
    	第一位 -文件 d文件夹 l链接
    	后面每3位一组
    	rw- u 读写
    	r-- g 读
    	r-- o 读
    ```

- ## 用户与组的管理: 只有root用户才可以进行管理

  ```shell
  #1、增加一个新的用户组
  groupadd 选项 用户组
  	可以使用的选项有：
  	-g GID 指定新用户组的组标识号（GID）。
  	
  # groupadd group1
  此命令向系统中增加了一个新组group1，新组的组标识号是在当前已有的最大组标识号的基础上加1。
  # groupadd -g 101 group2
  此命令向系统中增加了一个新组group2，同时指定新组的组标识号是101。
  
  #2、查看当前系统已有组信息
  cat /etc/group 
  itheima:x:1001:lisi,wangwu
  
  itheima组名
  x 密码口号 一般都没有密码
  1001 groupID  gid 组编号
  lisi,wangwu 归属该组的用户
  
  #3、删除组  
  groupdel 组名
  
  #4、修改文件归属的组
  chgrp 组名 文件/目录名  针对文件夹加上-R可以实现递归修改
  ```

  ```shell
  #1、创建用户
  useradd 选项 新建用户名
  	-g   指定用户所属的群组。值可以是组名也可以是GID
  	-G   指定用户所属的附加群组。
  	
  #2、设置密码	
  [root@node1 linux02]# passwd 用户名
  Changing password for user allen.
  New password: 
  BAD PASSWORD: The password is shorter than 8 characters
  Retype new password: 
  passwd: all authentication tokens updated successfully.	
  
  #3、删除用户
  userdel -r 用户名
  此命令删除用户sam在系统文件中（主要是/etc/passwd, /etc/shadow, /etc/group等）的记录，同时删除用户的主目录。
  
  #4、查看用户信息
  cat /etc/passwd | grep 用户名
  
  #5、修改文件所属的用户
  chown allen 1.txt   如果是文件夹及其下面的所有要修改 加上-R参数
  ```

- ## root用户与非root用户的区别

  - 命令提示符不同

    - root用户: `#`
    - 普通用户: `$`

  - home目录不同

    ```shell
    [root@node1 ~]# pwd
    /root
    
    [allen@node1 ~]$ pwd
    /home/allen
    ```

    

- ## su命令: 用于切换用户

  ```shell
  # su 用户
  
  [allen@node1 ~]$ ll /root
  ls: cannot open directory /root: Permission denied
  [allen@node1 ~]$ su root   #普通用户切换成为root需要输入root密码
  Password: 
  
  [root@node1 linux02]# su allen   #root用户切换成为普通用户 不需要密码
  [allen@node1 linux02]$ 
  
  [allen@node1 linux02]$ exit  #退出
  exit
  
  
  #弊端：虽然通过切换可以具有root权限，但是root密码已经泄露了 不安全。
  #能不能实现一种 让普通用户临时具有root权限，但是又不泄露密码
  ```

  

- ## sudo命令: 给普通用户临时授予root权限

  - ### 只有root可以分配sudo

  - ### sudo配置命令: __`visudo`__

  - ### sudo使用示例:

    - #### step1:使用root用户编辑sudo配置文件

    ```shell
    [root@node1 ~]# visudo
    
    ## Allow root to run any commands anywhere
    root    ALL=(ALL)       ALL
    allen   ALL=(ALL)       ALL
    
    allen   ALL=(ALL)       /usr/bin/ls  #配置只允许执行指定的命令
    ```

    - #### step2:普通用户执行命令之前需要添加sudo关键字 申请sudo权限校验
    ```shell
    [allen@node1 ~]$ ls /root
    ls: cannot open directory /root: Permission denied
    [allen@node1 ~]$ sudo ls /root
    
    We trust you have received the usual lecture from the local System
    Administrator. It usually boils down to these three things:
    
        #1) Respect the privacy of others.
        #2) Think before you type.
        #3) With great power comes great responsibility.
    
    [sudo] password for allen:    #这里需要输入allen普通用户的密码
    linux02
    [allen@node1 ~]$ sudo ls /root  #密码和sudo校验成功 获取一个为期5分钟的免密操作
    linux02
    ```

- ## 修改文件权限

  - ### 修改文件的权限

  > 核心的命令 chmod  权限  文件|文件夹     （针对文件夹-R 递归修改）

  - ### 方式1：老百姓喜闻乐见的形式   ==数字==

    ```shell
    read----->r      4
    write---->w      2
    execute-->x      1
    没有权限           0
    
    chmod 777 -R 文件|文件夹
    ```

  - ### 方式2： ==字母 +- 形式==

    ```shell
    user->u  group->g others->o  all->a
    + 增加权限
    - 减少权限
    
    chmod o-x 1.txt
    chmod a-w 1.txt
    ```

  - ### 方式3： ==等号赋值形式==

    ```shell
    chmod u=rwx 1.txt
    ```

# II. Linux常用系统信息查看

- ## 查看时间, 日期

  ```shell
  [root@node1 linux02]# date
  Tue May 18 14:44:13 CST 2021
  [root@node1 linux02]# date +"%Y-%m-%d %H:%M:%S"
  2021-05-18 14:44:53
  [root@node1 linux02]# cal
        May 2021      
  Su Mo Tu We Th Fr Sa
                     1
   2  3  4  5  6  7  8
   9 10 11 12 13 14 15
  16 17 18 19 20 21 22
  23 24 25 26 27 28 29
  30 31
  
  #关于时间日期的同步  同步网络授时
  #大数据都是集群环境  基本要求：集群的时间同步问题
  ```

- ## 查看磁盘, 内存信息

  ```shell
  df -h    #disk free 显示磁盘剩余空间
  [root@node1 linux02]# df -h
  Filesystem               Size  Used Avail Use% Mounted on
  devtmpfs                 1.9G     0  1.9G   0% /dev
  tmpfs                    1.9G     0  1.9G   0% /dev/shm
  tmpfs                    1.9G   12M  1.9G   1% /run
  tmpfs                    1.9G     0  1.9G   0% /sys/fs/cgroup
  /dev/mapper/centos-root   38G  1.5G   36G   5% /  #重点关注这一行
  /dev/sda1               1014M  152M  863M  15% /boot
  /dev/mapper/centos-home   19G   33M   19G   1% /home
  tmpfs                    378M     0  378M   0% /run/user/0
  tmpfs                    378M     0  378M   0% /run/user/1000
  
  #内存使用情况
  [root@node1 linux02]# free -h
                total        used        free      shared  buff/cache   available
  Mem:           3.7G        257M        3.0G         11M        467M        3.2G
  Swap:          3.9G          0B        3.9G
  ```

- ## 查看进程信息

  ```shell
  #在安装了jdk的情况下 有一个命令专门用于查看本机运行的java进程。
  jps
  
  [root@node1 ~]# jps  #必须在安装好jdk之后可以使用  
  -bash: jps: command not found
  
  #查看本机运行的所有进程
  ps -ef | grep 进程名
  
  #通常根据查询的进程号 结合kill -9 进程号  杀死进程
  ```

- ## 完整命令参考链接

  https://www.runoob.com/linux/linux-command-manual.html

  https://man.linuxde.net/

# III. 大数据集群环境搭建

- ## 分布式, 集群:

  > 分布式：多台不同的服务器中部署==不同的服务模块==，通过远程调用协同工作，对外提供服务。

  > 集群：多台不同的服务器中部署==相同应用或服务模块==，构成一个集群，通过负载均衡设备对外提供服务。

  - ### 共同点: 都使用多台机器, 与此相对的概念叫做单机系统

  - ### 注意：在口语中经常混淆分布式和集群的概念的。都是汲取两者的共同点。

    ```
    比如：搭建一个分布式hadoop集群。
    
    背后意思：不要搭建单机版本的 搭建多台机器版本的。 
    ```

  - ### 集群架构

    - #### 主从架构

      ```properties
      主角色:master leader   大哥
      从角色:slave  follower 小弟
      
      主从角色各司其职，需要共同配合对外提供服务。
      常见的是一主多从 也就是一个大哥带着一群小弟共同干活。
      ```

    - #### 主备架构

      ```properties
      主角色:active
      备角色:standby
      
      主备架构主要是解决单点故障问题的 保证业务的持续可用。
      常见的是一主一备 也可以一主多备。
      ```

- ## 虚拟机克隆

  - ### 前提：是虚拟机处于关闭状态。

  - ### 分类：链接克隆 、==完整克隆==

    ```
    链接克隆：表层是互相独立 底层存储是交织在一起；
    完整克隆：完全互相独立的两台虚拟机
    ```

  - ### 修改克隆机器属性。

    ```
    完整克隆意味着两台机器一模一样。在局域网网络中，有些属性是决定不能一样的。
    比如：IP、MAC、主机名hostname
    ```

  - ### 3台虚拟机硬件分配   16G

    ```
    node1  2*2cpu  4G内存
    node2  1*1cpu  2G内存
    node3  1*1cpu  2G内存
    ```

- ## 修改IP与主机名

  - ### 命令修改  临时生效 重启无效

  - ### ==修改底层配置文件==  永久生效  重启才能生效。

  ```
  vim /etc/hostname
  
  node2.itcast.cn
  ```

  ```shell
  #修改IP
  vim /etc/sysconfig/network-scripts/ifcfg-ens33
  
  TYPE="Ethernet"     #网卡类型 以太网
  PROXY_METHOD="none"
  BROWSER_ONLY="no"
  BOOTPROTO="none"   #ip等信息是如何决定的？  dhcp动态分配、 static|node 手动静态分配
  DEFROUTE="yes"
  IPV4_FAILURE_FATAL="no"
  IPV6INIT="yes"
  IPV6_AUTOCONF="yes"
  IPV6_DEFROUTE="yes"
  IPV6_FAILURE_FATAL="no"
  IPV6_ADDR_GEN_MODE="stable-privacy"
  NAME="ens33"        #网卡名称
  UUID="74c3b442-480d-4885-9ffd-e9f0087c9cf7"
  DEVICE="ens33"
  ONBOOT="yes"       #是否开机启动网卡服务
  IPADDR="192.168.88.151"  #IP地址
  PREFIX="24"   #子网掩码   等效: NETMASK=255.255.255.0
  GATEWAY="192.168.88.2"  #网关服务
  DNS1="192.168.88.2"     #网关DNS解析
  DOMAIN="114.114.114.114" 
  IPV6_PRIVACY="no
  
  #修改主机名hostname
  node2.itcast.cn
  
  ```

- ## 使用__reboot__命令重启Linux

- ## 修改hosts映射

  - ### 背景

    ```
    在网络中，很少直接通过IP访问机器，原因难记。
    通常使用主机名或者域名访问。
    此时就会涉及到主机名域名和IP之间的解析
    ```

  - ### 实现

    - ==本地hosts文件==   进行本地查找解析

      ```
      localhost 127.0.0.1 
      ```

    - 寻找DNS服务器  域名解析服务

  - ### 配置本地hosts文件实现

    - #### linux上

      ```shell
      vim /etc/hosts
      
      127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
      ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
      
      192.168.88.151 node1.itcast.cn node1
      192.168.88.152 node2.itcast.cn node2
      192.168.88.153 node3.itcast.cn node3
      ```

    - #### windows上

      ```shell
      C:\Windows\System32\drivers\etc\hosts
      
      192.168.88.151 node1.itcast.cn node1
      192.168.88.152 node2.itcast.cn node2
      192.168.88.153 node3.itcast.cn node3
      ```

- ## 关闭防火墙

  - ### firewalld

    ```shell
    #查看防火墙状态
    systemctl status firewalld
    
    #关闭防火墙
    systemctl stop firewalld
    
    #关闭防火墙开机自启动
    systemctl disable firewalld
    
    
    #centos服务开启关闭命令
    centos6:(某些可以在centos7下使用)
    	service 服务名 start|stop|status|restart
    	chkconfig on|off 服务名
    	
    centos7:	
    	systemctl start|stop|status|restart 服务名
    	systemctl disable|enable 服务名  #开机自启动  关闭自启
    ```

  - ### selinux

    ```shell
    vim /etc/selinux/config
    
    # This file controls the state of SELinux on the system.
    # SELINUX= can take one of these three values:
    #     enforcing - SELinux security policy is enforced.
    #     permissive - SELinux prints warnings instead of enforcing.
    #     disabled - No SELinux policy is loaded.
    SELINUX=disabled
    ```

    - #### 需要重启生效

- ## 集群时间同步

  - 背景：分布式软件==主从角色之间通常基于心跳时间差来判断角色工作是否正常==。

  - 国家授时中心  北京时间  

    - 授时服务器  国家级 企业级 院校级

  - linux上如何同步时间

    - ntp 网络时间协议 实现基于网络授时同步时间。

    - date

      ```shell
      查看当前的系统时间 也可以手动指定设置时间 不精准
      
      [root@node1 ~]# date
      Thu May 20 14:50:30 CST 2021
      ```

    - ntpdate

      ```shell
      #ntpdate  授时服务器
      
      ntpdate ntp5.aliyun.com
      
      [root@node1 ~]# ntpdate ntp5.aliyun.com
      20 May 14:53:07 ntpdate[2187]: step time server 203.107.6.88 offset -1.354309 sec
      
      #企业中运维往往不喜欢ntpdate 原因是这个命令同步时间是立即的。不是平滑过渡的。
      ```

    - ntpd软件

      ```
      通过配置 平滑的和授时服务器进行时间的同步
      ```

    - VMware软件可以提高让虚拟机的时间和windows笔记本保持一致。

- ## ssh免密登录

  - 背景

    ```shell
    #在进行集群操作的时候  需要从一台机器ssh登录到其他机器进行操作 默认情况下需要密码
    
    [root@node1 ~]# ssh node2
    The authenticity of host 'node2 (192.168.227.152)' can't be established.
    ECDSA key fingerprint is SHA256:5d9A04L+QfYuW7X1J44cKNbyUtuwPkhg+//0OfEczHI.
    ECDSA key fingerprint is MD5:74:f0:65:22:af:fd:65:af:ff:91:37:83:3f:ef:ac:81.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added 'node2,192.168.227.152' (ECDSA) to the list of known hosts.
    root@node2's password: 
    Last login: Thu May 20 11:48:37 2021 from 192.168.227.1
    
    [root@node2 ~]# exit
    logout
    Connection to node2 closed.
    ```

  - 需求：能否实现免密ssh登录。

    - 技术：SSH方式2：免密登录功能。  原理见课堂画图

  - 实现

    ```shell
    #实现node1----->node2
    
    #step1
    在node1生成公钥私钥
    ssh-keygen  一顿回车 在当前用户的home下生成公钥私钥 隐藏文件
    
    [root@node1 .ssh]# pwd
    /root/.ssh
    [root@node1 .ssh]# ll
    total 12
    -rw------- 1 root root 1675 May 20 11:59 id_rsa
    -rw-r--r-- 1 root root  402 May 20 11:59 id_rsa.pub
    -rw-r--r-- 1 root root  183 May 20 11:50 known_hosts
    
    #step2
    copy公钥给node2
    ssh-copy-id node2  
    注意第一次需要密码
    
    #step3  
    [root@node1 .ssh]# ssh node2
    Last login: Thu May 20 12:03:30 2021 from node1.itcast.cn
    [root@node2 ~]# exit
    logout
    Connection to node2 closed.
    ```

  - 课程要求

    ```shell
    #至少打通node1---->node1  node2  node3 这三个免密登录 
    
    #至于所有机器之间要不要互相免密登录 看你心情
    ```

- scp远程拷贝

  - 背景：linux上copy文件 cp

  - 命令：==scp==  基于ssh协议跨网络cp动作

  - 注意事项，没有配置ssh免密登录也可以进行scp远程复制 只不过在复制的时候需要输入密码。

  - 栗子

    ```shell
    #本地copy其他机器
    scp itcast.txt root@node2:/root/
    
    scp -r linux02/ root@node2:$PWD   #copy文件夹 -r参数   $PWD copy至和本机相同当前路径
    
    #为什么不需要输入密码 
    因为配置了机器之间的免密登录  如果没有配置 scp的时候就需要输入密码
    
    
    #copy其他机器文件到本地
    scp root@node2:/root/itcast.txt  ./  
    ```

# IV. Linux软件安装

- ## rpm包管理器与常用命令

  - ### rpm包管理器

    - 指的是==RH系列的包管理器==（Red-Hat Package Manager），也是RH安装的软件包后缀名。当下已经扩大了行业标准。
    - RPM指的是使用rpm命令进行软件的查看、安装、卸载。
    - 弊端
      - 提前下载rpm包，==手动安装==
      - 自己==解决包之间的依赖==

  - ### rpm常用命令

    ```shell
    #查询
    [root@node1 ~]# rpm -qa  | grep ssh
    libssh2-1.8.0-3.el7.x86_64
    openssh-clients-7.4p1-21.el7.x86_64
    openssh-7.4p1-21.el7.x86_64
    openssh-server-7.4p1-21.el7.x86_64
    
    [root@node1 ~]# rpm -qi openssh-clients-7.4p1-21.el7.x86_64
    Name        : openssh-clients
    Version     : 7.4p1
    Release     : 21.el7
    Architecture: x86_64
    Install Date: Mon 17 May 2021 11:37:29 AM CST
    Group       : Applications/Internet
    Size        : 2643176
    License     : BSD
    Signature   : RSA/SHA256, Fri 23 Aug 2019 05:37:26 AM CST, Key ID 24c6a8a7f4a80eb5
    Source RPM  : openssh-7.4p1-21.el7.src.rpm
    Build Date  : Fri 09 Aug 2019 09:40:49 AM CST
    Build Host  : x86-01.bsys.centos.org
    Relocations : (not relocatable)
    Packager    : CentOS BuildSystem <http://bugs.centos.org>
    Vendor      : CentOS
    URL         : http://www.openssh.com/portable.html
    Summary     : An open source SSH client applications
    Description :
    OpenSSH is a free version of SSH (Secure SHell), a program for logging
    into and executing commands on a remote machine. This package includes
    the clients necessary to make encrypted connections to SSH servers.
    
    
    #rpm安装软件
    rpm -ivh rpm 包的全路径
    
    
    #rpm卸载软件  注意 通常采用忽略依赖的方式进行卸载
    rpm -e --nodeps 软件包名称
    
    因为在卸载的时候 默认会将软件连同其依赖一起卸载 为了避免影响其他软件的正常使用 通常建议使用--nodeps参数忽略依赖的存在 只卸载程序自己
    ```

- ## rpm安装MySQL详解

  - ==**本课程中软件安装目录规范**==

    ```shell
    /export/server      #软件安装目录
    /export/software    #安装包的目录
    /export/data        #软件运行数据保存的目录
    /export/logs        #软件运行日志
    
    mkdir -p /export/server
    mkdir -p /export/software 
    mkdir -p /export/data
    mkdir -p /export/logs
    ```

  > 友情提示：==MySQL只需要安装在node1服务器即可==。

  - 卸载Centos7自带的mariadb

    ```shell
    [root@node3 ~]# rpm -qa|grep mariadb
    mariadb-libs-5.5.64-1.el7.x86_64
    
    [root@node3 ~]# rpm -e mariadb-libs-5.5.64-1.el7.x86_64 --nodeps
    [root@node3 ~]# rpm -qa|grep mariadb                            
    [root@node3 ~]# 
    ```

  - 安装mysql

    ```shell
    mkdir /export/software/mysql
    
    #上传mysql-5.7.29-1.el7.x86_64.rpm-bundle.tar 到上述文件夹下  解压
    tar xvf mysql-5.7.29-1.el7.x86_64.rpm-bundle.tar
    
    #执行安装依赖
    yum -y install libaio
    
    [root@node3 mysql]# rpm -ivh mysql-community-common-5.7.29-1.el7.x86_64.rpm mysql-community-libs-5.7.29-1.el7.x86_64.rpm mysql-community-client-5.7.29-1.el7.x86_64.rpm mysql-community-server-5.7.29-1.el7.x86_64.rpm 
    
    warning: mysql-community-common-5.7.29-1.el7.x86_64.rpm: Header V3 DSA/SHA1 Signature, key ID 5072e1f5: NOKEY
    Preparing...                          ################################# [100%]
    Updating / installing...
       1:mysql-community-common-5.7.29-1.e################################# [ 25%]
       2:mysql-community-libs-5.7.29-1.el7################################# [ 50%]
       3:mysql-community-client-5.7.29-1.e################################# [ 75%]
       4:mysql-community-server-5.7.29-1.e################                  ( 49%)
    ```

  - mysql初始化设置

    ```shell
    #初始化
    mysqld --initialize
    
    #更改所属组
    chown mysql:mysql /var/lib/mysql -R
    
    #启动mysql
    systemctl start mysqld.service
    
    #查看生成的临时root密码 
    cat  /var/log/mysqld.log
    
    [Note] A temporary password is generated for root@localhost: o+TU+KDOm004
    ```

  - 修改root密码 授权远程访问 设置开机自启动

    ```shell
    [root@node2 ~]# mysql -u root -p
    Enter password:     #这里输入在日志中生成的临时密码
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 3
    Server version: 5.7.29
    
    Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.
    
    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    mysql> 
    
    
    #更新root密码  设置为hadoop
    mysql> alter user user() identified by "hadoop";
    Query OK, 0 rows affected (0.00 sec)
    
    
    #授权
    mysql> use mysql;
    
    mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'hadoop' WITH GRANT OPTION;
    
    mysql> FLUSH PRIVILEGES; 
    
    #mysql的启动和关闭 状态查看 （这几个命令必须记住）
    systemctl stop mysqld
    systemctl status mysqld
    systemctl start mysqld
    
    #建议设置为开机自启动服务
    [root@node2 ~]# systemctl enable  mysqld                             
    Created symlink from /etc/systemd/system/multi-user.target.wants/mysqld.service to /usr/lib/systemd/system/mysqld.service.
    
    #查看是否已经设置自启动成功
    [root@node2 ~]# systemctl list-unit-files | grep mysqld
    mysqld.service                                enabled 
    ```

  - Centos7 ==干净==卸载mysql 5.7

    ```shell
    #关闭mysql服务
    systemctl stop mysqld.service
    
    #查找安装mysql的rpm包
    [root@node3 ~]# rpm -qa | grep -i mysql      
    mysql-community-libs-5.7.29-1.el7.x86_64
    mysql-community-common-5.7.29-1.el7.x86_64
    mysql-community-client-5.7.29-1.el7.x86_64
    mysql-community-server-5.7.29-1.el7.x86_64
    
    #卸载
    [root@node3 ~]# yum remove mysql-community-libs-5.7.29-1.el7.x86_64 mysql-community-common-5.7.29-1.el7.x86_64 mysql-community-client-5.7.29-1.el7.x86_64 mysql-community-server-5.7.29-1.el7.x86_64
    
    #查看是否卸载干净
    rpm -qa | grep -i mysql
    
    #查找mysql相关目录 删除
    [root@node1 ~]# find / -name mysql
    /var/lib/mysql
    /var/lib/mysql/mysql
    /usr/share/mysql
    
    [root@node1 ~]# rm -rf /var/lib/mysql
    [root@node1 ~]# rm -rf /var/lib/mysql/mysql
    [root@node1 ~]# rm -rf /usr/share/mysql
    
    #删除默认配置 日志
    rm -rf /etc/my.cnf 
    rm -rf /var/log/mysqld.log
    ```

- ## yum包管理器

  - 介绍

    ```shell
    Yum（全称为 Yellow dog Updater, Modified）是一个在Fedora和RedHat以及CentOS中的Shell前端软件包管理器。基于RPM包管理，能够从指定的服务器自动下载RPM包并且安装，可以自动处理依赖性关系，并且一次安装所有依赖的软件包，无须繁琐地一次次下载、安装。
    ```

  - 特点

    - ==自动下载rpm包 进行安装==  前提是联网  不联网就凉凉
    - ==解决包之间的依赖关系==

  - 原理

    ```shell
    #yum之所以强大原因在于有yum源。里面有很多rpm包和包之间的依赖。
    yum源分为网络yum源和本地yum源。
    
    #其中网络yum源在centos默认集成了镜像地址 只要联网就可以自动寻找到可用的yum源。 前提联网
    #也可以自己搭建本地yum源。实现从本地下载安装。
    ```

  - 命令

    ```shell
    #列出当前机器可用的yum源信息
    yum repolist all
     
    #清楚yum源缓存信息
    yum clean all
    
    #查找软件
    rpm list | grep 软件包名称
    
    #yum安装软件   -y表示自动确认 否则在安装的时候需要手动输入y确认下载安装
    yum install -y xx软件名
    yum install -y mysql-*
    
    #yum卸载软件
    yum -y remove 要卸载的软件包名
    ```

  - 扩展：Linux上面 ==command  not found== 错误的解决方案。

    ```shell
    #错误信息
    -bash: xxxx: command not found
    
    #原因
    	1、命令写错了
    	2、命令或者对应的软件没有安装
    
    #通用解决方案
    	如果是软件没有安装 
    	yum install -y  xxxx
    	
    	如果上述安装依然无法解决，需要确认命令所属于什么软件
    	比如jps命令属于jdk软件。
    ```

- ## JDK的安装与环境变量配置

  - 简单：解压即可使用 但是通常配置环境变量，以便于在各个路径下之间使用java。

  - 要求：==**JDK1.8版本**==。

  - 步骤

    ```shell
    #上传安装包到/export/server下
    jdk-8u241-linux-x64.tar.gz
    
    #解压到当前目录
    tar zxvf jdk-8u241-linux-x64.tar.gz
    
    #删除红色安装包（可选）
    rm -rf jdk-8u241-linux-x64.tar.gz
    
    #配置环境变量
    vim /etc/profile            #G + o  
    
    export JAVA_HOME=/export/server/jdk1.8.0_241
    export PATH=$PATH:$JAVA_HOME/bin
    export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
    
    
    #重新价值环境变量文件 让配置生效
    source /etc/profile
    
    [root@node1 ~]# java -version      
    java version "1.8.0_241"
    ```

  - 将node1的JDK安装包scp给其他机器

    ```shell
     #scp安装包
     cd /export/server/
     scp -r jdk1.8.0_241/ root@node2:$PWD
     
     #scp环境变量文件
     scp /etc/profile node2:/etc/
     
     #别忘了 其他机器source哦
     source /etc/profile
    ```

# V. 了解shell编程

- shell介绍

  - 指的是一种==程序==，往往是使用C语言开发，功能是访问操作系统内核获取操作系统信息。
  - 指的是==shell脚本语言==，使用什么样的命令语法格式去控制shell程序访问内核。
  - 通常情况下，所说shell编程指的shell脚本编程，==学习shell语法规则==。

- shell编程开发规范

  - 在哪里编写？

  ```
  只要能进行文本编辑的地方都可以写  linux上常使用vim编辑器开发
  ```

  - 需要编译？

  ```
  不需要编译
  ```

  - 如何执行？

  ```shell
  需要语法解释器 不需要安装 
  Linux系统中集成了很多个同种类的shell解释器
  
  [root@node1 linux02]# cat /etc/shells 
  /bin/sh
  /bin/bash
  /usr/bin/sh
  /usr/bin/bash
  /bin/tcsh
  /bin/csh
  ```

- 默认shell解释器 ==bash  shell = shell==

  ```
  因为很多linux发行版都以bash作为默认的解释器 所以说市面上大多数shell编程都是基于bash开展的
  
  bash shell免费的。
  ```

- 入门案例

  - - shell脚本文件 后缀名没有要求 ==通常以.sh结尾  见名知意==

    - 格式

      ```shell
      #!/bin/bash   
      echo 'hello shell'
      
      #第一行 指定解释器的路径
      ```

    - 给脚本授予执行权限

      ```
      chmod a+x hello.sh 
      ```

    - 执行shell脚本

      - 绝对路径指定shell脚本

        ```shell
        [root@node1 linux02]# /root/linux02/hello.sh 
        hello shell
        ```

      - 相对路径

        ```shell
        [root@node1 linux02]# hello.sh   #默认去系统环境变量中寻找  错误
        -bash: hello.sh: command not found
        [root@node1 linux02]# ./hello.sh  #从当前目录下找
        hello shell
        ```

      - 把shell脚本交给其他shell程序执行  比如sh

        ```shell
        [root@node1 linux02]# sh hello.sh 
        hello shell
        ```

    - 探讨：后缀名 解释器 执行权限是必须的吗？   不是必须的

      ```shell
      [root@node1 linux02]# vim bye.hs
      echo "bye bye"
      
      [root@node1 linux02]# sh bye.hs 
      bye bye
      
      #文件不是sh结尾 没有授权 没有指定bash解释器路径 但是却可以执行
      #此时这个文件是作为参数传递给sh来执行的  此时解释器是sh 只要保证文件中语法正确就可以执行
      ```

  - 扩展：shell 命令、shell 脚本

    - 都是属于shell的东西 
    - shell命令倾向于交互式使用，适合逻辑简单场景
    - shell脚本适合复杂逻辑 理解结合函数、条件判断、流程控制 写出更加丰富的程序。
    - shell命令和shell脚本之间可以互相换行。

    ```shell
    #编写shell脚本 执行脚本
    [root@node1 linux02]# cat hello.sh 
    #!/bin/bash
    echo 'hello shell'
    [root@node1 linux02]# sh hello.sh       
    hello shell
    
    #以shell命令执行
    [root@node1 linux02]# echo 'hello shell'
    hello shell
    ```

- 变量

- 字符串

- 反引号