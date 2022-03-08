#! /bin/bash
export LANG=zh_CN.UTF-8
SQOOP_HOME=/usr/bin/sqoop
MYSQL_HOME=/usr/bin/mysql
if [[ $1 == "" ]];then
   TD_DATE=`date -d '1 days ago' "+%Y-%m-%d"`
else
   TD_DATE=$1
fi

if [[ $2 == "" ]];then
   OLD_DATE='2021-08-03'
else
   OLD_DATE=$2
fi

echo ${TD_DATE}
echo ${OLD_DATE}

${MYSQL_HOME} -h192.168.88.80 -p3306 -uroot -p123456 -Dyipin_append -e "
# update t_user_login set login_time = concat('${TD_DATE}', substr(login_time, 11))
# where substr(login_time, 1, 10)='${OLD_DATE}';
insert into t_user_login
select
    id,
    login_user,
    login_type,
    client_id,
    concat('${TD_DATE}', substr(login_time, 11)),
    login_ip,
    logout_time
from t_user_login
where substr(login_time, 1, 10)='${OLD_DATE}';


# update t_store_collect set
#                            update_time=if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
#                            create_time=concat('${TD_DATE}', substr(create_time, 11))
# where substr(create_time, 1, 10)='${OLD_DATE}';
insert into t_store_collect
select
    id,
    user_id,
    store_id,
    create_user,
    concat('${TD_DATE}', substr(create_time, 11)),
    update_user,
    if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
    is_valid
from t_store_collect
where substr(create_time, 1, 10)='${OLD_DATE}';


# update t_goods_collect set update_time=if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
#                            create_time=concat('${TD_DATE}', substr(create_time, 11))
# where substr(create_time, 1, 10)='${OLD_DATE}';
insert into t_goods_collect
select
    id,
    user_id,
    goods_id,
    store_id,
    create_user,
    concat('${TD_DATE}', substr(create_time, 11)),
    update_user,
    if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
    is_valid
from t_goods_collect
where substr(create_time, 1, 10)='${OLD_DATE}';



# update t_shop_cart set update_time=if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
#                        create_time=concat('${TD_DATE}', substr(create_time, 11))
# where substr(create_time, 1, 10)='${OLD_DATE}';
insert into t_shop_cart
select
    id,
    shop_store_id,
    buyer_id,
    goods_id,
    buy_num,
    create_user,
    concat('${TD_DATE}', substr(create_time, 11)),
    update_user,
    if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
    is_valid
from t_shop_cart
where substr(create_time, 1, 10)='${OLD_DATE}';


# update t_shop_order set finnshed_time=if(finnshed_time is not null, concat('${TD_DATE}', substr(finnshed_time, 11)), null),
#                         update_time=if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
#                         create_date=concat('${TD_DATE}', substr(create_date, 11)),
#                         create_time=concat('${TD_DATE}', substr(create_time, 11))
# where substr(create_time, 1, 10)='${OLD_DATE}';
insert into t_shop_order
select
    id,
    order_num,
    buyer_id,
    store_id,
    order_from,
    order_state,
    concat('${TD_DATE}', substr(create_date, 11)),
    if(finnshed_time is not null, concat('${TD_DATE}', substr(finnshed_time, 11)), null),
    is_settlement,
    is_delete,
    evaluation_state,
    way,
    is_stock_up,
    create_user,
    concat('${TD_DATE}', substr(create_time, 11)),
    update_user,
    if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
    is_valid
from t_shop_order
where substr(create_time, 1, 10)='${OLD_DATE}';


# update t_shop_order_group set update_time=if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
#                               create_time=concat('${TD_DATE}', substr(create_time, 11))
# where substr(create_time, 1, 10)='${OLD_DATE}';
insert into t_shop_order_group
select
    id,
    order_id,
    group_id,
    is_pay,
    create_user,
    concat('${TD_DATE}', substr(create_time, 11)),
    update_user,
    if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
    is_valid
from t_shop_order_group
where substr(create_time, 1, 10)='${OLD_DATE}';


