### Centos7安装Python3

```shell
#1、安装编译相关工具
yum -y groupinstall "Development tools"

yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel

yum install libffi-devel -y

#2、解压Python安装包
tar -zxvf  Python-3.8.5.tgz

#3、编译、安装Python
mkdir /usr/local/python3 #创建编译安装目录
cd Python-3.8.5
./configure --prefix=/usr/local/python3
make && make install  #make编译c源码 make install 编译后的安装

#安装过，出现下面两行就成功了
Installing collected packages: setuptools, pip
Successfully installed pip-20.1.1 setuptools-47.1.0


#4、创建软连接
# 查看当前python软连接  快捷方式
[root@node2 Python-3.8.5]# ll /usr/bin/ |grep python
-rwxr-xr-x.   1 root root      11232 Aug 13  2019 abrt-action-analyze-python
lrwxrwxrwx.   1 root root          7 May 17 11:36 python -> python2
lrwxrwxrwx.   1 root root          9 May 17 11:36 python2 -> python2.7
-rwxr-xr-x.   1 root root       7216 Aug  7  2019 python2.7


#默认系统安装的是python2.7 删除python软连接
rm -rf /usr/bin/python

#配置软连接为python3
ln -s /usr/local/python3/bin/python3 /usr/bin/python

#这个时候看下python默认版本
python -V

#删除默认pip软连接，并添加pip3新的软连接
rm -rf /usr/bin/pip
ln -s /usr/local/python3/bin/pip3 /usr/bin/pip


#5、更改yum配置
#因为yum要用到python2才能执行，否则会导致yum不能正常使用（不管安装 python3的那个版本，都必须要做的）
vi /usr/bin/yum 
把 #! /usr/bin/python 修改为 #! /usr/bin/python2 

vi /usr/libexec/urlgrabber-ext-down 
把 #! /usr/bin/python 修改为 #! /usr/bin/python2

vi /usr/bin/yum-config-manager
#!/usr/bin/python 改为 #!/usr/bin/python2
```

