"""
pyecharts-GDP数据可视化
学习目标：能够使用 pyecharts 绘制饼图
"""

# 需求
# ① 从文件中读取 GDP 数据
# ② 使用 pyecharts 绘制饼状图显示GDP前十的国家
from pyecharts.charts import Pie
import pyecharts.options as opts


def data_view_pie():
    with open('./spider/gdp.txt', 'r', encoding='utf8') as f:
        gdp_data = f.read()  # str
        gdp_data = eval(gdp_data)  # list, eval()方法本质就是把字符串两边引号去掉

    # 获取GDP前十国家
    gdp_top_10 = gdp_data[:10]

    # 创建饼图
    pie = Pie(init_opts=opts.InitOpts(width='1400px', height='800px'))
    # 给饼图添加数据
    pie.add(
        "GDP",
        gdp_top_10,
        label_opts=opts.LabelOpts(formatter='{b}:{d}%')
    )
    # 给饼图设置标题
    pie.set_global_opts(title_opts=opts.TitleOpts(title="2020年世界GDP前10", subtitle="美元"))
    # 保存结果, 默认保存到render.html文件中
    pie.render()


if __name__ == '__main__':
    data_view_pie()
    