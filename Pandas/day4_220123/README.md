# I. 数据分组

1. ## 数据划分区间(cut函数)

    可以使用 pandas 中的 cut 函数将传递的数据划分成几个区间。

    | 方式                                           | 说明                                                         |
    | ---------------------------------------------- | ------------------------------------------------------------ |
    | `pandas.cut(x, bins, right=True, labels=None)` | 将 x 中的每个数据划分到指定的区间： * x：待划分区间的数据，一维数据，可以是Series * bins：list，直接划分时每个区间的边界值 * right：划分区间时，默认左开右闭，设置为False，则表示左闭右开 * labels：可选项，指定每个区间的显示 label |

    1）加载 tips.csv 数据

    ```python
    tips = pd.read_csv('./data/tips.csv')
    tips
    ```

    ![image-20220123093711911](imgs/image-20220123093711911.png)

    ```python
    # 查看数据列的信息
    tips.info()
    ```

    ![image-20220123093820267](imgs/image-20220123093820267.png)

    ```python
    # 查看数据中 total_bill 列的统计值
    tips['total_bill'].describe()
    ```

    ![image-20220123093837306](imgs/image-20220123093837306.png)

    2）将 tips 数据按照 total_bill 列的值划分为 3 个区间：`0-10、10-30、30-60`

    ```python
    # 指定划分区间的边界值
    bins = [0, 10, 30, 60]
    pd.cut(tips['total_bill'], bins)
    ```

    ![image-20220123093855064](imgs/image-20220123093855064.png)

    ```python
    # right=False：设置划分区间时左闭右开
    pd.cut(tips['total_bill'], bins, right=False)
    ```

    ![image-20220123093917574](imgs/image-20220123093917574.png)

    ```python
    # 设置划分区间的 labels
    labels = ['<10', '<30', '<60']
    pd.cut(tips['total_bill'], bins, right=False, labels=labels)
    ```

    ![image-20220123093938855](imgs/image-20220123093938855.png)

    ```python
    # 在 tips 数据中增加消费金额区间这一列
    tips['bill_group'] = pd.cut(tips['total_bill'], bins, right=False, labels=labels)
    tips
    ```

    ![image-20220123093956282](imgs/image-20220123093956282.png)

    3）按照消费区间列统计每组消费数据的数目

    ```python
    # 按照消费区间列统计每组消费数据的数目
    tips.groupby('bill_group').size()
    ```

    ![image-20220123094011485](imgs/image-20220123094011485.png)

# II. 数据整理

