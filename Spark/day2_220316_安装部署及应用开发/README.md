# PySpark安装部署与应用开发

## PySpark应用开发

### Windows环境准备

> 无论在Windows系统还是Linux系统开发PySpark程序（使用Python编写Spark代码），需要安装一些软件：

![1632095140975](assets/1638755786869.png)

```ini
# 1、安装JDK 8
	Spark 框架使用Scala语言编写，最终运行代码转换为字节码，运行在JVM 虚拟机中

# 2、安装Hadoop 3.3.0
	Spark 程序往往读写HDFS上文件数据，在Windows系统需要Hadoop库包支持

# 3、安装Python3
	使用Python语言编写代码，安装Python语言包，此处使用Anaconda科学工具包
	
# 4、安装pyspark模块（库）
	在PyCharm中开发PySpark代码时，需要使用pyspark库，调用Spark 提供API
```

- 1、Windows 系统安装JDK

> 直接解压提供JDK压缩包： `jdk1.8.0_241.zip`到指定目录（建议：英文字符目录）中，比如解压路径：`D:\BigdataUser\Java`

![1632276495768](assets/1632276495768.png)

- 2、Windows 系统安装Hadoop

> 直接解压提供的`hadoop-3.3.0-Windows.zip`到指定（建议：英文字符目录）中，比如解压路径：`D:\BigdataUser`
>
> 配置java环境变量: 

![1632237579667](assets/1632237579667.png)

​	将 `hadoop-3.3.0\hadoop.dll`文件放入到Windows系统目录：`C:\Windows\System32`，重启电脑。

![1632237998733](assets/1632237998733.png)

- 3、Windows 系统安装Anaconda

> 在讲解Pandas时，已经安装完整，同样建议安装目录为英文字符目录，比如安装目录为：`C:\programfiles\Anaconda3`

![1638756966927](assets/1638756966927.png)

- 4、Anaconda 中安装pyspark库

> ​	使用PyCharm开发PySpark代码时，需要选择Python解释器，其中需要包含pyspark库，[在Anaconda 基础虚拟环境base中安装pyspark库]()。

```bash
# step1、切换虚拟环境
conda activate base
```

![1638757305137](assets/1638757305137.png)

```ini
# step2、安装pyspark类库
pip install pyspark==3.1.2 -i https://pypi.tuna.tsinghua.edu.cn/simple
```

> ​	`pyspark库`在Anaconda中**base基础虚拟环境**安装完成以后，查看`$ANACONDA_HOME/Lib/site-packages`目录，添加【`py4j`】和【`pyspark`】目录。

![1632233752979](assets/1632233752979.png)

> 至此，在Windows系统下，使用PyCharm开发PySpark程序环境准备全部完成。

### ★构建PyCharm Project

> 本次Spark课程中所有代码，都是基于Python语言开发，使用PyCharm集成开发环境。

![1632267428833](assets/1632267428833.png)

> 在Windows上创建PyCharm Project工程，设置Python解析器Interpreter，如下步骤设置：

- 1、打开PyCharm软件，点击【Create New Project】创建新的工程

![1632234247589](assets/1632234247589.png)

- 2、指定工程的名称（路径）、选择Window系统中安装Anaconda的base基础虚拟环境即可。

![1632234474153](assets/1632234474153.png)

- 3、添加Anaconda中base基础虚拟环境

![1632234764692](assets/1632234764692.png)

点击【OK】以后，为创建新工程Project添加刚刚指定Python Interpreter解释器

![1632234841241](assets/1632234841241.png)

点击【Create】安装，创建新的PyCharm Project。

> ​	**约定规范**：每天Spark课程，创建一个目录，比如第二天课程代码，目录名称：`pyspark-day02`，包含四个子目录：
>
> - `main`目录：源码目录，编写python代码存放位置
> - `resources`目录：资源目录，存储配置文件
> - `datas`目录：测试数据存储
> - `test` 目录：编写Python测试代码

![1634766525691](assets/1634766525691.png)

- 代码目录：`main`

![1638759381779](assets/1638759381779.png)

- 资源文件目录：`resources`

![1638759944594](assets/1638759944594.png)

> 编写Python测试代码：**HelloWorld程序**，文件名称：`python_hello_world.py`。

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

if __name__ == '__main__':
    """
    Python 入门程序：Hello World
    """
    print("Hello World.................")
```

​	执行Python代码，控制台打印：`Hello World`。

![1632236016403](assets/1638773984110.png)

### ★应用入口 - SparkContext

> Spark Application程序入口为：`SparkContext`，任何Spark应用首先需要构建SparkContext对象，构建步骤：

![1632236140837](assets/1632236140837.png)

文档：https://spark.apache.org/docs/3.1.2/rdd-programming-guide.html#initializing-spark

![1632236354192](assets/1632236354192.png)

案例演示代码：`01_test_sparkcontext.py`

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import time
from pyspark import SparkContext, SparkConf


if __name__ == '__main__':
    """
    Spark程序入口：SparkContext对象创建
    """

    # TODO：设置系统环境变量
    os.environ['JAVA_HOME'] = 'C:/Java/jdk1.8.0_241'
    os.environ['HADOOP_HOME'] = 'C:/Hadoop/hadoop-3.3.0'
    os.environ['PYSPARK_PYTHON'] = 'C:/Users/JohnChow/anaconda3/python.exe'
    os.environ['PYSPARK_DRIVER_PYTHON'] = 'C:/Users/JohnChow/anaconda3/python.exe'

    # 创建SparkConf实例，设置应用属性，比如名称和master
    spark_conf = SparkConf().setAppName("SparkContext Test").setMaster("local[2]")

    # 创建SparkContext对象，传递SparkConf实例
    sc = SparkContext(conf=spark_conf)
    print(sc)

    time.sleep(100000)
    # 关闭资源
    sc.stop()

```

