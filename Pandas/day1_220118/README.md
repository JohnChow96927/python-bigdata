# Pandas

## I. Python数据开发简介

- ### Python在数据开发领域的优势

    - #### 语言简单易学, 书写代码简单快捷

    - #### 同时在数据分析及大数据领域有海量的功能强大的开源库, 并持续更新

        - pandas: 数据清洗, 数据处理, 数据分析
        - Sklearn: 机器学习, 统计分析
        - PySpark
        - PyFlink
        - Matplotlib, Seaborn, Pyecharts: 数据可视化
        - ...

- ### 学习Pandas的原因

    - #### 数据分析开源库, 是商业和工程领域最流行的结构化数据工具集, 用于数据清洗, 处理以及分析

    - #### Pandas和PySpark很多功能都类似, 学会Pandas之后再学习PySpark就更加简单快速

    - #### Pandas在数据处理上有独特的优势

        - 底层基于Numpy构建, 运行速度快
        - 有专门处理缺失数据的API
        - 强大而灵活的分组, 聚合, 转换功能

- ### 其他常用Python库介绍

    ![image-20220118094543456](imgs/image-20220118094543456.png)

## II. 数据开发环境搭建

- ### Anaconda介绍

    ![image-20220118101148809](imgs/image-20220118101148809.png)

- ### Anaconda安装

    <https://www.anaconda.com/products/individual>

    具体面向百度

- ### Anaconda使用

    - #### 虚拟环境:

        > 不同的python项目, 可能使用了各个不同的python的包, 模块;
        >
        > 不同的python项目, 可能使用了相同的python包, 模块, 但版本不同;
        >
        > 不同的python项目, 甚至使用的python版本都不同

    不同项目代码的运行, 使用保存在不同路径下的python和各自的包模块; 不同的python解释器和包模块就称之为虚拟环境

    ![image-20220118101557098](imgs/image-20220118101557098.png)

    > **虚拟环境的本质，就是在你电脑里安装了多个Python解释器（可执行程序），每个Python解释器又关联了很多个包、模块；项目代码在运行时，是使用特定路径下的那个Python解释器来执行**

    - #### Anaconda添加国内镜像源(加速下载)

        - 打开命令行

            ```shell
            # Anaconda 添加国内清华镜像源
            conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
            # 让配置马上生效
            conda config --set show_channel_urls yes
            ```

    - #### 创建虚拟环境:

        - 通过界面创建

        - 通过命令行创建

            ```shell
            conda create -n 虚拟环境名字 python=3.8  # 创建虚拟环境 python=3.8 指定python版本
            conda activate 虚拟环境名字 # 进入虚拟环境
            conda deactivate # 退出当前虚拟环境
            conda remove -n 虚拟环境名字 --all  # 删除虚拟环境
            
            # 示例：
            # 1）创建一个名为 datasci 的 python3.8 虚拟环境
            conda create -n datasci python=3.8
            
            # 2）切换到 datasci python虚拟环境中
            conda activate datasci
            
            # 3）退出当前所在 python虚拟环境
            conda deactivate
            ```

- ### Anaconda的包管理功能

    ![image-20220118102133757](imgs/image-20220118102133757.png)

    - #### 通过anaconda提供的CMD工具进行python包的安装

        ```shell
        # 切换到自己的虚拟环境
        conda activate datasci
        
        conda install 包名字
        或者
        pip install 包名字
        
        # 阿里云：https://mirrors.aliyun.com/pypi/simple/
        # 豆瓣：https://pypi.douban.com/simple/
        # 清华大学：https://pypi.tuna.tsinghua.edu.cn/simple/
        # 中国科学技术大学 http://pypi.mirrors.ustc.edu.cn/simple/
        
        pip install 包名 -i https://pypi.tuna.tsinghua.edu.cn/simple/  # 通过清华大学镜像安装
        ```

    - #### 安装Pandas包

        ```shell
        # 安装 Pandas 扩展包
        pip install pandas==1.1.1 -i https://pypi.tuna.tsinghua.edu.cn/simple/
        ```

- ### Jupyter Notebook的使用

    ![image-20220118102403646](imgs/image-20220118102403646.png)

    ![image-20220118102412943](imgs/image-20220118102412943.png)

    ![image-20220118102443936](imgs/image-20220118102443936.png)

    ![image-20220118102455474](imgs/image-20220118102455474.png)

    - jupyter notebook的功能拓展

        ```shell
        # 进入到虚拟环境中
        conda activate 虚拟环境名字
        # 安装 jupyter_contrib_nbextensions
        pip install jupyter_contrib_nbextensions -i https://pypi.tuna.tsinghua.edu.cn/simple/
        # jupyter notebook安装插件
        jupyter contrib nbextension install --user --skip-running-check
        # 安装 pep8 扩展包
        pip install autopep8==1.5.7 -i https://pypi.tuna.tsinghua.edu.cn/simple/
        ```

    ![image-20220118102726624](imgs/image-20220118102726624.png)

    - Jupyter Notebook的界面

    ![image-20220118102802119](imgs/image-20220118102802119.png)

    ![image-20220118102819549](imgs/image-20220118102819549.png)

    - Jupyter Notebook常用快捷键

    ![image-20220118102901329](imgs/image-20220118102901329.png)

    ![image-20220118102918425](imgs/image-20220118102918425.png)

    ![image-20220118102938187](imgs/image-20220118102938187.png)

