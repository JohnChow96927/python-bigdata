#!/usr/bin/env bash
# /bin/bash
biz_date=20210101
biz_fmt_date=2021-01-01
dw_parent_dir=/data/dw/ods/one_make/full_imp
workhome=/opt/sqoop/one_make
full_imp_tables=${workhome}/full_import_tables.txt

mkdir ${workhome}/log

orcl_srv=oracle.bigdata.cn
orcl_port=1521
orcl_sid=helowin
orcl_user=ciss
orcl_pwd=123456

sqoop_import_params="sqoop import -Dmapreduce.job.user.classpath.first=true --outdir ${workhome}/java_code --as-avrodatafile"
sqoop_jdbc_params="--connect jdbc:oracle:thin:@${orcl_srv}:${orcl_port}:${orcl_sid} --username ${orcl_user} --password ${orcl_pwd}"

# load hadoop/sqoop env
source /etc/profile

while read p; do
    # parallel execution import
    ${sqoop_import_params} ${sqoop_jdbc_params} --target-dir ${dw_parent_dir}/${p}/${biz_date} --table ${p^^} -m 1 &
    cur_time=`date "+%F %T"`
    echo "${cur_time}: ${sqoop_import_params} ${sqoop_jdbc_params} --target-dir ${dw_parent_dir}/${p}/${biz_date} --table ${p} -m 1 &" >> ${workhome}/log/${biz_fmt_date}_full_imp.log
    sleep 15
done < ${full_imp_tables}