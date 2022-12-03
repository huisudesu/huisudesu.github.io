---
title: ffmpeg命令
date: 2022-05-09
tags:
- ffmpeg
- 视频处理
categories:
- 技术
description: 一些ffmpeg命令，包含渲染参数，查看信息，拼接视频
---

## 渲染

渲染命令

```shell
ffmpeg -i input.mp4 output.mp4
```

一些渲染参数

-   `-hwaccel cuda`：使用cuda加速
-   `-c:v h264_cuvid`：使用n卡加速的h264解码
-   `-c:v h264_nvenc`：使用n卡加速的h264编码
-   `-s 1920x1080`：分辨率
-   `-b:v 2000k`：比特率
-   `-vn`：不输出视频
-   `-ss hh:mm:ss`：开始时间
-   `-t hh:mm:ss`：结束时间
-   `-acodec copy`：音频编码与源格式相同

## 查看信息

查看支持的硬件加速选项

```shell
ffmpeg -hwaccels
```

查看支持的编码器

```shell
ffmpeg -encoders
```

查看支持n卡加速的编码器

```shell
ffmpeg -encoders | sls nv
```

查看支持的h264编码器

```shell
ffmpeg -encoders | sls h264
```

查看支持的解码器

```shell
ffmpeg -decoders
```

查看支持n卡加速的解码器

```shell
ffmpeg -decoders | sls nv
```

查看支持的h264解码器

```shell
ffmpeg -decoders | sls h264
```

## 拼接视频

转换成ts文件拼接：

```bash
ffmpeg -i $f1 -c:v copy -c:a copy -vbsf h264_mp4toannexb 1.ts
ffmpeg -i $f2 -c:v copy -c:a copy -vbsf h264_mp4toannexb 2.ts
ffmpeg -i $f3 -c:v copy -c:a copy -vbsf h264_mp4toannexb 3.ts
ffmpeg -i $f4 -c:v copy -c:a copy -vbsf h264_mp4toannexb 4.ts
ffmpeg -i $f5 -c:v copy -c:a copy -vbsf h264_mp4toannexb 5.ts
ffmpeg -i $f6 -c:v copy -c:a copy -vbsf h264_mp4toannexb 6.ts


ffmpeg -i ”concat:1.ts|2.ts|3.ts|4.ts|5.ts|6.ts“ -acodec copy -vcodec copy -absf aac_adtstoasc $f7

rm *.ts
```
