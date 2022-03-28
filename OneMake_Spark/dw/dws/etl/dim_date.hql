# 将运行出来的DIM_DATE维度数据上传到宿主机
cd /mnt/docker_share/data/DIM_DATE/2021

#上传文件
[root@node1 2021]# rz
rz waiting to receive.
?a? zmodem ′??.  °′ Ctrl+C ??.
Transferring ._SUCCESS.crc...
  100%       8 bytes    8 bytes/s 00:00:01       0 ′?
Transferring .part-00000-e4fafaa1-1a78-400a-b321-bf634cd712a1-c000.snappy.orc.crc...
  100%      84 bytes   84 bytes/s 00:00:01       0 ′?
Transferring _success...
Transferring _success...
Transferring part-00000-e4fafaa1-1a78-400a-b321-bf634cd712a1-c000.snappy.orc...
  100%       9 KB    9 KB/s 00:00:01       0 ′?

# 进入到Hadoop容器
docker exec -it hadoop bash
source /etc/profile
cd /mnt/docker_share/data/DIM_DATE

# 上传文件夹到HDFS
hdfs dfs -mkdir -p /data/dw/dws/one_make/dim_date/2021
hdfs dfs -put /mnt/docker_share/data/DIM_DATE/2021 /data/dw/dws/one_make/dim_date/

select * from one_make_dws.dim_date;
alter table one_make_dws.dim_date add if not exists partition (year='2021') location '/data/dw/dws/one_make/dim_date/2021';

refresh table one_make_dws.dim_date;