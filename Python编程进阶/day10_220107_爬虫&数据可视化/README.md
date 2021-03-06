## 昨日复习:

1. ##### 正则表达式: 数据检索, 数据验证, 数据验证, 数据过滤

2. ##### *?+{}

3. ##### ^匹配开头, $匹配结尾

4. ##### 正则分组: (?P<别名>)

5. ##### re模块:

    re.match: 从头开始匹配, 如果不是开头就匹配成功则返回None

    re.search: 搜索到第一个匹配的就返回

    re.findall: 从头到尾找所有, 返回list

    re.split: 分割

    re.sub: 替换匹配到的子串

6. ##### 正则表达式修饰符: re.I, re.M, re.S

7. ##### 贪婪模式和非贪婪模式

8. ##### 浏览器的渲染

9. ##### FastAPI动态返回图片数据: /images/{image_name}

10. ##### FastAPI提取url地址中的参数

11. ##### 爬虫的定义

12. ##### 爬虫的作用

13. ##### 爬虫的工作流程

14. ##### requests模块使用入门:

    1. 导入模块

    2. response = requests.get(url, header=headers_dict)
    3. 请求头伪装: User-Agent: ...

# 爬虫程序&数据可视化

## I. 爬虫程序

1. ### 爬取单张图片数据

    ```python
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
    ```

2. ### 爬取多张图片数据

    ```python
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
    ```

3. ### 爬取GDP数据

    ```python
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
    ```

4. ### 多任务爬虫

    ```python
    """
    爬虫示例-爬虫多任务版
    学习目标：能够使用多线程的方式执行多任务爬虫
    """
    
    # 需求：使用多线程实现分别爬取图片数据和 GDP 数据。
    import threading
    
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
    
    
    if __name__ == '__main__':
        image_thread = threading.Thread(target=get_images)
        gdp_thread = threading.Thread(target=get_gdp_data)
    
        # 启动线程
        image_thread.start()
        gdp_thread.start()
    ```

## II. 数据可视化

1. ### pyecharts绘制饼图

    ```python
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
    ```

## III. 程序日志记录

1. ### 日志的作用和级别

    ##### 程序的日志是记录程序在运行过程中, 一些关键性的信息.

    ##### 日志的作用: 

    ​	1) 便于了解程序的运行情况

    ​	2) 便于开发者检查bug

    ​	3) 便于分析用户的行为, 喜好等信息

    ##### 日志的登记划分:

    日志按重要程度**从低到高**分成**5个**等级:

    ​	1) DEBUG: 程序调试bug时使用

    ​	2) INFO: 程序正常运行时使用

    ​	3) WARNING: 程序未按预期运行时使用, 但并不是错误, 如: 用户登录密码错误

    ​	4) ERROR: 程序出错误时使用, 如: IO操作失败

    ​	5) CRITICAL: 严重错误, 导致程序不能再继续运行时使用, 如: 磁盘空间为空, 一般很少使用

    > DEBUG < INFO < WARNING < ERROR < CRITICAL(不严重 —> 严重)

2. ### logging模块的使用

    #### Python中可以使用logging模块记录日志

    > 记录日志时, 比设置的日志等级低的信息不会被记录

    ```python
    """
    logging模块记录日志
    学习目标：能够使用 logging 模块记录日志
    """
    
    import logging
    
    logging.basicConfig(level=logging.DEBUG,
                        format='%(asctime)s - %(filename)s[line:%(lineno)d] - %(levelname)s: %(message)s',
                        filename='log.txt',
                        filemode='a')
    """
    level: 要记录的日志级别
    format: 日志格式, 指定日志输出时所包含的字段信息以及它们的顺序
    (format中常用的格式字段:
        %(asctime)s: 日志事件发生的时间;
        %(filename)s: 源码文件名, 包含文件后缀;
        %(lineno)d: 调用日志记录函数的源代码所在的行号;
        %(levelname)s: 文字形式的日志级别;
        %(message)s: 日志记录的文本内容)
    filename: 日志输出位置, 设置后日志信息就不会被输出到控制台
    filemode: 日志的打开模式: 默认为'a', 在filename指定时才有效
    """
    
    # logging记录日志的默认级别是: WARNING
    logging.debug('这是一个debug级的日志')
    logging.log(logging.INFO, "这是一个info级的日志")
    logging.log(logging.WARNING, "这是一个warning级的日志")
    logging.error("这是一个error级的日志")
    logging.critical("这是一个critical级的日志")
    ```

3. ### 数据埋点

    - ##### 数据埋点是数据采集的一种方式, 指的是从自己的产品中采集用户的行为数据到日志的过程

        需求: 分析短视频app用户喜欢的视频类型, 以便给用户推荐视频

        日志记录用户行为数据: 搜索关键字, 点赞, 转发, 关注

    - ##### 数据埋点可以便于日后分析用户喜好

    - ##### 数据埋点的方式:

        1. 代码埋点: 在产品源代码中添加记录日志的代码(需要开发人员配合)
        2. 可视化埋点: 通过第三方产品, 配置记录用户**关键**行为数据(业务人员自己即可配置)
        3. 无埋点(全埋点): 通过第三方产品, 配置记录用户的**所有**行为数据(业务人员自己即可配置)