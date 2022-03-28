
-- trvl_exp_id	差旅报销单ID
-- ss_id	服务网点ID
-- srv_user_id	服务人员ID
-- biz_trip_ money	外出差旅费用金额总计
-- in_city_traffic_money	市内交通费用金额总计
-- hotel_money  住宿费
-- fars_money	车船费用金额总计
-- subsidy_money	补助费用金额总计
-- road_toll_money	过桥过路费用金额总计
-- oil_money	油费金额总计
-- secondary_money	二单补助费用总计
-- third_money	三单补助费用总计
-- actual_total_money	费用报销总计
select
      exp_sum.id as trvl_exp_id
    , wrk_odr.service_station_id as ss_id
    , exp_sum.user_id as srv_user_id
    , sum(case when trvl_dtl_sum.item = 1 then trvl_dtl_sum.item_money else 0 end) as biz_trip_money
    , sum(case when trvl_dtl_sum.item = 2 then trvl_dtl_sum.item_money else 0 end) as in_city_traffic_money
    , sum(case when trvl_dtl_sum.item = 3 then trvl_dtl_sum.item_money else 0 end) as hotel_money
    , sum(case when trvl_dtl_sum.item = 4 then trvl_dtl_sum.item_money else 0 end) as fars_money
    , sum(case when trvl_dtl_sum.item = 5 then trvl_dtl_sum.item_money else 0 end) as subsidy_money
    , sum(case when trvl_dtl_sum.item = 6 then trvl_dtl_sum.item_money else 0 end) as road_toll_money
    , sum(case when trvl_dtl_sum.item = 7 then trvl_dtl_sum.item_money else 0 end) as oil_money
    , sum(case when trvl_dtl_sum.item = 8 then trvl_dtl_sum.item_money else 0 end) as secondary_money
    , sum(case when trvl_dtl_sum.item = 9 then trvl_dtl_sum.item_money else 0 end) as third_money
    , max(exp_sum.submoney5) as actual_total_money
from
    one_make_dwd.ciss_service_trvl_exp_sum exp_sum
inner join
    one_make_dwd.ciss_s_exp_report_wo_payment r
    on exp_sum.dt = '20210101' and r.dt = '20210101' and exp_sum.id = r.exp_report_id and exp_sum.status = 15 /* 只取制证会计已审状态 */
inner join
    one_make_dwd.ciss_service_travel_expense exp
    on exp.dt = '20210101' and exp.id = r.workorder_travel_exp_id
inner join
    one_make_dwd.ciss_service_workorder wrk_odr
    on wrk_odr.dt = '20210101' and wrk_odr.id = exp.work_order_id
inner join
    (
        select
            travel_expense_id
            , item
            , sum(submoney5) as item_money
        from
            one_make_dwd.ciss_service_trvl_exp_dtl
        where
            dt = '20210101'
        group by
              travel_expense_id
            , item
    ) as trvl_dtl_sum
    on trvl_dtl_sum.travel_expense_id = exp.id
group by
      exp_sum.id
    , wrk_odr.service_station_id
    , exp_sum.user_id
limit 5
;

insert overwrite table one_make_dwb.fact_trvl_exp partition(dt = '20210101')
select
      exp_sum.id as trvl_exp_id
    , wrk_odr.service_station_id as ss_id
    , exp_sum.user_id as srv_user_id
    , sum(case when trvl_dtl_sum.item = 1 then trvl_dtl_sum.item_money else 0 end) as biz_trip_money
    , sum(case when trvl_dtl_sum.item = 2 then trvl_dtl_sum.item_money else 0 end) as in_city_traffic_money
    , sum(case when trvl_dtl_sum.item = 3 then trvl_dtl_sum.item_money else 0 end) as hotel_money
    , sum(case when trvl_dtl_sum.item = 4 then trvl_dtl_sum.item_money else 0 end) as fars_money
    , sum(case when trvl_dtl_sum.item = 5 then trvl_dtl_sum.item_money else 0 end) as subsidy_money
    , sum(case when trvl_dtl_sum.item = 6 then trvl_dtl_sum.item_money else 0 end) as road_toll_money
    , sum(case when trvl_dtl_sum.item = 7 then trvl_dtl_sum.item_money else 0 end) as oil_money
    , sum(case when trvl_dtl_sum.item = 8 then trvl_dtl_sum.item_money else 0 end) as secondary_money
    , sum(case when trvl_dtl_sum.item = 9 then trvl_dtl_sum.item_money else 0 end) as third_money
    , max(exp_sum.submoney5) as actual_total_money
from
    one_make_dwd.ciss_service_trvl_exp_sum exp_sum
inner join
    one_make_dwd.ciss_s_exp_report_wo_payment r
    on exp_sum.dt = '20210101' and r.dt = '20210101' and exp_sum.id = r.exp_report_id and exp_sum.status = 15 /* 只取制证会计已审状态 */
inner join
    one_make_dwd.ciss_service_travel_expense exp
    on exp.dt = '20210101' and exp.id = r.workorder_travel_exp_id
inner join
    one_make_dwd.ciss_service_workorder wrk_odr
    on wrk_odr.dt = '20210101' and wrk_odr.id = exp.work_order_id
inner join
    (
        select
            travel_expense_id
            , item
            , sum(submoney5) as item_money
        from
            one_make_dwd.ciss_service_trvl_exp_dtl
        where
            dt = '20210101'
        group by
              travel_expense_id
            , item
    ) as trvl_dtl_sum
    on trvl_dtl_sum.travel_expense_id = exp.id
group by
      exp_sum.id
    , wrk_odr.service_station_id
    , exp_sum.user_id
;

-- 对数（当前对数均为：87）
select * from one_make_dwb.fact_trvl_exp limit 10;
select count(distinct trvl_exp_id) from one_make_dwb.fact_trvl_exp limit 10;
select count(1) from one_make_dwd.ciss_service_trvl_exp_sum where status = 15 limit 10;