# DWB数仓主题事实层构建

## I. DWB层

### 1. 维修事务事实表

1. #### 需求分析

   - **目标**：**掌握DWB层维修事实指标表的构建需求分析**

   - **路径**

     - step1：目标需求
     - step2：数据来源

   - **实施**

     - **目标需求**：基于维修信息数据统计维修设备个数、维修、更换、升级配件数量、工时费用、配件费用等指标

       ![image-20211003172704904](assets/image-20211003172704904-1649035961777.png)

     - **数据来源**

       - ciss_service_repair：维修信息表

         ```sql
         select
             id,--维修单id
             code,--维修单号
             service_id,--服务单id
             is_pay,--是否收费 1-收费，0-免费
             hour_charge,--工时费用
             parts_charge,--配件费用
             fares_charge --车船费用
         from ciss_service_repair;
         ```

       - **ciss_service_order**：服务单信息表

         ```sql
         select
           id,            --服务单id
           workorder_id,  --工单id
           type           --工单类型,1-安装，2-维修，3-巡检
         from ciss_service_order;
         ```

       - **ciss_service_workorder**：工单详情事实表

         ```sql
         select
             id,--工单id
             service_userid,--工程师id
             service_station_id,--服务站点id
             oil_station_id,--油站id
             create_time --创建时间
         from ciss_service_workorder;
         ```

       - **ciss_service_order_device**：服务单设备信息表

         ```sql
         select
             id,               --设备id
             service_order_id  --服务单id
         from ciss_service_order_device;
         ```

       - **ciss_service_fault_dtl**：设备故障信息表

         ```sql
         select
             serviceorder_device_id,--服务单设备id
             solution_id,--解决方案id,1-维修，2-更换，3-升级
             fault_type_id --故障分类id
         from ciss_service_fault_dtl;
         ```

   - **小结**

     - 掌握DWB层维修事实指标表的需求分析

2. #### 构建实现

   - **目标**：**实现DWB层维修事实指标表的构建**

   - **实施**

     - **建表**

       ```sql
       drop table if exists one_make_dwb.fact_srv_repair;
       create table if not exists one_make_dwb.fact_srv_repair(
           rpr_id string comment '维修单id'
           , rpr_code string comment '维修单编码'
           , srv_user_id string comment '服务人员用户id'
           , ss_id string comment '服务网点id'
           , os_id string comment '油站id'
           , date_id string comment '日期id'
           , exp_rpr_num string comment '收费维修数量'
           , hour_money int comment '工时费用'
           , parts_money int comment '配件费用'
           , fars_money int comment '车船费用'
           , rpr_device_num int comment '维修设备数量'
           , rpr_mtrl_num int comment '维修配件数量'
           , exchg_parts_num int comment '更换配件数量'
           , upgrade_parts_num int comment '升级配件数量'
           , fault_type_ids string comment '故障类型id集合'
       ) comment '维修单事实表'
       partitioned by (dt string)
       stored as orc
       location '/data/dw/dwb/one_make/fact_srv_repair';
       ```

     - **抽取**

       ```sql
       insert overwrite table one_make_dwb.fact_srv_repair partition(dt = '20210101')
       select
           repair.id rpr_id                                              --维修单id
       	, repair.code rpr_code                                        --维修单号
       	, swo.service_userid srv_user_id                              --工程师id
       	, swo.service_station_id ss_id                                --服务网点id
       	, swo.oil_station_id os_id                                    --油站id
       	, swo.create_time date_id                                     --创建时间
       	, case when repair.is_pay = 1 then 1 else 0 end exp_rpr_num   --收费维修数量
       	, repair.hour_charge hour_money                               --工时费用
       	, repair.parts_charge parts_money                             --配件费用
       	, repair.fares_charge fars_money                              --车船费用
       	, rpr_device_num                                              --维修设备数量
       	, rpr_mtrl_num                                                --维修配件数量
       	, exchg_parts_num                                             --更换配件数量
       	, upgrade_parts_num                                           --升级配件数量
       	, fault_type_ids                                              --故障类型id集合
       	--维修信息表
       from one_make_dwd.ciss_service_repair repair
       	--服务单信息表
           left join one_make_dwd.ciss_service_order sorder on repair.service_id = sorder.id
       	--工单信息表
           left join one_make_dwd.ciss_service_workorder swo on sorder.workorder_id = swo.id
       	--获取维修设备数量
           left join (
       		select
       			rep.id, count(rep.id) rpr_device_num
       		from one_make_dwd.ciss_service_repair rep
       		left join one_make_dwd.ciss_service_order sod on rep.service_id = sod.id
       		left join one_make_dwd.ciss_service_order_device dev on sod.id = dev.service_order_id
       		group by rep.id
           ) repairdvc on repair.id = repairdvc.id
       	--获取维修、更换、升级配件数量
           left join (
       		select
       			rep.id,
           	   sum(case when sfd.solution_id = 1 then 1 else 0 end) rpr_mtrl_num,
           	   sum(case when sfd.solution_id = 2 then 1 else 0 end) exchg_parts_num,
           	   sum(case when sfd.solution_id = 3 then 1 else 0 end) upgrade_parts_num
       		from one_make_dwd.ciss_service_repair rep
           	left join one_make_dwd.ciss_service_order sod on rep.service_id = sod.id
           	left join one_make_dwd.ciss_service_order_device dev on sod.id = dev.service_order_id
           	left join one_make_dwd.ciss_service_fault_dtl sfd on dev.id = sfd.serviceorder_device_id
       		group by dev.id,rep.id
           ) dvcnum on repair.id = dvcnum.id
       	--获取故障类型ID
           left join (
       		select
       			rep.id, concat_ws(',', collect_set(sfd.fault_type_id)) fault_type_ids
       		from one_make_dwd.ciss_service_repair rep
           	left join one_make_dwd.ciss_service_order sod on rep.service_id = sod.id
           	left join one_make_dwd.ciss_service_order_device dev on sod.id = dev.service_order_id
           	left join one_make_dwd.ciss_service_fault_dtl sfd on dev.id = sfd.serviceorder_device_id
       		where sfd.fault_type_id is not null
       		group by rep.id
           ) faulttype on repair.id = faulttype.id
       where repair.dt = '20210101'
       ;
       ```

   - **小结**

     - 实现DWB层维修事实指标表的构建

