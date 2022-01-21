# I. 缺失值处理

1. ## 加载数据集

    1）加载 `titanic_train.csv` 数据集

    ```python
    # 加载数据
    train = pd.read_csv('./data/titanic_train.csv')
    pirnt(train.shape)
    train.head()
    ```

    ![image-20220121092259694](imgs/image-20220121092259694.png)

    **字段介绍**：

    | 字段名        | 说明                               |
    | ------------- | ---------------------------------- |
    | `PassengerId` | 乘客的ID                           |
    | `Survived`    | 乘客是否获救，0：没获救，1：已获救 |
    | `Pclass`      | 乘客船舱等级（1/2/3三个等级舱位）  |
    | `Name`        | 乘客姓名                           |
    | `Sex`         | 性别                               |
    | `Age`         | 年龄                               |
    | `SibSp`       | 乘客在船上的兄弟姐妹/配偶数量      |
    | `Parch`       | 乘客在船上的父母/孩子数量          |
    | `Ticket`      | 船票号                             |
    | `Fare`        | 船票价                             |
    | `Cabin`       | 客舱号码                           |
    | `Embarked`    | 登船的港口                         |

    #### 构造缺失值统计的函数

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

    #### 查看数据集中的缺失值情况

    ```python
    # 查看缺失值情况
    missing_values_table(train)
    ```

    ![image-20220121092317494](imgs/image-20220121092317494.png)

2. ## 缺失值处理方式概述

    ![chapter03-32-2669499](imgs/chapter03-32-2669499.png)

3. ## 删除缺失值(不建议使用)

    > 删除缺失值：删除缺失值会损失信息，并不推荐删除，当缺失数据占比较低的时候，可以尝试使用删除缺失值

    1）按行删除：删除指定列为缺失值的行记录

    ```python
    # 复制一份数据
    train_cp = train.copy() 
    # 对Age列进行处理，空值就删除整行数据
    train_cp.dropna(subset=['Age'], how='any', inplace=True)
    # 输出Age列缺失值的总数
    print(train_cp['Age'].isnull().sum())
    # 图形化缺失值情况
    msno.matrix(train_cp)
    ```

    ![image-20220120170544154](imgs/image-20220120170544154-2671266.png)

    补充内容：dropna的参数

    > df.dropna(axis=0, how='any', thresh=None, subset=None, inplace=False)
    >
    > 参数说明：
    >
    > - 可选参数subset：不与thresh参数一起使用：接收一个列表，列表中的元素为列名: 对特定的列进行缺失值删除处理
    > - 可选参数thresh：参数为int类型，按行去除NaN值，去除NaN值后该行剩余数值的数量（列数）大于等于n，便保留这一行
    > - 可选参数axis：默认为0，设置为 0 或 'index' 表示按行删除，设置为 1 或 'columns' 表示按列删除
    > - 可选参数how：默认为'any'，表示如果存在NA值，则删除该行或列，设置为'all'，表示所有值都是NA，则删除该行或列
    > - 可选参数inplace：表示是否修改变原始的数据集，默认为False，可以设置为True

    2）按列删除：当一列包含了很多缺失值的时候（比如超过80%），可以使用df.drop(['列名',..], axis=1)函数将指定列删除，但最好不要删除数据

    ```python
    # 复制一份数据
    train_cp = train.copy() 
    # 对Age列进行处理，空值就删除整行数据
    train_cp.drop(['Age'], axis=1, inplace=True)
    # 图形化缺失值情况
    msno.matrix(train_cp)
    ```

    ![image-20220120170657324](imgs/image-20220120170657324-2671271.png)

    > 注意：Age 列没有了!!!

4. ## 非时序数据填充缺失值

    > 填充缺失值（非时间序列数据）：填充缺失值是指用一个估算的值来去替代缺失值

    1）使用常量来替换（默认值）

    ```python
    # 复制一份数据
    train_constant = train.copy()
    # 计算各列空值总数
    print('填充缺失值之前：')
    print(train_constant.isnull().sum())
    
    # 将空值都填为0，inplace=True为必要参数
    train_constant.fillna(0, inplace=True)
    
    # 计算各列空值总数
    print('填充缺失值之后：')
    print(train_constant.isnull().sum())
    ```

    ![image-20220120170737338](imgs/image-20220120170737338-2671345.png)

    2）使用统计量替换（缺失值所处列的平均值、中位数、众数）

    ```python
    # 复制一份数据
    train_mean = train.copy()
    # 计算年龄的平均值
    age_mean = train_mean['Age'].mean()
    print(age_mean)
    # 使用年龄的平均值填充 Age 列的缺失值
    train_mean['Age'].fillna(age_mean, inplace=True)
    train_mean.isnull().sum()
    ```

    ![image-20220120170804036](imgs/image-20220120170804036-2671350.png)

