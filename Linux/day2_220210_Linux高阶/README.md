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

- ## root用户与非root用户的区别

- ## su命令

- ## sudo命令

- ## 修改文件权限

  - 

# II. Linux常用系统信息查看

- 查看时间, 日期
- 查看磁盘, 内存信息
- 查看进程信息
- 完整命令参考链接

# III. 大数据集群环境搭建

分布式（Distributed）、集群（Cluster）

分布式：多台机器每台机器上部署不同组件

集群：多台机器每台机器上部署相同组件

负载均衡

## 环境搭建：



# IV. Linux软件安装

# V. 软件安装

# VI. 了解shell编程

 