1. ## melt/pivot整理数据

    1. ### melt函数功能演示

        > melt 函数可以将一个宽数据集变为长数据集

        1）加载美国收入与宗教信仰数据 `pew.csv`

        ```python
        pew = pd.read_csv('./data/pew.csv')
        pew.head()
        ```

        ![image-20220123103508905](imgs/image-20220123103508905.png)

        2）先执行下面的代码，将输出的结果和上面的输出结果进行对比

        ```python
        pew_long = pd.melt(pew, id_vars=['religion'])
        pew_long
        ```

        ![image-20220123103559350](imgs/image-20220123103559350.png)

        结果说明：

        1）我们发现，基于religion列，把原来的df拉长了，我们称原来的df为`宽数据集`，拉长之后的df称之为`长数据集`

        - 对于展示数据而言，下图中`pew`返回的这种"宽"数据没有任何问题，如第一行数据，展示了Agnostic（不可知论（者））所有的收入分布情况
        - 从数据分析的角度，有时候我们需要把数据由"宽"数据，转换成"长"数据，就如同下图中`pew_long`返回的数据
        - 在pandas中我们就可以使用`df.melt()`函数，通过各种参数，来达成宽数据集转换为长数据集的效果

        ![img](imgs/chapter03-57.png)

    2. ### melt函数的参数

        melt 是溶解/分解的意思， 即拆分数据；melt既是模块函数也是DataFrame类的实例方法，也就是说既可以用`pd.melt(...)`, 也可使用`dataframe.melt(...)`的形式进行调用。

        | 参数       | 类型               | 说明                                                         |
        | ---------- | ------------------ | ------------------------------------------------------------ |
        | frame      | dataframe          | 必要参数，被 melt 的数据集名称在 pd.melt() 中使用，比如上例中`pd.melt(pew, id_vars='religion')`的`pew` |
        | id_vars    | tuple/list/ndarray | 可选项，**不需要被转换的列名**，在转换后作为标识符列（不是索引列），比如上例`pd.melt(pew, id_vars='religion')` |
        | value_vars | tuple/list/ndarray | 可选项，**需要被转换的现有列**，如果未指明value_vars，除id_vars指定的其他列都将被转换 |
        | var_name   | string             | 自定义设置variable列的列名                                   |
        | value_name | string             | 自定义设置value列的列名                                      |

        1）比如，可以更改 melt 之后的数据的列名

        ```python
        pew_long = pd.melt(pew, id_vars=['religion'], var_name='income', value_name='count')
        pew_long.head()
        ```

        ![image-20220123104013109](imgs/image-20220123104013109.png)

    3. ### pivot函数功能演示

        pivot 函数是 melt 函数的逆运算，既是模块函数也是DataFrame类的实例方法，也就是说既可以用`pd.pviot(...)`, 也可使用`dataframe.pivot(...)`的形式进行调用。

        | 参数    | 类型              | 说明                                                         |
        | ------- | ----------------- | ------------------------------------------------------------ |
        | data    | dataframe         | 必要参数，被 pivot 的数据集名称在 pd.pivot() 中使用          |
        | index   | str/a list of str | 指定列标签，数据转换后，该列的数据会作为结果中的行标签       |
        | columns | str/a list of str | 指定列标签，数据转换后，该列的数据会作为结果中的列标签       |
        | values  | str               | 指定列标签，数据转换后，该列的值用于组成新 DataFrame 的元素值 |

        ```python
        pew_wide = pew_long.pivot(index='religion', columns='income', values='count')
        pew_wide
        ```

        ![image-20220123104044595](imgs/image-20220123104044595.png)

        ```python
        # 重置行标签
        pew_wide.reset_index()
        ```

        ![image-20220123104109137](imgs/image-20220123104109137.png)

2. ## stack/unstack整理数据

    1. ### stack和unstack简介

        pandas进行数据重排时，经常用到 `stack` 和 `unstack` 两个函数。`stack` 的意思是堆叠、堆积，`unstack` 即"不要堆叠"

        常见的数据的层次化结构有两种，一种是表格，一种是"花括号"，即下面这样的两种形式：

        ![img](imgs/chapter03-69.png)

        stack函数会将数据从`表格结构` 变成 `花括号结构`（返回的是series类型），即将其列索引变成行索引，反之，unstack函数将数据从 `花括号结构`变成 `表格结构`，即要将其中一层的行索引变成列索引。

    2. ### stack功能演示

        1）加载 `state_fruit.csv` 数据集

        ```python
        state_fruit = pd.read_csv('./data/state_fruit.csv', index_col=0)
        state_fruit
        ```

        ![image-20220123104256248](imgs/image-20220123104256248.png)

        2）使用 `stack` 函数整理数据，查看效果：

        ```python
        state_fruit_series = state_fruit.stack()
        state_fruit_series
        ```

        ![image-20220123104350377](imgs/image-20220123104350377.png)

        3）此时可以使用 `reset_index()`，将结果变为 DataFrame

        ```python
        state_fruit_tidy = state_fruit_series.reset_index()
        state_fruit_tidy
        ```

        ![image-20220123104411226](imgs/image-20220123104411226.png)

        4）给 columns 重新命名

        ```python
        state_fruit_tidy.columns = ['state', 'fruit', 'weight']
        state_fruit_tidy
        ```

        ![image-20220123104436568](imgs/image-20220123104436568.png)

    3. ### unstack功能演示

        1）使用 `unstack` 函数

        ```python
        state_fruit_series.unstack()
        ```

        ![image-20220123104457901](imgs/image-20220123104457901.png)

