"""
爬虫示例-爬虫多任务版
学习目标：能够使用多线程的方式执行多任务爬虫
"""

# 需求：使用多线程实现分别爬取图片数据和 GDP 数据。

import requests
import re


def get_images():
    # ① 先请求 http://127.0.0.1:8080/index.html，获取响应内容
    url = 'http://127.0.0.1:8080/index.html'
    # 发送请求
    response = requests.get(url)

    # 获取响应的内容
    html_str = response.content.decode()
    # print(html_str)

    # ② 从上一步的响应内容中提取所有图片的地址
    image_url_list = re.findall(r'<img src="(.*?)"', html_str)
    # print(image_url_list)

    # ③ 遍历每一个图片地址，向每个图片地址发送请求，并将响应的内容保存成图片文件
    base_url = 'http://127.0.0.1:8080'

    for i, image_url in enumerate(image_url_list):
        # 拼接完整的图片地址
        image_url = base_url + image_url[1:]
        # 发送请求
        image_response = requests.get(image_url)

        # 将响应内容保存成本地图片
        with open(f'./spider/{i}.jpg', 'wb') as f:
            f.write(image_response.content)

    print('保存图片完毕!!!')


def get_gdp_data():
    # ① 先请求 http://127.0.0.1:8080/gdp.html，获取响应内容
    url = 'http://127.0.0.1:8080/gdp.html'
    # 发送请求
    response = requests.get(url)

    # 获取响应的内容
    html_str = response.content.decode()
    # print(html_str)

    # ② 使用正则提取页面上的国家和GDP数据
    gdp_data = re.findall('<a href=""><font>(.*?)</font></a>.*?<font>￥(.*?)亿元</font>', html_str, flags=re.S)
    # print(gdp_data)

    # ③ 将提取的 GDP 保存到文件 gdp.txt 中
    with open('./spider/gdp.txt', 'w', encoding='utf8') as f:
        f.write(str(gdp_data))

    print('保存GDP数据完毕!!!')



