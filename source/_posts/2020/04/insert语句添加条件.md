---
title: insert语句添加条件
date: 2020-04-08 02:03:58
updated: 2020-04-08 02:03:58
tags: 数据库
---

insert 语句添加 where
用对虚拟表的查询来添加条件，如果不存在，则插入值(1,'haha',3)

```
insert into table_name(id,name,value) 
select 1,'haha',3 from DUAL
where not EXISTS (select * from table_name where id = 1)
```
