drop table if exists test.dws_user_daycount_john;
-- 建表(Hive)
create table if not exists test.dws_user_daycount_john
(
    user_id
    string
    comment
    '用户id',
    login_count
    bigint
    comment
    '登录次数',
    store_collect_count
    bigint
    comment
    '店铺收藏数量',
    goods_collect_count
    bigint
    comment
    '商品收藏数量',
    cart_count
    bigint
    comment
    '加入购物车次数',
    cart_amount
    decimal
(
    38,
    2
) comment '加入购物车金额',
    order_count bigint comment '下单次数',
    order_amount decimal
(
    38,
    2
) comment '下单金额',
    payment_count bigint comment '支付次数',
    payment_amount decimal
(
    38,
    2
) comment '支付金额'
    ) comment '每日用户行为'
    partitioned by
(
    dt string
)
    row format delimited fields terminated by '\t'
    stored as orc tblproperties
(
    'orc.compress' = 'SNAPPY'
);


-- ========== 链式CTE求注入dws层结果表 ==========
-- 登录次数
with login_count as (
    select count(id)  as login_count,
           login_user as user_id,
           dt
    from yp_dwd.fact_user_login
    group by login_user, dt
),
     -- 店铺收藏数
     store_collect_count as (
         select count(id)                     as store_collect_count,
                user_id,
                substring(create_time, 1, 10) as dt
         from yp_dwd.fact_store_collect
         where end_date = '9999-99-99'
         group by user_id, substring(create_time, 1, 10)
     ),
     -- 商品收藏数量
     goods_collect_count as (
         select count(id)                     as goods_collect_count,
                user_id,
                substring(create_time, 1, 10) as dt
         from yp_dwd.fact_goods_collect
         where end_date = '9999-99-99'
         group by user_id, substring(create_time, 1, 10)
     ),
     -- 加购物车次数及金额
     cart_count_amount as (
         select count(cart.id)                     as cart_count,
                sum(g.goods_promotion_price)       as cart_amount,
                buyer_id                           as user_id,
                substring(cart.create_time, 1, 10) as dt
         from yp_dwd.fact_shop_cart cart,
              yp_dwb.dwb_goods_detail g
         where cart.end_date = '9999-99-99'
           and cart.goods_id = g.id
         group by buyer_id, substring(cart.create_time, 1, 10)
     ),
     -- 下单次数及金额
     order_count_amount as (
         select count(o.id)                     as order_count,
                sum(order_amount)               as order_amount,
                buyer_id                        as user_id,
                substring(o.create_time, 1, 10) as dt
         from yp_dwd.fact_shop_order o,
              yp_dwd.fact_shop_order_address_detail od
         where o.id = od.id
           and o.is_valid = 1
           and o.end_date = '9999-99-99'
           and od.end_date = '9999-99-99'
         group by buyer_id, substring(o.create_time, 1, 10)
     ),
     -- 支付次数及金额
     payment_count_amount as (
         select count(id)                     as payment_count,
                sum(trade_true_amount)        as payment_amount,
                user_id,
                substring(create_time, 1, 10) as dt
         from yp_dwd.fact_trade_record
         where is_valid = 1
           and trade_type in (1, 11)
           and status = 1
         group by user_id, substring(create_time, 1, 10)
     ),
     -- union all表
     unionall as (
         -- 登录次数
         select user_id,
                dt,
                lc.login_count,
                0 store_collect_count,
                0 goods_collect_count,
                0 cart_count,
                0 cart_amount,
                0 order_count,
                0 order_amount,
                0 payment_count,
                0 payment_amount
         from login_count lc
         union all
         -- 店铺收藏数
         select user_id,
                dt,
                0 login_count,
                scc.store_collect_count,
                0 goods_collect_count,
                0 cart_count,
                0 cart_amount,
                0 order_count,
                0 order_amount,
                0 payment_count,
                0 payment_amount
         from store_collect_count scc
         union all
         -- 商品收藏数
         select user_id,
                dt,
                0 login_count,
                0 store_collect_count,
                gcc.goods_collect_count,
                0 cart_count,
                0 cart_amount,
                0 order_count,
                0 order_amount,
                0 payment_count,
                0 payment_amount
         from goods_collect_count gcc
         union all
         -- 购物车加车次数及金额
         select user_id,
                dt,
                0 login_count,
                0 store_collect_count,
                0 goods_collect_count,
                cca.cart_count,
                cca.cart_amount,
                0 order_count,
                0 order_amount,
                0 payment_count,
                0 payment_amount
         from cart_count_amount cca
         union all
         -- 下单次数及金额
         select user_id,
                dt,
                0 login_count,
                0 store_collect_count,
                0 goods_collect_count,
                0 cart_count,
                0 cart_amount,
                oca.order_count,
                oca.order_amount,
                0 payment_count,
                0 payment_amount
         from order_count_amount oca
         union all
         -- 支付次数及金额
         select user_id,
                dt,
                0 login_count,
                0 store_collect_count,
                0 goods_collect_count,
                0 cart_count,
                0 cart_amount,
                0 order_count,
                0 order_amount,
                pca.payment_count,
                pca.payment_amount
         from payment_count_amount pca
     )
