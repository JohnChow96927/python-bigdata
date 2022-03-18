[TOC]



### 1. 数据整理

#### 练习1：melt/pivot 函数使用

> 注意：使用 work1.csv 数据集

![img](images/1.png)

**需求1**：使用 melt 方法将 work1.csv 的数据转换为如下长数据

![img](images/2.png)

```python
import pandas as pd
df = pd.read_csv('./data/work1.csv')
df_long = df.melt(id_vars=['day'], var_name='city', value_name='count')
```

**需求2**：使用 pivot 方法将需求1的结果再转换为如下宽数据

![img](images/3.png)

```python
df_wide = df_long.pivot(index='day', columns='city', values='count')
df_wide.reset_index()
```

#### 练习2：stack/unstack 函数的使用

> 注意：使用 work1.csv 数据集

![img](images/4.png)

**需求1**：使用 stack 实现练习1中需求1的效果如下：

![img](images/5.png)

```python
day_series = df.set_index('day').stack()
df_long = day_series.reset_index()
df_long.columns = ['day', 'city', 'count']
```

#### 练习3：wide_to_long 函数的使用

> 注意：使用 work2.csv 数据集

![img](images/6.png)

**需求**：使用 wide_to_long 将 work2.csv 数据转换为如下长数据

![img](images/7.png)

```python
df = pd.read_csv('./data/work2.csv')
new_df = pd.wide_to_long(df, stubnames=['ht'], i=['famid', 'birth'], j='age', sep='_')
new_df.reset_index()
```

### 2. 数据透视表

> 注意：使用 uniqlo.csv 数据集

#### 练习1：统计不同销售渠道中每个种类产品的销量(分别使用分组聚合和透视表实现)

![img](images/8.png)

**分组聚合实现**：

```python
uniqlo = pd.read_csv('./data/uniqlo.csv')
# 分组聚合实现
result = uniqlo.groupby(['channel', 'product']).quant.sum()
result.unstack()
```

**pivot_table 透视表实现**：

```python
# 透视表实现
uniqlo.pivot_table(index='channel', columns='product', values='quant', aggfunc='sum')
```

#### 练习2：统计不同销售渠道中男性和女性客户的总销售额(分别使用分组聚合和透视表实现)

![img](images/9.png)

**分组聚合实现**：

```python
# 分组聚合
result = uniqlo.groupby(['channel', 'gender_group']).revenue.sum()
result.unstack()
```

**pivot_table 透视表实现**：

```python
# 透视表实现
uniqlo.pivot_table(index='channel', columns='gender_group', values='revenue', aggfunc='sum')
```

#### 练习3：统计不同销售渠道销售的订单数和总销售额

![img](images/10.png)

**分组聚合实现**：

```python
# 分组聚合
uniqlo.groupby('channel')[['order', 'revenue']].sum()
```

**pivot_table 透视表实现**：

```python
# 透视表实现
uniqlo.pivot_table(index='channel', values=['order', 'revenue'], 
                   aggfunc={'order': 'sum', 'revenue': 'sum'})
```



### 3. 数据的导入和导出

#### 练习1：pandas 从 winfunc 数据库中导入 movie 表和 review 表的数据

![img](images/11.png)



```python
# 导入 sqlalchemy 的数据库引擎
from sqlalchemy import create_engine

# 创建数据库引擎，传入uri规则的字符串
engine = create_engine('mysql+pymysql://root:mysql@127.0.0.1:3306/winfunc?charset=utf8')

# 读取电影表数据
movie = pd.read_sql('movie', engine)

# 读取用户评分表数据
review = pd.read_sql('review', engine)
```

#### 练习2：pandas 加载之后，将左侧和右侧数据按照电影 ID 进行关联

![img](images/12.png)

```python
result = pd.merge(movie, review, left_on='id', right_on='movie_id')
```

#### 练习3：统计不同电影的用户平均分，并将统计结果导出到 movie_rating 数据表中

![image-20210915172624548](images/13.png)

```python
movie_avg_rating = result.groupby(['movie_id', 'title']).rating.mean()
movie_avg_rating = movie_avg_rating.reset_index()
# 数据导出到SQL表中
movie_avg_rating.to_sql('movie_rating', engine)
```
