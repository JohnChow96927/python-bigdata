# I. 操作系统概述

1. ## 计算机原理

   - ### 冯诺依曼三个原则：

     - #### 程序、数据底层采用二进制

     - #### 程序存储、顺序执行

     - #### 计算机由五个部分组成：

       - ##### CPU（运算器、控制器）

       - ##### 存储设备（内存、外存）

       - ##### 输入设备

       - ##### 输出设备

     

2. ## 操作系统概述

   ```properties
   定义:管理计算机硬件与软件资源的程序，同时也是计算机系统的内核与基石。没有操作系统称之为裸机。
   意义:使编程变得更简单。不需要再编写程序如何去控制协调硬件工作。操作系统也提供一个让用户与系统交互的操作界面。
   ```

3. ## 操作系统分类

   ##### 桌面操作系统

   ##### 服务器操作系统

   ##### 嵌入式操作系统

   ##### 移动设备操作系统

# II. Linux操作系统

- ### Linux发展史

  > http://linuxfederation.com/complete-historical-timeline-linux-evolution/

- ### Linux内核

  > 内核可以理解为操作系统最核心的那一部分。但是只有内核是不方便使用的。

- ### ==Linux操作系统=Linux内核+GNU+其他应用操作==

- ### Linux发行版本

- ### Linux分类

  ```properties
  个人桌面版
  
  企业服务器版
  
  -:国内最大的体系 RH 红帽系统，Centos是社区免费版本。
  ```

# III. VMware虚拟机使用

1. ##  虚拟设备与NAT网络模式

   - ### 虚拟设备组件

     > 所谓的虚拟指的是物理上不存在，但是逻辑上存在，功能跟物理实体一样的。

     ```shell
     #1、网卡、网络适配器
     	连接网络的硬件设备 分为有线和无线之分 其唯一身份标识MAC地址。
     #2、交换机
     	通过网线将计算机组成局域网，同一个交换机下网络地位是一样的。
     	整个局域网网络属性由交换机决定的。
     #3、DHCP 动态主机配置协议设备
     	自动的分配IP 网关DNS等属性 集中维护局域网网络。
     #4、NAT服务器
     	将不可上网的IP转换成为可以上网的IP  
     ```

   - ### Q：如何去组建一个局域网？

     ```
     交换机 服务器 网线
     ```

   - ### VMware NAT网络模式

     > 1、这种网络模式下，使用的交换机是谁？
     > 2、这种网络模式下，虚拟机能否上网？如果能上网，是如何上网的？

     ```properties
     NAT模式:使用vmnet8交换机，可以上网，通过NAT转换上网的。
     ```

2. ## NAT模式安装CentOS详解

   - 整个离线课程3台虚拟机 建议硬件资源分配

     ```
     node1 1*2 CPU  4G ram  
     node2 1*1 CPU  2G ram
     node2 1*1 CPU  2G ram
     ```

   - 安装过程详见附件资料与课堂演示

   - 特别注意

     - 推荐使用英文版本、无桌面版系统
     - 注意网卡初始化开关on
     - 注意网络配置

3. ## SSH协议原理

   - SSH安全外壳协议

     ```properties
     核心:非对称加密（单向的）
     实现:两把钥匙
       	公钥、私钥
      	公钥加密、私钥解密
     
     用途1:基于用户名密码加密登录
     用途2:机器间的免密登录
     ```

# IV. Linux常用基础命令

1. ## 文件系统概述

   - 文件系统概述

     ```properties
     文件系统: 操作系统用于明确存储设备（常见的是磁盘，也有基于NAND Flash的固态硬盘）上的文件的方法和数据结构; 在存储设备上组织文件的方法。
     操作系统中负责管理和存储文件信息的软件机构称为文件管理系统，简称文件系统。
     ```

     功能：==存储文件==，存储数据，管理文件。

   - 文件系统常见形式：==目录树==结构。

     ```properties
     1、都是从/根目录开始的
     2、分为两个种类：目录、文件
     3、路径的唯一性
     4、只有在目录下才可以继续创建下一级目录
     ```

   - Linux号称万物皆文件，组成一个目录树结构。所有的文件都是从/根目录开始的。

   - 回顾重要概念

     ```shell
     #1、当前目录
       你目前所在的目录 可以使用pwd来查看。 有的场合叫做当前工作目录。
     
     #2、相对路径
       相对你当前的工作目录  路径没有/
     
     #3、绝对路径
       从根目录开始,/开始的 跟你在哪里没有关系
     
     ```

   - 特殊符号

     ```properties
      .
     	如果是文件名字以.开始  .1.txt   表示文件是隐藏文件
     	如果是路径中有. 表示的是当前路径  ./
     	
      ..
     	当前路径的上一级   cd ../../   
     
      ~  
     	表示的是用户的家目录
     	root用户的家目录  /root
     	普通用户的家目录   /home/用户名
     
       /
        根目录
     ```

