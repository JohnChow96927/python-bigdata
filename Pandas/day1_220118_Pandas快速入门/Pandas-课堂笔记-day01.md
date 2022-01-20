[TOC]

# Day01-Series和DataFrame操作

Pandas 课程特点：

* 方法很多、但是每个都不难
* 熟悉Pandas的方法(基本使用)
* 用到查

业务分析、机器学习

PySpark：算子

## 今日课程内容简介

* Python数据开发简介【了解】
* Anaconda数据开发环境搭建【掌握】
* pandas快速入门【重点】
* Series和DataFrame【重点】

## 知识点1：02-Python做数据开发的优势【了解】

Python作为当下最为流行的编程语言之一，可以独立完成数据开发的各种任务：

- 语言本身就简单易学，书写代码简单快速
- 同时在数据分析以及大数据领域里有海量的功能强大的开源库，并持续更新
  - Pandas：数据清洗、数据处理、数据分析
  - Sklearn：机器学习、统计分析
  - PySpark：Spark使用Python
  - PyFlink：Flink使用Python Java
  - Matplotlib、Seaborn、Pyecharts：数据可视化(出图表)
  - ...

## 知识点2：03-为什么要学习Pandas【了解】

Python在数据处理上独步天下：代码灵活、开发快速；尤其是Python的 **Pandas** 开源库，无论是在数据分析领域、还是在大数据开发场景中都具有显著的优势：

- Pandas 是 Python 中的一个第三方数据分析开源库，也是商业和工程领域最流行的结构化数据工具集，用于数据清洗、处理以及分析
- Pandas 和 PySpark 中很多功能都类似，甚至使用方法都是相同的；当我们学会 Pandas 之后，再学习 PySpark 就更加简单快速
- Pandas在数据处理上具有独特的优势
  - 底层是基于Numpy构建的，所以运行速度特别的快
  - 有专门的处理缺失数据的API(方法)
  - 强大而灵活的分组、聚合、转换功能
- Pandas 在整个数据开发的流程中的应用场景
  - 在大数据场景下，数据在流转的过程中，Pandas 中丰富的API能够更加灵活、快速的对数据进行清洗和处理
  - 数据量大到 excel 严重卡顿，且又都是单机数据的时候，我们使用 Pandas
  - 在大数据 ETL 数据仓库中，对数据进行清洗及处理的环节使用 Pandas

劣势：

 * 单机开源库，数据量会有限制

## 知识点3：04-Python中常见的数据开发开源库【了解】

| 扩展包       | 简介                                                         |
| ------------ | ------------------------------------------------------------ |
| `NumPy`      | Python 中的一个开源数学运算库，运行速度非常快，主要用于数组计算 |
| `Matplotlib` | Matplotlib 是一个功能强大的数据可视化开源 Python 库          |
| `Seaborn`    | Python 中的一个数据可视化开源库，建立在 Matplotlib 之上，并集成了 Pandas 的数据结构 |
| `Pyecharts`  | 基于百度的 echarts 的 Python 数据可视化开源库，有完整丰富的中文文 档及示例 |
| `Sklearn`    | 即scikit-learn，是基于 Python 语言的机器学习工具，经常用于统计分析计算 |
| `PySpark`    | 是 Spark 为 Python 开发者提供的 API，具有 Spark 全部的 API 功能 |

## 知识点4：05-Anaconda简介和软件安装【掌握】

- Anaconda 是最流行的数据分析平台，全球两千多万人在使用

- Anaconda 附带了一大批常用数据科学包

- Anaconda 包含了虚拟环境和包管理工具 conda

- 我们平时使用 Anaconda 自带的 jupyter notebook 来进行开发，Anaconda 是工具管理器，jupyter notebook是代码编辑器（类似于PyCharm，但jupyter notebook是基于html网页运行的）

  代码一行一行单独执行，探索

## 知识点5：06-什么是虚拟环境(虚拟环境的作用)【理解】

同一个python解释器中，能否按照同一个扩展包的不同版本？

pymysql 1.0.2