3. ## wide_to_long整理数据

    > wide_to_long函数的作用是将列名起始部分相同的列进行拆解，使宽数据变换为长数据

    **需求**：

    - 加载`data/movie.csv`数据，统计每部电影的每个主演的被点赞数，返回新的df
    - 新df 的列名为 `movie_title`、`actor_num`、`actor`、`actor_facebook_likes`：分别代表电影名称、演员编号、演员姓名、该演员被点赞数

    1. ### 初步数据整理

        1）加载 `movie.csv` 数据

        ```python
        movies = pd.read_csv('./data/movie.csv')
        movies.head()
        ```

        ![img](../../../../../../../images/chapter03-77.png)

        2）去除无关字段

        ```python
        movie_actors = movies[['movie_title', 'actor_1_name', 'actor_2_name', 'actor_3_name', 
                               'actor_1_facebook_likes', 'actor_2_facebook_likes', 'actor_3_facebook_likes']]
        movie_actors.head()
        ```

        ![img](../../../../../../../images/chapter03-78.png)

        3）整理 columns 列名

        ```python
        movie_actors.columns = ['movie_title', 'actor_name_1', 'actor_name_2', 'actor_name_3',
                               'actor_facebook_likes_1', 'actor_facebook_likes_2', 'actor_facebook_likes_3']
        movie_actors.head()
        ```

        ![img](../../../../../../../images/chapter03-79.png)

    2. ### wide_to_long函数的具体使用

        1）先执行下面的代码，观看输出结果：

        ```python
        movie_actors_tidy = pd.wide_to_long(movie_actors, 
                                            stubnames=['actor_name', 'actor_facebook_likes'],
                                            i=['movie_title'],
                                            j='actor_num',
                                            sep='_').reset_index()
        movie_actors_tidy.head()
        ```

        ![img](../../../../../../../images/chapter03-80.png)

        ```python
        movie_actors_tidy[movie_actors_tidy.movie_title=='Avatar']
        ```

        ![img](../../../../../../../images/chapter03-81.png)

# III. 数据透视表

1. ## pandas透视表概述

    数据透视表（Pivot Table）是一种交互式的表，可以进行某些计算，如求和与计数等。所进行的计算与数据跟数据透视表中的排列有关。

    > 之所以称为数据透视表，是因为可以动态地改变它们的版面布置，以便按照不同方式分析数据，也可以重新安排行号、列标和页字段。每一次改变版面布置时，数据透视表会立即按照新的布置重新计算数据。另外，如果原始数据发生更改，则可以更新数据透视表。
    >
    > 注意：透视表的本质是分组聚合操作。

    在使用 Excel 做数据分析时，透视表是很常用的功能，pandas 也提供了透视表功能，对应的 API 为 `pivot_table`

    **pandas pivot_table 函数介绍**：

    | 方法                      | 说明           |
    | ------------------------- | -------------- |
    | `pd.pivot_table(df, ...)` | 进行透视表操作 |
    | `df.pivot_table(...)`     | 进行透视表操作 |

    > pivot_table 最重要的四个参数 values、index、columns、aggfunc，下面通过案例介绍 pivot_tabe 的使用

    **透视表示例**：

    1）加载优衣库门店销售数据 `uniqlo.csv`

    ```python
    # 加载优衣库门店销售数据
    uniqlo = pd.read_csv('./data/uniqlo.csv')
    uniqlo.head()
    ```

    ![img](../../../../../../../images/chapter04-207.png)

    ```python
    # 查看加载数据列的结束
    uniqlo.info()
    ```

    ![img](../../../../../../../images/chapter04-208.png)

    2）示例1：统计不同种类产品在不同城市的销量

    **分组聚合实现**：

    ```python
    # 分组聚合操作：统计不同种类产品在不同城市的销量
    result = uniqlo.groupby(['product', 'city'])['quant'].sum()
    result
    ```

    ![img](../../../../../../../images/chapter04-209.png)

    ```python
    # unstack 操作
    result = result.unstack()
    result
    ```

    ![img](../../../../../../../images/chapter04-210.png)

    **pivot_table 透视表操作**：

    ```python
    # 透视表操作
    uniqlo.pivot_table(index='product', 
                       columns='city', 
                       values='quant', 
                       aggfunc='sum')
    ```

    ![img](../../../../../../../images/chapter04-211.png)

    2）示例2：统计不同城市、不同渠道，不同种类产品的销售额

    **分组聚合操作**：

    ```python
    result = uniqlo.groupby(['city', 'channel', 'product'])['revenue'].sum()
    result
    ```

    ![img](../../../../../../../images/chapter04-212.png)

    ```python
    # unstack 操作
    result = result.unstack()
    result
    ```

    ![img](../../../../../../../images/chapter04-213.png)

    **pivot_table 透视表操作**：

    ```python
    # 透视表操作
    uniqlo.pivot_table(index=['city', 'channel'], 
                       columns='product', 
                       values='revenue', 
                       aggfunc='sum')
    ```

    ![img](../../../../../../../images/chapter04-214.png)

    3）示例3：统计不同种类产品的销售额

    **分组聚合操作**：

    ```python
    # 分组聚合操作
    uniqlo.groupby('product')[['revenue']].sum()
    ```

    ![img](../../../../../../../images/chapter04-215.png)

    **pivot_table 透视表操作**：

    ```python
    # 透视表操作
    uniqlo.pivot_table(index='product', values='revenue', aggfunc='sum')
    ```

    ![img](../../../../../../../images/chapter04-216.png)

    4）示例4：统计不同城市销售的产品种类数和产品的总销售额

    **分组聚合实现**：

    ```python
    # 分组聚合操作
    uniqlo.groupby('city').agg({'product': 'nunique', 'revenue': 'sum'})
    ```

    ![img](../../../../../../../images/chapter04-217.png)

    **pivot_table 透视表操作**：

    ```python
    uniqlo.pivot_table(index='city', values=['product', 'revenue'], 
                       aggfunc={'product': 'nunique', 'revenue': 'sum'})
    ```

    ![img](../../../../../../../images/chapter04-218.png)

