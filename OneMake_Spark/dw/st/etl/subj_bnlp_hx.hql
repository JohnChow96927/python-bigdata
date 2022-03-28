-- 核销总数统计
-- 核销配件总数统计
-- 核销配件金额统计
-- 核销配件最大金额统计
-- 核销配件最小金额统计
-- 核销配件平均金额统计
-- 维度
--     日期维度(月)
--     日期维度(周)
--     日期维度(日)
--     仓库维度(客户所属地理位置)
select count(fbh.hx_id) hx_num, sum(fbh.hx_m_num) sum_hx_m_num, sum(fbh.hx_m_money) sum_hx_m_money, max(fbh.hx_m_money) max_hx_m_money,
       min(fbh.hx_m_money) min_hx_m_money, avg(fbh.hx_m_money) avg_hx_m_money, dd.date_id dws_day, dd.week_in_year_id dws_week, dd.year_month_id dws_month,
       substr(dw.srv_station_name, 0, 2) warehouse_location
from one_make_dwb.fact_bnlp_hx fbh
         left join one_make_dws.dim_date dd on fbh.dt = dd.date_id
         left join one_make_dws.dim_warehouse dw on fbh.warehouse_id = dw.code
group by dd.date_id, dd.week_in_year_id, dd.year_month_id, substr(dw.srv_station_name, 0, 2)
;

-- 装载数据
insert overwrite table one_make_st.subj_bnlp_hx partition(month = '202101', week='2021W1', day='20210101')
select count(fbh.hx_id) hx_num, sum(fbh.hx_m_num) sum_hx_m_num, sum(fbh.hx_m_money) sum_hx_m_money, max(fbh.hx_m_money) max_hx_m_money,
    min(fbh.hx_m_money) min_hx_m_money, avg(fbh.hx_m_money) avg_hx_m_money, dd.date_id dws_day, dd.week_in_year_id dws_week, dd.year_month_id dws_month,
    substr(dw.srv_station_name, 0, 2) warehouse_location
from one_make_dwb.fact_bnlp_hx fbh
    left join one_make_dws.dim_date dd on fbh.dt = dd.date_id
    left join one_make_dws.dim_warehouse dw on fbh.warehouse_id = dw.code
where dd.year_month_id = '202101'and dd.week_in_year_id = '2021W1' and  dd.date_id = '20210101'
group by dd.date_id, dd.week_in_year_id, dd.year_month_id, substr(dw.srv_station_name, 0, 2)
;