- ### Jupyter Notebook中使用Markdown

    > 注意：在命令模式中，按M即可进入到Markdown编辑模式，使用Markdown语法可以在代码间穿插格式化的文本作为说明文字或笔记。

    ![image-20220118103243966](imgs/image-20220118103243966.png)

    ![image-20220118103256498](imgs/image-20220118103256498.png)

## III. Pandas快速入门

1. ### DataFrame和Series简介

    1. #### DataFrame

        - 用来处理结构化数据(SQL数据表, Excel表格)
        - 可以简单理解为一张数据表(带有行标签和列标签)

    2. #### Series

        - 用来处理单列数据, 也可以把DataFrame看做由Series对象组成的字典或集合
        - 可以简单理解为数据表的一行或一列

    ![image-20220118104534185](imgs/image-20220118104534185.png)

2. ### 加载数据集(csv和tsv)

    1. #### 文件格式简介

        csv和tsv文件都是存储一个二维表数据的文件类型

        > ##### 注意: csv每一列的列元素之间以逗号进行分割, tsv文件每一行的列元素之间以\t进行分割

        ![image-20220118110734011](imgs/image-20220118110734011.png)

    2. #### 加载数据集

        ![image-20220118111051269](imgs/image-20220118111051269.png)

        ![image-20220118111108428](imgs/image-20220118111108428.png)

3. ### DataFrame的行列标签和行列位置编号

    1. #### DataFrame的行标签和列标签

        如图所示, 分别是DataFrame的行标签和列标签

        ![image-20220118111211735](imgs/image-20220118111211735.png)

        获取DataFrame的行标签:

        ```python
        china.index
        ```

        获取DataFrame的列标签:

        ```python
        china.columns
        ```

        设置DataFarme的行标签:

        ```python
        china_df = china.set_index('year')
        ```

    2. #### DataFrame的行位置编号和列位置编号

        ![image-20220118112152948](imgs/image-20220118112152948.png)

4. ### DataFrame获取指定行列的数据

    1. #### loc函数获取指定行列的数据

        ![image-20220118115906327](imgs/image-20220118115906327.png)

        ![image-20220118111952092](imgs/image-20220118111952092.png)

        ![image-20220118112042848](imgs/image-20220118112042848.png)

        ![image-20220118112057137](imgs/image-20220118112057137.png)

        

    2. #### iloc函数获取指定行列的数据

        ![image-20220118115951796](imgs/image-20220118115951796.png)

        ![image-20220118120217850](imgs/image-20220118120217850.png)

        ![image-20220118120234704](imgs/image-20220118120234704.png)

        ![image-20220118120245928](imgs/image-20220118120245928.png)

    3. #### loc和iloc的切片操作

        **基本格式**：

        | 语法                                                    | 说明                                                         |
        | ------------------------------------------------------- | ------------------------------------------------------------ |
        | `df.loc[起始行标签:结束行标签, 起始列标签:结束列标签]`  | 根据行列标签范围获对应行的对应列的数据，包含起始行列标签和结束行列标签 |
        | `df.iloc[起始行位置:结束行位置, 起始列位置:结束列位置]` | 根据行列标签位置获对应行的对应列的数据，包含起始行列位置，但不包含结束行列位置 |

        ![image-20220118120451761](imgs/image-20220118120451761.png)

    4. #### []语法获取指定行列的数据

        ##### **基本格式**：

        | 语法                              | 说明                                                         |
        | --------------------------------- | ------------------------------------------------------------ |
        | `df[['列标签1', '列标签2', ...]]` | 根据列标签获取所有行的对应列的数据，结果为：DataFrame        |
        | `df['列标签']`                    | 根据列标签获取所有行的对应列的数据 1）如果结果只有一列，结果为：Series， 行标签作为 Series 的索引标签 2）如果结果有多列，结果为：DataFrame |
        | `df[['列标签']]`                  | 根据列标签获取所有行的对应列的数据，结果为：DataFrame        |
        | `df[起始行位置:结束行位置]`       | 根据指定范围获取对应行的所有列的数据，不包括结束行位置       |

        ![image-20220118120533627](imgs/image-20220118120533627.png)

        ![image-20220118120547551](imgs/image-20220118120547551.png)

        ### 上图为常用语法!

        ![image-20220118120600775](imgs/image-20220118120600775.png)

## IV. Series和DataFrame