# IV. 数据导入和导出

1. ## CSV文件

    | 方法                                       | 说明                                                         |
    | ------------------------------------------ | ------------------------------------------------------------ |
    | `pd.read_csv(filepath, sep=',')`           | 将 csv 数据加载成 DataFrame 数据 * sep参数用来指定加载时列的分割符，默认为逗号 |
    | `df.to_csv(filepath, sep=',', index=True)` | 将 DataFrame 数据导出成 csv 数据 * sep参数用来指定导出时列的分割符，默认为逗号； * index参数用来设置导出数据时是否将行标签也导出，默认为True |

    > csv 是数据协作和共享的首选格式，因为可以使用excel打开

    ```python
    # 加载 csv 数据
    scientists = pd.read_csv('./data/scientists.csv')
    # 加载 tsv 数据
    china = pd.read_csv('./data/china.tsv', sep='\t')
    
    # 导出成 tsv 文件，设置分隔符必须为\t
    scientists.to_csv('./data/scientists_df.tsv', sep='\t')
    # 导出时不在 csv 文件中存入行标签
    scientists.to_csv('./data/scientists_df_noindex.csv', index=False)
    ```

2. ## Excel文件

    > 注意：根据anaconda的版本不同，pandas读写excel有时需要额外安装`xlrd`、`openpyxl`两个包
    >
    > ```shell
    > pip install -i https://pypi.tuna.tsinghua.edu.cn/simple xlrd
    > pip install -i https://pypi.tuna.tsinghua.edu.cn/simple openpyxl
    > ```

    | 方法                                                     | 说明                                                         |
    | -------------------------------------------------------- | ------------------------------------------------------------ |
    | `pd.read_execl(filepath, sheet_name=0, engine=None)`     | 将 excel 数据加载成 DataFrame 数据 * sheet_name参数用来指定加载 excel 中的哪些 sheet 数据，默认加载 excel 中的第一个sheet * engine参数用来指定加载 excel 数据的引擎，加载 xls 数据时，默认使用 xlrd 引擎；加载 xlsx 数据时，需要将 engine 设置为 'openpyxl' |
    | `df.to_excel(filepath, sheet_name='Sheet1', index=True)` | 将 DataFrame 数据导出成 excel 数据 * sheet_name参数用来设置导出到 excel 时的 sheet 名称，默认为 Sheet1 * index参数用来设置导出数据时是否将行标签也导出，默认为True |

    ```python
    # 加载 excel 数据
    pd.read_excel('./data/scientists_df.xlsx', engine='openpyxl')
    
    # 导出成 excel 数据
    scientists.to_excel('./data/scientists_df_noindex.xlsx', 
                        sheet_name='scientists', index=False)
    ```

