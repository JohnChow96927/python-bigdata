# I. pandas绘图

1. ## pandas数据可视化简介

    > pandas库是Python数据分析的核心库

    1）它不仅可以加载和转换数据，还可以做更多的事情：它还可以可视化

    2）DataFrame 对象或 Series 对象直接调用`plot()`函数即可绘图

    > plot 默认为折线图，折线图也是最常用和最基础的可视化图形，足以满足我们日常 80% 的需求：
    >
    > ```
    > df.plot()
    > s.plot()
    > ```

    我们可以在 plot 后增加调用来使用其他的图形，当然这些图形对数据结构也有自己的要求，教程后边会逐个介绍：

    ```python
    df.plot.line() # 折线图的全写方式
    df.plot.bar() # 条形图(柱状图)
    df.plot.barh() # 条形图(横向柱状图)
    df.plot.hist() # 直方图
    df.plot.box() # 箱形图
    df.plot.kde() # 核密度估计图
    df.plot.density() # 同 df.plot.kde()
    df.plot.area() # 面积图
    df.plot.pie() # 饼图
    df.plot.scatter() # 散点图
    df.plot.hexbin() # 六边形箱体图，或简称六边形图
    ```

    Pandas 处理的结果可视化，建议直接用 Seaborn 绘图，具体 Pandas 的可视化可以参考如下文档

# II. seaborn绘图

1. ## seaborn简介

    

2. ## seaborn绘图

    

# III. pyecharts绘图

1. ## echarts和pyecharts简介

    

2. ## pyecharts绘图案例

    

# II. RFM用户分群分析

1. 会员价值度模型介绍

    

2. RFM计算案例

    