"""
FastAPI 基本使用-返回html内容
学习目标：能够使用 FastAPI 定义处理函数返回 html 内容
"""
# 导入 FastAPI 类
from fastapi import FastAPI
# 导入 uvicorn
import uvicorn

# 创建 FastAPI 对象
app = FastAPI()


# 定义业务处理函数并设置对应的 URL 地址
# get：表示请求方式
# /index：表示请求的 URL 地址
@app.get('/index')
def index():
    # 'Hello World'是响应体的内容
    return 'Hello World'


# TODO：定义处理函数，访问 / 和 /gdp.html 地址时，返回 gdp.html 内容


# TODO：定义处理函数，访问 /render.html 地址时，返回 render.html 内容


if __name__ == '__main__':
    # 启动 Web 服务器
    uvicorn.run(app, host='127.0.0.1', port=8080, reload=True)