3. ## SQL表数据

    以MySQL数据库为例，**此时默认你已经在本地安装好了MySQL数据库**。如果想利用pandas和MySQL数据库进行交互，需要先安装与数据库交互所需要的python包

    ```bash
    pip install pymysql==1.0.2
    pip install sqlalchemy==1.3.20
    ```

    **将 DataFrame 写入数据库**：

    1）加载数据集

    ```python
    scientists = pd.read_csv('./data/scientists.csv')
    scientists
    ```

    ![img](../../../../../../../images/chapter06-01.png)

    2）将 DataFrame 数据导出到数据库

    ```python
    # 导入 sqlalchemy 的数据库引擎
    from sqlalchemy import create_engine
    
    # 创建数据库引擎，传入uri规则的字符串
    engine = create_engine('mysql+pymysql://root:chuanzhi@127.0.0.1:3306/python?charset=utf8')
    # mysql+pymysql://root:chuanzhi@127.0.0.1:3306/python?charset=utf8
    # mysql：表示数据库类型
    # pymysql：表示python操作数据库的包
    # root:mysql：表示数据库的账号和密码，用冒号连接
    # 127.0.0.1:3306/python：表示数据库的ip和端口，以及名叫python的数据库(注意：数据库需要自己创建)
    # charset=utf8：规定编码格式
    
    # 将 DataFrame 数据导出到数据库
    scientists.to_sql('tb_scientists', engine, index=False, if_exists='append')
    # 第一个参数为数据表的名称
    # 第二个参数engine为数据库交互引擎
    # index=False：表示不导出行标签
    # if_exists='append'：表示如果表存在就追加数据，表不存在就创建表并写入
    ```

    ![img](../../../../../../../images/chapter06-02.png)

    **将 SQL 表数据加载成 DataFrame 数据**：

    1）加载 tb_scientists 表的数据

    ```python
    # 加载表数据
    pd.read_sql('tb_scientists', engine)
    ```

    ![img](../../../../../../../images/chapter06-03.png)

    2）加载表数据时指定 SQL 语句

    ```python
    # 加载表数据
    pd.read_sql('select Name, Age from tb_scientists', engine)
    ```

    ![img](../../../../../../../images/chapter06-04.png)

4. ## Pickle文件

    **导出到pickle文件**：

    - 调用to_pickle方法将以二进制格式保存数据
    - 如要保存的对象是计算的中间结果，或者保存的对象以后会在Python中复用，可把对象保存为.pickle文件
    - 如果保存成pickle文件，只能在python中使用
    - 文件的扩展名可以是.p、.pkl、.pickle

    ```python
    scientists = pd.read_csv('data/scientists.csv')
    scientists.to_pickle('./data/scientists_df.pickle')
    ```

    **读取pickle文件**：

    可以使用pd.read_pickle函数读取.pickle文件中的数据

    ```python
    scientists_df = pd.read_pickle('./data/scientists_df.pickle')
    scientists_df
    ```

5. ## feather格式文件(了解)

    - feather是一种文件格式，用于存储二进制对象
    - feather对象也可以加载到R语言中使用
    - feather格式的主要优点是在Python和R语言之间的读写速度要比CSV文件快
    - feather数据格式通常只用中间数据格式，用于Python和R之间传递数据
    - 一般不用做保存最终数据

6. ## 数据导出的其他方法

    其他导出方法清单：

    | 导出方法     | 说明                             |
    | ------------ | -------------------------------- |
    | to_clipboard | 把数据保存到系统剪贴板，方便粘贴 |
    | to_dict      | 把数据转换成Python字典           |
    | to_hdf       | 把数据保存为HDF格式              |
    | to_html      | 把数据转换成HTML                 |
    | to_json      | 把数据转换成JSON字符串           |
    | to_sql       | 把数据保存到SQL数据库            |

# V. Python数据可视化

