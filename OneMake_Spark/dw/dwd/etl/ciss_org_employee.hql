
-- 加载org_employee数据到dwd
insert overwrite table one_make_dwd.org_employee partition(dt='20210101')
select
    /*+repartition(1) */
    empid
    , empcode
    , operatorid
    , userid
    , empname
    , realname
    , gender
    , birthdate
    , position
    , empstatus
    , cardtype
    , cardno
    , indate
    , outdate
    , otel
    , oaddress
    , ozipcode
    , oemail
    , faxno
    , mobileno
    , qq
    , htel
    , haddress
    , hzipcode
    , pemail
    , party
    , degree
    , sortno
    , major
    , specialty
    , workexp
    , regdate
    , createtime
    , lastmodytime
    , orgidlist
    , orgid
    , remark
    , tenant_id
    , app_id
    , weibo
from
	one_make_ods.org_employee
where
	dt = '20210101'
;

select * from one_make_dwd.org_employee where dt = '20210101';

-- 加载岗位数据到dwd
insert overwrite table one_make_dwd.org_position partition(dt='20210101')
select
    /*+repartition(1) */
    positionid
    , posicode
    , posiname
    , posilevel
    , positionseq
    , positype
    , createtime
    , lastupdate
    , updator
    , startdate
    , enddate
    , status
    , isleaf
    , subcount
    , tenant_id
    , app_id
    , dutyid
    , manaposi
    , orgid
from
	one_make_ods.org_position
where
	dt = '20210101'
;

