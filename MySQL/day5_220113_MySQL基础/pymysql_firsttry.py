# 导入pymysql拓展包
import pymysql


def main():
    # 创建数据库连接对象
    conn = pymysql.connect(host='localhost',
                           port=3306,
                           database='python',
                           user='root',
                           password='123456')
    cursor = conn.cursor()
    for i in range(100000):
        cursor.execute("INSERT INTO test_index VALUES('py-%d')" % i)
    conn.commit()
    cursor.close()
    conn.close()


if __name__ == '__main__':
    main()
