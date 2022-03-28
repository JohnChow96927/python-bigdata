-- 创建dwb数据库
create database if not exists one_make_dwb;

-- 创建工单事实表
-- drop table if exists one_make_dwb.fact_worker_order;
create table if not exists one_make_dwb.fact_worker_order(
    wo_id string comment '工单id'
    , callaccept_id string comment '来电受理单id'
    , oil_station_id string comment '油站id'
    , userids string comment '服务该工单用户id(注意：可能会有多个，以逗号分隔)'
    , wo_num bigint comment '工单单据数量'
    , back_num bigint comment '退回工单数量，默认为0'
    , abolished_num bigint comment '已作废工单数量'
    , wait_dispatch_num bigint comment '待派工数量'
    , wait_departure_num bigint comment '待出发数量'
    , alread_complete_num bigint comment '已完工工单数量（已完工、已回访）'
    , processing_num bigint comment '正在处理工单数量（待离站、待完工）'
    , people_num int comment '工单人数数量（一个工单由多人完成）'
    , service_total_duration int comment '服务总时长（按小时），(LEAVE_TIME - START_TIME)'
    , repair_service_duration int comment '报修响应时长（按小时），(START_TIME-SUBMIT_TIME)'
    , customer_repair_num bigint comment '客户报修工单数量'
    , charg_num bigint comment '收费工单数量'
    , repair_device_num bigint comment '维修设备数量'
    , install_device_num bigint comment '安装设备数据量'
    , install_num bigint comment '安装单数量'
    , repair_num bigint comment '维修单数量'
    , remould_num bigint comment '巡检单数量'
    , inspection_num bigint comment '改造单数量'
    , workorder_trvl_exp decimal(20,1) comment '工单差旅费'
) comment '工单事实表'
partitioned by (dt String)
stored as orc
location '/data/dw/dwb/one_make/fact_worker_order'
;

-- 创建油站事实表
-- drop table if exists one_make_dwb.fact_oil_station;
create table if not exists one_make_dwb.fact_oil_station(
    os_id string comment '油站ID'
    , os_name string comment '油站名称'
    , os_code string comment '油站编码'
    , province_id string comment '省份ID'
    , city_id string comment '城市ID'
    , county_id string comment '县ID'
    , status_id int comment '状态ID'
    , cstm_type_id int comment '客户分类ID'
    , os_num int comment '油站数量	默认为1'
    , invalid_os_num int comment '已停用油站数量（状态为已停用为1，否则为0）'
    , valid_os_num int comment '有效油站数量（状态为启用为1，否则为0）'
    , current_new_os_num int comment '当日新增油站（新增油站为1，老油站为0）'
    , current_invalid_os_num int comment '当日停用油站（当天停用的油站数量）'
    , device_num int comment '油站设备数量'
) comment '油站事实表'
    partitioned by (dt String)
    stored as orc
    location '/data/dw/dwb/one_make/fact_oil_station'
;

-- 创建安装单事实表
-- drop table if exists one_make_dwb.fact_srv_install;
create table if not exists one_make_dwb.fact_srv_install(
    inst_id string comment '安装单ID'
    , inst_code string comment '安装单编码'
    , inst_type_id string comment '安装方式ID'
    , srv_user_id string comment '服务人员用户ID'
    , ss_id string comment '服务网点ID'
    , os_id string comment '油站ID'
    , date_id string comment '日期ID'
    , new_inst_num int comment '全新安装数量'
    , debug_inst_num int comment '设备联调安装数量'
    , repair_num int comment '产生维修安装单数量'
    , ext_exp_num decimal(20, 1) comment '额外收费安装单数量'
    , inst_device_num int comment '安装设备数量'
    , exp_device_money int comment '安装费用'
    , validated_inst_num int comment '审核安装单数量'
) comment '安装单事实表'
    partitioned by (dt String)
    stored as orc
    location '/data/dw/dwb/one_make/fact_srv_install'
;

