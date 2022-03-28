#!/usr/bin/env python
# @Time : 2021/7/20 15:19
# @desc :
__coding__ = "utf-8"
__author__ = "itcast"

import os
import subprocess
import datetime
import time
import logging

biz_date = '20210101'
biz_fmt_date = '2021-01-01'
dw_parent_dir = '/data/dw/ods/one_make/incr_imp'
workhome = '/opt/sqoop/one_make'
incr_imp_tables = workhome + '/incr_import_tables.txt'
if os.path.exists(workhome + '/log'):
    os.system('make ' + workhome + '/log')

orcl_srv = 'oracle.bigdata.cn'
orcl_port = '1521'
orcl_sid = 'helowin'
orcl_user = 'ciss'
orcl_pwd = '123456'

sqoop_import_params = 'sqoop import -Dmapreduce.job.user.classpath.first=true --outdir %s/java_code --as-avrodatafile' % workhome
sqoop_jdbc_params = '--connect jdbc:oracle:thin:@%s:%s:%s --username %s --password %s' % (orcl_srv, orcl_port, orcl_sid, orcl_user, orcl_pwd)

# load hadoop/sqoop env
subprocess.call("source /etc/profile", shell=True)
print('executing...')
# read file
fr = open(incr_imp_tables)
for line in fr.readlines():
    tblName = line.rstrip('\n')
    # clean old directory in HDFS
    hdfs_command = 'hdfs dfs -rm -r %s/%s/%s' % (dw_parent_dir, tblName, biz_date)
    # parallel execution import
    # ${sqoop_import_params} ${sqoop_jdbc_params} --target-dir ${dw_parent_dir}/${p}/${biz_date} --table ${p^^} -m 1 &
    # sqoopImportCommand = f''' {sqoop_import_params} {sqoop_jdbc_params} --target-dir {dw_parent_dir}/{tblName}/{biz_date} --table {tblName.upper()} -m 1 &'''
    sqoopImportCommand = '''
    %s %s --target-dir %s/%s/%s --table %s -m 1 &
    ''' % (sqoop_import_params, sqoop_jdbc_params, dw_parent_dir, tblName, biz_date, tblName.upper())
    # parallel execution import
    subprocess.call(sqoopImportCommand, shell=True)
    # cur_time=`date "+%F %T"`
    # cur_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    logging.basicConfig(level=logging.INFO,
                        filename='%s/log/%s_full_imp.log' % (workhome, biz_fmt_date),
                        filemode='a',
                        format='%(asctime)s - %(pathname)s[line:%(lineno)d] - %(levelname)s: %(message)s')
    # logging.info(cur_time + ' : ' + sqoopImportCommand)
    logging.info(sqoopImportCommand)
    time.sleep(15)
