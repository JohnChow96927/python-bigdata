# 今日所有内容仅了解

# 1. CS架构

- ##### Client + Server: 客户端 + 服务端

# 2. BS架构

- ##### Broser + Server: 浏览器 + 服务端

- ##### URL: 统一 资源 占位符

    ```tex
    https://www.baidu.com/s?wd=python
    ```

    http : 协议, 一种通讯的规则

    www.baidu.com : 域名 —> IP地址: 计算机在网络中的地址

    s? : 资源所在位置

    wd=python : 搜索的关键字, 传递的参数

- ##### DNS: 域名解析器: 将域名与ip地址进行绑定

# 3. HTML

- ##### HTML的定义: 全称 HyperText Mark-up Language 超文本标记语言

- ##### 作用: 开发网页的语言

- ##### 超文本的两层含义:

    - 超越文本限制, 网页中还可以有图片视频音频等内容
    - 超链接文本

- ##### 标签大多成对出现

- ##### 结构:

    ```html
    <!DOCTYPE html>		文档声明
    <html>	根标签
        <head>	页头部分
            <title>标题</title>
        </head>
        <body>
            <ul>
                <li>
                无序标签
                </li>
            </ul>
            <ol>
                <li>有序标签</li>
                <li>有序标签</li>
            </ol>
    <!--
    注释
    -->
            网页正文
        </body>
    </html>		结束标签
    ```

- ##### 常用的HTML标签: 20多个

    - 标签不区分大小写, 但推荐使用小写
    - 成对出现的标签(双标签, 闭合标签), 容许嵌套和承载内容
    - 单个出现的标签(单标签, 空标签), 没有标签内容
    - 标签的嵌套

- ##### 标签初体验

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
    </head>
    <body>
    <h1>hello html</h1>
    <h1>hello world</h1>
    </body>
    </html>
    ```

- ##### 列表标签

    - 有序(ol标签)
    - 无序(ul标签)

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
    </head>
    <body>
    <!--
       无序标签  ul>li
       有序标签 ol>li
       属性 type
    -->
    <ul type="square">
        <li>无序标签</li>
        <li>无序标签</li>
        <li>无序标签</li>
    </ul>
    
    <ol type="i">
        <li>有序标签</li>
        <li>有序标签</li>
        <li>有序标签</li>
    </ol>
    </body>
    </html>
    ```

- ##### 表格标签: `<table>`

    - 表头标签`<th>`
    - 行标签`<tr>`
    - 列标签`<td>`

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
    </head>
    <body>
    <!--
    表格标签
    table
     属性 border="1px"
    tr 行
    td 单元格
    th 表头单元格
    -->
    <table border="1px" cellspacing="0" width="300px">	border: 边框宽度
        <tr>
            <th>姓名</th>
            <th>年龄</th>
        </tr>
        <tr align="center">
            <td>张三</td>
            <td>18</td>
        </tr>
        <tr>
            <td>李四</td>
            <td>19</td>
        </tr>
    </table>
    </body>
    </html>
    ```

- ##### 表单标签: `<form>`

    - 表单元素标签:
        - `<label>`: 定义文字标注
        - `<select>`: 定义下拉列表, 与`<option>`标签相配合定义下拉列表中的选项
        - `<input>`: 定义不同类型的用户输入数据方式, 属性type="text"等等

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
    </head>
    <body>
    <!--
    action 服务器地址
    method 发送方式 如果没有这个属性 默认发送方式为 get
    get请求方式
      如何发送数据: 服务器地址?key=value&key1=value1&key2=value2
      数据不安全 数据发送大小有限制
    post请求方式
       将数据进行隐藏 数据相对安全
       数据发送的大小没有限制
    aJax 提交数据
    -->
    <form action="01-标签初体验.html" method="post">
        账号:<input type="text" name="username"> <br>
        <!--    收集数据-->
        密码:<input type="password" name="password"> <br>
        <!--    提交按钮-->
        <input type="submit">
    </form>
    </body>
    </html>
    ```

