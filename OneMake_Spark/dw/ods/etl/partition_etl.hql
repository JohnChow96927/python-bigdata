-- 
-- 创建分区脚本
-- 
alter table one_make_ods.CISS_BASE_AREAS ADD IF NOT EXISTS PARTITION (dt='20210101') location '/data/dw/ods/one_make/full_imp/CISS4.CISS_BASE_AREAS/20210101';
alter table one_make_ods.CISS_BASE_BASEINFO ADD IF NOT EXISTS PARTITION (dt='20210101') location '/data/dw/ods/one_make/full_imp/CISS4.CISS_BASE_BASEINFO/20210101';