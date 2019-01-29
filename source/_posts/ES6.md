---
title: ES6
date: 2018-11-06 17:16
tags: JS
---

# 1. 常量：let和const
- 暂时性死区
    如果区块中存在let和const命令，这个区块对这些命令声明的变量，从一开始就形成了封闭作用域。凡是在声明之前就使用这些变量，就会报错。

    ```
    var tmp = 123;
    if (true) {
        tmp = 'abc'; // ReferenceError
        let tmp;
    }
    //上面代码中，存在全局变量tmp，但是块级作用域内
    //let又声明了一个局部变量tmp，导致后者绑定这个块级作用域，
    //所以在let声明变量前，对tmp赋值会报错。
    ```
    总之，在代码块内，使用let命令声明变量之前，该变量都是不可用的。这在语法上，称为“暂时性死区”（temporal dead zone，简称 TDZ）。

<!-- more -->



