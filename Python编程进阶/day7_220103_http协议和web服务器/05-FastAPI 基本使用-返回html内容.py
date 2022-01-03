"""
FastAPI 基本使用-返回html内容
学习目标：能够使用 FastAPI 定义处理函数返回 html 内容
"""
# 导入 FastAPI 类
from fastapi import FastAPI
from fastapi import Response
# 导入 uvicorn
import uvicorn

# 创建 FastAPI 对象
app = FastAPI()

'''
{
    '/index': index,
    '/': gdp,
    '/gdp.html': gdp,
    '/render.html': render
}
'''


# 定义业务处理函数并设置对应的 URL 地址
# get：表示请求方式
# /index：表示请求的 URL 地址
@app.get('/index')
def index():
    # 'Hello World'是响应体的内容
    return 'Hello World'


# TODO：定义处理函数，访问 / 和 /gdp.html 地址时，返回 gdp.html 内容
@app.get('/')
@app.get('gdp.html')
def gdp():
    # 读取gdp.html文件内容
    with open('./sources/html/gdp.html', 'r', encoding='utf8') as file:
        content = file.read()
    # 返回 html 时，不能直接 return，默认会告诉浏览器这是 json 格式
    return Response(content, media_type='text/html')


# TODO：定义处理函数，访问 /render.html 地址时，返回 render.html 内容
@app.get('/render.html')
def render():
    # 读取render.html文件内容
    with open('./sources/html/render.html', 'r', encoding='utf8') as file:
        content = file.read()
    return Response(content, media_type='text/html')


if __name__ == '__main__':
    # 启动 Web 服务器
    # reload=True：检测到代码修改之后，服务器会自动进行重启
    # 注意：设置reload=True时，第一个参数的格式："文件名:app"
    uvicorn.run(app, host='127.0.0.1', port=8080, reload=True)
