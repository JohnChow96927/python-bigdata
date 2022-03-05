-- 下单次数, 下单件数, 下单金额
-- 表: dwb_order_detail
-- 字段: order_id buy_num(购买件数) total_price 金额
-- 被支付次数, 被支付件数, 被支付金额
-- 表:
-- order_state订单状态(除了1, 7皆为已支付)
-- is_pay 支付状态, 为1的为已支付, 优先使用这个
-- 字段: order_id buy_num(购买件数) total_price 金额
-- 被退款次数, 被退款件数, 被退款金额
-- 表: dwb_order_detail
-- 过滤条件: 如何判断订单是否退款
-- refund_id 如果is not null 表明有退款
-- 字段: order_id buy_num(购买件数) total_price 金额
-- 被加入购物车次数, 被加入购物车件数
-- 表: fact_shop_cart
-- 字段: id 次数 buy_num(件数)
-- 被收藏次数
-- 表: fact_goods_collect
-- 字段: id
-- 好评数, 中评数, 差评数
-- 表: fact_goods_evaluation_detail
-- 字段: geval_scores_goods(商品评分): 具体问业务


-- 维度:
-- 日期(day) + 商品
-- 表: dwb_goods_detail
-- 字段: dt goods_id

with order_base as (
    select dt,
           order_id,    -- 订单id
           goods_id,    -- 商品id
           goods_name,  -- 商品名称
           buy_num,     -- 购买数量
           total_price, -- 商品总金额(数量*单价)
           is_pay,      -- 支付状态(1为已支付)
           row_number() over (partition by order_id, goods_id) as rn
    from yp_dwb.dwb_order_detail
),
     order_count as (
         select dt,
                goods_id   as    sku_id,
                goods_name as    sku_name,
                count(order_id)  order_count,
                sum(buy_num)     order_num,
                sum(total_price) order_amount
         from order_base
         where rn = 1
         group by dt, goods_id, goods_name
     ),
     pay_base as (
         select *,
                row_number()
                    over (partition by order_id, goods_id) rn
         from yp_dwb.dwb_order_detail
         where is_pay = 1
     ),
     payment_count as (
         select dt,
                goods_id         sku_id,
                goods_name       sku_name,
                count(order_id)  payment_count,
                sum(buy_num)     payment_num,
                sum(total_price) payment_amount
         from pay_base
         where rn = 1
         group by dt, goods_id, goods_name
     ),
     refund_base as (
         select *,
                row_number() over (partition by order_id, goods_id) rn
         from yp_dwb.dwb_order_detail
         where refund_id is not null
     ),
     refund_count as (
         select dt,
                goods_id            sku_id,
                goods_name          sku_name,
                count(order_id)     refund_count,
                sum(buy_num)        refund_num,
                sum(total_price) as refund_amount
         from refund_base
         where rn = 1
         group by dt, goods_id, goods_name
     ),
     cart_count as (
         select substring(create_time, 1, 10) dt,
                goods_id                      sku_id,
                count(id)                     cart_count,
                sum(buy_num)                  cart_num
         from yp_dwd.fact_shop_cart
         where end_date = '9999-99-99'
         group by substring(create_time, 1, 10), goods_id
     ),
     favor_count as (
         select substring(c.create_time, 1, 10) dt,
                goods_id                        sku_id,
                count(c.id)                     favor_count
         from yp_dwd.fact_goods_collect c
         where end_date = '9999-99-99'
         group by substring(c.create_time, 1, 10), goods_id
     ),
     evaluation_count as (
         select substring(geval_addtime, 1, 10)                                       dt,
                e.goods_id                                                            sku_id,
                count(if(geval_scores_goods >= 9, 1, null))                           evaluation_good_count,
                count(if(geval_scores_goods > 6 and geval_scores_goods < 9, 1, null)) evaluation_mid_count,
                count(if(geval_scores_goods <= 6, 1, null))                           evaluation_bad_count
         from yp_dwd.fact_goods_evaluation_detail e
         group by substring(geval_addtime, 1, 10), e.goods_id
     ),
     unionall as (
         select dt,
                sku_id,
                sku_name,
                order_count,
                order_num,
                order_amount,
                0 as payment_count,
                0 as payment_num,
                0 as payment_amount,
                0 as refund_count,
                0 as refund_num,
                0 as refund_amount,
                0 as cart_count,
                0 as cart_num,
                0 as favor_count,
                0 as evaluation_good_count,
                0 as evaluation_mid_count,
                0 as evaluation_bad_count
         from order_count
         union all
         select dt,
                sku_id,
                sku_name,
                0 as order_count,
                0 as order_num,
                0 as order_amount,
                payment_count,
                payment_num,
                payment_amount,
                0 as refund_count,
                0 as refund_num,
                0 as refund_amount,
                0 as cart_count,
                0 as cart_num,
                0 as favor_count,
                0 as evaluation_good_count,
                0 as evaluation_mid_count,
                0 as evaluation_bad_count
         from payment_count
         union all
         select dt,
                sku_id,
                sku_name,
                0 as order_count,
                0 as order_num,
                0 as order_amount,
                0 as payment_count,
                0 as payment_num,
                0 as payment_amount,
                refund_count,
                refund_num,
                refund_amount,
                0 as cart_count,
                0 as cart_num,
                0 as favor_count,
                0 as evaluation_good_count,
                0 as evaluation_mid_count,
                0 as evaluation_bad_count
         from refund_count
         union all
         select dt,
                sku_id,
                null as sku_name,
                0    as order_count,
                0    as order_num,
                0    as order_amount,
                0    as payment_count,
                0    as payment_num,
                0    as payment_amount,
                0    as refund_count,
                0    as refund_num,
                0    as refund_amount,
                cart_count,
                cart_num,
                0    as favor_count,
                0    as evaluation_good_count,
                0    as evaluation_mid_count,
                0    as evaluation_bad_count
         from cart_count
         union all
         select dt,
                sku_id,
                null as sku_name,
                0    as order_count,
                0    as order_num,
                0    as order_amount,
                0    as payment_count,
                0    as payment_num,
                0    as payment_amount,
                0    as refund_count,
                0    as refund_num,
                0    as refund_amount,
                0    as cart_count,
                0    as cart_num,
                favor_count,
                0    as evaluation_good_count,
                0    as evaluation_mid_count,
                0    as evaluation_bad_count
         from favor_count
         union all
         select dt,
                sku_id,
                null as sku_name,
                0    as order_count,
                0    as order_num,
                0    as order_amount,
                0    as payment_count,
                0    as payment_num,
                0    as payment_amount,
                0    as refund_count,
                0    as refund_num,
                0    as refund_amount,
                0    as cart_count,
                0    as cart_num,
                0    as favor_count,
                evaluation_good_count,
                evaluation_mid_count,
                evaluation_bad_count
         from evaluation_count
     )
select dt,
       sku_id,
       max(sku_name)              as sku_name,
       sum(order_count)           as order_count,
       sum(order_num)             as order_num,
       sum(order_amount)          as order_amount,
       sum(payment_count)         as payment_count,
       sum(payment_num)           as payment_num,
       sum(payment_amount)        as payment_amount,
       sum(refund_count)          as refund_count,
       sum(refund_num)            as refund_num,
       sum(refund_amount)         as refund_amount,
       sum(cart_count)            as cart_count,
       sum(cart_num)              as cart_num,
       sum(favor_count)           as favor_count,
       sum(evaluation_good_count) as evaluation_good_count,
       sum(evaluation_mid_count)  as evaluation_mid_count,
       sum(evaluation_bad_count)  as evaluation_bad_count
from unionall
group by dt, sku_id
order by dt, sku_id;

