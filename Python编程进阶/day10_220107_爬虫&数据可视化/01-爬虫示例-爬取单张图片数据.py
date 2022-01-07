"""
爬虫示例-爬虫单张图片数据
学习目标：能够使用 requests 爬取单张图片数据并保存
"""

# 需求：使用 requests 编写爬虫程序，爬取 http://127.0.0.1:8080/images/1.jpg 图片数据并保存。

import requests

# 准备请求的 URL 地址
url = 'http://127.0.0.1:8080/images/1.jpg'

# 发送请求
response = requests.get(url)

# 获取响应图片内容
image_content = response.content

# 将响应图片内容保存成本地图片文件
with open('./spider/1.jpg', 'wb') as f:
    f.write(image_content)
