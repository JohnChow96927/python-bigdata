[TOC]

# Day02-查询/数据类型/缺失值

## 今日课程内容简介

* DataFrame增删改【熟悉】
* DataFrame查询【重点】
* Pandas数据类型【熟悉】
* 缺失值处理【重点】



## 知识点1：02-DataFrame行操作-添加行vs修改行vs删除行【了解】
**添加行**：

| 方法               | 说明                                                     |
| ------------------ | -------------------------------------------------------- |
| `df.append(other)` | 向 DataFrame 末尾添加 other 新行数据，返回新的 DataFrame |

**修改行**：

> 注意：修改行时，是直接对原始 DataFrame 进行修改

| 方式                                       | 说明                           |
| ------------------------------------------ | ------------------------------ |
| `df.loc[['行标签', ...],['列标签', ...]]`  | 修改行标签对应行的对应列的数据 |
| `df.iloc[['行位置', ...],['列位置', ...]]` | 修改行位置对应行的对应列的数据 |

**删除行**：

| 方式                       | 说明                                       |
| -------------------------- | ------------------------------------------ |
| `df.drop(['行标签', ...])` | 删除行标签对应行的数据，返回新的 DataFrame |

## 知识点2：03-DataFrame列操作-添加列vs修改列vs删除列【重点】

**添加列/修改行**：

> 注意：添加列/修改列时，是直接对原始 DataFrame 进行修改

| 方式                     | 说明                                                         |
| ------------------------ | ------------------------------------------------------------ |
| `df['列标签']=新列`      | 1）如果 DataFrame 中不存在对应的列，则在 DataFrame 最右侧增加新<br />列<br /> 2）如果 DataFrame 中存在对应的列，则修改 DataFrame 中该列的数据 |
| `df.loc[:, 列标签]=新列` | 1）如果 DataFrame 中不存在对应的列，则在 DataFrame 最右侧增加新<br />列<br /> 2）如果 DataFrame 中存在对应的列，则修改 DataFrame 中该列的数据 |

**删除列**：

| 方式                               | 说明                                       |
| ---------------------------------- | ------------------------------------------ |
| `df.drop(['列标签', ...], axis=1)` | 删除列标签对应的列数据，返回新的 DataFrame |

## 知识点3：04-DataFrame查询操作-条件查询【重点】

**基本格式**：

| 方式                                 | 说明                            |
| ------------------------------------ | ------------------------------- |
| `df.loc[条件...]` `或` `df[条件...]` | 获取 DataFrame 中满足条件的数据 |
| `df.query('条件...')`                | 获取 DataFrame 中满足条件的数据 |

## 知识点4：05-DataFrame查询操作-分组聚合【重点】

**基本格式**：

| 方式                                                         | 说明                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `df.groupby(列标签, ...).列标签.聚合函数()`<br /> 或 <br />`df.groupby(列标签, ...)[列标签].聚合函数()` | 按指定列分组，并对分组<br />数据的相应列进行相应的<br />聚合操作 |
| `df.groupby(列标签, ...).agg({'列标签': '聚合', ...})`<br /> 或 <br />`df.groupby(列标签, ...).aggregate({'列标签': '聚合', ...})` | 按指定列分组，并对分组<br />数据的相应列进行相应的 聚合操作  |

常见聚合函数：

| 方式    | 说明               |
| ------- | ------------------ |
| `mean`  | 计算平均值         |
| `max`   | 计算最大值         |
| `min`   | 计算最小值         |
| `sum`   | 求和               |
| `count` | 计数(非空数据数目) |

## 知识点5：06-DataFrame查询操作-排序操作【重点】

**基本格式**：

| 方法                                            | 说明                                                         |
| ----------------------------------------------- | ------------------------------------------------------------ |
| `df.sort_values(by=['列标签'], ascending=True)` | 将 DataFrame 按照指定列的数据进行排序：<br /> ascending 参数默认为True，表示升序；<br /> 将 ascending 设置为 False，表示降序 |
| `df.sort_index(ascending=True)`                 | 将 DataFrame 按照行标签进行排序： <br />ascending 参数默认为True，表示升序；<br /> 将 ascending 设置为 False，表示降序 |

