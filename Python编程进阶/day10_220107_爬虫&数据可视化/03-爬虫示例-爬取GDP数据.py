"""
爬虫示例-爬取GDP数据
学习目标：能够使用 requests 爬取GDP数据并保存
"""

# 需求：访问 http://127.0.0.1:8080/gdp.html 网址，提取页面上的国家和GDP数据并保存到本地。

# 思路
# ① 先请求 http://127.0.0.1:8080/gdp.html，获取响应内容
# ② 使用正则提取页面上的国家和GDP数据
# ③ 将提取的 GDP 保存到文件 gdp.txt 中

import requests
import re


def get_gdp_data():
    url = "http://127.0.0.1:8080/gdp.html"

    response = requests.get(url)

    html_str = response.content.decode()

    gdp_data = re.findall(r'<a href=""><font>(.*?)</font></a>.*?<font>￥(.*?)亿元</font>', html_str,
                          flags=re.S)  # 修饰符re.S, .也能匹配\n
    print(gdp_data)

    with open('./spider/gdp.txt', 'w', encoding='utf8') as f:
        f.write(str(gdp_data))

    print('保存GDP数据成功!')


if __name__ == '__main__':
    get_gdp_data()
