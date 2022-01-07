"""
爬虫案例：保存网络图片(多张)
学习目标：能够使用正则提取html页面上图片的地址，并将图片保存到本地
"""
import re
import requests
import time

# 代码实现思路
# 1. 首先请求 https://www.tupianzj.com/meinv/20210219/224797.html，获取响应内容
url = 'https://www.tupianzj.com/meinv/20210219/224797.html'

headers_dict = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
                  '(KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36'
}

response = requests.get(url, headers=headers_dict)

# 获取响应的内容
html_content = response.content.decode('gbk') # str
# print(html_content)

# 2. 从上一步的响应内容中，提取页面上的图片的地址(正则匹配)

# 注意：findall方法进行匹配时，如果正则表达式中有分组，findall返回的是所有分组匹配到的内容
image_list = re.findall(r'<img src="(.*?)"', html_content) # list
print(image_list)

# 3. 遍历向每个图片地址发送请求，获取图片的响应内容，然后保存成一个本地图片文件
for image_url in image_list:
    # 向每个图片地址发送请求
    response = requests.get(image_url, headers=headers_dict)

    # 获取图片的响应内容
    image_content = response.content # bytes

    # 然后保存成一个本地图片文件
    file_name = image_url[-10:]
    with open('./spider/' + file_name, 'wb') as f:
        f.write(image_content)

print('图片保存完成！！！')
time.sleep(1)

