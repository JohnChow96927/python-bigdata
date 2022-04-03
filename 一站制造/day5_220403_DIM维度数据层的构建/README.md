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