# update t_shop_order_goods_details set update_time=if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
#                                       create_time=concat('${TD_DATE}', substr(create_time, 11))
# where substr(create_time, 1, 10)='${OLD_DATE}';
insert into t_shop_order_goods_details
select
    id,
    order_id,
    shop_store_id,
    buyer_id,
    goods_id,
    buy_num,
    goods_price,
    total_price,
    goods_name,
    goods_image,
    goods_specification,
    goods_weight,
    goods_unit,
    goods_type,
    refund_order_id,
    goods_brokerage,
    is_refund,
    create_user,
    concat('${TD_DATE}', substr(create_time, 11)),
    update_user,
    if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
    is_valid
from t_shop_order_goods_details
where substr(create_time, 1, 10)='${OLD_DATE}';


# update t_order_pay set create_date=concat('${TD_DATE}', substr(create_date, 11)),
#                        update_time=if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
#                        create_time=concat('${TD_DATE}', substr(create_time, 11))
# where substr(create_time, 1, 10)='${OLD_DATE}';
insert into t_order_pay
select
    id,
    group_id,
    order_pay_amount,
    concat('${TD_DATE}', substr(create_date, 11)),
    create_user,
    concat('${TD_DATE}', substr(create_time, 11)),
    update_user,
    if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
    is_valid
from t_order_pay
where substr(create_time, 1, 10)='${OLD_DATE}';


# update t_order_delievery_item set update_time=if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
#                                   create_time=concat('${TD_DATE}', substr(create_time, 11))
# where substr(create_time, 1, 10)='${OLD_DATE}';
insert into t_order_delievery_item
select
    id,
    shop_order_id,
    refund_order_id,
    dispatcher_order_type,
    shop_store_id,
    buyer_id,
    circle_master_user_id,
    dispatcher_user_id,
    dispatcher_order_state,
    order_goods_num,
    delivery_fee,
    distance,
    dispatcher_code,
    receiver_name,
    receiver_phone,
    sender_name,
    sender_phone,
    create_user,
    concat('${TD_DATE}', substr(create_time, 11)),
    update_user,
    if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
    is_valid
from t_order_delievery_item
where substr(create_time, 1, 10)='${OLD_DATE}';


# update t_goods_evaluation set update_time=if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
#                               create_time=concat('${TD_DATE}', substr(create_time, 11))
# where substr(create_time, 1, 10)='${OLD_DATE}';
insert into t_goods_evaluation
select
    id,
    user_id,
    store_id,
    order_id,
    geval_scores,
    geval_scores_speed,
    geval_scores_service,
    geval_isanony,
    create_user,
    concat('${TD_DATE}', substr(create_time, 11)),
    update_user,
    if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
    is_valid
from t_goods_evaluation
where substr(create_time, 1, 10)='${OLD_DATE}';


# update t_refund_order set update_time=if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
#                           create_time=concat('${TD_DATE}', substr(create_time, 11))
# where substr(create_time, 1, 10)='${OLD_DATE}';
insert into t_refund_order
select
    id,
    order_id,
    apply_date,
    modify_date,
    refund_reason,
    refund_amount,
    refund_state,
    refuse_refund_reason,
    refund_goods_type,
    refund_shipping_fee,
    create_user,
    concat('${TD_DATE}', substr(create_time, 11)),
    update_user,
    if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
    is_valid
from t_refund_order
where substr(create_time, 1, 10)='${OLD_DATE}';


# update t_order_settle set settlement_create_date=if(settlement_create_date is not null, concat('${TD_DATE}', substr(settlement_create_date, 11)), null),
#                           settle_time=if(settle_time is not null, concat('${TD_DATE}', substr(settle_time, 11)), null),
#                           update_time=if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
#                           create_time=concat('${TD_DATE}', substr(create_time, 11))
# where substr(create_time, 1, 10)='${OLD_DATE}';
insert into t_order_settle
select
    id,
    order_id,
    if(settlement_create_date is not null, concat('${TD_DATE}', substr(settlement_create_date, 11)), null),
    settlement_amount,
    dispatcher_user_id,
    dispatcher_money,
    circle_master_user_id,
    circle_master_money,
    plat_fee,
    store_money,
    status,
    note,
    if(settle_time is not null, concat('${TD_DATE}', substr(settle_time, 11)), null),
    create_user,
    concat('${TD_DATE}', substr(create_time, 11)),
    update_user,
    if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
    is_valid,
    first_commission_user_id,
    first_commission_money,
    second_commission_user_id,
    second_commission_money