5. ## 时序数据缺失值处理

    时序数据在某一列值的变化往往有一定线性规律，绝大多数的时序数据，具体的列值随着时间的变化而变化，所以对于有时序的行数据缺失值处理有三种方式：

    - 用时间序列中空值的上一个非空值填充
    - 用时间序列中空值的下一个非空值填充
    - 线性插值方法

    1）加载样例时序数据集 `city_day.csv`，该数据集为印度城市空气质量数据（2015-2020）

    ```python
    city_day = pd.read_csv('./data/city_day.csv', parse_dates=True, index_col='Date')
    # 复制一份数据
    city_day_cp = city_day.copy()
    # 查看数据的前 5 行
    city_day_cp.head()
    ```

    ![image-20220120170849950](imgs/image-20220120170849950.png)

    2）用之前封装的方法（本章3.2.2小节），查看数据缺失情况：

    ```python
    city_day_missing = missing_values_table(city_day_cp)
    city_day_missing
    ```

    ![image-20220120170923738](imgs/image-20220120170923738.png)

    结果说明：

    - 我们可以观察到数据中有很多缺失值，比如Xylene有超过60%的缺失值（二甲苯），PM10 有超过30%的缺失值

    3）使用`fillna`函数中的`ffill`参数，用时间序列中空值的上一个非空值填充

    ```python
    # 截取一小部分数据用于填充效果查看
    city_day['Xylene'][50:64]
    ```

    ![image-20220120170950389](imgs/image-20220120170950389.png)

    ```python
    # 填充缺失值
    city_day.fillna(method='ffill', inplace=True)
    # 截取一小部分数据查看填充效果
    city_day['Xylene'][50:64]
    ```

    ![image-20220120171016602](imgs/image-20220120171016602.png)

    4）上面填充了缺失值之后，再次查看缺失值情况

    ```python
    # 查看缺失值比例
    missing_values_table(city_day)
    ```

    ![image-20220120171101728](imgs/image-20220120171101728.png)

    5）使用`fillna`函数中的`bfill`参数，用时间序列中空值的下一个非空值填充

    ```python
    # 截取一小部分数据用于填充效果查看
    city_day['AQI'][20:30]
    ```

    ![image-20220120171121898](imgs/image-20220120171121898.png)

    ```python
    # 填充缺失值
    city_day.fillna(method='bfill', inplace=True)
    # 截取一小部分数据查看填充效果
    city_day['AQI'][20:30]
    ```

    ![image-20220120171159365](imgs/image-20220120171159365.png)

    6）上面填充了缺失值之后，再次查看缺失值情况

    ```python
    # 查看缺失值比例
    missing_values_table(city_day)
    ```

    ![image-20220120171257848](imgs/image-20220120171257848.png)

    7）使用`df.interpolate(limit_direction="both", inplace=True)` 对缺失数据进行线性填充

    - 绝大多数的时序数据，具体的列值随着时间的变化而变化。 因此，使用bfill和ffill进行插补并不是解决缺失值问题的最优方案。
    - 线性插值法是一种插补缺失值技术，它假定数据点之间存在严格的线性关系，并利用相邻数据点中的非缺失值来计算缺失数据点的值

    ```python
    # 截取一小部分数据用于填充效果查看
    city_day_cp['Xylene'][50:65]
    ```

    ![image-20220120171355175](imgs/image-20220120171355175-2671397.png)

    ```python
    # 线性插值填充
    city_day_cp.interpolate(limit_direction='both', inplace=True)
    # 截取一小部分数据用于查看填充效果
    city_day_cp['Xylene'][50:65]
    ```

    ![image-20220120171407982](imgs/image-20220120171407982-2671395.png)

6. ## 其它填充缺失值的方法

    > ##### 上面介绍的线性填充缺失值的方法，其本质就是机器学习算法预测；当然还有其他机器学习算法可以用来做缺失值的计算，绝大多数场景只需要我们掌握上述缺失值填充的办法即可；一旦无法用上述办法来解决问题，那么将交由算法工程师来解决

# II. apply自定义函数

1. ## apply函数简介

    pandas 的 `apply()` 函数可以作用于 `Series` 或者整个 `DataFrame`，功能也是自动遍历整个 `Series` 或者 `DataFrame`，对每一个元素运行指定的函数。

    1. pandas 提供了很多数据处理的 API，但当提供的 API 不能满足需求的时候，需要自己编写数据处理函数, 这个时候可以使用 apply 函数

    2. apply 函数可以接收一个自定义函数，可以将 DataFrame 的行或列数据传递给自定义函数处理

    3. apply 函数类似于编写一个 for 循环，遍历行、列的每一个元素, 但比使用 for 循环效率高很多