- ##### 文本域标签

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
    </head>
    <body>
    <form action="01-标签初体验.html">
        <!--
        cols 列宽
        rows 行高
        -->
        <textarea name="ms" cols="50" rows="20"></textarea> <br>
        <input type="submit">
    </form>
    
    </body>
    </html>
    ```

- ##### 下拉选择框

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
    </head>
    <body>
    <!--
    下拉选择框
     select>option
    -->
    <form action="01-标签初体验.html">
        <select name="city">
    <!--        value 用户提交的数据-->
            <option value="">请选择</option>
            <option value="帝都">北京</option>
            <option value="魔都">上海</option>
            <option value="羊城">广州</option>
            <option value="鹏城">深圳</option>
        </select> <br>
        <input type="submit">
    </form>
    </body>
    </html>
    ```

- ##### 文本输入框

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
    </head>
    <body>
    <!--
    input
        属性 type 控制input的作用
        text  文本输入框
        password  密码输入框
        file  文件选择框
        checked 多选框
        radio 单选框
        submit 提交按钮
        reset  重置按钮
        button 普通按钮
    -->
    <form action="01-标签初体验.html">
    
        账号: <input type="text" name="username"> <br>
        密码: <input type="password" name="password"> <br>
        头像: <input type="file" name="head"> <br>
        <!--    value:在选择框中 提交的数据-->
        爱好: <input type="checkbox" name="hobby" value="抽烟"> 抽烟
        <input type="checkbox" name="hobby" value="喝酒"> 喝酒
        <input type="checkbox" name="hobby" value="烫头"> 烫头
        <br>
        性别:
        <label for="gender">
            <input type="radio" name="gender" value="male" id="gender"> 男
        </label>
        <input type="radio" name="gender" value="female"> 女
    
        <br>
        <!--    value:给按钮取名字-->
        提交: <input type="submit"> <br>
        重置: <input type="reset"> <br>
        <!--    普通按钮需要结合js使用 单独使用毫无意义-->
        普通按钮: <input type="button" value="普通按钮"> <br>
    </form>
    </body>
    </html>
    ```

    

# 4. CSS

- ##### 定义: Cascading Style Sheet 层叠样式表, 用来美化页面的一种语言

- ##### 作用: 设置标签文字大小, 颜色, 字体加粗等样式, 控制页面布局

- ##### 基本语法: 选择器{样式规则}

    ```css
    div{
        width:100px;
        height:100px;
        background:gold;
    }
    ```

- ##### CSS的引入方式

    - 行内式: 直接在标签的style属性中添加css样式

        - 优点: 方便, 直观
        - 缺点: 缺乏可重用性

        ```html
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <title>Title</title>
        </head>
        <body>
        <!--
        div
        块级标签 所有能够单独占用一行的标签
        行级标签 所有的标签只能在一行上显示
        行内式:如何使用
        直接在标签上使用 style属性 在属性值中写样式
        -->
        <!--    样式: key:value;key:value;-->
            <div style="font-size: 50px;color: blue">
                行级标签
            </div>
        
            <div  style="font-size: 50px;color: blue">
                行级标签
            </div>
        
            <div  style="font-size: 50px;color: blue">
                行级标签
            </div>
        
            <div  style="font-size: 50px;color: blue">
                行级标签
            </div>
        </body>
        </html>
        ```

    - 内嵌式: 在`<head>`标签内加入`<style>`标签,在其中编写css代码

        - 优点: 在同一个页面内部便于复用和维护
        - 缺点: 在多个页面之间可重用性不高

        ```html
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <title>Title</title>
            <style>
                /*
                    ctrl + shift + /
                    要在这里写css的样式
                    第一步:选择到需要操作的标签 使用选择器
                    第二步:为这些选择到的标签添加样式
                    学习第一个比较简单的选择器:
                    元素选择器: 通过元素名在整个文件中找到需要操作的标签
                    格式
                    标签名{
                      css样式
                    }
                    div{
                        css样式
                    }
                */
                div {
                    font-size: 50px;
                    color: red;
                }
            </style>
        </head>
        <body>
        <div>我是div</div>
        <div>我是div</div>
        <div>我是div</div>
        <div>我是div</div>
        <div>我是div</div>
        <div>我是div</div>
        <div>我是div</div>
        <div>我是div</div>
        <div>我是div</div>
        <div>我是div</div>
        <h1>我是标题</h1>
        <h1>我是标题</h1>
        <h1>我是标题</h1>
        <h1>我是标题</h1>
        </body>
        </html>
        ```

    - 外链式: 将css代码写在一个单独的.css文件中, 在`<head>`标签中使用`<link>`标签直接引入该文件到页面中

        - 优点: 是的css样式与heml页面分离, 便于整个页面系统的规划和维护, 可重用性高
        - 缺点: 容易出现css代码过于集中, 维护不当容易造成混乱

        ```html
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <title>Title</title>
        </head>
        <!--
        在head中使用link标签 rel 引入的是什么 href代表的是相对路径
        ../ 上一级
        ./当前
        -->
        <link rel="stylesheet" href="demo.css">
        <body>
        <!--
        外链式 将css样式写到css文件中  在html文件中引入css文件
        -->
        <div>我是div</div>
        <div>我是div</div>
        <div>我是div</div>
        <div>我是div</div>
        <div>我是div</div>
        <div>我是div</div>
        <div>我是div</div>
        <div>我是div</div>
        <div>我是div</div>
        <div>我是div</div>
        </body>
        </html>
        ```

- #### css选择器: 用来选择标签的, 选出来以后给标签加样式

    - 标签选择器
    - 类选择器
    - 层级选择器(后代选择器)
    - id选择器
    - 组选择器
    - 伪类选择器

- ##### 类选择器: 以. 开头, 是应用最多的一种选择器

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
        <style>
            /*
            类选择器
            class属性 通用属性
            格式:
            .class属性值{
                css样式
            }
            通过class的值选择标签
            */
            .my_div{
                font-size: 50px;
                color: red;
            }
        </style>
    </head>
    <body>
    <div>我是div</div>
    <div class="my_div">我是div</div>
    <div class="my_div">我是div</div>
    <div class="my_div">我是div</div>
    <div>我是div</div>
    <div>我是div</div>
    <div>我是div</div>
    <div>我是div</div>
    <div>我是div</div>
    <div class="my_div">我是div</div>
    </body>
    </html>
    ```