pymysql 1.1.1

> 虚拟环境就是存在于同一台机器上不同目录下多个独立的Python解释器，每个Python解释器中可以安装自己的依赖包和模块。运行不同的项目可以选择不同的Python解释器。

虚拟环境的作用：

- 很多开源库版本升级后API有变化，老版本的代码不能在新版本中运行
- 将不同 Python 版本/相同开源库的不同版本隔离
- 不同版本的代码使用不同的虚拟环境运行

![img](images/1.png)



## 知识点6：07-Anaconda创建虚拟环境的2种方式【掌握】

```
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --set show_channel_urls yes
```

* 通过 Anaconda 提供的虚拟环境管理界面创建虚拟环境

* 通过 cmd 命令行终端创建虚拟环境

  ```bash
  conda env list # 查看本机有几个虚拟环境
  conda create -n 虚拟环境名字 python=3.8  # 创建虚拟环境 python=3.8 指定python版本
  conda activate 虚拟环境名字 # 进入虚拟环境
  conda deactivate # 退出当前虚拟环境
  conda remove -n 虚拟环境名字 --all  # 删除虚拟环境
  ```

## 知识点7：08-Anaconda虚拟环境安装py扩展包【掌握】

* 通过 Anaconda 提供的虚拟环境管理界面安装 py 扩展包

* 通过 cmd 命令行在虚拟环境中安装 py 扩展包

  > 注意：一定要先切换到对应的虚拟环境中，然后再安装 py 扩展包

  ```bash
  # ① 切换虚拟环境
  conda activate 虚拟环境名
  # ② 安装扩展包
  conda install 包名【不推荐】
  pip install 包名【推荐】
  
  
  # 安装 pandas 扩展包
  pip install pandas==1.1.1
  ```

## 知识点8：09-虚拟环境中jupyter notebook的安装和启动【掌握】

* 通过 Anaconda 提供的虚拟环境界面安装 jupyter notebook

  ![img](images/2.png)

* 通过 Anaconda 提供的虚拟环境界面启动 jupyter notebook【不推荐】

  ![img](images/3.png)

  ![img](images/4.png)

* 通过 cmd 命令行的方式启动 jupyter notebook【推荐】

  > 注意：启动之后 cmd 窗口不能关闭！！！

  ```bash
  # 切换到对应的虚拟环境
  conda activate datasci
  # 切换到自己的代码目录下
  D:
  cd code
  # 启动jupyter notebook
  jupyter notebook
  ```

  ![img](images/5.png)

## 知识点9：10-jupyter notebook的扩展插件安装和配置【掌握】

```bash
# 进入到虚拟环境中
conda activate 虚拟环境名字
# 安装 jupyter_contrib_nbextensions
pip install jupyter_contrib_nbextensions -i https://pypi.tuna.tsinghua.edu.cn/simple/
# jupyter notebook安装插件
jupyter contrib nbextension install --user --skip-running-check
# 安装 pep8 扩展包
pip install autopep8==1.5.7 -i https://pypi.tuna.tsinghua.edu.cn/simple/
```

![img](images/6.png)

## 知识点10：11-jupyter notebook创建py文件和菜单介绍【掌握】

![image-20211029212625281](images/7.png)

![img](images/8.png)

## 知识点11：12-jupyter notebook的常用快捷键【掌握】

Jupyter Notebook中分为两种模式：**命令模式和编辑模式**.

1）两种模式通用快捷键：

- Shift+Enter：执行本单元代码，并跳转到下一单元
- Ctrl+Enter：执行本单元代码，留在本单元

2）**命令模式**：编辑模式下按ESC进入即可进入命令模式

```bash
y：cell切换到Code模式
m：cell切换到Markdown模式
a：在当前cell的上面添加cell
b：在当前cell的下面添加cell
双击d：删除当前cell
```

3）**编辑模式**：命令模式下按Enter进入，或鼠标点击代码编辑框体的输入区域

