import re


def isCellPhoneNumber() -> bool:
    mobile = input("请输入手机号: ")
    result = re.search(r'^1[3-9]\d{9}$', mobile)
    if result:
        return True
    else:
        return False


def isLowerCase() -> bool:
    content = input("请输入内容进行判断:")
    result = re.search(r'^[a-z]+$', content)
    if result:
        return True
    else:
        return False


def getMobileNumber(filepath):
    with open(filepath, 'r', encoding='utf8') as f:
        content = f.read()
        return re.findall(r'^1[3-9]\d{9}$', content)


def question4():
    my_str = """
        <!DOCTYPE html>
        <html> 
        <head>   
            <title>徐清风</title> 
        <head> 
        <body>   
            <h2>     
                <em>大数据分析</em>
            </h2> 
        </body>
        </html>
        """

    # 进行字符串匹配
    re_obj = re.search(r'<em>(?P<text>.*)</em>', my_str)

    # 根据分组别名获取指定分组匹配的内容
    result = re_obj.group('text')
    print(result)


def question5(mobile: str) -> str:
    result = re.sub(r'(\d{3})\d{4}(\d{4})', r'\1****\2', mobile)
    return result
