---
title: Powershell
date: 2022-06-02
categories:
- 技术
tags:
- Powershell
description: 一些Powershell命令，包含帮助、别名、文件操作等
---

## 帮助

`help`/`Get-Help`/`man`

```powershell
help [cmd]
help [cmd] -parameter [para]
```

`Get-Command`/`gcm` 

```powershell
Get-Command -noun [] -verb []
```

`Alias` 

```powershell
Get-Alias [cmd] #获取原名
Get-Alias -Definition [cmd] #获取别名
```

`Show-Command`：图形界面

```powershell
Show-Command [cmd]
```

`PSProvider`

```powershell
Get-PSProvider
```

`Item`

```powershell
Get-Item
Move-Item
New-Item
Remove-Item
Rename-item
Copy-Item
Clear-Item
```

获取文件内容

```powershell
Get-Content [filename]
```

`echo`

```powershell
Write-Output
```

比较文件

```powershell
diff -reference (Get-Content file1) -difference (Get-Content file2)
```

