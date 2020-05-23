---
title: 如何从MySQL生成数据库的结构表
date: 2019-05-05 22:44:17
updated: 2019-05-05 22:44:17
tags: 数据库
---
写论文、作业的时候常常需要做一张类似这样的表格，来说明数据库表的结构：

| 列名 | 数据类型 | 约束 | 备注 |
| :------: | :------: | :------: | :------: |
| id | int | PRI | 自增主键 |
| name | varchar(10) |  | 名字 |

表数少时可以一个个慢慢写，当涉及到表过多时，这就是个耗时耗力的苦差事了。那么有什么办法直接生成这样的设计表吗？
<!-- more -->
答案是有的。
在MySQL中，数据库每一个表中的每一列都会在`information_schema.columns`表中对应一行，也就是说，这个表记录了MySQL中每个库、表的结构信息，我们可以通过对它的查询，来生成数据库结构表。

`informaiton_schema.columns`中共有22个列，下面是常用的列名：

1. `table_catalog`：不管是table | view 这个列的值总是def
2. `table_schema`：表 | 视图所在的数据库名
3. `table_name`：表名 | 视图名
4. `column_name`：列名
5. `column_default`：列的默认值
6. `is_nullable`：是否可以取空值
7. `data_type`：列的数据类型
8. `character_maximum_length`：列的最大长度（这列只有在数据类型为 char | varchar 时才有意义）
9. `column_type`：列类型（这个类型包含了`column_name`和`character_maximum_length`的信息）
10. `column_key`：列上的索引类型（主键-->PRI | 唯一索引 -->UNI | 一般索引 -->MUL）

下面是查询的demo：
```
SET @rownum = 0;

SELECT
	(@rownum :=@rownum + 1) 序号,
	COLUMN_NAME 列名,
	COLUMN_TYPE 数据类型,
	column_key 约束,
	IS_NULLABLE 可否为空,
	COLUMN_COMMENT 备注
FROM
	INFORMATION_SCHEMA. COLUMNS
WHERE
	table_schema = '数据库名'
AND table_name = '表名'
-- 用自己的库名表名替换''内容
ORDER BY
	column_key DESC
```
用数据库图形工具（如Navicat）查询后选中所有查询结果，复制出字段名和数据，到表格中粘贴即可。