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

分布式（Distributed）、集群（Cluster）

分布式：多台机器每台机器上部署不同组件

集群：多台机器每台机器上部署相同组件

负载均衡

## 环境搭建：



# IV. Linux软件安装

# V. 软件安装

# VI. 了解shell编程

 