```bash
多光标操作：Ctrl键点击鼠标（Mac:CMD+点击鼠标）
回退：Ctrl+Z（Mac:CMD+Z）
重做：Ctrl+Y（Mac:CMD+Y)
补全代码：变量、方法后跟Tab键
为一行或多行代码添加/取消注释：Ctrl+/（Mac:CMD+/）
```

## 知识点12：13-jupyter notebook编写md内容简介【了解】

> 注意：在命令模式中，按M即可进入到Markdown编辑模式，使用Markdown语法可以在代码间穿插格式化的文本作为说明文字或笔记。

```markdown
# 一级标题
## 二级标题
### 三级标题
#### 四级标题
#### 五级标题
- 一级缩进
	- 二级缩进
		- 三级缩进
```

## 知识点13：14-Pandas快速入门-DataFrame和Series简介【理解】

pandas最基本的两种数据结构：

1）**DataFrame**

- 用来处理结构化数据（SQL数据表，Excel表格）
- 可以简单理解为一张数据表(带有行标签和列标签)

2）**Series**

- 用来处理单列数据，也可以以把DataFrame看作由Series对象组成的字典或集合
- 可以简单理解为数据表的一行或一列

![img](images/9.png)

## 知识点14：15-Pandas快速入门-加载csv和tsv文件数据【重点】

csv 和 tsv 文件都是存储一个二维表数据的文件类型。

> 注意：其中csv文件每一列的列元素之间以逗号进行分割，tsv文件每一行的列元素之间以\t进行分割

![img](images/10.png)

```python
import pandas as pd

# 加载 csv 数据
df = pd.read_csv('csv文件路径')

# 加载 tsv 数据
df = pd.read_csv('tsv文件路径', sep='\t')
```

## 知识点15：16-DataFrame的行列标签和行列位置编号【重点】

**行标签和列标签**：

![img](images/11.png)

**行位置编号和列位置编号**：

![img](images/12.png)

## 知识点16：17-DataFrame-loc函数获取指定的行列数据【重点】

**基本格式**：

| 语法                                     | 说明                                                         |
| ---------------------------------------- | ------------------------------------------------------------ |
| `df.loc[[行标签1, ...], [列标签1, ...]]` | 根据行标签和列标签获取对应行的对应<br />列的数据，结果为：DataFrame |
| `df.loc[[行标签1, ...]]`                 | 根据行标签获取对应行的所有列的数据<br />结果为：DataFrame    |
| `df.loc[:, [列标签1, ...]]`              | 根据列标签获取所有行的对应列的数据<br />结果为：DataFrame    |
| `df.loc[行标签]`                         | 1）如果结果只有一行，结果为：Series<br />2）如果结果有多行，结果为：DataFrame |
| `df.loc[[行标签]]`                       | 无论结果是一行还是多行，结果为DataFrame                      |
| `df.loc[[行标签], 列标签]`               | 1）如果结果只有一列，结果为：Series，<br />行标签作为 Series 的索引标签<br />2）如果结果有多列，结果为：DataFrame |
| `df.loc[行标签, [列标签]]`               | 1）如果结果只有一行，结果为：Series，<br />列标签作为 Series 的索引标签<br />2）如果结果有多行，结果为DataFrame |
| `df.loc[行标签, 列标签]`                 | 1）如果结果只有一行一列，结果为单个值<br />2）如果结果有多行一列，结果为：Series，<br />行标签作为 Series 的索引标签<br />3）如果结果有一行多列，结果为：Series，<br />列标签作为 Series 的索引标签<br />4）如果结果有多行多列，结果为：DataFrame |

## 知识点17：18-DataFrame-iloc函数获取指定行列数据【重点】

**基本格式**：

