import os


# 获取项目根目录路径
BASE_PATH = os.path.dirname(
    os.path.dirname(__file__)
)
# logging 的配置信息
"""
logging 配置
"""

# 定义三种日志的输出格式
standard_format = '[%(asctime)s][%(threadName)s:%(thread)d][task_id:%(name)s][%(filename)s:%(lineno)d]' \
                  '[%(levelname)s][%(message)s]'

simple_format = '[%(levelname)s][%(asctime)s][%(filename)s:%(lineno)d]%(message)s'

test_format = '%(asctime)s] %(message)s'

# ******************注意1：log文件的目录
BASE_PATH = os.path.dirname(os.path.dirname(__file__))
logfile_dir = os.path.join(BASE_PATH, 'log')  # 将日志文件放入项目下的 log 文件夹

# ******************注意2：log文件名
logfile_name = 'itcast.log'

# 如果不存在定义的日志目录就创建一个
if not os.path.isdir(logfile_dir):
    os.mkdir(logfile_dir)

# log文件的全路径
logfile_path = os.path.join(logfile_dir, logfile_name)

# 日志配置字典
LOGGING_DIC = {
    # 配置字典的版本
    'version': 1,
    'disable_existing_loggers': False,
    # 设置多种日志的格式
    'formatters': {
        'standard': {
            'format': standard_format
        },
        'simple': {
            'format': simple_format
        },
        'test': {
            'format': test_format
        },
    },
    'filters': {},
    # handlers 是日志的接收者，不同的 handler 会将日志输出到不同的位置
    'handlers': {
        # 打印到终端的日志
        'console': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',  # 打印到屏幕
            'formatter': 'simple'
        },
        # 打印到文件的日志，有轮转功能
        'default': {
            'level': 'DEBUG',
            'class': 'logging.handlers.RotatingFileHandler',  # 保存到文件,日志轮转
            'maxBytes': 1024 * 1024 * 5,  # 日志大小 5M 超过此大小，将文件重命名为其他文件，继续在新的 a1.log 内写入
            'backupCount': 5,  # 重命名日志的份数，表示最多重命名几次。日志需要保存时间越长，份数应该越高
            'filename': logfile_path,  # os.path.join(os.path.dirname(os.path.dirname(__file__)), 'log', 'a2.log)
            'encoding': 'utf-8',
            'formatter': 'standard',
        },
    },
    # loggers 是日志的产生者，产生的日志会传递给 handler 然后控制输出
    'loggers': {
        # logging.getLogger(__name__)拿到的logger配置
        # 大部分日志名不同但需放在同一日志文件内的，可以将日志名留空
        '': {
            'handlers': ['console', 'default'],
            'level': 'DEBUG',
            'propagate': False
        }
    }
}