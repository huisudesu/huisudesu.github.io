---
title: frp搭建内网穿透
description: 使用frp搭建内网穿透服务，访问内网的文件等
date: 2022-03-08
categories:
- 技术
tags: frp
---

## 下载

frp下载地址：[Github](https://github.com/fatedier/frp/releases) 

下载后解压。

## 服务器端

编辑`frps.ini`

```ini
[common]
bind_port = 7000
vhost_http_port = 7080 #http端口
token = ******

dashboard_port = 7500
# dashboard 用户名密码，默认都为 admin
dashboard_user = admin
dashboard_pwd = admin
```

运行

```bash
./frps -c frps.ini
```



## 客户端

编辑`frpc.ini` 

```ini
[common]
server_addr = *** #域名或ip
server_port = 7000 #同上
token = ***** #同上

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 7022

[smb]
type = tcp
local_ip = 127.0.0.1
local_port = 445
remote_port = 7445

[http]
type = http
local_ip = 127.0.0.1
local_port = 3080
custom_domains = *** #域名
```

运行

```bash
./frpc -c frps.ini
```



