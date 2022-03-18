# RDD弹性分布式数据集

## - I. PyCharm创建代码模板Template

> 编写每次PySpark程序，都是如下5步，其中第1步和第5步相同的，每次都要重新写一遍非常麻烦，[可以在PyCharm中构建PySpark程序的代码模板。]()

![1632238607298](assets/1632238607298.png)

> PyCharm 中设置 Python 代码模板：**设置 File > Settings > File and Code Template > Python Script**

![1638759810375](assets/1638759810375.png)

新建Python Spark程序模板Template：`PySpark Linux Script`

![1641972113343](assets/1641972113343.png)

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pyspark import SparkConf, SparkContext

if __name__ == '__main__':
    """
       
    """
    # 设置系统环境变量
    os.environ['JAVA_HOME'] = '/export/server/jdk'
    os.environ['HADOOP_HOME'] = '/export/server/hadoop'
    os.environ['PYSPARK_PYTHON'] = '/export/server/anaconda3/bin/python'
    os.environ['PYSPARK_DRIVER_PYTHON'] = '/export/server/anaconda3/bin/python'

    # 1. 获取上下文对象-context
    spark_conf = SparkConf().setAppName("PySpark Example").setMaster("local[2]")
    sc = SparkContext(conf=spark_conf)

    # 2. 加载数据源-source

    # 3. 数据转换处理-transformation

    # 4. 处理结果输出-sink

    # 5. 关闭上下文对象-close
    sc.stop()

```

