import pymysql

conn = pymysql.connect(host='localhost',
                       port=3306,
                       user='root',
                       password='123456',
                       database='winfunc',
                       charset='utf8')

cursor = conn.cursor()

sql = 'SELECT * FROM students'

row_count = cursor.execute(sql)
print(f'SQL语句执行影响的行数: {row_count}')

fetch_all = cursor.fetchall()
print(fetch_all)

fetch_one = cursor.fetchone()
print(fetch_one)

fetch_many = cursor.fetchmany(2)
print(fetch_many)

cursor.close()
conn.close()
