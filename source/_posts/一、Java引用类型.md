---
title: 一、Java引用类型
date: 2019-03-15 22:55
tags: 重学Java笔记
---
> “重学Java笔记”为本人从基础开始复习Java所作的笔记，记下各种已经忘记的基础知识。

<!-- more -->

1. 在Java中类型可分为两大类：值类型与引用类型。值类型就是基本数据类型（byte、short、int、long、float、double、boolean、char）
基本的变量类型只有一块存储空间(分配在栈中), 而引用类型有两块存储空间(一块在栈中,一块在堆中)

2. 如下方代码所示，形参a即该StringBuffer的引用。
```
public class Test {
    public static void Sample(StringBuffer a){
        a.append(" Changed ");
        System.out.println("a: "+a);
    }
    public static void main(String[] args){
        StringBuffer b=new StringBuffer("This is a test!");
        Sample(b);
        System.out.println("b: "+b);
   }
}

运行结果：
a: This is a test! Changed
b: This is a test! Changed
```
引用即指针。