### 2. 客户回访事务事实表

1. #### 需求分析

   - **目标**：**掌握DWB层客户回访事实指标表的需求分析**

   - **路径**

     - step1：目标需求
     - step2：数据来源

   - **实施**

     - **目标需求**：基于客户回访数据统计工单满意数量、不满意数量、返修数量等指标

       ![image-20211003174758208](assets/image-20211003174758208.png)

     - **数据来源**

       - **ciss_service_return_visit**：回访信息表

         ```sql
         select
             id,--回访id
             code,--回访编号
             workorder_id,--工单id
             create_userid, --回访人员id
             service_attitude,--服务态度
             response_speed,--响应速度
             repair_level,--服务维修水平
             is_repair --是否返修
         from ciss_service_return_visit;
         ```

         - 1：满意
         - 2：不满意

       - **ciss_service_workorder**：服务工单信息表

         ```sql
         select
             id,--工单id
             service_userid,--工程师id
             service_station_id,--服务站点id
             oil_station_id --油站id
         from ciss_service_workorder;
         ```

   - **小结**

     - 掌握DWB层客户回访事实指标表的需求分析

2. #### 构建实现

   - **目标**：**实现DWB层客户回访事实指标表的构建**

   - **实施**

     - **建表**

       ```sql
       -- 创建客户回访实时表
       drop table if exists one_make_dwb.fact_srv_rtn_visit;
       create table if not exists one_make_dwb.fact_srv_rtn_visit(
           vst_id string comment '回访id'
           , vst_code string comment '回访编号'
           , wrkodr_id string comment '工单id'
           , srv_user_id string comment '服务人员用户id'
           , os_id string comment '油站id'
           , ss_id string comment '服务网点id'
           , vst_user_id string comment '回访人员id'
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
       partitioned by (dt string)
       stored as orc
       location '/data/dw/dwb/one_make/fact_srv_rtn_visit';
       ```

     - **抽取**

       ```sql
       insert overwrite table one_make_dwb.fact_srv_rtn_visit partition(dt = '20210101')
       select
           visit.id vst_id                         --回访id
       	, visit.code vst_code                   --回访编号
       	, visit.workorder_id wrkodr_id          --工单id
       	, swo.service_userid srv_user_id        --工程师id
       	, swo.oil_station_id os_id              --油站id
       	, swo.service_station_id ss_id          --服务网点id
       	, visit.create_userid vst_user_id       --回访人员id
       	, satisfied_num                         --满意数量
       	, unsatisfied_num                       --不满意数量
       	, srv_atu_num                           --服务态度满意数量
       	, srv_bad_atu_num                       --服务态度不满意数量
       	, srv_rpr_prof_num                      --服务水平满意数量
       	, srv_rpr_unprof_num                    --服务水平不满意数量
       	, srv_high_res_num                      --服务响应速度满意数量
       	, srv_low_res_num                       --服务响应速度不满意数量
       	, rtn_rpr_num                           --返修数量
       --回访信息表
       from one_make_dwd.ciss_service_return_visit visit
       --工单信息表
       left join one_make_dwd.ciss_service_workorder swo on visit.workorder_id = swo.id
       --获取满意与不满意个数
       left join (
           select visit.workorder_id,
       	    sum(case when visit.service_attitude = 1 and visit.response_speed = 1 and visit.repair_level = 1 then 1 else 0 end) satisfied_num,
       	    sum(case when visit.service_attitude = 0 then 1 when visit.response_speed = 0 then 1 when visit.repair_level = 0 then 1 when visit.yawp_problem_type = 0 then 1 else 0 end) unsatisfied_num,
       	    sum(case when visit.service_attitude = 1 then 1 else 0 end) srv_atu_num,
       	    sum(case when visit.service_attitude = 0 then 1 else 0 end) srv_bad_atu_num,
       	    sum(case when visit.repair_level = 1 then 1 else 0 end) srv_rpr_prof_num,
       	    sum(case when visit.repair_level = 0 then 1 else 0 end) srv_rpr_unprof_num,
       	    sum(case when visit.response_speed = 1 then 1 else 0 end) srv_high_res_num,
       	    sum(case when visit.response_speed = 0 then 1 else 0 end) srv_low_res_num,
       	    sum(case when visit.is_repair = 1 then 1 else 0 end) rtn_rpr_num
           from one_make_dwd.ciss_service_return_visit visit
       	left join one_make_dwd.ciss_service_workorder swo on visit.workorder_id = swo.id
       	where visit.dt = '20210101'
       	group by visit.workorder_id
       ) vstswo on visit.workorder_id = vstswo.workorder_id
       where visit.dt = '20210101'
       ;
       ```

   - **小结**

     - 实现DWB层客户回访事实指标表的构建