-- 创建维修事实表
-- drop table if exists one_make_dwb.fact_srv_repair;
create table if not exists one_make_dwb.fact_srv_repair(
    rpr_id string comment '维修单ID'
    , rpr_code string comment '维修单编码'
    , srv_user_id string comment '服务人员用户ID'
    , ss_id string comment '服务网点ID'
    , os_id string comment '油站ID'
    , date_id string comment '日期ID'
    , exp_rpr_num string comment '收费维修数量'
    , hour_money int comment '工时费用'
    , parts_money int comment '配件费用'
    , fars_money int comment '车船费用'
    , rpr_device_num int comment '维修设备数量'
    , rpr_mtrl_num int comment '维修配件数量'
    , exchg_parts_num int comment '更换配件数量'
    , upgrade_parts_num int comment '升级配件数量'
    , fault_type_ids string comment '故障类型ID集合'
) comment '维修单事实表'
    partitioned by (dt String)
    stored as orc
    location '/data/dw/dwb/one_make/fact_srv_repair'
;

-- 创建客户回访实时表
-- drop table if exists one_make_dwb.fact_srv_rtn_visit;
create table if not exists one_make_dwb.fact_srv_rtn_visit(
    vst_id string comment '回访ID'
    , vst_code string comment '回访编号'
    , wrkodr_id string comment '工单ID'
    , srv_user_id string comment '服务人员用户ID'
    , os_id string comment '油站ID'
    , cstm_id string comment '用户ID'
    , ss_id string comment '服务网点ID'
    , vst_user_id string comment '回访人员ID'
    , satisfied_num int comment '满意数量'
    , unsatisfied_num int comment '不满意数量'
    , srv_atu_num int comment '服务态度满意数量'
    , srv_bad_atu_num int comment '服务态度不满意数量'
    , srv_rpr_prof_num int comment '服务维修水平满意数量'
    , srv_rpr_unprof_num int comment '服务维修水平不满意数量'
    , srv_high_res_num int comment '服务响应速度满意数量'
    , srv_low_res_num int comment '服务响应速度不满意数量'
    , rtn_rpr_num int comment '返修数量'
) comment '客户回访事实表'
    partitioned by (dt String)
    stored as orc
    location '/data/dw/dwb/one_make/fact_srv_rtn_visit'
;

-- 创建呼叫中心 | 来电受理事实表
-- drop table if exists one_make_dwb.fact_call_service;
create table if not exists one_make_dwb.fact_call_service(
    id string comment '受理id（唯一标识）'
    , code string comment '受理单唯一编码'
    , call_date string comment '来电日期（日期ID）'
    , call_hour int comment '来电时间（小时）（事实维度）'
    , call_type_id string comment '来电类型（事实维度）'
    , call_type_name string comment '来电类型名称（事实维度）'
    , process_way_id string comment '受理方式（事实维度）'
    , process_way_name string comment '受理方式（事实维度）'
    , oil_station_id string comment '油站ID'
    , userid string comment '受理人员ID'
    , cnt int comment '单据数量（指标列）'
    , dispatch_cnt int comment '派工数量'
    , cancellation_cnt int comment '派工单作废数量'
    , chargeback_cnt int comment '派工单退单数量'
    , interval int comment '受理时长（单位：秒），process_time – call_time'
    , tel_spt_cnt int comment '电话支持数量'
    , on_site_spt_cnt int comment '现场安装、维修、改造、巡检数量'
    , custm_visit_cnt int comment '回访单据数量'
    , complain_cnt int comment '投诉单据数量'
    , other_cnt int comment '其他业务单据数量'
)
partitioned by (dt String)
stored as orc
location '/data/dw/dwb/one_make/fact_call_service'
;

/**
 * 服务公司财务费用事实表
 */

-- 创建费用事实表
-- drop table one_make_dwb.fact_regular_exp;
create table if not exists one_make_dwb.fact_regular_exp(
      exp_id string comment '费用报销ID'
    , ss_id string comment '服务网点ID'
    , srv_user_id string comment '服务人员ID'
    , actual_exp_money decimal(20,1) comment '费用实际报销金额'
    , exp_item string comment '费用项目ID'
    , exp_item_name string comment '费用项目名称'
    , exp_item_money decimal(20,1) comment '费用项目实际金额'
)
partitioned by (dt String)
stored as orc
location '/data/dw/dwb/one_make/fact_regular_exp'
;