- ##### id选择器: 以# 开头, 元素的id名称不能重复, 所以id选择器只能对应于页面上的一个元素

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
        <!--
        使用id选择器
        格式
        #id的值{
            css样式
        }
        通过id的值选择
        id属性 通用属性
        id的值在整个文件中是唯一的
        -->
        <style>
            #my_div {
                font-size: 50px;
                color: blue;
            }
        </style>
    </head>
    <body>
    <div>我是div</div>
    <div id="my_div">我是div</div>
    <div>我是div</div>
    <div>我是div</div>
    <div>我是div</div>
    <div>我是div</div>
    <div>我是div</div>
    <div>我是div</div>
    <div>我是div</div>
    <div>我是div</div>
    </body>
    </html>
    ```

- ##### 层级选择器(后代选择器): 以 选择器1 选择器2 开头, 主要应用在标签嵌套的结构中, 减少命名

    - 不一定是父子关系, 也可能是祖孙关系, 主要有后代关系都适用

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
        <style>
            /*
            层级选择器
            选择器1 选择器2 ...{
                 css样式
            }
            1.先通过选择器1选择到所有的元素
            2.在选择器1选择到的元素的基础上 再通过选择器2进行选择(而不是从整个文件中选择)
            */
            .my_outer #my_inner{
                font-size: 50px;
                color: red;
            }
        </style>
    </head>
    <body>
    <div class="my_outer">
        父亲div
        <div id="my_inner">儿子div</div>
    </div>
    
    <div class="my_outer">
        父亲div
    </div>
    </body>
    </html>
    ```