### 3. 费用事务事实表

- **目标**：**实现DWB层费用报销事实指标表的构建**

- **路径**

  - step1：目标需求
  - step2：数据来源
  - step3：目标实现

- **实施**

  - **目标需求**：基于费用报销数据统计费用报销金额等指标

    ![image-20211003182720330](assets/image-20211003182720330.png)

  - **数据来源**

    - **ciss_service_expense_report**：费用信息表

      ```sql
      select
          id,--报销单id
          create_user_id,--创建人id
          submoney5, --报销金额
          create_org_id --部门id
      from ciss_service_expense_report;
      ```

    - **ciss_base_servicestation**：服务网点信息表

      ```sql
      select
          id,--服务网点id
          org_id --部门id
      from ciss_base_servicestation;
      ```

    - **ciss_service_exp_report_dtl**：费用明细表

      ```sql
      select
          exp_report_id,--报销单id
          submoney5,--项目报销实际金额
          item_id --费用项目id
      from ciss_service_exp_report_dtl;
      ```

    - **tmp_dict**：数据字典表

      ```sql
      select
             dictid, --项目id
             dictname --项目名称
      from one_make_dwb.tmp_dict where dicttypename = '费用报销项目';
      ```

  - **目标实现**

    - **建表**

      ```sql
      drop table if exists one_make_dwb.fact_regular_exp;
      create table if not exists one_make_dwb.fact_regular_exp(
            exp_id string comment '费用报销id'
          , ss_id string comment '服务网点id'
          , srv_user_id string comment '服务人员id'
          , actual_exp_money decimal(20,1) comment '费用实际报销金额'
          , exp_item string comment '费用项目id'
          , exp_item_name string comment '费用项目名称'
          , exp_item_money decimal(20,1) comment '费用项目实际金额'
      )
      partitioned by (dt string)
      stored as orc
      location '/data/dw/dwb/one_make/fact_regular_exp';
      ```

    - **抽取**

      ```sql
      insert overwrite table one_make_dwb.fact_regular_exp partition(dt = '20210101')
      select
          /*+repartitions(1) */
          exp.id as exp_id                           --费用报销id
          , ss.id as ss_id                           --服务网点id
          , exp.create_user_id as srv_user_id        --创建人id
          , exp.submoney5 as actual_exp_money        --实际报销金额
          , dict.dictid as exp_item                  --费用项目id
          , dict.dictname as exp_item_name           --费用项目名称
          , exp_dtl.submoney5 as exp_item_money      --费用项目金额
      from
      --费用信息表
      (
          select
      	    *
      	from one_make_dwd.ciss_service_expense_report
          where dt = '20210101' and status = 9 --只取制证会计已审状态
      ) exp
      --服务网点信息表
      left join one_make_dwd.ciss_base_servicestation ss
      on ss.dt = '20210101' and ss.org_id = exp.create_org_id
      --报销明细表
      left join one_make_dwd.ciss_service_exp_report_dtl exp_dtl
      on exp_dtl.dt = '20210101' and exp.id = exp_dtl.exp_report_id
      --数据字典表
      left join one_make_dwb.tmp_dict dict
      on dict.dicttypename = '费用报销项目' and dict.dictid = exp_dtl.item_id
      ;
      ```

