insert overwrite table one_make_dws.dim_logistics partition(dt = '20210101')
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
            '物流公司'
            , '物流类型'
        )
order by dict_t.dicttypename, dict_e.dictid
;

-- select * from one_make_dws.dim_logistics;