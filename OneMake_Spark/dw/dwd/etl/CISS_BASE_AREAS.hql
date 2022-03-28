--
-- 对CISS_BASE_AREA.hql进行数据装载
-- 
INSERT OVERWRITE TABLE one_make_dwd.CISS_BASE_AREAS
SELECT
    ID,
    AREANAME,
    PARENTID,
    SHORTNAME,
    LNG,
    LAT,
    RANK,
    POSITION,
    SORT
FROM
    one_make_ods.CISS_BASE_AREAS t
WHERE
    t.dt = '20210101'
;

-- 测试数据
SELECT
    *
FROM
    one_make_dwd.CISS_BASE_AREAS
;

-- 通过REPARTITION HINT来调整输出的分区为1个
INSERT OVERWRITE TABLE one_make_dwd.CISS_BASE_AREAS
SELECT
	/*+ REPARTITION(1) */
    ID,
    AREANAME,
    PARENTID,
    SHORTNAME,
    LNG,
    LAT,
    RANK,
    POSITION,
    SORT
FROM
    one_make_ods.CISS_BASE_AREAS t
WHERE
    t.dt = '20210101'
;


