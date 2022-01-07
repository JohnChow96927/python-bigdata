"""
爬虫示例-爬虫多张图片数据
学习目标：能够使用 requests 爬取多张图片数据并保存
"""

import requests
import re


# 需求：访问 http://127.0.0.1:8080/index.html 网址，获取页面上的所有图片保存到本地。

# 思路
# ① 先请求 http://127.0.0.1:8080/index.html，获取响应内容
# ② 从上一步的响应内容中提取所有图片的地址
# ③ 遍历每一个图片地址，向每个图片地址发送请求，并将响应的内容保存成图片文件

def get_images():
    # 先请求index.html, 获取相应内容
    url = 'http://127.0.0.1:8080/index.html'

    # 发送请求
    response = requests.get(url)

    # 获取响应的内容
    html_str = response.content.decode()
    print(html_str)

    # 从html内容中提取图片地址
    # 如果正则表达式进行了分组, findall返回的是每个分组匹配的内容, 不再是整个正则表达式匹配的内容
    img_url_list = re.findall(r'<img src="(.*?)"', html_str)    # 问号表示非贪婪模式
    print(img_url_list)  # ['./images/0.jpg', ...]

    base_url = 'http://127.0.0.1:8080'
    for i, img_url in enumerate(img_url_list):
        image_url = base_url + img_url[1:]
        # 发送请求
        image_response = requests.get(image_url)

        with open(f'./spider/{i}.jpg', 'wb') as f:
            f.write(image_response.content)


if __name__ == '__main__':
    get_images()
