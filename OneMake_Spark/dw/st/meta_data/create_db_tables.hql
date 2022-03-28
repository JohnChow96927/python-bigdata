-- 创建st数据库
create database if not exists one_make_st;

-- 创建工单主题表
-- drop table if exists one_make_st.subj_worker_order;
create table if not exists one_make_st.subj_worker_order(
    owner_process bigint comment '派工方式-自己处理数量'
    ,tran_process bigint comment '派工方式-转派工数量'
    ,wokerorder_num bigint comment '工单总数'
    ,wokerorder_num_max int comment '工单总数最大值'
    ,wokerorder_num_min int comment '工单总数最小值'
    ,wokerorder_num_avg int comment '工单总数平均值'
    ,install_sumnum bigint comment '派工类型-安装总数'
    ,repair_sumnum bigint comment '派工类型-维修总数'
    ,remould_sumnum bigint comment '派工类型-巡检总数'
    ,inspection_sumnum bigint comment '派工类型-改造总数'
    ,alread_complete_sumnum bigint comment '完工总数'
    ,customer_classify_zsh bigint comment '客户类型-中石化数量'
    ,customer_classify_jxs bigint comment '客户类型-经销商数量'
    ,customer_classify_qtzx bigint comment '客户类型-其他直销数量'
    ,customer_classify_zsy bigint comment '客户类型-中石油数量'
    ,customer_classify_qtwlh bigint comment '客户类型-其他往来户数量'
    ,customer_classify_zhjt bigint comment '客户类型-中化集团数量'
    ,customer_classify_zhy bigint comment '客户类型-中海油数量'
    ,customer_classify_gys bigint comment '客户类型-供应商数量'
    ,customer_classify_onemake bigint comment '客户类型-一站制造**数量'
    ,customer_classify_fwy bigint comment '客户类型-服务员数量'
    ,customer_classify_zt bigint comment '客户类型-中铁数量'
    ,customer_classify_hzgs bigint comment '客户类型-合资公司数量'
    ,customer_classify_jg bigint comment '客户类型-军供数量'
    ,customer_classify_zhhangy bigint comment '客户类型-中航油数量'
    ,dws_day string comment '日期维度-按天'
    ,dws_week string comment '日期维度-按周'
    ,dws_month string comment '日期维度-按月'
    ,oil_type string comment '油站类型'
    ,oil_province string comment '油站所属省'
    ,oil_city string comment '油站所属市'
    ,oil_county string comment '油站所属区'
    ,customer_classify string comment '客户类型'
    ,customer_province string comment '客户所属省'
) comment '工单主题表'
    partitioned by (month String, week String, day String)
    stored as orc
    location '/data/dw/st/one_make/subj_worker_order'
;

-- 创建油站主题表
-- drop table if exists one_make_st.subj_oilstation;
create table if not exists one_make_st.subj_oilstation(
    sum_osnum bigint comment '油站数量'
    ,sumnew_osnum int comment '新增油站数量'
    ,dws_day string comment '日期维度-按天'
    ,dws_week string comment '日期维度-按周'
    ,dws_month string comment '日期维度-按月'
    ,oil_type string comment '油站维度-油站类型'
    ,oil_province string comment '油站维度-油站所属省'
    ,oil_city string comment '油站维度-油站所属市'
    ,oil_county string comment '油站维度-油站所属区'
    ,customer_classify string comment '客户维度-客户类型'
    ,customer_province string comment '客户维度-客户所属省'
) comment '油站主题表'
    partitioned by (month String, week String, day String)
    stored as orc
    location '/data/dw/st/one_make/subj_oilstation'
;

-- 创建安装主题表
-- drop table if exists one_make_st.subj_install;
create table if not exists one_make_st.subj_install(
    install_way string comment '安装方式'
    ,install_sum bigint comment '安装数量'
    ,sum_money decimal(20,1) comment '支付费用'
    ,dws_day string comment '日期维度-按天'
    ,dws_week string comment '日期维度-按周'
    ,dws_month string comment '日期维度-按月'
    ,oil_type string comment '油站维度-油站类型'
    ,oil_province string comment '油站维度-油站所属省'
    ,oil_city string comment '油站维度-油站所属市'
    ,oil_county string comment '油站维度-油站所属区'
    ,customer_classify string comment '客户维度-客户类型'
    ,customer_province string comment '客户维度-客户所属省'
) comment '安装主题表'
    partitioned by (month String, week String, day String)
    stored as orc
    location '/data/dw/st/one_make/subj_install'
;

