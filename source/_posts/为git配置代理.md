---
title: 为git配置代理
date: 2020-05-22
updated: 2019-05-22
tags: 代理
---

> 各平台的 Shadowsocks 客户端都提供一个本地的 socks5 代理和一个 http 代理，建议使用socks5

<!-- more -->

```shell script
#地址带引号可能出错
#不存在https.proxy
git config --global http.proxy socks5://127.0.0.1:1086
```

还有针对 github.com 的单独配置，这更符合工作环境：
```shell script
#只对github.com
git config --global http.https://github.com.proxy socks5://127.0.0.1:1086

#取消代理
git config --global --unset http.https://github.com.proxy
```

在使用 git 开头的路径时，也就是在使用 ssh 通道时
打开用户主目录下的 `.ssh/config` 文件，添加以下内容
```shell script
# 必须是 github.com
Host github.com
HostName github.com
User git
IdentityFile ~/.ssh/id_dsa

# 走 HTTP 代理
ProxyCommand socat - PROXY:127.0.0.1:%h:%p,proxyport=8080

# 走 socks5 代理（如 Shadowsocks）
ProxyCommand nc -v -x 127.0.0.1:1086 %h %p
# 或
ProxyCommand nc -X 5 -x 127.0.0.1:1086 %h %p

#在windows上，因为这个bash是不带netcat的，也就找到不到nc命令。
#在win10上，有的msysgit版本集成了connect工具(没有就先安装)，所以在windows上，可以把ssh的config文件设置为：
ProxyCommand connect -S 127.0.0.1:1080 %h %p
#就可以给ssh加socks代理了。（未测试，有待勘误）
```

