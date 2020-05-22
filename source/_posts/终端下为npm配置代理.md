---
title: 终端下为npm配置代理
date: 2020-05-22
updated: 2019-05-22
tags: 代理
---
cnpm太不靠谱，终端下程序又不走代理，这时候就需要一些设置。

<!-- more -->

# 针对npm配置的命令行操作

```shell script
   npm config set <key> <value> [--global]
   npm config get <key>
   npm config delete <key>
   npm config list
   npm config edit
   npm get <key>
   npm set <key> <value> [--global]
```
在设置配置属性时属性值默认是被存储于用户配置文件中，如果加上`--global`，则被存储在全局配置文件中。

用户配置文件一般就是用户根目录下的`.npmrc`文件。

如果要查看npm的所有配置属性（包括默认配置），可以使用`npm config ls -l`。

如果要查看npm的各种配置的含义，可以使用`npm help config`。

# 为npm设置代理

```shell script
npm config set proxy http://127.0.0.1:1087
npm config set https-proxy http://127.0.0.1:1087
```

如果代理需要认证的话可以这样来设置。
```shell script
npm config set proxy http://username:password@server:port
npm config set https-proxy http://username:pawword@server:port
```

如果代理不支持https的话需要修改npm存放package的网站地址。
```shell script
npm config set registry "http://registry.npmjs.org/"
```

清除npm的代理命令如下：
```shell script
npm config delete http-proxy
npm config delete https-proxy
```

也可以单独为这次npm下载定义代理
```shell script
npm install -g pomelo --proxy http://127.0.0.1:1087
```
