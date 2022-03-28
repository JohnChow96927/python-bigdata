-- 派工方式统计（多个）
--     自己处理
--     转派工
-- 工单总数统计
-- 工单总数最大值统计
-- 工单总数最小值统计
-- 工单总数平均值统计
-- 派工类型总数统计(多个)
--    安装单
--    维修单
--    巡检单
--    改造单
-- 完工总数统计
-- 客户类型统计（多个）
--     中石化
--     经销商
--     其他直销
--     中石油
--     其他往来户
--     中化集团
--     中海油
--     供应商
--     一站制造**
--     服务员
--     中铁
--     合资公司
--     军供
--     中航油
-- 维度
--     日期维度(月)
--     日期维度(周)
--     日期维度(日)
--     油站维度(油站类型)
--     油站维度(油站所属省)
--     油站维度(油站所属市)
--     油站维度(油站所属区)
--     客户维度(客户类型)
--     客户维度(客户所属省)
select
    max(owner_process_num) owner_process, max(tran_process_num) tran_process, sum(fwo.wo_num) wokerorder_num, max(fwo.wo_num) wokerorder_num_max,
    min(fwo.wo_num) wokerorder_num_min, avg(fwo.wo_num) wokerorder_num_avg, sum(install_num) install_sumnum, sum(repair_num) repair_sumnum,
    sum(remould_num) remould_sumnum, sum(inspection_num) inspection_sumnum, sum(alread_complete_num) alread_complete_sumnum,
    max(customerzsh.customerClassify) customer_classify_zsh, max(customerjxs.customerClassify) customer_classify_jxs,
    max(customerothersale.customerClassify) customer_classify_qtzx, max(customerzsy.customerClassify) customer_classify_zsy,
    max(customerothercnt.customerClassify) customer_classify_qtwlh, max(customerozhonghua.customerClassify) customer_classify_zhjt,
    max(customerzhonghy.customerClassify) customer_classify_zhy, max(customersupplier.customerClassify) customer_classify_gys,
    max(customeronemake.customerClassify) customer_classify_onemake, max(customerseremp.customerClassify) customer_classify_fwy,
    max(customerzhongt.customerClassify) customer_classify_zt, max(customercomamy.customerClassify) customer_classify_hzgs,
    max(customerarmi.customerClassify) customer_classify_jg, max(customerzhy.customerClassify) customer_classify_zhhangy,
    dd.date_id dws_day, dd.week_in_year_id dws_week, dd.year_month_id dws_month, oil.company_name oil_type, oil.province_name oil_province,
    oil.city_name oil_city, oil.county_name oil_county, oil.customer_classify_name customer_classify, oil.customer_province_name customer_province
from one_make_dwb.fact_worker_order fwo,
     (select count(1) owner_process_num from one_make_dwb.fact_call_service fcs where fcs.process_way_name = '自己处理') ownerProcess,
     (select count(1) tran_process_num from one_make_dwb.fact_call_service fcs where fcs.process_way_name = '转派工') tranWork,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='中石化') customerzsh,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='经销商') customerjxs,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='其他直销') customerothersale,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='中石油') customerzsy,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='其他往来户') customerothercnt,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='中化集团') customerozhonghua,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='中海油') customerzhonghy,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='供应商') customersupplier,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='一站制造**') customeronemake,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='服务员') customerseremp,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='中铁') customerzhongt,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='合资公司') customercomamy,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='军供') customerarmi,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='中航油') customerzhy
         left join one_make_dws.dim_date dd on fwo.dt = dd.date_id
         left join one_make_dws.dim_oilstation oil on fwo.oil_station_id = oil.id
group by dd.date_id, dd.week_in_year_id, dd.year_month_id, oil.company_name, oil.province_name, oil.city_name, oil.county_name,
         oil.customer_classify_name, oil.customer_province_name
;

-- 填充数据
insert overwrite table one_make_st.subj_worker_order partition(month = '202101', week='2021W1', day='20210101')
select
    max(owner_process_num) owner_process, max(tran_process_num) tran_process, sum(fwo.wo_num) wokerorder_num, max(fwo.wo_num) wokerorder_num_max,
    min(fwo.wo_num) wokerorder_num_min, avg(fwo.wo_num) wokerorder_num_avg, sum(install_num) install_sumnum, sum(repair_num) repair_sumnum,
    sum(remould_num) remould_sumnum, sum(inspection_num) inspection_sumnum, sum(alread_complete_num) alread_complete_sumnum,
    max(customerzsh.customerClassify) customer_classify_zsh, max(customerjxs.customerClassify) customer_classify_jxs,
    max(customerothersale.customerClassify) customer_classify_qtzx, max(customerzsy.customerClassify) customer_classify_zsy,
    max(customerothercnt.customerClassify) customer_classify_qtwlh, max(customerozhonghua.customerClassify) customer_classify_zhjt,
    max(customerzhonghy.customerClassify) customer_classify_zhy, max(customersupplier.customerClassify) customer_classify_gys,
    max(customeronemake.customerClassify) customer_classify_onemake, max(customerseremp.customerClassify) customer_classify_fwy,
    max(customerzhongt.customerClassify) customer_classify_zt, max(customercomamy.customerClassify) customer_classify_hzgs,
    max(customerarmi.customerClassify) customer_classify_jg, max(customerzhy.customerClassify) customer_classify_zhhangy,
    dd.date_id dws_day, dd.week_in_year_id dws_week, dd.year_month_id dws_month, oil.company_name oil_type, oil.province_name oil_province,
    oil.city_name oil_city, oil.county_name oil_county, oil.customer_classify_name customer_classify, oil.customer_province_name customer_province
from one_make_dwb.fact_worker_order fwo,
     (select count(1) owner_process_num from one_make_dwb.fact_call_service fcs where fcs.process_way_name = '自己处理') ownerProcess,
     (select count(1) tran_process_num from one_make_dwb.fact_call_service fcs where fcs.process_way_name = '转派工') tranWork,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='中石化') customerzsh,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='经销商') customerjxs,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='其他直销') customerothersale,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='中石油') customerzsy,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='其他往来户') customerothercnt,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='中化集团') customerozhonghua,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='中海油') customerzhonghy,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='供应商') customersupplier,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='一站制造**') customeronemake,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='服务员') customerseremp,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='中铁') customerzhongt,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='合资公司') customercomamy,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='军供') customerarmi,
     (select count(1) customerClassify from one_make_dws.dim_oilstation oil where oil.customer_classify_name ='中航油') customerzhy
         left join one_make_dws.dim_date dd on fwo.dt = dd.date_id
         left join one_make_dws.dim_oilstation oil on fwo.oil_station_id = oil.id
where dd.year_month_id = '202101'and dd.week_in_year_id = '2021W1' and  dd.date_id = '20210101'
group by dd.date_id, dd.week_in_year_id, dd.year_month_id, oil.company_name, oil.province_name, oil.city_name, oil.county_name,
         oil.customer_classify_name, oil.customer_province_name
;