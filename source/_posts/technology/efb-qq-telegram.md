---
title: efb实现qq、telegram双向消息转发
date: 2022-03-10
categories:
- 技术
tags: 
- efb
- qq
- telegram
description: 使用efb实现qq、telegram双向消息转发
---


## go-cqhttp

[下载地址](https://github.com/Mrs4s/go-cqhttp/releases)

[参考文档](https://docs.go-cqhttp.org/)

根据参考文档配置相关参数。

运行：

```bash
./go-cqhttp
```

## efb

Telegram创建bot，获取token。

查看自己的Telegram ID。

下载项目

```bash
git clone https://github.com/sullivansuen/TG-EFB-QQ-Docker.git
cd TG-EFB-QQ-Docker
```

修改`./efb/profiles/default/blueset.telegram/config.yaml`中的`token`和`admins`段为上面的token和id。

## 运行

**运行**

```bash
docker-compose up -d
```

**停止**

```bash
docker-compose down
```

## 参考

[Telegram收发QQ信息-EFB和GO-CQHTTP的Docker部署教程](https://sakari.top/2021/11/15/tg-qq-gocq/)

[ TG-EFB-QQ-Docker](https://github.com/xzsk2/TG-EFB-QQ-Docker)
