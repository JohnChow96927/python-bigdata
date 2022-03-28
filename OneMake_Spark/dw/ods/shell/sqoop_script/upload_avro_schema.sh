#!/usr/bin/env bash
# 上传
# /bin/bash
workhome=/opt/sqoop/one_make
hdfs_schema_dir=/data/dw/ods/one_make/avsc
biz_date=20210101
biz_fmt_date=2021-01-01
local_schema_backup_filename=schema_${biz_date}.tar.gz
hdfs_schema_backup_filename=${hdfs_schema_dir}/avro_schema_${biz_date}.tar.gz
log_file=${workhome}/log/upload_avro_schema_${biz_fmt_date}.log

# 打印日志
log() {
    cur_time=`date "+%F %T"`
    echo "${cur_time} $*" >> ${log_file}
}

source /etc/profile
cd ${workhome}

#  hadoop fs [generic options] [-test -[defsz] <path>]
# -test -[defsz] <path> :
#   Answer various questions about <path>, with result via exit status.
#     -d  return 0 if <path> is a directory.
#     -e  return 0 if <path> exists.
#     -f  return 0 if <path> is a file.
#     -s  return 0 if file <path> is greater than zero bytes in size.
#     -z  return 0 if file <path> is zero bytes in size, else return 1.

log "Check if the HDFS Avro schema directory ${hdfs_schema_dir}..."
hdfs dfs -test -e ${hdfs_schema_dir} > /dev/null

if [ $? != 0 ]; then
    log "Path: ${hdfs_schema_dir} is not exists. Create a new one."
    log "hdfs dfs -mkdir -p ${hdfs_schema_dir}"
    hdfs dfs -mkdir -p ${hdfs_schema_dir}
fi

log "Check if the file ${hdfs_schema_dir}/CISS4_CISS_BASE_AREAS.avsc has uploaded to the HFDS..."
hdfs dfs -test -e ${hdfs_schema_dir}/CISS4_CISS_BASE_AREAS.avsc.avsc > /dev/null
if [ $? != 0 ]; then
    log "Upload all the .avsc schema file."
    log "hdfs dfs -put ${workhome}/java_code/*.avsc ${hdfs_schema_dir}"
    hdfs dfs -put ${workhome}/java_code/*.avsc ${hdfs_schema_dir}
fi

# backup
log "Check if the backup tar.gz file has generated in the local server..." 
if [ ! -e ${local_schema_backup_filename} ]; then
    log "package and compress the schema files"
    log "tar -czf ${local_schema_backup_filename} ./java_code/*.avsc"
    tar -czf ${local_schema_backup_filename} ./java_code/*.avsc
fi

log "Check if the backup tar.gz file has upload to the HDFS..."
hdfs dfs -test -e ${hdfs_schema_backup_filename} > /dev/null
if [ $? != 0 ]; then
    log "upload the schema package file to HDFS"
    log "hdfs dfs -put ${local_schema_backup_filename} ${hdfs_schema_backup_filename}"
    hdfs dfs -put ${local_schema_backup_filename} ${hdfs_schema_backup_filename}
fi