-- 创建维修主题表
-- drop table if exists one_make_st.subj_repair;
create table if not exists one_make_st.subj_repair(
    sum_pay_money decimal(20,1) comment '支付费用'
    ,sum_hour_money decimal(20,1) comment '小时费用'
    ,sum_parts_money decimal(20,1) comment '零部件费用'
    ,sum_fars_money decimal(20,1) comment '交通费用'
    ,sum_faulttype_num bigint comment '故障类型总数'
    ,max_faulttype_num int comment '故障类型最大数量'
    ,avg_faulttype_num int comment '故障类型平均数量'
    ,dws_day string comment '日期维度-按天'
    ,dws_week string comment '日期维度-按周'
    ,dws_month string comment '日期维度-按月'
    ,oil_type string comment '油站维度-油站类型'
    ,oil_province string comment '油站维度-油站所属省'
    ,oil_city string comment '油站维度-油站所属市'
    ,oil_county string comment '油站维度-油站所属区'
    ,customer_classify string comment '客户维度-客户类型'
    ,customer_province string comment '客户维度-客户所属省'
    ,logi_company string comment '物流公司维度-物流公司名称'
) comment '维修主题表'
    partitioned by (month String, week String, day String)
    stored as orc
    location '/data/dw/st/one_make/subj_repair'
;

-- 创建回访主题表
-- drop table if exists one_make_st.subj_rtn_visit;
create table if not exists one_make_st.subj_rtn_visit(
    rtn_srv_num int comment '回访服务人员数量'
    ,vst_user int comment '回访人员数量'
    ,wait_dispatch_num bigint comment '待派工数量'
    ,wait_departure_num bigint comment '待出发数量'
    ,alread_complete_num bigint comment '已完工工单数量'
    ,processing_num bigint comment '正在处理工单数量'
    ,satisfied_num int comment '满意数量'
    ,unsatisfied_num int comment '不满意数量'
    ,srv_atu_num int comment '服务态度满意数量'
    ,srv_bad_atu_num int comment '服务态度不满意数量'
    ,srv_rpr_prof_num int comment '服务维修水平满意数量'
    ,srv_rpr_unprof_num int comment '服务维修水平不满意数量'
    ,srv_high_res_num int comment '服务响应速度满意数量'
    ,srv_low_res_num int comment '服务响应速度不满意数量'
    ,rtn_rpr_num int comment '返修数量'
    ,max_vst_user int comment '回访人员最大数量'
    ,min_vst_user int comment '回访人员最小数量'
    ,dws_day string comment '日期维度-按天'
    ,dws_week string comment '日期维度-按周'
    ,dws_month string comment '日期维度-按月'
    ,orgname string comment '组织机构维度-回访人员所属部门'
    ,posiname string comment '组织机构维度-回访人员所属岗位'
    ,empname string comment '组织机构维度-回访人员名称'
    ,oil_type string comment '油站维度-油站类型'
    ,oil_province string comment '油站维度-油站所属省'
    ,oil_city string comment '油站维度-油站所属市'
    ,oil_county string comment '油站维度-油站所属区'
    ,customer_classify string comment '客户维度-客户类型'
    ,customer_province string comment '客户维度-客户所属省'
) comment '回访主题表'
    partitioned by (month String, week String, day String)
    stored as orc
    location '/data/dw/st/one_make/subj_rtn_visit'
;

-- 创建派单主题表
-- drop table if exists one_make_st.subj_dispatch;
create table if not exists one_make_st.subj_dispatch(
    install_sumnum int comment '安装单数量'
    ,repair_sumnum int comment '维修单数量'
    ,remould_sumnum int comment '巡检单数量'
    ,inspection_sumnum int comment '改造单数量'
    ,max_wo_num int comment '派单数最大值'
    ,min_wo_num int comment '派单数最小值'
    ,avg_wo_num decimal(20, 1) comment '派单数平均值'
    ,call_srv_user int comment '呼叫中心派单人'
    ,max_dispatch_cnt int comment '呼叫中心最大派单'
    ,min_dispatch_cnt int comment '呼叫中心最小派单'
    ,avg_dispatch_cnt decimal(20, 1) comment '呼叫中心平均派单'
    ,people_wo_num decimal(20, 1) comment '派单平均值'
    ,srv_reps_duration int comment '派单响应时长'
    ,srv_duration int comment '服务时长'
    ,pepople_sumnum int comment '工单人数'
    ,dws_day string comment '日期维度-按天'
    ,dws_week string comment '日期维度-按周'
    ,dws_month string comment '日期维度-按月'
    ,orgname string comment '组织机构维度-回访人员所属部门'
    ,posiname string comment '组织机构维度-回访人员所属岗位'
    ,empname string comment '组织机构维度-回访人员名称'
    ,oil_type string comment '油站维度-油站类型'
    ,oil_province string comment '油站维度-油站所属省'
    ,oil_city string comment '油站维度-油站所属市'
    ,oil_county string comment '油站维度-油站所属区'
    ,customer_classify string comment '客户维度-客户类型'
    ,customer_province string comment '客户维度-客户所属省'
) comment '派单主题表'
    partitioned by (month String, week String, day String)
    stored as orc
    location '/data/dw/st/one_make/subj_dispatch'
