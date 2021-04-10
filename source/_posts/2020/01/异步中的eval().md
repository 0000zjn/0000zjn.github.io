---
title: 异步中的eval()
date: 2020-01-13
updated: 2020-01-13
tags: JS
---

await仅在异步方法中有效
<!-- more -->

```
const session = async () => {
    console.log(111)
};

// 错误的写法
eval(`await session(extra, data)`);// Uncaught SyntaxError: await is only valid in async function

// 正确的写法
eval(`(async () => { await session(extra, data) })()`);
```
