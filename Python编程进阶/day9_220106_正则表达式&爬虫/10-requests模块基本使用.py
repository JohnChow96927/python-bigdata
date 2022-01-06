"""
requests模块基本使用
学习目标：能够使用 requests 模块请求URL地址并获取响应内容
"""

# TODO：需求：使用 requests 请求百度，并获取响应内容
# 导入requests模块
import requests

# 准备请求的目标url地址
url = input("请输入准备请求的url地址: ")

headers_dict = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36'
}
response = requests.get(url, headers=headers_dict)

print(response.content.decode())

# 查看requests发起请求时的请求头
print(response.request.headers)
