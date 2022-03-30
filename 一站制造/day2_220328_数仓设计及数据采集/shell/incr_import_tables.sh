#!/usr/bin/env bash
# 编写SHELL脚本的时候要特别小心，特别是编写SQL的条件，如果中间加了空格，就会导致命令执行失败
# /bin/bash
biz_date=20210101
biz_fmt_date=2021-01-01
dw_parent_dir=/data/dw/ods/one_make/incr_imp
workhome=/opt/sqoop/one_make
incr_imp_tables=${workhome}/incr_import_tables.txt

orcl_srv=oracle.bigdata.cn
orcl_port=1521
orcl_sid=helowin
orcl_user=ciss
orcl_pwd=123456

mkdir ${workhome}/log

sqoop_condition_params="--where \"'${biz_fmt_date}'=to_char(CREATE_TIME,'yyyy-mm-dd')\""
sqoop_import_params="sqoop import -Dmapreduce.job.user.classpath.first=true --outdir ${workhome}/java_code --as-avrodatafile"
sqoop_jdbc_params="--connect jdbc:oracle:thin:@${orcl_srv}:${orcl_port}:${orcl_sid} --username ${orcl_user} --password ${orcl_pwd}"

# load hadoop/sqoop env
source /etc/profile

while read p; do
    # clean old directory in HDFS
    hdfs dfs -rm -r ${dw_parent_dir}/${p}/${biz_date}
    
    # parallel execution import
    ${sqoop_import_params} ${sqoop_jdbc_params} --target-dir ${dw_parent_dir}/${p}/${biz_date} --table ${p^^} ${sqoop_condition_params} -m 1 &
    cur_time=`date "+%F %T"`
    echo "${cur_time}: ${sqoop_import_params} ${sqoop_jdbc_params} --target-dir ${dw_parent_dir}/${p}/${biz_date} --table ${p} ${sqoop_condition_params} -m 1 &" >> ${workhome}/log/${biz_fmt_date}_incr_imp.log
    sleep 30
    
done < ${incr_imp_tables}