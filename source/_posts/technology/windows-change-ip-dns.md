---
title: Windows使用bat脚本一键更改网络设置
date: 2022-04-29
categories:
- 技术
tags:
- Windows
- 网络
- 脚本
description: 使用bat脚本一键更改Windows ipv4和dns设置
---

## 设置ip、dns获取方式为手动

```powershell
netsh interface ip set address name="以太网" source=static addr=192.168.50.138 mask=255.255.255.0 gateway=192.168.50.100
netsh interface ip set dns "以太网" static 192.168.50.100 primary
```

## 设置ip、dns获取方式为DHCP

```powershell
netsh interface ip set address name="以太网" source=dhcp
netsh interface ip set dns name="以太网" source=dhcp
```

## 创建脚本

-   创建bat脚本，输入其中内容
-   发送到桌面快捷方式
-   右键-属性-快捷方式-高级-用管理员身份运行
-   运行脚本