| 语法                                      | 说明                                                         |
| ----------------------------------------- | ------------------------------------------------------------ |
| `df.iloc[[行位置1, ...], [列位置1, ...]]` | 根据行位置和列位置获取对应行的对应<br />列的数据，结果为：DataFrame |
| `df.iloc[[行位置1, ...]]`                 | 根据行位置获取对应行的所有列的数据<br />结果为：DataFrame    |
| `df.iloc[:, [列位置1, ...]]`              | 根据列位置获取所有行的对应列的数据<br />结果为：DataFrame    |
| `df.iloc[行位置]`                         | 结果只有一行，结果为：Series                                 |
| `df.iloc[[行位置]]`                       | 结果只有一行，结果为：DataFrame                              |
| `df.iloc[[行位置], 列位置]`               | 结果只有一行一列，结果为：Series，<br />行标签作为 Series 的索引标签 |
| `df.iloc[行位置, [行位置]]`               | 结果只有一行一列，结果为：Series，<br />列标签作为 Series 的索引标签 |
| `df.iloc[行位置, 行位置]`                 | 结果只有一行一列，结果为单个值                               |

## 知识点18：20-DataFrame-loc和iloc函数的切片操作【重点】

**基本格式**：

| 语法                                                    | 说明                                                         |
| ------------------------------------------------------- | ------------------------------------------------------------ |
| `df.loc[起始行标签:结束行标签, 起始列标签:结束列标签]`  | 根据行列标签范围获对应行的对应列的数据，包含起始行列标签和结束行列标签 |
| `df.iloc[起始行位置:结束行位置, 起始列位置:结束列位置]` | 根据行列标签位置获对应行的对应列的数据，包含起始行列位置，但不包含结束行列位置 |

## 知识点19：21-DataFrame-[]语法获取指定行列的数据【重点】

**基本格式**：

| 语法                              | 说明                                                         |
| --------------------------------- | ------------------------------------------------------------ |
| `df[['列标签1', '列标签2', ...]]` | 根据列标签获取所有行的对应列的数据，结果为：DataFrame        |
| `df['列标签']`                    | 根据列标签获取所有行的对应列的数据<br/>1）如果结果只有一列，结果为：Series，<br />行标签作为 Series 的索引标签<br />2）如果结果有多列，结果为：DataFrame |
| `df[['列标签']]`                  | 根据列标签获取所有行的对应列的数据，结果为：DataFrame        |
| `df[起始行位置:结束行位置]`       | 根据指定范围获取对应行的所有列的数据，不包括结束行位置       |

## 知识点20：22-Series详解-创建Series数据【了解】

```python
s = pd.Series(['banana', 42])
print(s)
print(type(s))

s = pd.Series(['banana', 'apple'])
print(s)
print(type(s))

s = pd.Series([50, 42])
print(s)
print(type(s))

# 创建 Series 时指定行标签
s = pd.Series(['smart', 18], index=['name', 'age'])
print(s)
print(type(s))
```

## 知识点21：23-Series详解-常用的属性和方法【熟悉】

**常用属性和方法**：

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

## 知识点22：24-Series详解-常用的统计方法【熟悉】

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

## 知识点23：25-Series详解-bool索引【重点】

> Series 支持 bool 索引，可以从 Series 获取 bool 索引为 True 的位置对应的数据。
>
> 应用场景：按条件进行 Series 数据的筛选操作。

![img](images/13.png)

## 知识点24：26-Series详解-Series运算【重点】

| 情况                         | 说明                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| `Series 和 数值型数据运算`   | Series 中的每个元素和数值型数据逐一运算，返回新的 Series     |
| `Series 和 另一 Series 运算` | 两个 Series 中相同行标签的元素分别进行运算，若不存在相<br/>同的行标签，计算后的结果为 NaN，最终返回新的 Series |

## 知识点25：27-DataFrame详解-创建DataFrame数据【了解】

```python
# 通过字典创建DataFrame
peoples = pd.DataFrame({
    'Name': ['Smart', 'David'],
    'Occupation': ['Teacher', 'IT Engineer'],
    'Age': [18, 30]
})

# 通过嵌套列表创建DataFrame，同时指定index行标签和columns列标签
peoples = pd.DataFrame([
    ['Teacher', 18],
    ['IT Engineer', 30]
], columns=['Occupation', 'Age'], index=['Smart', 'David'])
peoples
```

## 知识点26：28-DataFrame详解-常用的属性和方法【熟悉】

**常用属性和方法**：