1. ## 数据可视化简介

    1. ### 数据可视化概念

        > 数据可视化是指直观展现数据，它是数据处理过程的一部分。

        把数值绘制出来更方便比较。借助数据可视化，能更直观地理解数据，这是直接查看数据表做不到的

        数据可视化有助于揭示数据中隐藏的模式，数据分析时可以利用这些模式选择模型

    2. ### 数据可视化常用库

        1）**Matplotlib（功能强大，代码相对复杂）**

        - Matplotlib是Python编程语言的开源绘图库。它是Python可视化软件包中最突出的，使用最广泛的绘图工具。
        - Matplotlib在执行各种任务方面非常高效。可以将可视化文件导出为所有常见格式（PDF，SVG，JPG，PNG，BMP和GIF）。
        - Matplotlib可以创建流行的可视化类型-折线图，散点图，直方图，条形图，误差图，饼图，箱形图以及更多其他类型的图，还支持3D绘图。
        - 许多Python库都是基于Matplotlib构建的，Pandas和Seaborn是在Matplotlib上构建的
        - Matplotlib项目由John Hunter于2002年启动。Matplotlib最初是在神经生物学的博士后研究期间开始可视化癫痫患者的脑电图（ECoG）数据。

        2）**Pandas （使用简单，功能稍弱）**

        - Pandas的绘图功能基于Matplotlib，是对Matplotlib的二次封装
        - Matplotlib绘图时，代码相对复杂，使用Pandas绘制基本图表相对比较简单，更加方便
        - Pandas中常用的数据结构 series 和 dataframe 都有plot()方法，用于绘图

        3）**Seaborn （推荐使用）**

        - Seaborn是基于Matplotlib的图形可视化python开源库
        - Seaborn是在Matplotlib的基础上进行了更高级的API封装，从而使得作图更加容易
        - Seaborn的API设计偏向探索和理解数据

        4）**echarts 和 pyecharts （追求可视化效果，推荐使用）**

        - ECharts，是百度开源，使用 JavaScript 实现的开源可视化库，可以流畅的运行在 PC 和移动设备上，兼容当前绝大部分浏览器（IE8/9/10/11，Chrome，Firefox，Safari等），底层依赖矢量图形库 [ZRender](https://github.com/ecomfe/zrender)，提供直观，交互丰富，可高度个性化定制的数据可视化图表
        - pyecharts 是一个用Python生成 Echarts 图表的类库。

    3. ### 常见统计图形简介

        统计图能够简洁、直观地对主要的数据信息进行呈现，反映事物内在的规律和关联。当然难免会丢失数据的细节，鱼与熊掌不可兼得。

        根据统计图呈现变量的数量将其分为单变量图、双变量图、多变量图，然后再根据测试尺度进行细分。变量主要分为3类：无序、有序和连续型变量。

        > 单变量其实就是通常我们所说的数据集中的一列数据。

        **单变量图**：观察一个变量的数据分布情况。

        - 连续型变量：直方图、箱线图
            - 举例：查看用户消费金额的分布情况
        - 分类变量：条形图(柱状图)、饼图
            - 举例：按周几统计每天的消费数量

        **双变量图**：观察两个变量(自变量和因变量)之间的联系。

        - 因变量为连续型
            - 自变量为无序分类变量：简单条形图
                - 举例：按 day(周几) 统计每餐消费的平均值并进行可视化
            - 自变量为有序分类变量：折线图、条形图
                - 举例：按 day(周几) 统计每餐消费的平均值并进行可视化
            - 自变量为连续性变量：散点图、蜂巢图
                - 举例：查看消费数据中消费tip随着消费金额total_bill的变化情况
        - 因变量为分类型
            - 自变量为分类型：条形图
            - 连续变量：目前没有很好的图形可用。常见处理方式是，将自/应变量交换后用条图呈现

        **多变量图(3变量图)**：观察多个变量之间的联系

        > 此处仅介绍 3 变量图，切勿将统计图做得太复杂，不然将失去统计图 `直观明了` 的优点

        - 要表现3个变量的关联，最好是采用三维坐标的立体统计图，但由于实际上还是在平面上对三维图呈现，立体图在使用上并不方便
        - 当其中有变量为分类变量时，可以对二维图进行扩充，使二维图能够表现更多信息。例如在散点图中用点的形状或者颜色区分不同类别，其实就是呈现了两个连续变量和一个分类变量的数量关联信息。类似的还有多条折线图。

2. ## Matplotlib绘图

    1. ### Matplotlib绘图入门

        **基本概念**：

        ![img](../../../../../../../images/chapter05-86.png)

        - Figure：图或画布，画图之前首先要创建一个画布
        - Axes：坐标系，一个图上可以添加多个坐标系，在每个坐标系上都可以绘图
        - Axis：坐标轴，坐标系分为x轴和y轴，可以设置坐标轴的刻度、标题等

        **基本绘图**：

        > 使用 Matplotlib 绘图，首先需要导入 pyplot 模块，该模块包含一系列绘图函数的相关函数

        ```python
        import matplotlib.pyplot as plt
        ```

        Matplotlib提供了两种方法来作图：状态接口和面向对象

        1）状态接口

        ```python
        # 准备数据
        x = [-3, 5, 7]
        y = [10, 2, 5]
        
        
        # 绘制折线图
        plt.plot(x, y)
        
        # 设置 x 轴、y 轴刻度
        plt.xlim(-3, 8)
        plt.ylim(2, 10)
        
        # 设置 x 轴、y 轴标题
        plt.xlabel('X Axis', size=20)
        plt.ylabel('Y Axis', size=20)
        
        # 设置图形标题
        plt.title('Line Plot', size=30)
        
        # 显示图形
        plt.show()
        ```

        ![img](../../../../../../../images/chapter05-01.png)

        2）面向对象

        ```python
        # 准备数据
        x = [-3, 5, 7]
        y = [10, 2, 5]
        
        # 创建图(画布)
        fig = plt.figure(figsize=(6.4, 4.8))
        
        # 在图(画布)上添加坐标系
        axes = fig.subplots(1, 1)
        
        # 在坐标系上进行绘图
        axes.plot(x, y)
        
        # 设置坐标系 x 轴、y 轴刻度
        axes.set_xlim(-3, 8)
        axes.set_ylim(0, 10)
        
        # 设置坐标系 x 轴、y轴标题
        axes.set_xlabel('X Axis', fontsize=20)
        axes.set_ylabel('Y Axis', fontsize=20)
        
        # 设置坐标系标题
        axes.set_title('Line Plot', fontsize=30)
        
        # 显示图形
        plt.show()
        ```

        ![img](../../../../../../../images/chapter05-02.png)

    2. ### 使用Matplotlib绘制统计图

        > 本小节使用 seaborn 库的 tips 数据集，其中包含了某餐厅服务员收集的顾客付小费的相关数据

        1）加载 `tips` 数据集类

        ```python
        tips = sns.load_dataset('tips')
        tips.head()
        ```

        ![img](../../../../../../../)

        1. #### 单变量绘图

            **直方图**

            1）查看客户消费金额 total_bill 的分布情况

            ```python
            # 创建图和坐标系
            fig = plt.figure()
            axes = fig.subplots(1, 1)
            # bins=10：表示把数据分成几组，即将数据划分按顺序为几个区间
            axes.hist(tips['total_bill'], bins=10)
            
            # 显示图形
            plt.show()
            ```

            > 注意：直方图的柱子宽度表示该组数据的区间。

            ![img](../../../../../../../images/chapter05-87.png)

            **箱线图**：

            ```python
            fig = plt.figure()
            axes = fig.subplots(1, 1)
            # 箱线图
            axes.boxplot(tips['total_bill'])
            
            # 显示图形
            plt.show()
            ```

            ![img](../../../../../../../images/chapter05-88.png)

            箱线图补充：

            ![img](../../../../../../../images/chapter05-89.png)

            - 箱子的中间有一条线，代表了数据的中位数
            - 箱子的上下底，分别是数据的上四分位数（Q3）和下四分位数（Q1）
            - 四分位距（interquartile range，简称IQR）：IQR = Q3 - Q1
            - 上边缘：Q3 + 1.5*IQR，下边缘：Q1 - 1.5*IQR
            - 箱体包含了50%的数据。因此，**箱子的高度在一定程度上反映了数据的波动程度**
            - 有时候箱子外部会有一些点，可以理解为数据中的**"异常值"**

            **条形图**：

            1）按照 day(周几) 统计每天的消费数量

            ```bash
            # 按照 day(周几) 统计每天的消费数量
            result = tips['day'].value_counts()
            
            fig = plt.figure()
            axes = fig.subplots(1, 1)
            # axes.bar(x, y)：指定x轴和y轴数据
            axes.bar(result.index, result.values)
            ```

            ![img](../../../../../../../images/chapter05-90.png)

            **饼图**：

            ```python
            fig = plt.figure()
            axes = fig.subplots(1, 1)
            # pie：饼图
            axes.pie(day_counts.values, labels=day_counts.index, autopct='%.1f%%')
            ```

            ![img](../../../../../../../images/chapter05-91.png)

        2. #### 双变量绘图

            **散点图**

            1）查看消费数据中消费tip随着消费金额total_bill的变化情况

            ```python
            fig = plt.figure()
            axes = fig.subplots(1, 1)
            # axes.scatter(x, y)：散点图，指定x轴和y轴的数据
            axes.scatter(tips['total_bill'], tips['tip'])
            ```

            ![img](../../../../../../../images/chapter05-92.png)

            **蜂巢图**：

            ```python
            fig = plt.figure()
            axes = fig.subplots(1, 1)
            
            # axes.hexbin(x, y)：蜂巢图，指定x轴和y轴的数据
            # gridsize=10：指定x轴方向上每一横行分几个格子
            hb = axes.hexbin(tips['total_bill'], tips['tip'], gridsize=10)
            
            # 添加图形右侧的颜色提示栏
            fig.colorbar(hb, ax=axes)
            ```

            ![img](../../../../../../../images/chapter05-95.png)

            **条形图**：

            1）按 day(周几) 统计每餐消费的平均值并进行可视化

            ```python
            # 按 day(周几) 统计每餐消费的平均值
            result = tips.groupby('day').total_bill.mean()
            
            fig = plt.figure()
            axes = fig.subplots(1, 1)
            # axes.bar(x, y)：条形图，指定x轴和y轴的数据
            axes.bar(result.index, result.values)
            ```

            ![img](../../../../../../../images/chapter05-93.png)

            **折线图**：

            ```python
            # 创建一个有序的分类数据类型
            from pandas.api.types import CategoricalDtype
            cat = CategoricalDtype(categories=['Thur', 'Fri', 'Sat', 'Sun'], ordered=True)
            # 将 day 这列数据转换为有序分类数据类型
            tips['day'] = tips['day'].astype(cat)
            
            # 按 day(周几) 统计每餐消费的平均值
            result = tips.groupby('day').total_bill.mean()
            
            
            fig = plt.figure()
            axes = fig.subplots(1, 1)
            # axes.plot(x, y)：折线图，指定x轴和y轴的数据
            axes.plot(result.index, result.values)
            ```

            ![img](../../../../../../../images/chapter05-94.png)

        3. #### 多变量绘图

            **散点图**：

            1）查看不同性别的消费客户中，消费tip随着消费金额total_bill的变化情况

            ```python
            def recode_sex(sex):
                if sex == 'Female':
                    return 0
                else:
                    return 1
            
            tips['sex_color'] = tips['sex'].apply(recode_sex)
            tips
            ```

            ![img](../../../../../../../images/chapter05-14.png)

            ```python
            # 创建图和坐标系
            fig = plt.figure()
            axes = fig.subplots(1, 1)
            
            # 散点图
            # c：设置根据哪列数据将散点图分类，使用不同的颜色表示
            scatter = axes.scatter(tips['total_bill'], tips['tip'], 
                                   c=tips['sex_color'], s=tips['size'] * 10, alpha=0.5)
            
            # 添加图例
            legend = axes.legend(*scatter.legend_elements(), title='gender')
            axes.add_artist(legend)
            
            # 显示图形
            plt.show()
            ```

            ![img](../../../../../../../images/chapter05-96.png)