1. ### Series详解

    #### Series是Pandas中用来存储一维数据的容器

    1. #### 创建Series

        ##### 创建Series的最简单方法是传入一个Python列表

        - 如果传入数据类型是数字, 则最终的dtype类型为int64
        - 如果传入的数据类型是统一的字符串或是多种类型, 那么最终的dtype类型是object

        ![image-20220118145232325](imgs/image-20220118145232325.png)

        > ##### 注意: 上面的结果中, 左边显示的0, 1是Series的行标签, 默认为0,1,2,3...

        创建Series时也可以通过index参数来指定行标签

        ![image-20220118145602068](imgs/image-20220118145602068.png)

    2. #### Series常用操作

        ##### 常用属性和方法:

        | 属性或方法       | 说明                                            |
        | ---------------- | ----------------------------------------------- |
        | `s.shape`        | 查看 Series 数据的形状                          |
        | `s.size`         | 查看 Series 数据的个数                          |
        | `s.index`        | 获取 Series 数据的行标签                        |
        | `s.values`       | 获取 Series 数据的元素值                        |
        | `s.keys()`       | 获取 Series 数据的行标签，和 `s.index` 效果相同 |
        | `s.loc[行标签]`  | 根据行标签获取 Series 中的某个元素数据          |
        | `s.iloc[行位置]` | 根据行位置获取 Series 中的某个元素数据          |
        | `s.dtypes`       | 查看 Series 数据元素的类型                      |

        ![image-20220118150322686](imgs/image-20220118150322686.png)

        ![image-20220118150346660](imgs/image-20220118150346660.png)

        **常用统计方法**：

        | 方法               | 说明                                  |
        | ------------------ | ------------------------------------- |
        | `s.mean()`         | 计算 Series 数据中元素的平均值        |
        | `s.max()`          | 计算 Series 数据中元素的最大值        |
        | `s.min()`          | 计算 Series 数据中元素的最小值        |
        | `s.std()`          | 计算 Series 数据中元素的标准差        |
        | `s.value_counts()` | 统计 Series 数据中不同元素的个数      |
        | `s.count()`        | 统计 Series 数据中非空(NaN)元素的个数 |
        | `s.describe()`     | 显示 Series 数据中元素的各种统计值    |

        ![image-20220118150923102](imgs/image-20220118150923102.png)

        ![image-20220118150941555](imgs/image-20220118150941555.png)

        ![image-20220118150950148](imgs/image-20220118150950148.png)

        ![image-20220118151022349](imgs/image-20220118151022349.png)

        ![image-20220118151037173](imgs/image-20220118151037173.png)

        ![image-20220118151102882](imgs/image-20220118151102882.png)

        **Series方法(备查)**：

        | 方法            | 说明                                 |
        | --------------- | ------------------------------------ |
        | append          | 连接两个或多个Series                 |
        | corr            | 计算与另一个Series的相关系数         |
        | cov             | 计算与另一个Series的协方差           |
        | describe        | 计算常见统计量                       |
        | drop_duplicates | 返回去重之后的Series                 |
        | equals          | 判断两个Series是否相同               |
        | get_values      | 获取Series的值，作用与values属性相同 |
        | hist            | 绘制直方图                           |
        | isin            | Series中是否包含某些值               |
        | min             | 返回最小值                           |
        | max             | 返回最大值                           |
        | mean            | 返回算术平均值                       |
        | median          | 返回中位数                           |
        | mode            | 返回众数                             |
        | quantile        | 返回指定位置的分位数                 |
        | replace         | 用指定值代替Series中的值             |
        | sample          | 返回Series的随机采样值               |
        | sort_values     | 对值进行排序                         |
        | to_frame        | 把Series转换为DataFrame              |
        | unique          | 去重返回数组                         |

    3. #### bool索引

        ##### Series支持bool索引, 可以从Series获取bool索引为True的位置对应的数据

        ![image-20220118153134810](imgs/image-20220118153134810.png)

        ##### 应用: 从age_series中删选出年龄大于平均值的数据

        ![image-20220118153318573](imgs/image-20220118153318573.png)

    4. #### Series运算

        | 情况                         | 说明                                                         |
        | ---------------------------- | ------------------------------------------------------------ |
        | `Series 和 数值型数据运算`   | Series 中的每个元素和数值型数据逐一运算，返回新的 Series     |
        | `Series 和 另一 Series 运算` | 两个 Series 中相同行标签的元素分别进行运算，若不存在相 同的行标签，计算后的结果为 NaN，最终返回新的 Series |

        ##### Series和数值型数据运算

        ![image-20220118153945198](imgs/image-20220118153945198.png)

        ##### Series和另一Series运算

        ![image-20220118154217356](imgs/image-20220118154217356.png)

        ![image-20220118154355721](imgs/image-20220118154355721.png)

2. ### DataFrame详解

    1. #### 创建DataFrame

    2. #### DataFrame常用操作

    3. #### bool索引

    4. #### DataFrame运算

    5. #### 行标签和列标签操作

