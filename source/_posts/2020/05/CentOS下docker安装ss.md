---
title: CentOS下docker安装ss
date: 2020-05-13 02:57:29
updated: 2020-05-13 02:57:29
tags: 代理
---

实践记录

<!-- more -->

```bash
#docker安装
yum install -y docker
#启动docker服务
systemctl start docker
#启动Docker服务并设为开机启动
systemctl enable --now docker
#在docker中安装ss服务端
# -k密码 -m加密方式 -p

#run-A
docker run -dt --name ss-server -p 2333:2333 mritd/shadowsocks -s "-s 0.0.0.0 -p 2333 -m aes-256-gcm -k 123456 --fast-open" --restart=always
#run-B kcp
docker run -dt --name ss-server -p 2333:2333 -p 2334:2334/udp mritd/shadowsocks -m "ss-server" -s "-s 0.0.0.0 -p 2333 -m aes-256-gcm -k 123456 --fast-open" -x -e "kcpserver" -k "-t 127.0.0.1:2333 -l :2334 -mode fast2"
#kcp加速版
docker run -dt --name ss-server -p 2333:2333 -p 2334:2334/udp -e SS_CONFIG="-s 0.0.0.0 -p 2333 -m aes-256-gcm -k 123456 --fast-open" -e KCP_MODULE="kcpserver" -e KCP_CONFIG="-t 127.0.0.1:2333 -l :2334 -mode fast2" -e KCP_FLAG="true" mritd/shadowsocks

#安装完之后查看是否安装成功：　
yum list installed | grep docker
#查看docker是否启动成功
systemctl status docker

#centos7系统开始，使用firewalld服务替代了iptables服务
#查看防火墙状态
systemctl status firewalld
#关闭防火墙
systemctl stop firewalld
#关闭iptable
systemctl stop iptables

#查看正在运行的容器
docker ps
#查看所有容器（包括停止的）
docker ps -a
#重启docker服务
systemctl restart docker
#运行容器
docker start/restart/stop ss-server
#强制删除容器
docker rm ss-server -f

```
