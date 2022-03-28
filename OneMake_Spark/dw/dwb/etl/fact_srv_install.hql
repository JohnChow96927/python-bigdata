-- inst_id	安装单ID
-- inst_code	安装单编码
-- inst_type_id	安装方式ID
-- srv_user_Id	服务人员用户ID
-- ss_id	服务网点ID
-- os_id	油站ID
-- date_id	日期ID
-- new_inst_num	全新安装数量
-- debug_inst_num	设备联调安装数量
-- repair_num	产生维修安装单数量
-- ext_exp_num	额外收费安装单数量
-- inst_device_num	安装设备数量
-- exp_device_money	安装费用
-- validated_inst_num	审核安装单数量
select sinstall.id inst_id, sinstall.code inst_code, sinstall.install_way inst_type_id, swo.service_userid srv_user_Id,
       swo.service_station_id ss_id, swo.oil_station_id os_id, swo.create_time date_id, new_inst_num, debug_inst_num,
       repair_num, ext_exp_num, inst_device_num, exp_device_money, validated_inst_num
from one_make_dwd.ciss_service_install sinstall
    left join one_make_dwd.ciss_service_order sorder on sinstall.service_id = sorder.id
    left join one_make_dwd.ciss_service_workorder swo on sorder.workorder_id = swo.id
    left join (
        select id,
           case when install_type = 1 then 1 else 0 end new_inst_num,
           case when install_way = 2 then 1 else 0 end debug_inst_num,
           case when is_repair = 1 then 1 else 0 end repair_num,
           case when is_pay = 1 then 1 else 0 end ext_exp_num
        from one_make_dwd.ciss_service_install
) installType on sinstall.id = installType.id
    left join (
        select sorder.id, count(sodevice.id) inst_device_num from one_make_dwd.ciss_service_order sorder
        left join one_make_dwd.ciss_service_order_device sodevice on sorder.id = sodevice.service_order_id
        group by sorder.id
) sodev on sorder.id = sodev.id
    left join (
        select swo.id, sum(dtl.money5) exp_device_money from one_make_dwd.ciss_service_workorder swo
        left join one_make_dwd.ciss_s_install_exp_rep_02_dtl dtl on swo.id = dtl.workorder_id
        where dtl.dt = '20210101' and dtl.money5 is not null group by swo.id
) dtl on swo.id = dtl.id
    left join (
        select swo.id, case when ivalida.has_validate = 1 then 1 else 0 end validated_inst_num from one_make_dwd.ciss_service_workorder swo
        left join one_make_dwd.ciss_service_install_validate ivalida on swo.id = ivalida.workorder_id
) validate on swo.id = validate.id
where swo.service_userid is not null
;

insert overwrite table one_make_dwb.fact_srv_install partition(dt = '20210101')
select sinstall.id inst_id, sinstall.code inst_code, sinstall.install_way inst_type_id, swo.service_userid srv_user_Id,
       swo.service_station_id ss_id, swo.oil_station_id os_id, swo.create_time date_id, new_inst_num, debug_inst_num,
       repair_num, ext_exp_num, inst_device_num, exp_device_money, validated_inst_num
from one_make_dwd.ciss_service_install sinstall
         left join one_make_dwd.ciss_service_order sorder on sinstall.service_id = sorder.id
         left join one_make_dwd.ciss_service_workorder swo on sorder.workorder_id = swo.id
         left join (
    select id,
           case when install_type = 1 then 1 else 0 end new_inst_num,
           case when install_way = 2 then 1 else 0 end debug_inst_num,
           case when is_repair = 1 then 1 else 0 end repair_num,
           case when is_pay = 1 then 1 else 0 end ext_exp_num
    from one_make_dwd.ciss_service_install
) installType on sinstall.id = installType.id
         left join (
    select sorder.id, count(sodevice.id) inst_device_num from one_make_dwd.ciss_service_order sorder
    left join one_make_dwd.ciss_service_order_device sodevice on sorder.id = sodevice.service_order_id
    group by sorder.id
) sodev on sorder.id = sodev.id
         left join (
    select swo.id, sum(dtl.money5) exp_device_money from one_make_dwd.ciss_service_workorder swo
    left join one_make_dwd.ciss_s_install_exp_rep_02_dtl dtl on swo.id = dtl.workorder_id
    where dtl.dt = '20210101' and dtl.money5 is not null group by swo.id
) dtl on swo.id = dtl.id
         left join (
    select swo.id, case when ivalida.has_validate = 1 then 1 else 0 end validated_inst_num from one_make_dwd.ciss_service_workorder swo
    left join one_make_dwd.ciss_service_install_validate ivalida on swo.id = ivalida.workorder_id
) validate on swo.id = validate.id
where swo.service_userid is not null and sinstall.dt = '20210101'
;

-- 对数 21847 21812
select count(1) from one_make_dwd.ciss_service_install;
select count(1) from one_make_dwb.fact_srv_install;
-- 对数：过滤服务人员id为空的有36人
select count(1) from one_make_dwd.ciss_service_install sinstall
                         left join one_make_dwd.ciss_service_order sorder on sinstall.service_id = sorder.id
                         left join one_make_dwd.ciss_service_workorder swo on sorder.workorder_id = swo.id
where swo.service_userid is null
;