-- sum压缩合并出结果表
select user_id,
       dt,
       sum(login_count)         login_count,
       sum(store_collect_count) store_collect_count,
       sum(goods_collect_count) goods_collect_count,
       sum(cart_count)          cart_count,
       sum(cart_amount)         cart_amount,
       sum(order_count)         order_count,
       sum(order_amount)        order_amount,
       sum(payment_count)       payment_count,
       sum(payment_amount)      payment_amount
from unionall
group by user_id, dt
order by user_id, dt
;



-- ========== full join合并方式 ==========
-- 登录次数
with login_count as (
    select count(id)  as login_count,
           login_user as user_id,
           dt
    from yp_dwd.fact_user_login
    group by login_user, dt
),
     -- 店铺收藏数
     store_collect_count as (
         select count(id)                     as store_collect_count,
                user_id,
                substring(create_time, 1, 10) as dt
         from yp_dwd.fact_store_collect
         where end_date = '9999-99-99'
         group by user_id, substring(create_time, 1, 10)
     ),
     -- 商品收藏数量
     goods_collect_count as (
         select count(id)                     as goods_collect_count,
                user_id,
                substring(create_time, 1, 10) as dt
         from yp_dwd.fact_goods_collect
         where end_date = '9999-99-99'
         group by user_id, substring(create_time, 1, 10)
     ),
     -- 加购物车次数及金额
     cart_count_amount as (
         select count(cart.id)                     as cart_count,
                sum(g.goods_promotion_price)       as cart_amount,
                buyer_id                           as user_id,
                substring(cart.create_time, 1, 10) as dt
         from yp_dwd.fact_shop_cart cart,
              yp_dwb.dwb_goods_detail g
         where cart.end_date = '9999-99-99'
           and cart.goods_id = g.id
         group by buyer_id, substring(cart.create_time, 1, 10)
     ),
     -- 下单次数及金额
     order_count_amount as (
         select count(o.id)                     as order_count,
                sum(order_amount)               as order_amount,
                buyer_id                        as user_id,
                substring(o.create_time, 1, 10) as dt
         from yp_dwd.fact_shop_order o,
              yp_dwd.fact_shop_order_address_detail od
         where o.id = od.id
           and o.is_valid = 1
           and o.end_date = '9999-99-99'
           and od.end_date = '9999-99-99'
         group by buyer_id, substring(o.create_time, 1, 10)
     ),
     -- 支付次数及金额
     payment_count_amount as (
         select count(id)                     as payment_count,
                sum(trade_true_amount)        as payment_amount,
                user_id,
                substring(create_time, 1, 10) as dt
         from yp_dwd.fact_trade_record
         where is_valid = 1
           and trade_type in (1, 11)
           and status = 1
         group by user_id, substring(create_time, 1, 10)
     ),
     -- full join 临时表
     full_join_temp as (
         select coalesce(login_count.user_id,
                         store_collect_count.user_id,
                         goods_collect_count.user_id,
                         cart_count_amount.user_id,
                         order_count_amount.user_id,
                         payment_count_amount.user_id
                    )      as user_id,
                coalesce(login_count.dt,
                         store_collect_count.dt,
                         goods_collect_count.dt,
                         cart_count_amount.dt,
                         order_count_amount.dt,
                         payment_count_amount.dt
                    )      as dt,
                coalesce(
                        login_count.login_count,
                        0) as login_count,
                coalesce(
                        store_collect_count.store_collect_count,
                        0) as store_collect_count,
                coalesce(
                        goods_collect_count.goods_collect_count,
                        0) as goods_collect_count,
                coalesce(
                        cart_count_amount.cart_count,
                        0) as cart_count,
                coalesce(
                        cart_count_amount.cart_amount,
                        0) as cart_amount,
                coalesce(
                        order_count_amount.order_count,
                        0) as order_count,
                coalesce(
                        order_count_amount.order_amount,
                        0) as order_amount,
                coalesce(
                        payment_count_amount.payment_count,
                        0) as payment_count,
                coalesce(
                        payment_count_amount.payment_amount,
                        0) as payment_amount
         from login_count
                  full join store_collect_count
                            on login_count.user_id = store_collect_count.user_id
                                and login_count.dt = store_collect_count.dt
                  full join goods_collect_count
                            on login_count.user_id = goods_collect_count.user_id
                                and login_count.dt = goods_collect_count.dt
                  full join cart_count_amount
                            on login_count.user_id = cart_count_amount.user_id
                                and login_count.dt = cart_count_amount.dt
                  full join order_count_amount
                            on login_count.user_id = order_count_amount.user_id
                                and login_count.dt = order_count_amount.dt
                  full join payment_count_amount
                            on login_count.user_id = payment_count_amount.user_id
                                and login_count.dt = payment_count_amount.dt
     )
select user_id,
       dt,
       sum(login_count)         login_count,
       sum(store_collect_count) store_collect_count,
       sum(goods_collect_count) goods_collect_count,
       sum(cart_count)          cart_count,
       sum(cart_amount)         cart_amount,
       sum(order_count)         order_count,
       sum(order_amount)        order_amount,
       sum(payment_count)       payment_count,
       sum(payment_amount)      payment_amount
from full_join_temp
group by user_id, dt
order by user_id, dt
;

