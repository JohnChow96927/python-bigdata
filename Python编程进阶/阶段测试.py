# import time
# from functools import wraps
#
#
# def outer(fun):
#     @wraps(fun)
#     def inner():
#         begin_time = time.time()
#         fun()
#         end_time = time.time()
#         print(f"此函数从开始到结束的运行时间为:{end_time - begin_time}")
#
#     return inner
#
#
# @outer
# def fun():
#     print("我是一个函数~")
#
#
# fun()
# # 导入 FastAPI 类
# from fastapi import FastAPI, Path
# # 导入 uvicorn
# import uvicorn
# # 导入 Response 响应类
# from fastapi import Response
#
# # 创建 FastAPI 对象
# app = FastAPI()
#
#
# # 定义业务处理函数并设置对应的 URL 地址
# # get：表示请求方式
# # /index.html：表示请求的 URL 地址
# @app.get('/index.html')
# def index():
#     content = "itcast"
#     # 返回响应对象
#     return Response(content, media_type='html')
#
#
# @app.get('/{image_name}')
# def get_images(image_name):
#     with open(f'./source/{image_name}', 'rb') as f:
#         content = f.read()
#
#     # 返回响应对象
#     return Response(content, media_type='jpg')
#
#
# if __name__ == '__main__':
#     # 启动 Web 服务器
#     uvicorn.run(app, host='127.0.0.1', port=8080)

# import requests
#
# url = 'http://127.0.0.1:8080/1.jpg'
#
# response = requests.get(url)
#
# image_content = response.content
#
# with open('./images/1.jpg', 'wb') as f:
#     f.write(image_content)
