---
title: docker踩坑
date: 2020-06-02 16:59:18
updated: 2020-06-02 16:59:18
tags: 容器
---

## 1、尝试用docker运行本地新项目，一直启动就关闭。

<!-- more -->

原因：docker必须有前台进程，否则会自动关闭。eggjs的start命令默认有参数 --daemon，

解决方案：将`start`这行里命令里的`--daemon`去掉，即启动eggjs使用`egg-scripts start`就好了。在Docker里eggjs应用要在前台运行。当然，docker自身可以用run -d后台运行。

## 2、容器内应用无法访问宿主机的服务比如mysql。

原因：容器有自己的ip，有别于宿主机。

解决方案：数据库地址填写宿主机的内网ip如 172.** 而不是 127.0.0.1


