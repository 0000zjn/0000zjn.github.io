---
title: Koa和Express的区别
date: 2020-04-04 18:31:39
updated: 2020-04-04
tags: Node.js
---

1. Express 和 Koa 最明显的差别就是 Handler 的处理方法，一个是普通的回调函数，在同一线程上完成当前进程的所有Http请求；一个是利用生成器函数（Generator Function）来作为响应器，co作为底层运行框架，利用Generator特性，实现“协程响应”。
2. Express有回调，而Koa没有，借助 promise 和 generator 的能力，丢掉了 callback，完美解决异步组合问题和异步异常捕获问题。
3. Koa新增了一个Context对象，用来代替Express的Request和Response，作为请求的上下文对象。
4. Express 是 Web Framework，而Koa更像是一个中间件框架，其提供的是一个架子，而几乎所有的功能都需要由第三方中间件完成，比如路由。