;

-- 创建费用主题表
-- drop table if exists one_make_st.subj_expense;
create table if not exists one_make_st.subj_expense(
    install_money decimal(20,1) comment '安装费用'
    ,max_install_money decimal(20,1) comment '最大安装费用'
    ,min_install_money decimal(20,1) comment '最小安装费用'
    ,avg_install_money decimal(20,1) comment '平均安装费用'
    ,sumbiz_trip_money decimal(20, 1) comment '外出差旅费用金额总计'
    ,sumin_city_traffic_money decimal(20, 1) comment '市内交通费用金额总计'
    ,sumhotel_money decimal(20, 1) comment '住宿费费用金额总计'
    ,sumfars_money decimal(20, 1) comment '车船费用金额总计'
    ,sumsubsidy_money decimal(20, 1) comment '补助费用金额总计'
    ,sumroad_toll_money decimal(20, 1) comment '过桥过路费用金额总计'
    ,sumoil_money decimal(20, 1) comment '油费金额总计'
    ,exp_item_total int comment '差旅费用扣款明细总计'
    ,actual_total_money decimal(20, 1) comment '差旅费用总额统计'
    ,sum_secondary_money decimal(20, 1) comment '差旅费用二阶段扣款总计'
    ,sum_third_money decimal(20, 1) comment '差旅费用三阶段扣款总计'
    ,max_secondary_money decimal(20, 1) comment '差旅费用二阶段最大扣款总计'
    ,max_third_money decimal(20, 1) comment '差旅费用三阶段最大扣款总计'
    ,sum_srv_user int comment '报销人员总数量'
    ,max_srv_user int comment '报销人员最大数量'
    ,min_srv_user int comment '报销人员最小数量'
    ,avg_srv_user int comment '报销人员平均数量'
    ,dws_day string comment '日期维度-按天'
    ,dws_week string comment '日期维度-按周'
    ,dws_month string comment '日期维度-按月'
    ,oil_type string comment '油站维度-油站类型'
    ,oil_province string comment '油站维度-油站所属省'
    ,oil_city string comment '油站维度-油站所属市'
    ,oil_county string comment '油站维度-油站所属区'
    ,customer_classify string comment '客户维度-客户类型'
    ,customer_province string comment '客户维度-客户所属省'
) comment '费用主题表'
    partitioned by (month String, week String, day String)
    stored as orc
    location '/data/dw/st/one_make/subj_expense'
;

-- 创建客户主题表
-- drop table if exists one_make_st.subj_expense;
create table if not exists one_make_st.subj_expense(
    install_money decimal(20,1) comment '安装费用'
    ,max_install_money decimal(20,1) comment '最大安装费用'
    ,min_install_money decimal(20,1) comment '最小安装费用'
    ,avg_install_money decimal(20,1) comment '平均安装费用'
    ,sumbiz_trip_money decimal(20, 1) comment '外出差旅费用金额总计'
    ,sumin_city_traffic_money decimal(20, 1) comment '市内交通费用金额总计'
    ,sumhotel_money decimal(20, 1) comment '住宿费费用金额总计'
    ,sumfars_money decimal(20, 1) comment '车船费用金额总计'
    ,sumsubsidy_money decimal(20, 1) comment '补助费用金额总计'
    ,sumroad_toll_money decimal(20, 1) comment '过桥过路费用金额总计'
    ,sumoil_money decimal(20, 1) comment '油费金额总计'
    ,exp_item_total int comment '差旅费用扣款明细总计'
    ,actual_total_money decimal(20, 1) comment '差旅费用总额统计'
    ,sum_secondary_money decimal(20, 1) comment '差旅费用二阶段扣款总计'
    ,sum_third_money decimal(20, 1) comment '差旅费用三阶段扣款总计'
    ,max_secondary_money decimal(20, 1) comment '差旅费用二阶段最大扣款总计'
    ,max_third_money decimal(20, 1) comment '差旅费用三阶段最大扣款总计'
    ,sum_srv_user int comment '报销人员总数量'
    ,max_srv_user int comment '报销人员最大数量'
    ,min_srv_user int comment '报销人员最小数量'
    ,avg_srv_user int comment '报销人员平均数量'
    ,dws_day string comment '日期维度-按天'
    ,dws_week string comment '日期维度-按周'
    ,dws_month string comment '日期维度-按月'
    ,oil_type string comment '油站维度-油站类型'
    ,oil_province string comment '油站维度-油站所属省'
    ,oil_city string comment '油站维度-油站所属市'
    ,oil_county string comment '油站维度-油站所属区'
    ,customer_classify string comment '客户维度-客户类型'
    ,customer_province string comment '客户维度-客户所属省'
) comment '客户主题表'
    partitioned by (month String, week String, day String)
    stored as orc
    location '/data/dw/st/one_make/subj_expense'
