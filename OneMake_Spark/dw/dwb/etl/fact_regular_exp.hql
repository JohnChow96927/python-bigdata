-- exp_id string comment '费用报销ID'
-- ss_id string comment '服务网点ID'
-- srv_user_id string comment '服务人员ID'
-- actual_exp_money decimal(20,1) comment '费用实际报销金额'
-- exp_item string comment '费用项目ID'
-- exp_item_name string comment '费用项目名称'
-- exp_item_money decimal(20,1) comment '费用项目实际金额'
-- 处理方法：
-- 1. 只过滤出来制证会计已审单据
-- 2. 费用取submoney5（表示已审、扣款后的实际金额）
select
      exp.id as exp_id
    , ss.id as ss_id
    , exp.create_user_id as srv_user_id
    , exp.submoney5 as actual_exp_money
    , dict.dictid as exp_item
    , dict.dictname as exp_item_name
    , exp_dtl.submoney5 as exp_item_money
from 
    (select * from one_make_dwd.ciss_service_expense_report where dt = '20210101' and status = 9 /* 只取制证会计已审状态 */) exp
left join
    one_make_dwd.ciss_base_servicestation ss
    on ss.dt = '20210101' and ss.org_id = exp.create_org_id
left join
    one_make_dwd.ciss_service_exp_report_dtl exp_dtl
    on exp_dtl.dt = '20210101' and exp.id = exp_dtl.exp_report_id
left join
    one_make_dwb.tmp_dict dict
    on dict.dicttypename = '费用报销项目' and dict.dictid = exp_dtl.item_id
limit 5
;

insert overwrite table one_make_dwb.fact_regular_exp partition(dt = '20210101')
select
    /*+repartitions(1) */
      exp.id as exp_id
    , ss.id as ss_id
    , exp.create_user_id as srv_user_id
    , exp.submoney5 as actual_exp_money
    , dict.dictid as exp_item
    , dict.dictname as exp_item_name
    , exp_dtl.submoney5 as exp_item_money
from 
    (select * from one_make_dwd.ciss_service_expense_report where dt = '20210101' and status = 9 /* 只取制证会计已审状态 */) exp
left join
    one_make_dwd.ciss_base_servicestation ss
    on ss.dt = '20210101' and ss.org_id = exp.create_org_id
left join
    one_make_dwd.ciss_service_exp_report_dtl exp_dtl
    on exp_dtl.dt = '20210101' and exp.id = exp_dtl.exp_report_id
left join
    one_make_dwb.tmp_dict dict
    on dict.dicttypename = '费用报销项目' and dict.dictid = exp_dtl.item_id
;

-- 对数（测试为138保持一致）
select * from one_make_dwb.fact_regular_exp where dt = '20210101' limit 5;
select count(1) from one_make_dwb.fact_regular_exp where dt = '20210101';

select
    count(1)
from
    (select 
        *
    from 
        (select * from one_make_dwd.ciss_service_expense_report where dt = '20210101' and status = 9) exp
    left join one_make_dwd.ciss_service_exp_report_dtl exp_dtl
        on exp_dtl.dt = '20210101' and exp.id = exp_dtl.exp_report_id
    ) result   
;

-- 检查是否有一个组织机构id对应多个服务中心情况（确认无误）
select
    *
from
    (
        select
            ss.org_id as org_id
            , count(1) as cnt
        from 
            one_make_dwd.ciss_base_servicestation ss
        where
            ss.dt = '20210101'
        group by
            ss.org_id
    ) result
where result.cnt > 1
;
