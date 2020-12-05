---
title: sequelize踩坑
date: 2020-06-03 15:16:44
updated: 2020-06-03 15:16:44
tags: Node.js
---

## 1、Egg.JS中sequelize实例无法获取
<!-- more -->

TypeError: app.Sequelize.query is not a function

正解：
app.taobaoModel.query()

## 2、解决sequelize的副作用：
### 2.1 通过include查询造成的不必要的嵌套
在查询的上层使用col指定查询列
```
attributes: {
  include: [
    [ col('oneCategory.name'), 'oneCategoryName' ],
  ],
  exclude: [ 'createdAt', 'updatedAt', 'deletedAt' ],
},
include: [
  {
    model: app.advModel.ToolCategory,
    as: 'oneCategory',
    attributes: [],
  },
]
```
### 2.2 查询结果为模型实例，需要 `toJson()` 处理
增加参数 `raw: true`，如果需要使用关联查询include，则同时使用 `nest: true`
