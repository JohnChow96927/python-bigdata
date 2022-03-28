-- 属性维度数据加载
-- prop_name 字典名称
-- type_id 属性id
-- type_name 属性名称
insert overwrite table one_make_dws.dim_service_attribute partition(dt = '20210101')
select
    dict_t.dicttypename as prop_name
    , dict_e.dictid as type_id
    , dict_e.dictname as type_name
from
  one_make_dwd.eos_dict_type dict_t
inner join one_make_dwd.eos_dict_entry dict_e
    on dict_t.dt = '20210101'
        and dict_e.dt = '20210101'
        and dict_t.dicttypeid = dict_e.dicttypeid
        and dict_t.dicttypename in (
            '派工方式'
            , '派工类型'
            , '派工单状态'
            , '派工单--服务类型'
            , '派工单--报修人员'
            , '是否收费'
            , '工单业务类型'
        )
order by dict_t.dicttypename, dict_e.dictid
;

select * from one_make_dws.dim_service_attribute;