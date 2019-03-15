---
title: 二、Java中的switch
date: 2019-03-15 23:46
tags: 重学Java笔记
---

<!-- more -->

1. switch 后面小括号中表达式的值必须是**整型**或**字符型**或**enum枚举类型**，
2. String类型虽然不报错但是无法实现功能，如下方代码：输出“吃主席套餐”。
```
public static void main(String[] args) {
	String today = "六";
	switch (today) {
	case "一":
	case "三":
		System.out.println("吃包子");
		break;
	case "六":
		System.out.println("吃油条");
		break;
	default:
		System.out.println("吃主席套餐");
	}
}
```