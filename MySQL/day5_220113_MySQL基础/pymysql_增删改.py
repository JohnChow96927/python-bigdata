import pymysql

conn = pymysql.connect(host='localhost',
                       port=3306,
                       user='root',
                       password='123456',
                       database='winfunc',
                       charset='utf8')

cursor = conn.cursor()

sql = 'INSERT INTO students VALUES (8, "LILEI", "Female", 100)'
# 自动开启事务
row_count = cursor.execute(sql)
print(f'SQL语句执行影响的行数: {row_count}')

sql = 'SELECT * FROM students'
row_count = cursor.execute(sql)
print(f'SQL语句执行影响的行数: {row_count}')


fetch_all = cursor.fetchall()
print(fetch_all)

# 事务提交
conn.commit()
cursor.close()
conn.close()
