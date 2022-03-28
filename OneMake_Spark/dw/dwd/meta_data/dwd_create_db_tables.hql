create database if not exists one_make_dwd;

-- 行政区域表
-- 1. 没有分区
-- 2. 没有分隔符
-- 3. 使用orc格式
drop table one_make_dwd.ciss_base_areas;
create external table if not exists one_make_dwd.ciss_base_areas(
    id string, 
    areaname string, 
    parentid string, 
    shortname string, 
    lng string, 
    lat string, 
    rank integer, 
    position string, 
    sort integer
) comment '行政地理区域表'
stored as orc
location '/data/dw/dwd/one_make/ciss_base_areas'
;

create external table if not exists one_make_dwd.org_employee(
	empid bigint,
	empcode string,
	operatorid bigint,
	userid string,
	empname string,
	realname string,
	gender string,
	birthdate string,
	position bigint,
	empstatus string,
	cardtype string,
	cardno string,
	indate string,
	outdate string,
	otel string,
	oaddress string,
	ozipcode string,
	oemail string,
	faxno string,
	mobileno string,
	qq string,
	htel string,
	haddress string,
	hzipcode string,
	pemail string,
	party string,
	degree string,
	sortno bigint,
	major bigint,
	specialty string,
	workexp string,
	regdate string,
	createtime string,
	lastmodytime string,
	orgidlist string,
	orgid bigint,
	remark string,
	tenant_id string,
	app_id string,
	weibo string
 )
partitioned by (dt string)
stored as orc
location '/data/dw/dwd/one_make//org_employee'
;