;

-- 创建客户主题表
-- drop table if exists one_make_st.subj_customer;
create table if not exists one_make_st.subj_customer(
    sum_install_num int comment '安装数量'
    ,max_install_num int comment '安装最大数量'
    ,min_install_num int comment '安装最小数量'
    ,avg_min_install_num decimal(20, 1) comment '安装平均数量'
    ,sum_repair_num int comment '维修数量'
    ,max_repair_num int comment '维修最大数量'
    ,min_repair_num int comment '维修最小数量'
    ,avg_repair_num decimal(20, 1) comment '维修平均数量'
    ,sum_wo_num int comment '派工数量'
    ,max_sum_wo_num int comment '派工最大数量'
    ,min_sum_wo_num int comment '派工最小数量'
    ,avg_sum_wo_num decimal(20, 1) comment '派工平均数量'
    ,sum_remould_num int comment '巡检数量'
    ,max_remould_num int comment '巡检最大数量'
    ,min_remould_num int comment '巡检最小数量'
    ,avg_remould_num decimal(20, 1) comment '巡检平均数量'
    ,sum_alread_complete_num int comment '回访数量'
    ,max_alread_complete_num int comment '回访最大数量'
    ,min_alread_complete_num int comment '回访最小数量'
    ,avg_alread_complete_num decimal(20, 1) comment '回访平均数量'
    ,dws_day string comment '日期维度-按天'
    ,dws_week string comment '日期维度-按周'
    ,dws_month string comment '日期维度-按月'
    ,oil_type string comment '油站维度-油站类型'
    ,oil_province string comment '油站维度-油站所属省'
    ,oil_city string comment '油站维度-油站所属市'
    ,oil_county string comment '油站维度-油站所属区'
    ,customer_classify string comment '客户维度-客户类型'
    ,customer_province string comment '客户维度-客户所属省'
) comment '客户主题表'
    partitioned by (month String, week String, day String)
    stored as orc
    location '/data/dw/st/one_make/subj_customer'
;

-- 创建保内良品核销主题表
drop table if exists one_make_st.subj_bnlp_hx;
create table if not exists one_make_st.subj_bnlp_hx(
    hx_num int comment '核销数量'
    ,sum_hx_m_num int comment '核销物料数量'
    ,sum_hx_m_money decimal(20, 1) comment '核销配件金额数量'
    ,max_hx_m_money decimal(20, 1) comment '核销配件金额最大金额'
    ,min_hx_m_money decimal(20, 1) comment '核销配件金额最小金额'
    ,avg_hx_m_money decimal(20, 1) comment '核销配件金额平均金额'
    ,dws_day string comment '日期维度-按天'
    ,dws_week string comment '日期维度-按周'
    ,dws_month string comment '日期维度-按月'
    ,warehouse_location string comment '仓库维度-仓库所属位置'
) comment '保内良品核销主题表'
    partitioned by (month String, week String, day String)
    stored as orc
    location '/data/dw/st/one_make/subj_bnlp_hx'
;

-- 创建保内不良品核销主题表
drop table if exists one_make_st.subj_bn_blp_hx;
create table if not exists one_make_st.subj_bn_blp_hx(
    sum_hx_m_num int comment '核销配件总数量'
    ,sum_hx_m_money decimal(20, 1) comment '核销配件金额'
    ,max_hx_m_money decimal(20, 1) comment '核销配件金额最大金额'
    ,min_hx_m_money decimal(20, 1) comment '核销配件金额最小金额'
    ,avg_hx_m_money decimal(20, 1) comment '核销配件金额平均金额'
    ,dws_day string comment '日期维度-按天'
    ,dws_week string comment '日期维度-按周'
    ,dws_month string comment '日期维度-按月'
    ,warehouse_location string comment '仓库维度-仓库所属位置'
) comment '保内不良品核销主题表'
    partitioned by (month String, week String, day String)
    stored as orc
    location '/data/dw/st/one_make/subj_bn_blp_hx'
;