from t_order_settle
where substr(create_time, 1, 10)='${OLD_DATE}';


# update t_goods_evaluation_detail set geval_addtime=if(geval_addtime is not null, concat('${TD_DATE}', substr(geval_addtime, 11)), null),
#                                      geval_addtime_superaddition=if(geval_addtime_superaddition is not null, concat('${TD_DATE}', substr(geval_addtime_superaddition, 11)), null),
#                                      geval_explaintime=if(geval_explaintime is not null, concat('${TD_DATE}', substr(geval_explaintime, 11)), null),
#                                      update_time=if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
#                                      geval_explaintime_superaddition=if(geval_explaintime_superaddition is not null, concat('${TD_DATE}', substr(geval_explaintime_superaddition, 11)), null),
#                                      create_time=concat('${TD_DATE}', substr(create_time, 11))
# where substr(create_time, 1, 10)='${OLD_DATE}';
insert into t_goods_evaluation_detail
select
    id,
    user_id,
    store_id,
    goods_id,
    order_id,
    order_goods_id,
    geval_scores_goods,
    geval_content,
    geval_content_superaddition,
    if(geval_addtime is not null, concat('${TD_DATE}', substr(geval_addtime, 11)), null),
    if(geval_addtime_superaddition is not null, concat('${TD_DATE}', substr(geval_addtime_superaddition, 11)), null),
    geval_state,
    geval_remark,
    revert_state,
    geval_explain,
    geval_explain_superaddition,
    if(geval_explaintime is not null, concat('${TD_DATE}', substr(geval_explaintime, 11)), null),
    if(geval_explaintime_superaddition is not null, concat('${TD_DATE}', substr(geval_explaintime_superaddition, 11)), null),
    create_user,
    concat('${TD_DATE}', substr(create_time, 11)),
    update_user,
    if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
    is_valid
from t_goods_evaluation_detail
where substr(create_time, 1, 10)='${OLD_DATE}';



# update t_shop_order_address_detail set pay_time=if(pay_time is not null, concat('${TD_DATE}', substr(pay_time, 11)), null),
#                                        receive_time=if(receive_time is not null, concat('${TD_DATE}', substr(receive_time, 11)), null),
#                                        delivery_begin_time=if(delivery_begin_time is not null, concat('${TD_DATE}', substr(delivery_begin_time, 11)), null),
#                                         arrive_store_time=if(arrive_store_time is not null, concat('${TD_DATE}', substr(arrive_store_time, 11)), null),
#                                         arrive_time=if(arrive_time is not null, concat('${TD_DATE}', substr(arrive_time, 11)), null),
#                                        update_time=if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
#                                        create_time=concat('${TD_DATE}', substr(create_time, 11))
# where substr(create_time, 1, 10)='${OLD_DATE}';
insert into t_shop_order_address_detail
select
    id,
    order_amount,
    discount_amount,
    goods_amount,
    is_delivery,
    buyer_notes,
    if(pay_time is not null, concat('${TD_DATE}', substr(pay_time, 11)), null),
    if(receive_time is not null, concat('${TD_DATE}', substr(receive_time, 11)), null),
    if(delivery_begin_time is not null, concat('${TD_DATE}', substr(delivery_begin_time, 11)), null),
    if(arrive_store_time is not null, concat('${TD_DATE}', substr(arrive_store_time, 11)), null),
    if(arrive_time is not null, concat('${TD_DATE}', substr(arrive_time, 11)), null),
    create_user,
    concat('${TD_DATE}', substr(create_time, 11)),
    update_user,
    if(update_time is not null, concat('${TD_DATE}', substr(update_time, 11)), null),
    is_valid
from t_shop_order_address_detail
where substr(create_time, 1, 10)='${OLD_DATE}';


select * from t_shop_order_address_detail;
"
wait
echo 'success!'