2. ## 常用操作命令

   - 基础操作

     ```shell
     #1、history命令 
        查看历史执行命令
     #2、查看指定目录下内容
        ls
        ls -a      查看所有文件 包括隐藏文件
        ls -l =ll  查看文件详细信息 包括权限 类型 时间 大小等
        ll -h      表示以人性化的显示内容
        ll  *      *通配符表示任意字符  ?表示有且只有一个字符
     #3、切换工作目录
        #如何查看自己当前的所在目录 pwd
        cd 路径     注意自己写的是相对还是绝对的  还可以结合特殊符合使用
        cd ./
        cd /
        cd ../
        cd ~
     #4、文件的创建与删除
        touch 创建一个空文件  没有内容的文件
        mkdir 创建文件夹
        	 	 -p  父目录不存在的情况下 帮助创建
        rm    删除文件
        		 -f 强制删除  不给与提示
        		 -r 递归删除 针对文件夹
        		 -rf 杀伤力极大 问问自己在干什么
        		 坐牢眼：rm -rf /*
     #5、移动与复制
     	tree  以树状图的形式显示文件夹下内容
     		[root@node1 tmp]# tree /usr/tmp/
     		-bash: tree: command not found
     		#如果在linux中出现命令找不到错误，一般来说两种原因：命令写错 命令不存在
     		在确定没有写错的情况下  可以使用yum在线快速安装
     		yum install -y tree
     	cp	复制文件或者文件夹
     		-r 递归 针对文件夹
     		/a/b  表示复制的是文件夹b
     		/a/b/* 表示复制的是文件夹b下的所有内容
     	mv  移动文件或者文件夹
         mv  旧文件名 新文件名
     ```

   - 文件内容查看命令

     ```shell
     #1、cat
     	一次查看所有的内容  适合小文件
     #2、less
     	按space键翻下一页，按enter键翻下一行 
     	按b向上翻一页
     	按q退出
     #3、head	
     	查看文档的前几行内容
     	-n 指定行数
     #4、tail
     	- 数字  查看最后几行内容
     	-f -F 文件  实时查看文件的变化内容
     	（当追踪的文件丢失再出现的时候 能否继续追踪 F可以继续）
     ```

   - 管道命令 |

     ```shell
     # 命令 1 | 命令 2 
       可以将命令 1 的结果 通过命令 2 作进一步的处理
       
     [root@node1 ~]# ls 
     1.txt  anaconda-ks.cfg  hello  lrzsz-0.12.20.tar.gz  test  test.file
     [root@node1 ~]# ls | grep ^t
     test
     test.file  
     ```

   - echo 输出命令

     ```shell
     #相当于print 将内容输出console控制台
     [root@node1 test]# echo 111
     111
     [root@node1 test]# echo "hello "
     hello 
     ```

   - 重定向

     ```shell
     #  >  覆盖
     
     #  >> 追加
     	将前面命令成功的结果追加指定的文件中
     
     #  &>>
         将前面命令失败的结果追加指定的文件中
     
     
     输出的内容分为标准输出stdout  错误输出stderr
     [root@node1 test]# echo 111
     111
     [root@node1 test]# echo "hello "
     hello 
     [root@node1 test]# echo 111 > 4.txt
     [root@node1 test]# cat 4.txt 
     111
     [root@node1 test]# echo 222 > 4.txt   
     [root@node1 test]# cat 4.txt       
     222
     [root@node1 test]# echo 222 >> 4.txt
     [root@node1 test]# cat 4.txt        
     222
     222
     
     [root@node1 test]# mkdir a/b/c  >> 5.txt   
     mkdir: cannot create directory ‘a/b/c’: No such file or directory  
     #错误的输出无法通过>>进行追加
     
     [root@node1 test]# mkdir a/b/c &>> 5.txt
     [root@node1 test]# cat 5.txt 
     mkdir: cannot create directory ‘a/b/c’: No such file or directory
     
     
     #  && 和 ||
     	命令1 &&命令2  1执行成功才执行2
     	命令1 ||命令2  1执行失败才执行2
     
     [root@node1 test]# mkdir a/b/c && echo "创建目录成功了"
     mkdir: cannot create directory ‘a/b/c’: No such file or directory
     [root@node1 test]# mkdir -p a/b/c && echo "创建目录成功了"
     创建目录成功了
     ```

3. ## 搜索操作、软链接

   - 软链接

     - 可以对比理解windows快捷方式。

       ```shell
       有没有硬链接呢？  有
       ln -s 目标文件的绝对路径 软链接名（快捷方式）
       ln    目标文件的绝对路径 硬链接名
       ```

   - Linux搜索文件

     - find

       ```shell
       find <指定目录> <指定条件> <指定动作>
       	默认是搜索当前目录下，所有文件 显示在屏幕上
       	
       find . -name "*.log" -ls 在当前目录查找以.log 结尾的文件， 并显示详细信息。
       find /root/ -perm 777 查找/root/目录下权限为 777 的文件
       find . -type f -name "*.log" 查找当目录，以.log 结尾的普通文件
       find . -type d | sort 查找当前所有目录并排序
       find . -size +100M 查找当前目录大于 100M 的文件	
       ```

     - grep

       ```shell
       ps -ef | grep sshd 查找指定 ssh 服务进程
       ps -ef | grep sshd | grep -v grep 查找指定服务进程，排除 gerp 本身
       ps -ef | grep sshd -c 查找指定进程个数
       ```

     - locate

       ```shell
       #相当于find -name 但是效率比find更高 因为底层维护了一个索引的数据库 默认一天更新一次
       #通常的使用习惯是 先更新在查找
       updatedb
       locate /etc/sh 搜索 etc 目录下所有以 sh 开头的文件
       locate pwd 查找和 pwd 相关的所有文件
       ```

     - ==which==

       ```shell
       #查找环境变量中的内容 
       通常用于判断软件是否配置环境变量。
       ```

4. ## 打包解包、压缩解压缩

   - 打包、解包

     ```shell
     tar cvf 打包名.tar  文件或者目录
     tar xvf 打包名.tar
     tar xvf 打包名.tar -C指定解包目录
     ```

   - 压缩、解压缩

     ```shell
     #z  gzip
     使用 gzip 压缩和解压缩
     #j bzip2
     使用 bzip2 压缩和解压缩
     
     
     tar zcvf itheima.tar.gz a.txt b.txt 
     tar zcvf itheima.tgz a.txt b.txt 
     
     tar zxvf lrzsz-0.12.20.tar.gz -C aaa/
     ```

# V. vi/vim文本编辑器

