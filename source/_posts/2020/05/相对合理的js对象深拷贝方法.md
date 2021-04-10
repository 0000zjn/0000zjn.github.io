---
title: 相对合理的js对象深拷贝方法
date: 2020-05-16 14:48
updated: 2020-05-15 14:48
tags: JS
---
如果你不需要循环对象，也不需要保留内置类型，那么你可以使用`JSON.parse(JSON.stringify())`在所有浏览器中获得*最快*的克隆。 
如果你想要一个合适的结构化克隆，`MessageChannel`是你唯一可靠的跨浏览器选择。 

<!-- more -->

利用信道的结构化克隆算法实现深拷贝（异步）
```javascript
function structuralClone(obj) {
    return new Promise(resolve => {
        const { port1, port2 } = new MessageChannel();
        port2.onmessage = ev => resolve(ev.data);
        port1.postMessage(obj);
    });
}

const obj = { a: 1, b: { t: 12 } };
const clone = await structuralClone(obj);
```
