---
title: EggJS踩坑
date: 2020-06-01 15:16:44
updated: 2020-06-01 15:16:44
tags: Node.js
---

## 1、无法获取post body

<!-- more -->

背景：调试微信公众平台接口时，微信使用xml传递数据

问题：我在`ctx.request.body`拿不到数据，以为是bodyParser转码失败了，于是尝试了`ctx.request.rawBody`获取转码前的数据，断点测试无果，而header上的`content-length`明确地告诉我是有body的。

原因：egg默认只开启部分post传输格式，xml不在其内。

解决方案：在配置中启用对xml的支持：
```javascript
  config.bodyParser = {
    enableTypes: [
      'json', 'form', 'text', 'xml',
    ],
  };
```

## 2、还是无法获取post body

问题：无法从 `ctx.req.body` 上获取表单格式的请求参数

原因：egg虽然继承自koa，但是 `ctx.req` 并不恒等于 `ctx.request`，官方文档也没有介绍 `ctx.req` 的写法。

解决方案：永远用 `ctx.request` 而不是 `ctx.req`

## 3、无法获取环境config.${env}.js
egg默认在npm里设置的启动命令：egg-scripts start 使用的是production环境，框架默认未生成production的配置文件。
所以，如果在local配置中指定端口，将不会起效。
