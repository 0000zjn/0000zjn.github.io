---
title: 自己出的一道题，考验对js事件循环的理解
date: 2020-05-21 13:31:57
updated: 2020-05-21 13:31:57
tags: JavaScript
---

<!-- more -->

```javascript
function fun1(a) {
    console.log(1.1);
    setTimeout(() => console.log(a), 0);
}

async function fun2(a) {
    console.log(0.1+a);
    await setTimeout(() => console.log(a), 0);
    console.log(0.2+a)
}

(async () => {
    setTimeout(() => console.log("x"), 0);
    fun2(2);
    await fun2(3);
    await fun1(1);
    fun2(4);
})();

```


答案：


2.1
3.1
2.2
3.2
1.1
4.1
4.2
x
2
3
1
4
