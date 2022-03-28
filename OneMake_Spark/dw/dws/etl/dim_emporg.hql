-- 1. 创建dim_emporg维度表
-- empid	人员ID
-- empcode	人员编码
-- empname	人员姓名
-- userid	用户系统ID（登录用户名）
-- orgid	部门id
-- erp_usercode	erp对应的账号ID
-- posid	岗位ID
-- posicode	岗位编码
-- posiname	岗位名称
-- orgid	部门id
-- orgcode	部门编码
-- orgname	部门名称
-- dt	日期分区

-- 实现思路：
-- 先根据dwd层的表进行关联，然后分别把数据取出来
insert overwrite table one_make_dws.dim_emporg partition(dt='20210101')
select
	.[CLH VVVVVVVVVVVVVVVAVCM ,emp.empid as empid
	, emp.empcode as empcode
	, emp.empname as empname
	, emp.userid as userid
	, pos.positionid as posid
	, pos.posicode as posicode
	, pos.posiname as posiname
	, org.orgid as orgid
	, org.orgcode as orgcode
	, org.orgname as orgname
from
    one_make_dwd.org_employee emp
left join one_make_dwd.org_empposition emppos
	on emp.empid = emppos.empid and emp.dt = '20210101' and emppos.dt = '20210101'
left join one_make_dwd.org_position pos
	on emppos.positionid = pos.positionid and pos.dt = '20210101'
left join one_make_dwd.org_organization org
	on pos.orgid = org.orgid and org.dt = '20210101'
;