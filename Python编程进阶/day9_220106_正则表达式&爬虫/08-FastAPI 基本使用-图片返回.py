# 导入 FastAPI 类
from fastapi import FastAPI
# 导入 uvicorn
import uvicorn
# 导入 Response 响应类
from fastapi import Response

# 创建 FastAPI 对象
app = FastAPI()


# 定义业务处理函数并设置对应的 URL 地址
# get：表示请求方式
# /index.html：表示请求的 URL 地址
@app.get('/index.html')
def index():
    with open('./sources/html/index.html', 'r', encoding='utf8') as f:
        content = f.read()

    # 返回响应对象
    return Response(content, media_type='html')


@app.get('/gdp.html')
def gdp():
    with open('./sources/html/gdp.html', 'r', encoding='utf8') as f:
        content = f.read()

    # 返回响应对象
    return Response(content, media_type='html')


# TODO：需求：定义处理函数，给浏览器返回图片数据
@app.get('/images/0.jpg')
def get_image_0():
    with open('./sources/images/0.jpg', 'rb') as f:
        content = f.read()

    # 返回响应对象
    return Response(content, media_type='jpg')


@app.get('/images/1.jpg')
def get_image_1():
    with open('./sources/images/1.jpg', 'rb') as f:
        content = f.read()

    # 返回响应对象
    return Response(content, media_type='jpg')


@app.get('/images/2.jpg')
def get_image_2():
    with open('./sources/images/2.jpg', 'rb') as f:
        content = f.read()

    # 返回响应对象
    return Response(content, media_type='jpg')


@app.get('/images/3.jpg')
def get_image_3():
    with open('./sources/images/3.jpg', 'rb') as f:
        content = f.read()

    # 返回响应对象
    return Response(content, media_type='jpg')


@app.get('/images/4.jpg')
def get_image_4():
    with open('./sources/images/4.jpg', 'rb') as f:
        content = f.read()

    # 返回响应对象
    return Response(content, media_type='jpg')


@app.get('/images/5.jpg')
def get_image_5():
    with open('./sources/images/5.jpg', 'rb') as f:
        content = f.read()

    # 返回响应对象
    return Response(content, media_type='jpg')


@app.get('/images/6.jpg')
def get_image_6():
    with open('./sources/images/6.jpg', 'rb') as f:
        content = f.read()

    # 返回响应对象
    return Response(content, media_type='jpg')


if __name__ == '__main__':
    # 启动 Web 服务器
    uvicorn.run(app, host='127.0.0.1', port=8080)