## 知识点6：07-DataFrame查询操作-nlargest和nsmallest【重点】

**基本格式**：

| 方法                       | 说明                                               |
| -------------------------- | -------------------------------------------------- |
| `df.nlargest(n, columns)`  | 按照 columns 指定的列进行降序排序，并取前 n 行数据 |
| `df.nsmallest(n, columns)` | 按照 columns 指定的列进行升序排序，并取前 n 行数据 |

## 知识点7：08-DataFrame查询操作-绘图操作【了解】

安装 matplotlib 扩展包：

```python
# 注意先进入自己的虚拟环境，然后再安装 matplotlib 扩展包
pip install matplotlib -i https://pypi.tuna.tsinghua.edu.cn/simple/
```

## 知识点8：09-Pandas数据类型-numpy简介【了解】

> Numpy（Numerical Python）是一个开源的Python科学计算库，用于快速处理任意维度的数组。

1）Numpy 支持常见的数组和矩阵操作

- 对于同样的数值计算任务，使用 Numpy 比直接使用 Python 要简洁的多

2）Numpy 使用ndarray对象来处理多维数组，该对象是一个快速而灵活的大数据容器

**Numpy ndarray的优势**：

1）数据在内存中存储的风格

- ndarray 在存储数据时所有元素的类型都是相同的，数据内存地址是连续的，批量操作数组元素时速度更快
- python 原生 list 只能通过寻址方式找到下一个元素，这虽然也导致了在通用性方面 Numpy 的 ndarray 不及python 原生 list，但计算的时候速度就慢了

2）ndarray 支持并行化运算

3）Numpy 底层使用 C 语言编写，内部解除了 GIL（全局解释器锁），其对数组的操作速度不受 python 解释器的限制，可以利用CPU的多核心进行运算，效率远高于纯 python 代码

## 知识点9：10-Pandas数据类型-numpy的ndarray和数据类型【了解】

> numpy中存储数据的类型叫：ndarray，可以存储 n 维数组数据

ndarray的属性：

| 属性             | 说明                       |
| ---------------- | -------------------------- |
| ndarray.shape    | 数组维度的元组             |
| ndarray.ndim     | 数组维数                   |
| ndarray.size     | 数组中的元素数量           |
| ndarray.itemsize | 一个数组元素的长度（字节） |
| ndarray.dtype    | 数组元素的类型             |

## 知识点10：11-Pandas数据类型-pandas数据类型简介【重点】

> pandas 是基于 Numpy 的，很多功能都依赖于 Numpy 的 ndarray 实现的，pandas 的数据类型很多与 Numpy 类似，属性也有很多类似。比如 pandas 数据中的 NaN 就是 numpy.nan

![img](images/1.png)

## 知识点11：12-Pandas数据类型-类型转换-astype函数【重点】

> astype 方法是通用函数，可用于把 DataFrame 中的任何列转换为其他 dtype，可以向 astype 方法提供任何内置类型或 numpy 类型来转换列的数据类型

```python
# 注意：astype是数据类型转换的通用函数，但是转换可能会出错
series.astype('列类型')
```

## 知识点12：13-Pandas数据类型-类型转换-to_numeric函数【重点】

> 如果想把变量转换为数值类型（int、float），还可以使用 pandas 的 to_numeric 函数；to_numeric 将数据转换为数值类型时，可以进行一下错误的处理设置，并可以设置类型的向下转换。

```python
pd.to_numeric('Series数据', errors='错误处理', downcast='向下类型转换')
```

* errors参数：
  * 1）默认情况下，该值为 raise，如果 to_numeric 遇到无法转换的值时，会抛错
  * 2）设置为coerce：如果 to_numeric 遇到无法转换的值时，会返回NaN
  * 3）设置为ignore：如果 to_numeric 遇到无法转换的值时，会放弃转换，什么都不做