### ★WordCount编程实现

> 编写Spark 程序分为5个步骤：

```ini
1. 获取上下文对象-context
2. 加载数据源-source
3. 数据转换处理-transformation
4. 结果数据输出-sink
5. 关闭上下文对象-close
```

![1632238607298](assets/1632238607298.png)

> 创建python文件：`02_wordcount.py`，从本地文件系统读取数据：`datas/words.txt`

- 创建文本文件：`words.txt`，内容如下：

```ini
spark python spark hive spark hive
python spark hive spark python
mapreduce spark hadoop hdfs hadoop spark
hive mapreduce
```

- 词频统计WordCount代码如下：`02_wordcount.py`

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import time

from pyspark import SparkConf, SparkContext

"""
基于Python语言，编程实现Spark中词频统计WordCount
"""

if __name__ == '__main__':
    # 0. 设置系统环境变量
    os.environ['JAVA_HOME'] = 'C:/Java/jdk1.8.0_241'
    os.environ['HADOOP_HOME'] = 'C:/Hadoop/hadoop-3.3.0'
    os.environ['PYSPARK_PYTHON'] = 'C:/Users/JohnChow/anaconda3/python.exe'
    os.environ['PYSPARK_DRIVER_PYTHON'] = 'C:/Users/JohnChow/anaconda3/python.exe'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark WordCount").setMaster("local[2]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    input_rdd = sc.textFile('../datas/words.txt')

    # 3. 数据转换处理-transformation
    """
        a. 分割单词，扁平化
        d. 转换二元组，每个单词出现一次
        c. 按照单词Key分组，并且对组内聚合
    """
    output_rdd = input_rdd \
        .flatMap(lambda line: str(line).split(' ')) \
        .map(lambda word: (word, 1)) \
        .reduceByKey(lambda tmp, item: tmp + item)

    # 4. 结果数据输出-sink
    output_rdd.foreach(lambda item: print(item))
    output_rdd.saveAsTextFile('../datas/output-' + str(round(time.time() * 1000)))

    # 5. 关闭上下文对象-close
    sc.stop()

```

​	运行pyspark代码，结果如下所示：

![1632238886480](assets/1632238886480.png)

> 修改上述词频统计WordCount代码，**从HDFS文件系统上读取数据，并且将结果保存文件系统中**。

​	复制python代码，重命名为： `03_wordcount_hdfs.py` ，修改input和output文件路径，都是`hdfs`开头

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
    基于Python语言，编程实现Spark中词频统计WordCount
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = 'C:/Java/jdk1.8.0_241'
    os.environ['HADOOP_HOME'] = 'C:/Hadoop/hadoop-3.3.0'
    os.environ['PYSPARK_PYTHON'] = 'C:/Users/JohnChow/anaconda3/python.exe'
    os.environ['PYSPARK_DRIVER_PYTHON'] = 'C:/Users/JohnChow/anaconda3/python.exe'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark WordCount").setMaster("local[2]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source
    input_rdd = sc.textFile('hdfs://node1.itcast.cn:8020/datas/input/words.txt')

    # 3. 数据转换处理-transformation
    """
        a. 分割单词，扁平化
        d. 转换二元组，每个单词出现一次
        c. 按照单词Key分组，并且对组内聚合
    """
    word_rdd = input_rdd.flatMap(lambda line: str(line).split(' '))
    tuple_rdd = word_rdd.map(lambda word: (word, 1))
    output_rdd = tuple_rdd.reduceByKey(lambda tmp, item: tmp + item)

    # 4. 结果数据输出-sink
    output_rdd.saveAsTextFile('hdfs://node1.itcast.cn:8020/datas/wc-output')

    # 5. 关闭上下文对象-close
    sc.stop()

```

### ★远程Python解析器



## Spark应用提交

### spark-submit命令



### ★提交执行WordCount



### 部署模式DeployMode



### Job作业组成



## Spark on YARN

### Hadoop YARN



### ★配置部署及测试



### ★yarn-client模式



### ★yarn-cluster模式



## 配置Anaconda下载镜像源地址

> ​	有时候pip install 或conda install 安装一些依赖包，网不好直接超时，或者包死都下不下来，可以配置或指定国内源镜像。

- 1）、Windows 系统，配置镜像源

第1步、创建 .condarc 配置文件，Windows系统文件位置：C:/Users/用户名/.condarc

```ini
conda config --set show_channel_urls yes
```

![1638757430747](assets/1638757430747.png)

​	第2步、编辑文件 `.condarc`，**删除**里面所有内容，替换如下内容

```ini
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
```

![1638757552241](assets/1638757552241.png)

- 2）、Linunx系统，配置镜像源地址

step1、切换虚拟环境

```ini
conda activate base
```

step2、创建 `.condarc` 配置文件，Linux系统文件位置：`/root/.condarc`

```ini
conda config --set show_channel_urls yes
```

step3、编辑文件 /root/.condarc，删除里面所有内容，替换如下内容

```ini
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
```

> 也可以使用 `pip` 安装包时，通过 `i` 指定镜像源地址：`pip install -i 国内镜像地址 包名`

```
pip install -i  http://mirrors.aliyun.com/pypi/simple/ numpy
```

国内镜像源地址：

```ini
清华：https://pypi.tuna.tsinghua.edu.cn/simple
阿里云：http://mirrors.aliyun.com/pypi/simple/
中国科技大学 https://pypi.mirrors.ustc.edu.cn/simple/
华中理工大学：http://pypi.hustunique.com/
山东理工大学：http://pypi.sdutlinux.org/ 
豆瓣：http://pypi.douban.com/simple/
```