- **小结**

  - 实现DWB层费用报销事实指标表的构建

### 4. 差旅费用事务事实表

- **目标**：**实现DWB层差旅报销事实指标表的构建**

- **路径**

  - step1：目标需求
  - step2：数据来源
  - step3：目标实现

- **实施**

  - **目标需求**：基于差率报销信息统计交通费用、住宿费用、油费金额等报销费用指标

    ![image-20211003210750811](assets/image-20211003210750811.png)

  - **数据来源**

    - ciss_service_trvl_exp_sum：差旅报销汇总信息表

      ```sql
      select
          id,--汇总费用报销单id
          user_id,--报销人id【工程师id】
          status,--汇总单状态：15表示审核通过
          submoney5 --应收报销总金额
      from one_make_dwd.ciss_service_trvl_exp_sum;
      ```

    - ciss_s_exp_report_wo_payment：汇总报销单与工单费用单对照表

      ```sql
      select
          exp_report_id,--汇总费用报销单id
          workorder_travel_exp_id --费用单id
      from one_make_dwd.ciss_s_exp_report_wo_payment;
      ```

    - ciss_service_travel_expense：差旅报销单信息表

      ```sql
      select
          id,--费用单id
          work_order_id --工单id
      from one_make_dwd.ciss_service_travel_expense;
      ```

    - ciss_service_workorder：工单信息表

      ```sql
      select
          id,--工单id
      service_station_id --服务网点id
      from one_make_dwd.ciss_service_workorder;
      ```

    - ciss_service_trvl_exp_dtl：差旅费用明细表

      ```sql
      select
          travel_expense_id,--费用单id
          item,--费用项目名称
          submoney5 --费用金额
      from one_make_dwd.ciss_service_trvl_exp_dtl;
      ```

  - **目标实现**

    - **建表**

      ```sql
      drop table if exists one_make_dwb.fact_trvl_exp;
      create table if not exists one_make_dwb.fact_trvl_exp(
          trvl_exp_id string comment '差旅报销单id'
          , ss_id string comment '服务网点id'
        , srv_user_id string comment '服务人员id'
          , biz_trip_money decimal(20,1) comment '外出差旅费用金额总计'
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
      partitioned by (dt string)
      stored as orc
      location '/data/dw/dwb/one_make/fact_trvl_exp';
      ```

    - **抽取**

      ```sql
      insert overwrite table one_make_dwb.fact_trvl_exp partition(dt = '20210101')
      select
      	--差旅费汇总单id
          exp_sum.id as trvl_exp_id
      	--服务网点id
          , wrk_odr.service_station_id as ss_id
      	--服务人员id
          , exp_sum.user_id as srv_user_id
      	--外出差旅费用金额总计
          , sum(case when trvl_dtl_sum.item = 1 then trvl_dtl_sum.item_money else 0 end) as biz_trip_money
          --市内交通费用金额总计
      	, sum(case when trvl_dtl_sum.item = 2 then trvl_dtl_sum.item_money else 0 end) as in_city_traffic_money
          --住宿费费用金额总计
      	, sum(case when trvl_dtl_sum.item = 3 then trvl_dtl_sum.item_money else 0 end) as hotel_money
          --车船费用金额总计
      	, sum(case when trvl_dtl_sum.item = 4 then trvl_dtl_sum.item_money else 0 end) as fars_money
          --补助费用金额总计
      	, sum(case when trvl_dtl_sum.item = 5 then trvl_dtl_sum.item_money else 0 end) as subsidy_money
          --过桥过路费用金额总计
      	, sum(case when trvl_dtl_sum.item = 6 then trvl_dtl_sum.item_money else 0 end) as road_toll_money
          --油费金额总计
      	, sum(case when trvl_dtl_sum.item = 7 then trvl_dtl_sum.item_money else 0 end) as oil_money
          --二单补助费用总计
      	, sum(case when trvl_dtl_sum.item = 8 then trvl_dtl_sum.item_money else 0 end) as secondary_money
          --三单补助费用总计
      	, sum(case when trvl_dtl_sum.item = 9 then trvl_dtl_sum.item_money else 0 end) as third_money
          --费用报销总计
      	, max(exp_sum.submoney5) as actual_total_money
      --差旅报销汇总单
      from one_make_dwd.ciss_service_trvl_exp_sum exp_sum
      --汇总报销单与工单费用单对照表
      inner join one_make_dwd.ciss_s_exp_report_wo_payment r on exp_sum.dt = '20210101' and r.dt = '20210101' and exp_sum.id = r.exp_report_id and exp_sum.status = 15
      --差旅报销单信息表
      inner join one_make_dwd.ciss_service_travel_expense exp on exp.dt = '20210101' and exp.id = r.workorder_travel_exp_id
      --工单信息表
      inner join one_make_dwd.ciss_service_workorder wrk_odr on wrk_odr.dt = '20210101' and wrk_odr.id = exp.work_order_id
      --获取每种费用项目总金额
      inner join  (
      				select
      					travel_expense_id, item, sum(submoney5) as item_money
      				from one_make_dwd.ciss_service_trvl_exp_dtl
      				where dt = '20210101'
      				group by travel_expense_id, item
      		) as trvl_dtl_sum
        on trvl_dtl_sum.travel_expense_id = exp.id
      group by exp_sum.id, wrk_odr.service_station_id, exp_sum.user_id
      ;
        
      ```

