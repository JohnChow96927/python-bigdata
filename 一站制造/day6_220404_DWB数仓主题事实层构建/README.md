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

       ![image-20211003172704904](E:/Heima/%E5%B0%B1%E4%B8%9A%E7%8F%AD%E6%95%99%E5%B8%88%E5%86%85%E5%AE%B9%EF%BC%88%E6%AF%8F%E6%97%A5%E6%9B%B4%E6%96%B0%EF%BC%89/%E4%B8%80%E7%AB%99%E5%88%B6%E9%80%A0%E9%A1%B9%E7%9B%AE/%E9%A2%84%E4%B9%A0%E8%B5%84%E6%96%99/Day05&Day06%E8%AF%BE%E5%89%8D%E7%AC%94%E8%AE%B0/%E8%AF%BE%E5%89%8D%E7%AC%94%E8%AE%B0_Day06_DWB%E6%95%B0%E4%BB%93%E4%B8%BB%E9%A2%98%E4%BA%8B%E5%AE%9E%E5%B1%82%E6%9E%84%E5%BB%BA/Day06_%E6%95%B0%E4%BB%93%E4%B8%BB%E9%A2%98%E5%BA%94%E7%94%A8%E5%B1%82ST%E5%B1%82%E6%9E%84%E5%BB%BA.assets/image-20211003172704904.png)

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

   

### 2. 客户回访事务事实表



### 3. 费用事务事实表



### 4. 差旅费用事务事实



### 5. 网点物料事实表



## II. ST层构建: 周期快照事实表

### 1. 工单主题



### 2. 油站主题



### 3. 回访主题



### 4. 费用主题



### 5. 派单主题



### 6. 安装主题



### 7. 维修主题



## III. DM层构建