* downcast 参数，默认是None，接受的参数值为integer、signed、float 和 unsigned：
  * 1）如果设置了某一类型的数据，那么 pandas 会将原始数据转为该类型能存储的最小子型态
  * 2）如 Pandas 中 float 的子型态有float32、float64，所以设置了downcast='float'，则会将数据转为能够以较少bytes去存储一个浮点数的float32
  * 3）另外，downcast 参数和 errors 参数是分开的，如果 downcast 过程中出错，即使 errors 设置为 ignore 也会抛出异常

## 知识点13：14-Pandas数据类型-category数据类型转换【重点】

```python
# 将 Series 数据转换为 Category 类型
series.astype('category')
```

## 知识点14：15-Pandas数据类型-深入category类型【了解】

```python
# 创建 Category 数据
s = pd.Series(    
    pd.Categorical(['a', 'b', 'c', 'd'],
                   categories=['c', 'b', 'a'])
)

# 创建 Category 数据
cat_series = pd.Series(['B', 'D', 'C', 'A'], dtype='category')

from pandas.api.types import CategoricalDtype
# 自定义一个有序的 category 类型
cat = CategoricalDtype(categories=['B', 'D', 'A', 'C'], ordered=True)
cat_series = cat_series.astype(cat)
```

## 知识点15：16-Python中的datetime日期对象【了解】

```python
from datetime import datetime
# 获取当前时间
t1 = datetime.now() # datetime类型

# 创建 datetime 数据
t2 = datetime(2020, 1, 1) # datetime类型

# timedelta类型：两个日期相减
diff = t1 - t2
```

## 知识点16：17-Pandas中的数据转换为datetime类型【重点】

```python
# 将 Series 数据转换为 datetime 类型
pd.to_datetime('series数据')

# parse_dates 参数可以是列标签或列的位置编号，表示加载数据时，将指定列转换为 datetime 类型
ebola = pd.read_csv('./data/country_timeseries.csv', parse_dates=[0])
```

## 知识点17：18-Pandas中提取日期的各个部分【重点】

```python
dt = pd.to_datetime('2021-06-01')
dt.year # 获取年
dt.month # 获取月
dt.day # 获取日
```

日期各部分提取参考文档：https://pandas.pydata.org/pandas-docs/stable/user_guide/timeseries.html#time-date-components

```python
# 注意：dt是日期类型的Series对象的属性，用于对Series中的日期数据操作，比如提取日期各个部分
ebola['year'] = ebola['Date'].dt.year
ebola['year']
```

## 知识点18：19-Pandas日期运算和Timedelta类型【重点】

```python
# 两个 datetime 类型 Series 相减，结果为 timedelta 类型的 Series
ebola['outbreak_day'] = ebola['Date'] - ebola['Date'].min()
```

![img](images/2.png)

## 知识点19：20-日期序列数据生成-date_range方法【了解】

**产生日期序列数据**：

```python
pd.date_range(start='起始日期', end='结束日期', freq='日期间隔')
```

* freq参数
  * 默认为'D'，产生连续的日期
  * 'B'：只产生工作日日期
  * '2B'：隔一个工作日取一个工作日
  * 'WOM-1THU'：每个月的第一个星期四
  * 'WOM-3FRI'：每个月的第三个星期五

## 知识点20：21-DateTimeIndex的设置【重点】

将 datetime 类型的列设置为行标签，行标签类型为：DateTimeIndex

![img](images/3.png)

## 知识点21：22-根据日期进行数据的筛选【重点】
> 注：把行标签索引设置为日期对象后，可以直接使用日期来获取某些数据

```python
# 根据日期范围筛选数据
df.loc['起始日期': '结束日期']

# 根据时间范围筛选数据
df.between_time('2:00', '5:00')

# 筛选某时刻的数据
df.at_time('5:47')
```

## 知识点22：23-DateTimeIndex 行标签排序【重点】

> 在按日期各部分筛选数据时，可以将数据先按日期行标签排序，排序之后根据日期筛选数据效率更高。

坑点：

- 数据按照 DateTimeIndex 行标签排序之前，只能使用 df.loc[...] 的形式根据日期筛选数据，
- 排序之后，可以同时使用 df.loc[...] 或 df[...] 的形式根据日期筛选数据

