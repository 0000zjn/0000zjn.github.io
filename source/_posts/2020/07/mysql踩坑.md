---
title: mysql踩坑
date: 2020-07-05 17:06:47
updated: 2020-07-05 17:06:47
tags: 数据库
---

1. 查询分组后每个组内的数量
group by和count一起用时，count的是分组内成员的数量，而不是分组的数量。
如果要count所有，可以用子查询。
2. 查询 group by A,B的条数？可以用count(distinct B) group by A;

<!-- more -->