-- 差旅费用事实表
-- drop table one_make_dwb.fact_trvl_exp;
create table if not exists one_make_dwb.fact_trvl_exp(
      trvl_exp_id string comment '差旅报销单ID'
    , ss_id string comment '服务网点ID'
    , srv_user_id string comment '服务人员ID'
    , biz_trip_ decimal(20,1) comment '外出差旅费用金额总计'
    , in_city_traffic_money decimal(20,1) comment '市内交通费用金额总计'
    , hotel_money decimal(20,1) comment '住宿费费用金额总计'
    , fars_money decimal(20,1) comment '车船费用金额总计'
    , subsidy_money decimal(20,1) comment '补助费用金额总计'
    , road_toll_money decimal(20,1) comment '过桥过路费用金额总计'
    , oil_money decimal(20,1) comment '油费金额总计'
    , secondary_money decimal(20,1) comment '二单补助费用总计'
    , third_money decimal(20,1) comment '三单补助费用总计'
    , actual_total_money decimal(20,1) comment '费用报销总计'
)
partitioned by (dt String)
stored as orc
location '/data/dw/dwb/one_make/fact_trvl_exp'
;

/**
 * 服务公司物料仓储事实表
 */

-- 网点物料申请事实表
-- drop table if exists one_make_dwb.fact_srv_stn_ma;
create table if not exists one_make_dwb.fact_srv_stn_ma(
      ma_id string comment '申请单ID'
    , ma_code string comment '申请单编码'
    , ss_id string comment '服务网点ID'
    , logi_id string comment '物流类型ID'
    , logi_cmp_id string comment '物流公司ID'
    , warehouse_id string comment '仓库ID'
    , total_m_num decimal(10,0) comment '申请物料总数量'
    , total_m_money decimal(10,1) comment '申请物料总金额'
    , ma_form_num decimal(10,0) comment '申请单数量'
    , inst_m_num decimal(10,0) comment '安装申请物料数量'
    , inst_m_money decimal(10,1) comment '安装申请物料金额'
    , bn_m_num decimal(10,0) comment '保内申请物料数量'
    , bn_m_money decimal(10,1) comment '保内申请物料金额'
    , rmd_m_num decimal(10,0) comment '改造申请物料数量'
    , rmd_m_money decimal(10,1) comment '改造申请物料金额'
    , rpr_m_num decimal(10,0) comment '维修申请物料数量'
    , rpr_m_money decimal(10,1) comment '维修申请物料金额'
    , sales_m_num decimal(10,0) comment '销售申请物料数量'
    , sales_m_money decimal(10,1) comment '销售申请物料金额'
    , insp_m_num decimal(10,0) comment '巡检申请物料数量'
    , insp_m_money decimal(10,1) comment '巡检申请物料金额'

)
partitioned by (dt String)
stored as orc
location '/data/dw/dwb/one_make/fact_srv_stn_ma'
;

-- 物料分类指标事实表开发
-- drop table if exists one_make_dwb.fact_srv_stn_ma_dtl;
create table if not exists one_make_dwb.fact_srv_stn_ma_dtl(
      ss_id string comment '服务网点ID'
    , warehouse_id string comment '仓库ID'
    , m_code string comment '物料编码'
    , m_name string comment '物料名称'
    , total_m_num decimal(10,0) comment '申请物料总数量'
    , total_m_money decimal(10,1) comment '申请物料总金额'
    , ma_form_num decimal(10,0) comment '申请单数量'
    , inst_m_num decimal(10,0) comment '安装申请物料数量'
    , inst_m_money decimal(10,1) comment '安装申请物料金额'
    , bn_m_num decimal(10,0) comment '保内申请物料数量'
    , bn_m_money decimal(10,1) comment '保内申请物料金额'
    , rmd_m_num decimal(10,0) comment '改造申请物料数量'
    , rmd_m_money decimal(10,1) comment '改造申请物料金额'
    , rpr_m_num decimal(10,0) comment '维修申请物料数量'
    , rpr_m_money decimal(10,1) comment '维修申请物料金额'
    , sales_m_num decimal(10,0) comment '销售申请物料数量'
    , sales_m_money decimal(10,1) comment '销售申请物料金额'
    , ipt_m_num decimal(10,0) comment '巡检申请物料数量'
    , ipt_m_money decimal(10,1) comment '巡检申请物料金额'
)
partitioned by (dt String)
stored as orc
location '/data/dw/dwb/one_make/fact_srv_stn_ma_dtl'
;

