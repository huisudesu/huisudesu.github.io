---
title: docker安装openwrt作网关
date: 2022-03-10
categories:
- 技术
tags: 
- docker
- openwrt
description: 使用docker安装openwrt把旧笔记本变成网关
---



## 前期准备

开启网卡混合模式

```bash
sudo ip link set enx00e04c6800fa promisc on
```

创建macvlan网络

```bash
docker network create -d macvlan --subnet=192.168.50.0/24 --gateway=192.168.50.1 -o parent=enx00e04c6800fa macnet
```

pull docker

```bash
docker pull registry.cn-shanghai.aliyuncs.com/suling/openwrt:x86_64
```

## 配置docker

运行docker

```bash
docker run --restart always --name openwrt -d --network macnet --privileged registry.cn-shanghai.aliyuncs.com/suling/openwrt:x86_64 /sbin/init
```

进入docker设置网络

```bash
docker exec -it openwrt bash
vim /etc/config/network
```

更改 Lan 口设置：

```bash
config interface 'lan'
        option type 'bridge'
        option ifname 'eth0'
        option proto 'static'
        option ipaddr '192.168.50.100'
        option netmask '255.255.255.0'
        option ip6assign '60'
        option gateway '192.168.50.1'
        option broadcast '192.168.50.255'
        option dns '192.168.50.1'
```

重启网络

```shell
/etc/init.d/network restart
```

## 进行设置

地址`option ipaddr`

用户名：`root`

密码：`password`



## 宿主机网络恢复

Openwrt容器运行后，宿主机内可能无法正常连接外部网络，需要修改宿主机的 `/etc/network/interfaces` 文件

```bash
cp /etc/network/interfaces /etc/network/interfaces.bak 
vim /etc/network/interfaces 
```

向文件末尾添加：

```bash
auto eth0
iface eth0 inet manual

auto macvlan
iface macvlan inet static
  address 192.168.50.200
  netmask 255.255.255.0
  gateway 192.168.50.1
  dns-nameservers 192.168.50.1
  pre-up ip link add macvlan link eth0 type macvlan mode bridge
  post-down ip link del macvlan link eth0 type macvlan mode bridge
```



## 参考

[在Docker 中运行 OpenWrt 旁路网关](https://mlapp.cn/376.html)
