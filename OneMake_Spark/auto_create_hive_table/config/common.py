from auto_create_hive_table.config import settings  # 导入项目下的 settings.py 文件
import logging.config


# 添加日志功能（日志功能在接口层使用）
def get_logger(log_type):
    """
    log_type:传入的日志类型(admin,company,user等)
    """
    # 1.加载日志配置信息
    logging.config.dictConfig(settings.LOGGING_DIC)
    # 2.获取日志对象
    logger = logging.getLogger(log_type)
    # 返回日志对象给调用的地方
    return logger