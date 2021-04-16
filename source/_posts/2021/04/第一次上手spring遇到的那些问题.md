---
title: 第一次上手spring遇到的那些问题
date: 2021-04-12 09:42:25
updated: 2021-04-12 09:42:25
tags: Java
---

1、@Transactional 注解标记的方法必须在此service的最外层被调用，换句话说，此方法被同一个service的其他方法调用时，事务无效。事务方法必须由spring Bean实例来调用。
<!-- more -->
详见：事务失效的几种原因(https://blog.csdn.net/f641385712/article/details/80445933)

2、单元测试，运行后提示idea未收到测试事件(Test events were not received)
原因：需要指定使用idea作为测试工具（默认是Gradle）。(https://blog.csdn.net/21aspnet/article/details/108867567)

3、JPA使用Specification进行复杂查询，无法处理[1,2,3]格式的json数组。
MySQL的JSON类型用的人不多，网上资料没有一模一样适配的方案。
附上两种常见需求解决方案：
```
SELECT order0_.id AS id1_53_ WHERE JSON_EXTRACT ( order0_.ext_obj, '$.type' ) = 1

predicateList.add(
    criteriaBuilder.equal(
        criteriaBuilder.function("JSON_EXTRACT", String.class, root.get("extObj"), criteriaBuilder.literal("$.type")),
        1
    )
)
```

```
SELECT * FROM business_package businesspa0_  WHERE  JSON_CONTAINS( businesspa0_.app_id, '3')
恒等于：
SELECT * FROM business_package businesspa0_  WHERE  JSON_CONTAINS( businesspa0_.app_id, '3')=1

predicates.add(
        criteriaBuilder.equal(
                criteriaBuilder.function("JSON_CONTAINS", String.class, root.get("appId"), criteriaBuilder.literal(appId)),
                1
        )
);
```
方案二的恒等说到底还是对SQL语法的理解
