--step1: 确定主题抽取表之间关系
with sale_tmp as (select
    --step2: 抽取字段
    --所谓的抽取指的是把能够支撑本主题计算的指标和维度相关的字段抽取出来
    --维度相关的
    o.dt,  --日期
    s.city_id,
    s.city_name, --城市
    s.trade_area_id,
    s.trade_area_name, --商圈
    s.id as store_id,
    s.store_name, --店铺
    g.brand_id,
    g.brand_name, --品牌
    g.max_class_id,
    g.max_class_name,--大类
    g.mid_class_id,
    g.mid_class_name,--中类
    g.min_class_id,
    g.min_class_name,--小类
--指标相关的
    --订单量
    o.order_id,
    o.goods_id, --订单ID和商品ID
    --金融相关的
    o.order_amount, --订单金额
    o.total_price, --商品金额
    o.plat_fee, --平台收入
--     o.delivery_fee,--配送收入
    o.dispatcher_money, --配送收入
    --判断条件字段
    o.order_from, --订单来源判断条件  有安卓 IOS等之分
    o.evaluation_id, --评价表ID 其不为空表示该订单有评价
    o.geval_scores, --订单评分 根据业务指定计算好中差评
    o.delievery_id, --配送单ID 如果不为空表示该订单是配送单 其他也可以是商家配送 或者用户自提
    o.refund_id, --退款单ID 不为空表示有退款

    --step3: 如果想要对数据去重 可以在这里加上rn函数对指定的字段进行排序 后续计算的时候只去编号为1的即可
    row_number() over(partition by order_id) as order_rn,
    row_number() over(partition by order_id,g.brand_id) as brand_rn,
    row_number() over(partition by order_id,g.max_class_name) as maxclass_rn,
    row_number() over(partition by order_id,g.max_class_name,g.mid_class_name) as midclass_rn,
    row_number() over(partition by order_id,g.max_class_name,g.mid_class_name,g.min_class_name) as minclass_rn,
    --下面分组加入goods_id
    row_number() over(partition by order_id,g.brand_id,o.goods_id) as brand_goods_rn,
    row_number() over(partition by order_id,g.max_class_name,o.goods_id) as maxclass_goods_rn,
    row_number() over(partition by order_id,g.max_class_name,g.mid_class_name,o.goods_id) as midclass_goods_rn,
    row_number() over(partition by order_id,g.max_class_name,g.mid_class_name,g.min_class_name,o.goods_id) as minclass_goods_rn
from yp_dwb.dwb_order_detail o
    left join yp_dwb.dwb_goods_detail g on o.goods_id =g.id
    left join yp_dwb.dwb_shop_detail s  on o.store_id =s.id)
select
--     case when grouping(city_id) =0
--         then city_id else null end as city_id,
--     case when grouping(city_id) =0
--         then city_name else null end as city_name,  --城市
--     case when grouping(trade_area_id) =0
--         then trade_area_id else null end as trade_area_id,
--     case when grouping(trade_area_id) =0
--         then trade_area_name else null end as trade_area_name,   --商圈
--     case when grouping(store_id) =0
--         then store_id else null end as store_id,
--     case when grouping(store_id) =0
--         then store_name else null end as store_name,  --店铺

    --step5: 分组类型判断  如何精准的识别每个分组  笔记上写的有瑕疵
             -- 0   1       1             1          1      0             0            0
     grouping(dt,city_id,trade_area_id,store_id,brand_id,max_class_id,mid_class_id,min_class_id)
from sale_tmp
group by grouping sets(
    --step4: 增强分组聚合
    (dt), --日期
    (dt,city_id,city_name), --日期+城市
    (dt,city_id,city_name,trade_area_id,trade_area_name),--商圈
    (dt,city_id,city_name,trade_area_id,trade_area_name,store_id,store_name),--店铺
    (dt,brand_id,brand_name), --品牌
    (dt,max_class_id,max_class_name), --大类
    (dt,max_class_id,max_class_name,mid_class_id,mid_class_name), --中类
    (dt,max_class_id,max_class_name,mid_class_id,mid_class_name,min_class_id,min_class_name) --小类
);













