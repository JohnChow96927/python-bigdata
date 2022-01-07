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