2. ## Series的apply方法

    > ##### Series 有一个 apply 方法，该方法有一个 func 参数，当传入一个函数后，apply 方法就会把传入的函数应用于Series 的每个元素.

    1）创建一个 DataFrame 数据集，准备数据

    ```python
    df = pd.DataFrame({'a': [10, 20, 30], 'b': [20, 30, 40]})
    df
    ```

    ![image-20220121102110019](imgs/image-20220121102110019.png)

    2）创建一个自定义函数

    ```python
    def my_sq(x):
        """求平方"""
        return x ** 2
    ```

    3）使用 `apply` 方法进行数据处理

    ```python
    # 注意：series.apply(函数名)
    df['a'].apply(my_sq)
    ```

    ![image-20220121102134273](imgs/image-20220121102134273.png)

    4）series 的 `apply` 还可以接收多个参数

    ```python
    def my_add(x, n):
        """求和"""
        return x + n
    
    # 注意：args 参数必须是一个元组，这里 3 是传递给 n 的
    df['a'].apply(my_add, args=(3,))
    ```

    ![image-20220121102152642](imgs/image-20220121102152642.png)

    ```python
    # 使用 apply 时，也可直接指定参数 n 的值
    df['a'].apply(my_add, n=3)
    ```

    ![image-20220121102214571](imgs/image-20220121102214571.png)

3. ## DataFrame的apply方法

    > DataFrame 的 apply 函数用法和 Series的用法基本一致，当传入一个函数后，apply 方法就会把传入的函数应用于 DataFrame 的行或列

    1. ### 按列执行

        1）首先定义一个处理函数

        ```python
        def sub_one(x):
            """减1操作"""
            print(x)
            return x - 1
        ```

        2）针对 `df` 进行 `apply` 操作，默认按列执行

        ```python
        # 按列计算
        df.apply(sub_one)
        ```

        ![image-20220121102541865](imgs/image-20220121102541865.png)

    2. ### 按行执行

        > DataFrame 的 apply 函数有一个 `axis` 参数，默认值为 0，表示按列执行；可以设置为`axis=1` ，表示按行执行

        1）针对 `df` 进行 `apply` 操作，设置按行执行

        ```python
        # 按行计算
        df.apply(sub_one, axis=1)
        ```

        ![image-20220121102723624](imgs/image-20220121102723624.png)

    3. ### 每一个值都执行

        > DataFrame 还有一个 applymap 函数，applymap 也有一个 func 参数接收一个函数，针对 DataFrame 每个值应用 func 指定的函数进行操作，分别返回的结果构成新的 DataFrame 对象
        >
        > 注意：applymap函数是 DataFrame 独有的，Series 没有这个方法

        ```python
        # sub_one 应用于 df 中的每个元素
        df.applymap(sub_one)
        ```

        ![image-20220121102748409](imgs/image-20220121102748409.png)

4. ## apply使用案例

    > 接下来我们通过一个数据集 `titanic.csv`，应用 apply 函数计算缺失值的占比以及非空值占比

    ### 4.1 加载数据初步查看缺失情况

    1）加载`titanic.csv`数据集，通过`df.info()`函数来查看数据集基本信息，从中发现缺失值

    ```python
    titanic = pd.read_csv('./data/titanic.csv')
    titanic.info()
    ```

    ![img](../../../../../../../images/chapter04-08.png)

    ### 4.2 完成自定义函数

    通过观察发现有 4 列数据存在缺失值，age 和 deck 两列缺失值较多；此时我们就来完成几个自定义函数，分别来计算：

    - 缺失值总数
    - 缺失值占比
    - 非缺失值占比

    1）缺失值数目

    ```python
    def count_missing(vec):
        """计算缺失值的个数"""
        return vec.isnull().sum()
    ```

    2）缺失值占比

    ```python
    def prop_missing(vec):
        """计算缺失值的比例"""
        return count_missing(vec) / vec.size
    ```

    3）非缺失值占比

    ```python
    def prop_complete(vec):
        """计算非缺失值的比例"""
        return 1 - prop_missing(vec)
    ```

    ### 4.3 计算每一列缺失值及非空值的占比

    1）计算数据集中每列的缺失值

    ```python
    titanic.apply(count_missing)
    ```

    ![image-20220121103405474](imgs/image-20220121103405474.png)

    2）计算数据集中每列的缺失值比例

    ```python
    titanic.apply(prop_missing)
    ```

    ![image-20220121103426300](imgs/image-20220121103426300.png)

    3）计算数据集中每列的非缺失值比例

    ```python
    titanic.apply(prop_complete)
    ```

    ![image-20220121103450496](imgs/image-20220121103450496.png)

    ### 4.4 计算每一行缺失值及非空值的占比

    1）计算数据集中每行的缺失值

    ```python
    titanic.apply(count_missing, axis=1)
    ```

    ![image-20220121103610704](imgs/image-20220121103610704.png)

    2）计算数据集中每行的缺失值比例

    ```python
    titanic.apply(prop_missing, axis=1)
    ```

    ![image-20220121103630383](imgs/image-20220121103630383.png)

    3）计算数据集中每行的非缺失值比例

    ```python
    titanic.apply(prop_complete, axis=1)
    ```

    ![image-20220121103648125](imgs/image-20220121103648125.png)

    ### 4.5 按缺失值数量分别统计有多少行

    ```python
    titanic.apply(count_missing, axis=1).value_counts()
    ```

    ![image-20220121103731940](imgs/image-20220121103731940.png)