- ##### 组合选择器: 以 , 分隔开, 如果有公共的样式设置, 可以使用组合选择器

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
        <!--
        给class的值为 my_div 标签以及 id的值为 my_span的标签 以及 h1标签 添加相同的样式
    
        -->
        <style>
            /* .my_div {
                 font-size: 50px;
                 color: red;
             }
    
             #my_span {
                 font-size: 50px;
                 color: red;
             }
    
             h1 {
                 font-size: 50px;
                 color: red;
             }*/
    
            /*
            组合选择器:
            格式
            选择器1,选择器2,...{
               css样式
            }
            将所有的选择器选择到的元素 统一添加相同的样式
            */
    
            .my_div, #my_span, h1 {
                font-size: 50px;
                color: red;
            }
    
        </style>
    </head>
    <body>
    <div class="my_div">
        我是div
    </div>
    <div>
        我是div
    </div>
    <div>
        我是div
    </div>
    <span>
        我是span
    </span>
    <span id="my_span">
        我是span
    </span>
    
    <h1>
        我是标题
    </h1>
    
    </body>
    </html>
    ```

- ##### 伪类选择器: 以 : 分隔开, 当用户和网站交互时改变显示效果可以使用伪类选择器

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
        <style>
            div:hover {
                font-size: 50px;
                color: red;
            }
        </style>
    </head>
    <body>
    <div>我是div欣欣</div>
    </body>
    </html>
    ```

- ##### 常用的样式属性

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
        <style>
            div {
                /*    给元素添加一个边框
                        border: 边框的粗细 边框的样式 边框的颜色  solid:实线显示
                */
                border-left: 1px solid red;
                width: 500px;
                height: 500px;
                background: blue;
                /*  ctrl + alt + 空格 内容辅助键 */
                background-image: url("imgs/bg.jpg");
            }
        </style>
    </head>
    <body>
    <div>我是div</div>
    <span>我是span</span>
    </body>
    </html>
    ```

    ##### 布局常用样式属性

    width 设置元素(标签)的宽度，如：width:100px;
    height 设置元素(标签)的高度，如：height:200px;
    background 设置元素背景色或者背景图片
    如：background:gold; 设置元素的背景色, background: url(images/logo.png); 设置元素的背景图片
    border 设置元素四周的边框
    如：border:1px solid black; 设置元素四周边框是1像素宽的黑色实线
    以上也可以拆分成四个边的写法，分别设置四个边的：
    border-top 设置顶边边框，如：border-top:10px solid red;
    border-left 设置左边边框，如：border-left:10px solid blue;
    border-right 设置右边边框，如：border-right:10px solid green;
    border-bottom 设置底边边框，如：border-bottom:10px solid pink;

    ##### 文本常用样式属性

    color 设置文字的颜色，如： color:red;
    font-size 设置文字的大小，如：font-size:12px;
    font-family 设置文字的字体，如：font-family:'微软雅黑';为了避免中文字不兼容，一般写成：font-family:'Microsoft Yahei';
    font-weight 设置文字是否加粗，如：font-weight:bold; 设置加粗 font-weight:normal 设置不加粗
    line-height 设置文字的行高，如：line-height:24px; 表示文字高度加上文字上下的间距是24px，也就是每一行占有的高度是24px
    text-decoration 设置文字的下划线，如：text-decoration:none; 将文字下划线去掉
    text-align 设置文字水平对齐方式，如text-align:center 设置文字水平居中
    text-indent 设置文字首行缩进，如：text-indent:24px; 设置文字首行缩进24px