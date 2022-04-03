# DIM维度数据层构建

## I. 分层回顾

- **目标**：回顾一站制造项目分层设计

- **实施**

  ![image-20210821102418366](assets/image-20210821102418366.png)

  - **ODS层** ：原始数据层
  - **DWD层**：明细数据层
  - **DIM层**：维度数据层
  - **DWB层**：轻度汇总层
  - **ST层**：数据应用层

- **小结**

  - 回顾一站制造项目分层设计

## II. DIM层构建

### 1. 行政地区维度设计

- **目标**：**掌握行政地区维度的需求及设计**

- **路径**

  - step1：需求
  - step2：设计

- **实施**

  - **需求**：构建行政地区维度表，得到所有省份、城市、县区及乡镇维度信息

    - 省份维度表

      ```
      省份id	省份名称
      ```

    - 城市维度表

      ```
      省份id	省份名称	城市id	城市名称
      ```

    - 县区维度表

      ```
      省份id	省份名称	城市id	城市名称	县区id	县区名称
      ```

    - 乡镇维度表

      ```
      --省份id	省份名称	城市id	城市名称	县区id	县区名称	乡镇id	乡镇名称
      --11       北京市      1101     北京市      110108    海淀区    110108014  清华园街道
      ```

    - 统计不同地区维度下的网点个数、工单个数、报销金额等

  - **设计**

    - **数据来源**：one_make_dwd.ciss_base_areas

      ```
      select * from one_make_dwd.ciss_base_areas;
      ```

      - 举例

        - 清华园街道：4

          ![image-20211002231129906](assets/image-20211002231129906.png)

        - 海淀区：3

          ​							![image-20211002231236132](assets/image-20211002231236132.png)

          

        - 北京市【市级】2

          ![image-20211002231347525](assets/image-20211002231347525.png)

        - 北京市【省级】1

          ![image-20211002231416445](assets/image-20211002231416445.png)

    - **实现思路**：以乡镇维度为例

      - 获取所有乡镇的信息

        ```sql
        select id area_id,areaname area,parentid from one_make_dwd.ciss_base_areas where rank = 4;
        ```

      - 获取所有县区的信息

        ```sql
        select id county_id,areaname county,parentid from one_make_dwd.ciss_base_areas where rank = 3;
        ```

      - 获取所有省份的信息

        ```sql
        select id city_id,areaname city,parentid from one_make_dwd.ciss_base_areas where rank = 2;
        ```

      - 获取所有省份的信息

        ```sql
        select id province_id,areaname province,parentid from one_make_dwd.ciss_base_areas where rank = 1;
        ```

      - 需求：获取每个镇的所有行政地区信息

        ```
        省份id	省份名称	城市id	城市名称	县区id	县区名称		乡镇id	乡镇名称
        ```

      - 实现：下一级地区的父id = 上一级地区的id

        ```sql
        select
            a.townid, townname,
            b.countyid, countyname,
            c.cityid, cityname,
            d.provinceid,d.provincename
        from
            (select id townid, areaname townname ,parentid from one_make_dwd.ciss_base_areas where rank = 4) a
        join
            (select id countyid, areaname countyname ,parentid from one_make_dwd.ciss_base_areas where rank = 3) b
        on a.parentid = b.countyid
        join
            (select id cityid, areaname cityname ,parentid  from one_make_dwd.ciss_base_areas where rank = 2)  c
        on b.parentid = c.cityid
        join
            (select id provinceid, areaname provincename ,parentid from one_make_dwd.ciss_base_areas where rank = 1) d
        on c.parentid = d.provinceid;
        ```

### 2. 行政地区维度构建

- **目标**：**实现行政地区维度表的构建**

- **实施**

  - **建维度库**

    ```sql
    create database if not exists one_make_dws;
    ```

  - **建维度表**

    - 区域粒度【乡镇】

      ```sql
      create external table if not exists one_make_dws.dim_location_areas(
          id string comment 'id'
          , province_id string comment '省份ID'
          , province string comment '省份名称'
          , province_short_name string comment '省份短名称'
          , city_id string comment '城市ID'
          , city string comment '城市'
          , city_short_name string comment '城市短名称'
          , county_id string comment '县城ID'
          , county string comment '县城'
          , county_short_name string comment '县城短名称'
          , area_id string comment '区域ID'
          , area string comment '区域名称'
          , area_short_name string comment '区域短名称'
      ) comment '区域维度区域级别表'
      stored as orc
      tblproperties ("orc.compress"="SNAPPY")
      location '/data/dw/dws/one_make/dim_location_areas';
      ```

    - 县区粒度

      ```sql
      create external table if not exists one_make_dws.dim_location_county(
          id string comment 'id'
          , province_id string comment '省份ID'
          , province string comment '省份名称'
          , province_short_name string comment '省份短名称'
          , city_id string comment '城市ID'
          , city string comment '城市'
          , city_short_name string comment '城市短名称'
          , county_id string comment '县城ID'
          , county string comment '县城'
          , county_short_name string comment '县城短名称'
      ) comment '区域维度表（县城粒度）'
      stored as orc
      tblproperties ("orc.compress"="SNAPPY")
      location '/data/dw/dws/one_make/dim_location_county';
      ```

  - **抽取数据**

    - 区域粒度

      ```sql
      insert overwrite table one_make_dws.dim_location_areas
      select
        /*+repartition(1) */
          t_area.id as id,
          t_province.id as province_id,
          t_province.areaname as province,
          t_province.shortname as province_short_name,
          t_city.id as city_id,
          t_city.areaname as city,
          t_city.shortname as city_short_name,
          t_county.id as county_id,
          t_county.areaname as county,
          t_county.shortname as county_short_name,
          t_area.id as area_id,
          t_area.areaname as area,
          t_area.shortname area_short_name
      from
          one_make_dwd.ciss_base_areas t_area
          inner join one_make_dwd.ciss_base_areas t_county on t_area.rank = 4 and t_area.parentid = t_county.id
          inner join one_make_dwd.ciss_base_areas t_city on t_county.parentid = t_city.id
          inner join one_make_dwd.ciss_base_areas t_province on t_city.parentid = t_province.id
          inner join one_make_dwd.ciss_base_areas t_nation on t_province.parentid = t_nation.id
      ;
      ```

    - 县区粒度

      ```sql
      insert overwrite table one_make_dws.dim_location_county
      select
        /*+repartition(1) */
          t_county.id as id,
          t_province.id as province_id,
          t_province.areaname as province,
          t_province.shortname as province_short_name,
          t_city.id as city_id,
          t_city.areaname as city,
          t_city.shortname as city_short_name,
          t_county.id as county_id,
          t_county.areaname as county,
          t_county.shortname as county_short_name
      from
          one_make_dwd.ciss_base_areas t_county
          inner join one_make_dwd.ciss_base_areas t_city on t_county.rank =3 and t_county.parentid = t_city.id
          inner join one_make_dwd.ciss_base_areas t_province on t_city.parentid = t_province.id
          inner join one_make_dwd.ciss_base_areas t_nation on t_province.parentid = t_nation.id
      ;
      ```

- **小结**

  - 实现行政地区维度表的构建
  - **自行完善城市粒度、省份粒度**

### 3. 日期时间维度设计



### 4. 日期时间维度构建



### 5. 服务网点维度设计



### 6. 服务网点维度构建



### 7. 油站维度设计



### 8. 油站维度构建



### 9. 组织机构



### 10. 仓库, 物流



## 附: 常见问题

### 1. 未开启Cross Join



### 2. Unable to move source