| 属性或方法   | 说明                                     |
| ------------ | ---------------------------------------- |
| `df.shape`   | 查看 DataFrame 数据的形状                |
| `df.size`    | 查看 DataFrame 数据元素的总个数          |
| `df.ndim`    | 查看 DataFrame 数据的维度                |
| `len(df)`    | 获取 DataFrame 数据的行数                |
| `df.index`   | 获取 DataFrame 数据的行标签              |
| `df.columns` | 获取 DataFrame 数据的列标签              |
| `df.dtypes`  | 查看 DataFrame 每列数据元素的类型        |
| `df.info()`  | 查看 DataFrame 每列的结构                |
| `df.head(n)` | 获取 DataFrame 的前 n 行数据，n 默认为 5 |
| `df.tail(n)` | 获取 DataFrame 的后 n 行数据，n 默认为 5 |

## 知识点27：29-DataFrame详解-常用的统计方法【熟悉】

**常用统计方法**：

| 方法           | 说明                                         |
| -------------- | -------------------------------------------- |
| `s.max()`      | 计算 DataFrame 数据中每列元素的最大值        |
| `s.min()`      | 计算 DataFrame 数据中每列元素的最小值        |
| `s.count()`    | 统计 DataFrame 数据中每列非空(NaN)元素的个数 |
| `s.describe()` | 显示 DataFrame 数据中每列元素的各种统计值    |

## 知识点28：30-DataFrame详解-bool索引【重点】

> DataFrame 支持 bool 索引，可以从 DataFrame 获取 bool 索引为 True 的对应行的数据。
>
> 应用场景：按条件进行 DataFrame 数据的筛选操作。

![img](images/14.png)

## 知识点29：31-DataFrame详解-DataFrame运算【重点】

| 情况                               | 说明                                                         |
| ---------------------------------- | ------------------------------------------------------------ |
| `DataFrame 和 数值型数据运算`      | DataFrame 中的每个元素和数值型数据逐一运算，<br/>返回新的 DataFrame |
| `DataFrame 和 另一 DataFrame 运算` | 两个 DataFrame 中相同行标签和列标签的元素分<br/>别进行运算，若不存在相同的行标签或列标签，<br/>计算后的结果为 NaN，最终返回新的 DataFrame |

## 知识点30：32-DataFrame详解-set_index和reset_index【重点】

> 加载数据后，指定某列数据作为 DataFrame 行标签

* df.set_index('列名')：设置某列数据作为行标签

* df.reset_index()：重置行标签

## 知识点31：33-DataFrame详解-index_col参数【重点】

> 加载数据文件的时候，可以通过 index_col 参数，指定使用某一列数据作为行标签，index_col 参数可以指定列名或列位置编号

```python
# 加载 scientists.csv数据时，将 Name 列设置为行标签
pd.read_csv('./data/scientists.csv', index_col='Name')
或
pd.read_csv('./data/scientists.csv', index_col=0)
```

## 知识点32：33-DataFrame详解-修改行标签和列标签【重点】

| 方式                                                         | 说明                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `df.rename(index={'原行标签名': '新行标签名', ...}, columns={'原列标签名': '新列标签名', ...}, inplace=False)` | 修改指定的行标签和列标签，rename修改后默认返回新的 DataFrame；如果将inplace参数设置为True，则直接对原 DataFrame 进行修改 |
| `df.index = ['新行标签名1', '新行标签名2', ...]`<br />`df.columns = ['新列标签名1', '新列标签名2', ...]` | 修改DataFrame的行标签和列标签，直接对原 DataFrame 进行修改   |

## 知识点33：34-DataFrame详解-重新索引DataFrame数据【了解】

| 方式                                                         | 说明                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `df.reindex(index=['行标签1', '行标签2', ...], columns=['列标签1', '列标签2', ...])` | 重新索引的行标签和列标签，只提取原 DataFrame 中指定的行和列，并且原 DataFrame 中不存在的行标签和列表签会自动添加新行或新列，默认填充为NULL，返回新的 DataFrame |

