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

   

### 3. 费用事务事实表



### 4. 差旅费用事务事实



### 5. 网点物料事实表



## II. ST层构建: 周期快照事实表



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