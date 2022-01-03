"""
FastAPI基本使用-HelloWorld程序
学习目标：能够使用 FastAPI 完成 HelloWorld 案例程序
pip install fastapi
pip install uvicorn
"""
# 导入FastAPI类
from fastapi import FastAPI
# 导入uvicorn
import uvicorn

app = FastAPI()


# 需求: 当浏览器访问/index 资源路径时, 给浏览器返回Hello World
# 定义业务处理函数并设置对应的URL地址
# get: 表示请求方式
# /index: 表示请求的URL地址
@app.get('/index')
def index():
    # "Hello World"是响应体的内容
    return "Hello World"


if __name__ == '__main__':
    # 启动FastAPI程序
    # 使用uvicorn内置的Web服务器启动
    uvicorn.run(app, host='127.0.0.1', port=8080)