## 知识点23：24-resample日期序列数据的重采样【重点】

> 对于设置了日期类型行标签之后的数据，可以使用 resample 方法重采样，按照指定时间周期分组

```python
df.resample('W')：按周进行数据的重采样
df.resample('W-THU')：按周进行数据的重采样，以每周四作为一周的结束
df.resample('Q')：按季度进行数据的重采样
df.resample('QS')：表示按季度进行数据重采样，使用QS生成每季度的第一天
```

## 知识点24：25-缺失值处理-pandas缺失值NaN简介【重点】

**缺失数据有多重表现形式**：

1）数据库中，缺失数据表示为`NULL`

2）在某些编程语言中用`NA`或`None`表示

3）缺失值也可能是空字符串`''`或数值 `0`

4）在 pandas 中使用 `NaN` 表示缺失值

- pandas 中的 NaN 值来自 NumPy 库
- NumPy 中缺失值有几种表示形式：NaN，NAN，nan，他们都一样

> 注意点1：缺失值和其它类型的数据不同，它毫无意义，NaN不等于0，也不等于空字符串
>
> 注意点2：两个NaN也不相等

## 知识点25：26-缺失值处理-缺失值的判断【重点】

**pandas 判断是否为缺失值方法**：

| 方法                                 | 说明                  |
| ------------------------------------ | --------------------- |
| `pd.isnull(obj)` 或 `pd.isna(obj)`   | 判断 obj 是否为缺失值 |
| `pd.notnull(obj)` 或 `pd.notna(obj)` | 判断 obj 不为缺失值   |

**判断 Series 中的元素是否是缺失值**：

| 方法              | 说明                                                         |
| ----------------- | ------------------------------------------------------------ |
| `series.isnull()` | 判断 Series 中的每个元素是否为缺失值，返回一个 bool 序列的 Series 数据 |

**判断 DataFrame 中的数据是否是缺失值**：

| 方法          | 说明                                                         |
| ------------- | ------------------------------------------------------------ |
| `df.isnull()` | 判断 DataFrame 中的每个元素是否为缺失值，返回一个 bool 序列的 DataFrame 数据 |

## 知识点26：27-缺失值处理-加载包含缺失值的数据【重点】

```python
pd.read_csv('csv文件文件', na_values=["DR-3"], keep_default_na=False)
```

* na_values：指定加载数据时，把什么数据当作缺失值
* keep_default_na：设置为False，不显示默认缺失值，默认缺失值会被填充为''



NA

## 知识点27：28-缺失值处理-缺失情况的查看info函数【重点】

```python
# 查看 DataFrame 数据的形状
df.shape
# 查询 DataFrame 数据每列的结构，包含每列的非缺失值个数
df.info()
```

## 知识点28：29-缺失值处理-自定义缺失值统计的函数【重点】

```python
def missing_values_table(df):
    # 计算所有的缺失值
    mis_val = df.isnull().sum()

    # 计算缺失值的比例
    mis_val_percent = 100 * mis_val / len(df)

    # 将结果拼接成 DataFrame
    mis_val_table = pd.concat([mis_val, mis_val_percent], axis=1)

    # 将列重命名
    mis_val_table.columns = ['缺失值', '占比(%)']

    # 将缺失值为0的列去除，并按照缺失值占比进行排序
    mis_val_table_sorted = mis_val_table[mis_val_table['缺失值']!=0].sort_values(
        '占比(%)', ascending=False)

    # 打印信息
    print(f'传入的数据集共{df.shape[1]}列，\n其中{mis_val_table_sorted.shape[0]}列有缺失值')

    return mis_val_table_sorted
```

## 知识点29：30-缺失值处理-missingno库进行缺失值可视化【重点】

**安装**：

```python
# pip安装missingno
pip install missingno
```

**使用**：

```python
import missingno as msno

# 绘制柱状图，查看 DataFrame 中每列数据的缺失个数
msno.bar(df)

# 查看 DataFrame 中每列数据的缺失值分布情况
msno.matrix(df)

# 查看 DataFrame 中缺失列之间的相关性
msno.heatmap(df)
```

