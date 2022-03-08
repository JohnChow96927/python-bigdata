#! /bin/bash
#SQOOP_HOME=/opt/cloudera/parcels/CDH-6.2.1-1.cdh6.2.1.p0.1425774/bin/sqoop
export LANG=zh_CN.UTF-8
SQOOP_HOME=/usr/bin/sqoop
if [[ $1 == "" ]];then
   TD_DATE=`date -d '1 days ago' "+%Y-%m-%d"`
else
   TD_DATE=$1
fi

echo '========================================'
echo '==============开始增量导入==============='
echo '========================================'

# 先删除dt分区
${HIVE_HOME} -S -e "
   ALTER TABLE yp_ods.t_goods_evaluation DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_user_login DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_order_pay DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_store DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_trade_area DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_location DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_goods DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_goods_class DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_brand DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_shop_order DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_shop_order_address_detail DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_order_settle DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_refund_order DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_shop_order_group DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_shop_order_goods_details DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_shop_cart DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_store_collect DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_goods_collect DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_order_delievery_item DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_goods_evaluation_detail DROP IF EXISTS PARTITION (dt='${TD_DATE}');
   ALTER TABLE yp_ods.t_trade_record DROP IF EXISTS PARTITION (dt='${TD_DATE}');
"

# 全量表，无变化无需更新
# /usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
# --connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?enabledTLSProtocols=TLSv1.2&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
# --username root \
# --password 123456 \
# --query "select * from t_district where 1=1 and  \$CONDITIONS" \
# --hcatalog-database yp_ods \
# --hcatalog-table t_district \
# -m 1
# wait

# /usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
# --connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
# --username root \
# --password 123456 \
# --query "select * from t_date where 1=1 and  \$CONDITIONS" \
# --hcatalog-database yp_ods \
# --hcatalog-table t_date \
# -m 1
# wait

# 增量表
/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_goods_evaluation/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_goods_evaluation where 1=1 and (create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_goods_evaluation \
-m 1
wait


/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_user_login/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_user_login where 1=1 and (login_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_user_login \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_order_pay/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_order_pay where 1=1 and (create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_order_pay \
-m 1
wait

# 新增和更新同步
/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_store/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_store where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_store \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_trade_area/dt=${TD_DATE}
wait
/usr/bin/sqoop import -Dorg.apache.sqoop.splitter.allow_text_splitter=true -Dorg.apache.sqoop.db.type=mysql \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_trade_area where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS order by id" \
--hcatalog-database yp_ods \
--hcatalog-table t_trade_area \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_location/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_location where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_location \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_goods/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_goods where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_goods \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_goods_class/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_goods_class where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_goods_class \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_brand/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_brand where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_brand \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_shop_order/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_shop_order where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_shop_order \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_shop_order_address_detail/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_shop_order_address_detail where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_shop_order_address_detail \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_order_settle/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_order_settle where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_order_settle \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_refund_order/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_refund_order where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_refund_order \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_shop_order_group/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_shop_order_group where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_shop_order_group \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_shop_order_goods_details/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_shop_order_goods_details where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_shop_order_goods_details \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_shop_cart/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_shop_cart where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_shop_cart \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_store_collect/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_store_collect where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_store_collect \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_goods_collect/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_goods_collect where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_goods_collect \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_order_delievery_item/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_order_delievery_item where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_order_delievery_item \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_goods_evaluation_detail/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_goods_evaluation_detail where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_goods_evaluation_detail \
-m 1
wait

/usr/bin/hdfs dfs -rmr /user/hive/warehouse/yp_ods.db/t_trade_record/dt=${TD_DATE}
wait
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin_append?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select *, '${TD_DATE}' as dt from t_trade_record where 1=1 and ((create_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59') or (update_time between '${TD_DATE} 00:00:00' and '${TD_DATE} 23:59:59')) and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_trade_record \
-m 1
wait

echo '========================================'
echo '=================success==============='
echo '========================================'