-- 保内良品核销指标事实表开发
-- drop table if exists one_make_dwb.fact_bnlp_hx;
create table if not exists one_make_dwb.fact_bnlp_hx(
    hx_id string comment '核销单ID'
    , hx_code string comment '核销单编号'
    , ss_id string comment '服务网点ID'
    , logi_cmp_id string comment '物流公司ID'
    , logi_type_id string comment '物流类型ID'
    , apply_id string comment '申请人ID'
    , warehouse_id string comment '仓库ID'
    , hx_m_num int comment '核销配件总数量'
    , hx_m_money decimal(10,1) comment '核销配件总金额'
    , hx_form_num int comment '核销申请单数量'
)
partitioned by (dt String)
stored as orc
location '/data/dw/dwb/one_make/fact_bnlp_hx'
;

-- 保内不良品核销事实表开发
-- drop table if exists one_make_dwb.fact_bn_blp_hx;
create table if not exists one_make_dwb.fact_bn_blp_hx(
    blphx_id string comment '不良品核销申请ID'
    , blphx_code string comment '不良品核销编码'
    , ss_id string comment '服务网点ID'
    , logi_cmp_id string comment '物流公司ID'
    , logi_type_id string comment '物流类型ID'
    , warehouse_id string comment '仓库ID'
    , hx_m_num int comment '核销配件总数量'
    , hx_m_money decimal(10,1) comment '核销配件金额'
    , hx_exchg_m_num int comment '工单配件更换数量'
    , hx_exchg_m_money decimal(10,1) comment '工单配置更换金额'
    , hx_form_num int comment '核销申请单数量'
)
partitioned by (dt String)
stored as orc
location '/data/dw/dwb/one_make/fact_bn_blp_hx'
;

-- 网点调拨事实表开发
-- drop table if exists one_make_dwb.fact_transfer;
create table if not exists one_make_dwb.fact_transfer(
    transfer_id string comment '调拨单ID'
  , transfer_code string comment '调拨单编号'
  , trans_in_ss_id string comment '申请服务中心ID'
  , trans_out_ss_id string comment '调出服务中心ID'
  , trans_in_warehouse_id string comment '申请仓库ID'
  , trans_out_warehouse_id string comment '调出仓库ID'
  , logi_type_id string comment '物流方式ID'
  , logi_cmp_id string comment '物流公司ID'
  , trans_m_num bigint comment '调拨物料件数'
  , trans_m_money decimal(10,1) comment '调拨物料金额'
  , trans_form_num bigint comment '调拨单数量'
)
partitioned by (dt String)
stored as orc
location '/data/dw/dwb/one_make/fact_transfer'
;

/*
 * 服务商相关事实表
 */
-- 服务商油站事实表
-- drop table if exists one_make_dwb.fact_csp_os;
create table if not exists one_make_dwb.fact_csp_os(
    os_id string comment '油站ID'
  , os_code string comment '油站编码'
  , province_id string comment '省份ID'
  , city_id string comment '城市ID'
  , county_id string comment '县ID'
  , csp_id string comment '服务商ID'
  , os_device_num bigint comment '油站设备数量'
  , os_num bigint comment '油站数量'
)
partitioned by (dt String)
stored as orc
location '/data/dw/dwb/one_make/fact_csp_os'
;

-- 服务商工单事实表
-- drop table if exists one_make_dwb.fact_csp_workorder;
create table if not exists one_make_dwb.fact_csp_workorder(
    wkodr_id string comment '工单id'
  , csp_id string comment '服务商id'
  , os_id string comment '油站id'
  , wkodr_num string comment '工单单据数量'
  , cmp_wkodr_num string comment '已完工工单数量（已完工）'
  , working_wkodr_num string comment '正在处理工单数量（已提交）'
  , device_num string comment '设备数据'
)
partitioned by (dt String)
stored as orc
location '/data/dw/dwb/one_make/fact_csp_workorder'
;

-- 服务商消耗品核销事实表
-- drop table if exists one_make_dwb.fact_csp_xhp_hx;
create table if not exists one_make_dwb.fact_csp_xhp_hx(
    xhp_id string comment '消耗品申请单ID'
    , xhp_code string comment '消耗品申请单编码'
    , csp_id string comment '服务商ID'
    , csp_wh_code string comment '服务商仓库编码'
    , logi_cmp_id string comment '物流公司ID'
    , logi_type_id string comment '物流类型ID'
    , apply_m_num int comment '申请物料总数量'
    , apply_m_money decimal(10,1) comment '申请物料总金额'
)
partitioned by (dt String)
stored as orc
location '/data/dw/dwb/one_make/fact_csp_xhp_hx'
;