---
title: MAX() 和 ORDER BY LIMIT 的比较
date: 2020-05-20 13:21:25
updated: 2020-05-20 13:21:25
tags: 数据库
---

查询某字段的最大值，一般有两种方法：

```
SELECT MAX(date) date FROM form_name
SELECT date FROM form_name ORDER BY date LIMIT 1
```

<!-- more -->

## explain结果：
| 1 | id | select_type | table | partitions | type | possible_keys | key| key_len | ref | rows | filtered | Extra |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 有索引MAX | 1 | SIMPLE | null | null | null | null | null | null | null | null | null | Select tables optimized away |
| 有索引LIMIT | 1 | SIMPLE | form_name | null | index | null | ix_ form_name_date | 5 | null | 1 | 100.00 | Using index |
| 无索引MAX | 1 | SIMPLE | form_name | null | ALL | null | null | null | null | 1216666 | 100.00 | null |
| 无索引LIMIT | 1 | SIMPLE | form_name | null | index | null | ix_live_stream_date | 5 | null | 1 | 100.00 | Using index |
最坏的情况，就是没有对 filed 添加索引的情况下。使用 MIN() 或 MAX() 需要单次读取所有的表数据，而使用 ORDER BY LIMII 则首先需要文件排序。

如果数据量超大，那么性能的差异是很明显的。在我的测试机上 ORDER BY LIMIT 往往需要两倍 MIN()/MAX() 的时间。

但是，如果对 field 字段添加了索引，那么差距就不那么明显了。MIN()/MAX() 可以直接从索引中获取最大值和最小值。但 ORDER BY LIMII 仍然需要对索引进行排序。实际的差异可能就微不足道了。

从上面的论述来看，MIN()/MAX() 可能是更好的选择，因为最坏的情况下它更好，最好的情况下差不多。

ORDER BY LIMIT 的使用场景，应该用来查询 TOP N 或者 LOWER N 且 N > 1 这种数据。也就是说获取前 N 条数据列表这种非特例的操作。
