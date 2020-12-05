---
title: Array.prototype.map中的this问题
date: 2020-12-05 18:16:17
updated: 2020-12-05 18:16:17
tags: JavaScript
---
TypeError: Cannot read property 'ctx' of undefined

<!-- more -->

问题代码：
```
class UserInterestsService extends Service {
  getInterests(userInterests) {
    return new Interests(this.ctx, userInterests);
  }
  async getUserInterests() {
    return userInterests.map(this.getInterests);
  }
}
```

问题出在方法getInterests()中，错误内容：TypeError: Cannot read property 'ctx' of undefined

原因：Array.prototype.map()方法将回调的this指向了undefined。

原理：map()方法调用回调的本质是callback.call(thisArg:undefined, ob)，而箭头函数在执行的时候默认不会使用自己的this，而是会和外层的this保持一致。

解决办法：
1、使用map时增加第二个参数：thisArg: this，执行 `callback` 函数时值被用作`this`。
2、使用箭头函数作为回调。
```
return userInterests.map(e => { return this.getInterests(e); });
```