- **小结**

  - 实现DWB层差旅报销事实指标表的构建

### 5. 网点物料事实表

- **目标**：**实现DWB层网点物料事实指标表的构建**

- **路径**

  - step1：目标需求
  - step2：数据来源
  - step3：目标实现

- **实施**

  - **目标需求**：基于物料申请单的信息统计物料申请数量、物料申请金额等指标

    ![image-20211003220952233](assets/image-20211003220952233.png)

  - **数据来源**

    - ciss_material_wdwl_sqd：物料申请信息表

      ```sql
      select
          id,--申请单id
          code,--申请单编号
          service_station_code,--服务网点编号
          logistics_type,--物流公司类型
          logistics_company,--物流公司名称
          warehouse_code --仓库id
      from ciss_material_wdwl_sqd;
      ```

    - **ciss_base_servicestation**：服务网点信息表

      ```sql
      select
          id,--服务网点id
          code --服务网点编号
      from ciss_base_servicestation;
      ```

    - **ciss_material_wdwl_sqd_dtl**：物料申请明细表

      ```sql
      select
          wdwl_sqd_id,--申请单id
          application_reason,--申请理由
          count_approve,--审核数量
          price,--单价
          count --个数
      from ciss_material_wdwl_sqd_dtl;
      ```

  - **目标实现**

    - **建表**

      ```sql
      create table if not exists one_make_dwb.fact_srv_stn_ma(
            ma_id string comment '申请单id'
          , ma_code string comment '申请单编码'
          , ss_id string comment '服务网点id'
          , logi_id string comment '物流类型id'
          , logi_cmp_id string comment '物流公司id'
          , warehouse_id string comment '仓库id'
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
      partitioned by (dt string)
      stored as orc
      location '/data/dw/dwb/one_make/fact_srv_stn_ma';
      ```

    - **抽取**

      ```sql
      insert overwrite table one_make_dwb.fact_srv_stn_ma partition(dt = '20210101')
      select    
      	/*+repartition(1) */ 
          ma.id as ma_id, 	                       --物料申请单id
      	ma.code as ma_code,                        --申请单编号
      	stn.id as ss_id,                           --服务网点id
      	ma.logistics_type as logi_id,              --物流类型id
      	ma.logistics_company as logi_cmp_id,       --物流公司id
          ma.warehouse_code as warehouse_id,         --仓库id
      	sum(m_smry.cnt) as total_m_num ,           --申请物料总数量
      	sum(m_smry.money) as total_m_money,        --申请物料总金额
          count(1) as ma_form_num,                   --申请单数量
      	sum(case when m_smry.ma_rsn = 1 then m_smry.cnt else 0 end) as inst_m_num,        --安装申请物料数量   
          sum(case when m_smry.ma_rsn = 1 then m_smry.money else 0 end) as inst_m_money,    --安装申请物料金额
          sum(case when m_smry.ma_rsn = 2 then m_smry.cnt else 0 end) as bn_m_num,          --保内申请物料数量
          sum(case when m_smry.ma_rsn = 2 then m_smry.money else 0 end) as bn_m_money,      --保内申请物料金额
          sum(case when m_smry.ma_rsn = 3 then m_smry.cnt else 0 end) as rmd_m_num,         --改造申请物料数量
          sum(case when m_smry.ma_rsn = 3 then m_smry.money else 0 end) as rmd_m_money,     --改造申请物料金额
          sum(case when m_smry.ma_rsn = 4 then m_smry.cnt else 0 end) as rpr_m_num,         --维修申请物料数量
          sum(case when m_smry.ma_rsn = 4 then m_smry.money else 0 end) as rpr_m_money,     --维修申请物料金额
          sum(case when m_smry.ma_rsn = 5 then m_smry.cnt else 0 end) as sales_m_num,       --销售申请物料数量
          sum(case when m_smry.ma_rsn = 5 then m_smry.money else 0 end) as sales_m_money,   --销售申请物料金额
          sum(case when m_smry.ma_rsn = 6 then m_smry.cnt else 0 end) as insp_m_num,        --巡检申请物料数量
          sum(case when m_smry.ma_rsn = 6 then m_smry.money else 0 end) as insp_m_money     --巡检申请物料金额
      --物料申请信息表:8为审核通过
      from (
      		select * 
      		from one_make_dwd.ciss_material_wdwl_sqd 
      		where dt = '20210101' and status = 8 
      	 ) ma
      --关联站点信息表，获取站点id
      left join one_make_dwd.ciss_base_servicestation stn 
      	on stn.dt = '20210101' and ma.service_station_code = stn.code
      --关联物料申请费用明细
      left join (
      			 select 
      				dtl.wdwl_sqd_id as wdwl_sqd_id, 
      				dtl.application_reason as ma_rsn, 
      				sum(dtl.count_approve) as cnt,
                      sum(dtl.price * dtl.count) as money
                   from one_make_dwd.ciss_material_wdwl_sqd_dtl dtl
      			 where dtl.dt = '20210101'
      			 group by dtl.wdwl_sqd_id, dtl.application_reason
                ) m_smry on m_smry.wdwl_sqd_id = ma.id
      group by ma.id, ma.code, stn.id, ma.logistics_type, ma.logistics_company, ma.warehouse_code
      ;
      ```

