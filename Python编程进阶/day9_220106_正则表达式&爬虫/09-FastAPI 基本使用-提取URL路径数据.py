# 导入 FastAPI 类
import os.path

from fastapi import FastAPI, Path
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


# TODO：需求：定义通用处理函数，给浏览器返回图片数据
@app.get('/images/{image_name}')
def get_image(image_name):
    file_path = './sources/images/' + image_name
    if not os.path.isfile(file_path):
        return "Not Found!"
    else:
        with open('./sources/images/' + image_name, 'rb') as f:
            content = f.read()
        return Response(content, media_type='jpg')


if __name__ == '__main__':
    # 启动 Web 服务器
    uvicorn.run(app, host='127.0.0.1', port=8080)