# III. 数据去重操作

1. ## Series的去重操作

    **Series 去重有 2 种方式**：

    | 方法                                    | 说明                                                         |
    | --------------------------------------- | ------------------------------------------------------------ |
    | `series.drop_duplicates(inplace=False)` | 删除 Series 中重复的元素并返回一个新的 Series；inplace设置True，则会直接在原 Series 数据基础上删除重复的元素 |
    | `series.unique()`                       | 将 Series 中的元素去重，返回一个去重后的 ndarray 数据        |

    1）创建一个包含重复元素的 Series 数据

    ```python
    # 创建一个 Series 数据
    new_series = pd.Series([1, 3, 2, 4, 3, 5, 1, 8, 9, 7, 8])
    new_series
    ```

    ![image-20220121104535849](imgs/image-20220121104535849.png)

    2）删除 Series 数据中重复的元素

    ```python
    # 使用 drop_duplicates 删除 Series 中重复的元素
    new_series.drop_duplicates()
    ```

    ![image-20220121104559424](imgs/image-20220121104559424.png)

    ```python
    # 使用 unique 对 Series 中的数据去重
    new_series.unique()
    ```

    ![image-20220121104627291](imgs/image-20220121104627291.png)

2. DataFrame的去重操作

    | 方法                                                         | 说明                                                         |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | `df.drop_duplicates(subset=None, keep='first', inplace=False)` | 删除 DataFrame 中重复的行并返回一个新的 DataFrame；nplace设置True，则会直接在原 DataFrame 数据基础上删除重复的行 |

    其他参数说明：

    - subset：默认为None，只删除每一列完全相同的重复行；subset可以设置列名，如：`subset=[列1, 列2, ...]`，只要指定列的值相同，则认为就是重复的行
    - keep='first'：删除重复行时默认保留重复行的第一个；设置为'last'，则保留重复行的最后一个

    1）加载 `scientists_duplicates.csv` 数据集

    ```python
    scientists = pd.read_csv('./data/scientists_duplicates.csv')
    scientists
    ```

    ![image-20220121104646836](imgs/image-20220121104646836.png)

    2）删除 DataFrame 数据中完全重复的行

    ```python
    # 注意：此处是返回了一个新的 DataFrame，原 DataFrame 的数据并没有改变
    scientists.drop_duplicates()
    ```

    ![image-20220121104733012](imgs/image-20220121104733012.png)

    3）删除 DataFrame 数据中 `Name、Born、Died` 三列相同的行

    ```python
    # 删除指定列值相同的行
    scientists.drop_duplicates(subset=['Name', 'Born', 'Died'])
    ```

    ![image-20220121104758503](imgs/image-20220121104758503.png)

# IV. 数据组合

1. ## 数据组合简介

    在动手进行数据分析工作之前，需要进行数据清理工作，数据清理的主要目标是：

    - 每个观测值成一行
    - 每个变量成一列
    - 每种观测单元构成一张表格

    数据整理好之后，可能需要多张表格组合到一起才能进行某些问题的分析

    - 比如：一张表保存公司名称，另一张表保存股票价格
    - 单个数据集也可能会分割成多个，比如时间序列数据，每个日期可能在一个单独的文件中

