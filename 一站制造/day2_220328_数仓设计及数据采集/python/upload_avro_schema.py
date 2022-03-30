#!/usr/bin/env python
# @Time : 2021/7/20 15:46
# @desc :
__coding__ = "utf-8"
__author__ = "itcast"

# import pyhdfs
import logging
import os

workhome = '/opt/sqoop/one_make'
hdfs_schema_dir = '/data/dw/ods/one_make/avsc'
biz_date = '20210101'
biz_fmt_date = '2021-01-01'
local_schema_backup_filename = 'schema_%s.tar.gz' % biz_date
hdfs_schema_backup_filename = '%s/avro_schema_%s.tar.gz' % (hdfs_schema_dir, biz_date)
log_file = '%s/log/upload_avro_schema_%s.log' % (workhome, biz_fmt_date)

# append log to file
logging.basicConfig(level=logging.INFO,
                    filename=log_file,
                    filemode='a',
                    format='%(asctime)s - %(pathname)s[line:%(lineno)d] - %(levelname)s: %(message)s')

os.system('source /etc/profile')
os.system('cd %s' % workhome)

#  hadoop fs [generic options] [-test -[defsz] <path>]
# -test -[defsz] <path> :
#   Answer various questions about <path>, with result via exit status.
#     -d  return 0 if <path> is a directory.
#     -e  return 0 if <path> exists.
#     -f  return 0 if <path> is a file.
#     -s  return 0 if file <path> is greater than zero bytes in size.
#     -z  return 0 if file <path> is zero bytes in size, else return 1.
logging.info('Check if the HDFS Avro schema directory %s...', hdfs_schema_dir)
# hdfs = pyhdfs.HdfsClient(hosts="node1,9000", user_name="hdfs")
# print(hdfs.listdir('/'))
# hdfs dfs -test -e ${hdfs_schema_dir} > /dev/null
commStatus = os.system('hdfs dfs -test -e %s > /dev/null' % hdfs_schema_dir)
if commStatus is not 0:
    logging.info('Path: %s is not exists. Create a new one.', hdfs_schema_dir)
    logging.info('hdfs dfs -mkdir -p %s', hdfs_schema_dir)
    os.system('hdfs dfs -mkdir -p %s' % hdfs_schema_dir)

logging.info('Check if the file %s/CISS4_CISS_BASE_AREAS.avsc has uploaded to the HFDS...', hdfs_schema_dir)
commStatus = os.system('hdfs dfs -test -e %s/CISS4_CISS_BASE_AREAS.avsc > /dev/null' % hdfs_schema_dir)
if commStatus is not 0:
    logging.info('Upload all the .avsc schema file.')
    logging.info('hdfs dfs -put %s/java_code/*.avsc %s', workhome, hdfs_schema_dir)
    os.system('hdfs dfs -put %s/java_code/*.avsc %s' % (workhome, hdfs_schema_dir))

# backup
logging.info('Check if the backup tar.gz file has generated in the local server...')
commStatus = os.system('[ -e %s ]' % local_schema_backup_filename)
if commStatus is not 0:
    logging.info('package and compress the schema files')
    logging.info('tar -czf %s ./java_code/*.avsc', local_schema_backup_filename)
    os.system('tar -czf %s ./java_code/*.avsc' % local_schema_backup_filename)

logging.info('Check if the backup tar.gz file has upload to the HDFS...')
commStatus = os.system('hdfs dfs -test -e %s > /dev/null' % hdfs_schema_backup_filename)
if commStatus is not 0:
    logging.info('upload the schema package file to HDFS')
    logging.info('hdfs dfs -put %s %s', local_schema_backup_filename, hdfs_schema_backup_filename)
    os.system('hdfs dfs -put %s %s' %(local_schema_backup_filename, hdfs_schema_backup_filename))