- **小结**

  - 实现DWB层网点物料事实指标表的构建

## II. ST层构建: 周期快照事实表

- **目标**：**掌握ST层的设计**

- **路径**

  - step1：功能
  - step2：来源
  - step3：需求

- **实施**

  - **功能**：数据应用层，用于支撑对外所有主题的==报表==应用数据的结果

    - **对外提供整个公司所有运营的报表**

  - **来源**：对DWB层的主题事实数据关联DWS层的维度表进行最终聚合

    - DWS：维度表：时间、地区、油站、组织机构

      - 时间维度表：年、季度、月、周、天

        ```
        dt				year    quater		month    		week  
        2022-01-01		2022	Q1			2022-01			1
        ```

    - DWB：主题事实表：工单、呼叫中心、费用

      - 工单主题表：天、工单id、工单个数【1】

        ```
        dt		wokerorder_id		wo_cnt		install_cnt  rep_cnt  ins_cnt   rem_cnt
        								1			1			0		0			0
        ```

    - ST：每个月对应的工单总个数

      ```
      select
      	b.month,
      	sum(wo_cnt),
      	sum(install_cnt)
      	……
      from fact_workorder a
      join dim_time b on a.dt = b.dt
      group by b.month
      ```

  - **需求**：按照一站制造的业务主题的划分需求，构建每个主题的ST层的数据

- **小结**

  - 掌握ST层的设计

### 1. 工单主题

1. #### 需求分析

   

2. #### 构建实现

   

### 2. 油站主题

1. #### 需求分析

   

2. #### 构建实现

   

### 3. 回访主题

1. #### 需求分析

   

2. #### 构建实现

   

### 4. 费用主题

1. #### 需求分析

   

2. #### 构建实现

   

### 5. 派单主题



### 6. 安装主题



### 7. 维修主题



### 8. 物料主题



## III. DM层构建