2. ## concat拼接数据

    1. ### 方法简介

        **基本格式**：

        | 方法                        | 说明                                                         |
        | --------------------------- | ------------------------------------------------------------ |
        | `pd.concat([df1, df2, ..])` | 多个数据集(DataFrame或Series)之间按行标签索引 或列标签索引拼接，默认是outer，可以设置为inner |

    2. ### 行拼接: 按照列标签索引对齐

        **DataFrame和DataFrame 进行拼接**：

        > 注意：行拼接时，无法对齐的列，默认在拼接后的数据中会填充为 NaN，因为默认拼接是 outer 拼接

        1）加载数据集

        ```python
        df1 = pd.read_csv('./data/concat_1.csv')
        df2 = pd.read_csv('./data/concat_2.csv')
        df3 = pd.read_csv('./data/concat_3.csv')
        ```

        ![img](../../../../../../../images/chapter03-01.png)

        ### 

        2）将 `df1`、`df2`和 `df3` 按照列标签对齐，进行行拼接

        ```
        row_concat = pd.concat([df1, df2, df3])
        row_concat
        ```

        ![img](../../../../../../../images/chapter03-02.png)

        ```python
        # 按照行位置获取数据
        row_concat.iloc[3]
        ```

        ![img](../../../../../../../images/chapter03-03.png)

        ```python
        # 按照行标签获取数据
        row_concat.loc[3]
        ```

        ![img](../../../../../../../images/chapter03-04.png)

        3）`concat` 拼接数据时忽略原有数据的行标签

        ```python
        # ignore_index=True：表示 concat 拼接时忽略索引
        pd.concat([df1, df2, df3], ignore_index=True)
        ```

        ![img](../../../../../../../images/chapter03-05.png)

        **DataFrame 和 Series 进行拼接**：

        1）创建一个 Series 数据

        ```python
        new_series = pd.Series(['n1', 'n2', 'n3', 'n4'])
        print(new_series)
        ```

        ![img](../../../../../../../images/chapter03-07.png)

        2）将 `df1` 和 `new_series` 按照列标签对齐，进行行拼接

        ```
        pd.concat([df1, new_series])
        ```

        ![img](../../../../../../../images/chapter03-08.png)

    3. ### 列拼接: 按照行标签索引对齐

        > 注意：列拼接时，无法对齐的行，默认在拼接后的数据中会填充为 NaN，因为默认拼接是 outer 拼接

        **DataFrame和DataFrame 进行拼接**：

        1）将 `df1`、`df2`和 `df3` 按照行标签对齐，进行列拼接

        ```python
        pd.concat([df1, df2, df3], axis=1)
        ```

        ![img](../../../../../../../images/chapter03-06.png)

        **DataFrame 和 Series 进行拼接**：

        1）创建一个 Series 数据

        ```python
        new_series = pd.Series(['n1', 'n2', 'n3', 'n4'])
        print(new_series)
        ```

        ![img](../../../../../../../images/chapter03-07.png)

        2）`df1` 和 `new_series` 按照行标签对齐，进行列拼接

        ```python
        pd.concat([df1, new_series], axis=1)
        ```

        ![img](../../../../../../../images/chapter03-09.png)

    4. ### join参数的设置

        concat 方法的 join参数：

        - 默认为 outer：无法对齐的行/列，默认在拼接后的数据中会填充为 NaN，因为默认拼接是 outer 拼接
        - 设置为 inner：只有能够对齐的行/列，才会出现在拼接的结果中

        1）修改 `df1` 和 `df3` 的 columns 列标签

        修改之前：

        ![img](../../../../../../../images/chapter03-10.png)

        ```python
        df1.columns = ['A', 'B', 'C', 'D']
        df3.columns = ['A', 'C', 'F', 'H']
        ```

        ![img](../../../../../../../images/chapter03-11.png)

        2）将 `df1` 和 `df3` 按列标签对齐，进行行拼接，默认 outer

        ```python
        pd.concat([df1, df3])
        ```

        ![img](../../../../../../../images/chapter03-12.png)

        3）将 `df1` 和 `df3` 按列标签对齐，进行行拼接，设置 `join='inner'`

        ```python
        pd.concat([df1, df3], join='inner')
        ```

        ![img](../../../../../../../images/chapter03-13.png)

3. ## merge关联数据

    1. ### 方法简介

        

    2. ### merge示例

        

4. ## join关联数据

    1. ### 方法简介

        

    2. ### join示例

        

# V. 数据分组

```python
# 标量: 一个单独的数值, 如1,2,3...
# 向量: 一个一维数组, 如[1,2,3]
# 矩阵, 一个二维数组, 如[[1,2,3],[4,5,6]]
# 张量: 更高维度的数组
# 默认向量和标量不能比较
```

```python
import numpy as np

# 函数向量化
@np.vectorize	# 向量化装饰器
def add_vec_2(x, y):
    if x != 0:
        return x + y
```











