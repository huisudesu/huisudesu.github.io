---
title: 变色龙哈希（chameleon hash）
description: 变色龙哈希（chameleon hash）简介及实例
date: 2022-12-20
categories:
- 研究
tags: 
- 哈希函数
- 变色龙哈希
---

## 变色龙哈希简介

在介绍变色龙哈希之前，先介绍陷门（Trapdoor）函数。单向陷门函数 $f$ 是具有以下性质的一类函数：

* 对于定义域 $D$ 中的任意元素 $x$ ，可在多项式时间内计算得到 $f(x)$

* 对于值域 $R$ 中的任意元素 $y$ ，无法在多项式时间内计算得到$f^{-1}(x)$

* 当知道某个信息 $k$ 以后，对于值域 $R$ 中的任意元素 $y$ ，都可以在多项式时间内计算得到 $f_{k}^{-1}(x)$

我们称信息 $k$ 为这个单向陷门函数的**陷门（Trapdoor）**。

**变色龙哈希函数（Chameleon Hash  Function）**就是一种**带陷门的哈希函数，**如果**陷门信息已知**，则可以高效地计算出任意输入数据的碰撞。如果**陷门信息未知**，那么变色龙哈希函数和普通的哈希函数一样具有**抗碰撞性**。

一个变色龙函数由下面**四个函数**组成：

* $Setup(1^{\lambda})\rightarrow(hk,td).$ 给定安全参数 $\lambda$ ，密钥生成算法输出公钥 $hk$ 和陷门 $td$ 

* $Hash(hk,m)\rightarrow (h,r)\Rightarrow Hash(hk,m,r)\rightarrow h.$ 给定公钥 $hk$ ，待哈希的消息 $m$ 和辅助随机数 $r$ ，哈希算法输出哈希值 $h$

* $Trap(td,m,r,m')\rightarrow r'.$ 给定陷门 $td$ ，消息 $m$ ，随机数 $r$ 和另外一个消息 $m'$ ，变色龙算法输出满足$Hash(m,r)=Hash(m',r')$  的 $r'$ ，并且 $r'$ 是在随机数空间均匀分布的

* $Verify(hk,m,h,r)\rightarrow \{0,1\}$ 验证函数，输出True or False


> 除了**不可伪造性**以外，变色龙签名具有比较有趣的性质。我们假定 Bob 掌握一个变色龙哈希算法 的陷门信息，而 Alice 签名的前置哈希算法就是该算法 。当 Alice 签名以后，Bob 如果拿着 Alice 的签名结果给第三方 Charlie 看，第三方必然不会相信这个签名结果，因为 Charlie 知道 Bob 拿有哈希算法的陷门信息，他可以任意更改被签名的消息。即，Bob 不能将 Alice 签名的合法性向第三方展示。这是变色龙签名的**不可传递性**（non-transferability）。另外，Alice 也由于没有陷门信息，不能找到哈希碰撞，从而不能否认其已经签过名，这就是**不可抵赖性**（non-repudiation）。\[1\]


在区块链中，如果将连接区块链的哈希函数改为变色龙哈希函数，陷门信息由**特定人**掌握，则这些特定人就可以任意修改区块数据，而不会破坏链式结构的完整性。这给区块链带来了**可编辑**的特性。\[1\]

下面介绍一些前置知识和变色龙哈希的实例。

## 前置知识

### 双线性映射（Bilinear Mapping）

$(G_1, G_2, G_T)$ 是三个素数 $p$ 阶群乘法循环群，双线性映射 $e:G_1\times G_2\rightarrow G_T$ 是满足如下性质的映射：

* 双线性：对于 $\forall g_1\in G_1,g_2\in G_2,a,b\in Z_p$，均有$e(g_1^a,g_2^b)=e(g_1,g_2)^{ab}$成立

* 非退化性：$\exist g_1\in G_1, g_2\in G_2$满足$e(g_1,g_2)\not=1_{G_T}$

* 可计算性：存在有效的算法，对于$\forall g_1\in G_1, g_2\in G_2$，均可计算$e(g_1,g_2)$

如果$G_1=G_2$ 则称上述双线性配对是对称的，否则是非对称的。

### 拉格朗日多项式（Lagrange polynomial）

对于某个多项式函数，已知有给定的$k+1$个取值点： $(x_0,y_0).\dots,(x_k,y_k)$ ，其中，$x_j$对应自变量，$y_i$对于函数取值，假设任意$x_j$都互不相同。

**拉格朗日插值多项式**为：$L(x):=\sum_{j=0}^{k}y_jl_j(x)$

其中，$l_j(x)$ 为**拉格朗日基本多项式**（或称**插值基函数，**Lagrange basis polynomials），其表达式为： $l_j(x):=\Pi_{i=0,i\not=j}^k\frac{x-x_i}{x_j-x_i}$

拉格朗日基本多项式$l _{j}(x)$的特点是在 $x_{j}$上取值为**1**，在其它的点 $x_{i},\,i\neq j$上取值为**0**。

### Gap Diffie-Hellman (GDP) Group

设 $G$ 是一个素数 $p$ 阶的乘法循环群，生成元为 $g$。

对于 *Diffie-Hellman tuple*: $(g,g^x,g^y,g^{xy})$ ，其中，$x,y\in Z_p^*$，有如下两个问题：

* Computational Diffie-Hellman (CDH) problem

  * 给定 $(g,g^x,g^y)$ ，其中，$x,y\in Z_p^*$ ，计算 $g^{xy}$

* Decisional Diffie-Hellman (DDH) problem

  * 给定 $(g,g^x,g^y,g^{z})$ ，其中，$x,y,z\in Z_p^*$，确定 $g^{xy}=g^z$ 是否成立

**Gap Diffie-Hellman (GDH) group** 是满足如下性质的 group：

* Decisional Diffie-Hellman (DDH) problem 可在多项式时间内解决

* Computational Diffie-Hellman (CDH) problem 没有多项式时间算法以不可忽略的概率解决

## 变色龙哈希

Public Coin Chameleon Hash\[2\] 是一个变色龙哈希的实现，函数的具体实现如下：

* $Setup(1^\lambda)\rightarrow (G_1,G_2,p,g_1,g_2)$

  * 生成素数 $p$ 阶双线性群 $(G_1, G_2, G_T)$

  * $G_1=\langle g_1\rangle, G_2=\langle g_2\rangle$ 生成元

  * 系统参数：$params=(G_1,G_2,p,g_1,g_2)$

* $KeyGen(params)\rightarrow (hk,tk)$

  * 生成 $x\xleftarrow{R}Z_p, \widehat{h}\xleftarrow{R} G_1$

  * $h_1=g^x_1, h_2=g^x_2$

  * $hk=(h_1,h_2,\widehat{h})$

  * $tk=x$

* $Hash(m,hk)\rightarrow (\hslash,R)$

  * 随机数 $r\xleftarrow{R}Z_p$

  * $\hslash=h_1^r\widehat{h}^m$

  * $R=g_1^r$

* $HVerify(m,hk,R)$

  * $true$ if $e(\hslash/\widehat{h}^m,g_2)=e(R,h_2)$

    * $\Leftrightarrow e(h_1^r,g_2)=e(g_1^r,h_2)$

    * $\Leftrightarrow e(g_1^{xr},g_2)=e(g_1^r,g_2^x)$

    * $\Leftrightarrow e(g_1,g_2)^{xr}=e(g_1,g_2)^{xr}$

  * $false$ otherwise

* $Hcol(tk,m,m')$

  * 新message $m'$ ，计算新的 $R'$

  * $R'=(\frac{\hslash}{\widehat{h}^{m'}})^{\frac{1}{x}}$

  * $e(\hslash/\widehat{h}^{m'},g_2)=e(R',h_2)$

  * $\Leftrightarrow e(\hslash/\widehat{h}^{m'},g_2)=e((\hslash/\widehat{h}^{m'})^{1/x},g_2^x)$

  * $\Leftrightarrow e(\hslash/\widehat{h}^{m'},g_2)=e(\hslash/\widehat{h}^{m'},g_2)$

&nbsp;

## 阈值变色龙哈希

### 简介

阈值变色龙哈希（Threshold Trapdoor Chameleon Hash）\[3\]是一个将变色龙哈希应用到去中心化领域的尝试，使用拉格朗日多项式实现去中心化。但是仍然需要一个信任实体分发密钥。

其总体思想如下：

* $t$ 个节点，共享一个 $t-1$ 次的多项式 $f$

* 每个节点的私钥为该多项式在点 $i$ 的值 $f(i)$

* $t$ 个点 $(i,f(i))$ 可以推出原多项式

* Trapdoor 是这个 $t-1$ 次的多项式在 $0$ 点的值

### 实现

* $Setup(1^\lambda)\rightarrow (G_1,G_2,p,g_1,g_2)$

  * 生成素数 $p$ 阶双线性群 $(G_1, G_2, G_T)$

  * $G_1=\langle g_1\rangle, G_2=\langle g_2\rangle$， $g_1,g_2$ 为生成元

  * 系统参数：$params=(G_1,G_2,p,g_1,g_2)$

* $KeyGen(params,t,n)\rightarrow (hk,(sk_1,\dots,sk_n))$

  * 生成$x\xleftarrow{R}Z_p, \widehat{h}\xleftarrow{R} G_1$

  * $h_1=g^x_1, h_2=g^x_2$

  * 计算$d\ s.t.\ xd \equiv  1\bmod{p}$

  * 生成系数在$Z_p$中的$t-1$次的多项式$v$，将$v$的常数项设置为$d$，即$v(0)=d$

    * $v(x)=d+\alpha_{1}x^{1}+\alpha_{2}x^{2}+\cdots+\alpha_{t-1}x^{t-1},\ \alpha_i\in Z_p$

  * public hash key: $hk=(h_1,h_2,\widehat{h})$

  * 每个node $i\in[1,n]$ 的私钥$sk_i=v(i)$

    * $v(i)=(\sum_{j=1}^{t-1}i^{j}\alpha_j) +d$

* $Hash(m,hk)\rightarrow (\hslash,R)$

  * 随机数$r\xleftarrow{R}Z_p$

  * $\hslash=h_1^r\widehat{h}^m$

  * $R=g_1^r$

* $HVerify(m,\hslash, hk,R)\rightarrow (true\ or\ false)$

  * $true$ if $e(\hslash/\widehat{h}^m,g_2)=e(R,h_2)$

  * $false$ otherwise

* $Sign(sk_i,m',\hslash)\rightarrow(\sigma_i)$

  * node $i$ 签名作为新消息 $m'$ 的凭证

  * $\sigma_i=(\frac{\hslash}{\widehat{h}^{m'}})^{sk_i}$

* $Hcol((\sigma_1,\dots,\sigma_t),R,hk,\hslash,m)\rightarrow(\bot\ or\ R')$

  * 先运行 $HVerify$ 检查，如果$false$返回$\bot$

  * 对每个node $i$，计算拉格朗日系数$l$

  * $l_i=\big[\Pi_{j=1,j\not=i}^{t}(0-j)\big]\big[\Pi_{j=1,j\not=i}^{t}(i-j)\big]^{-1}\bmod{p}$

  * 计算新的随机数$R'=\Pi_{i=1}^{t} \sigma_i^{l_i}$

    * $R'=\Pi_{i=1}^{t} \sigma_i^{l_i}=\Pi_{i=1}^{t} ((\frac{\hslash}{\widehat{h}^{m'}})^{sk_i})^{l_i}=\Pi_{i=1}^{t} (\frac{\hslash}{\widehat{h}^{m'}})^{sk_il_i}=(\frac{\hslash}{\widehat{h}^{m'}})^{\sum_{i=1}^{t}sk_il_i}=(\frac{\hslash}{\widehat{h}^{m'}})^{\sum_{i=1}^{t}v(i)l_i}$

  * 检查$e(\hslash/\widehat{h}^{m'},g_2)=e(R',h_2)$

    * $\Leftrightarrow e(\hslash/\widehat{h}^{m'},g_2)=e((\frac{\hslash}{\widehat{h}^{m'}})^{\sum_{i=1}^{t}v(i)l_i},g_2^x)$

    * $\Leftrightarrow e(\hslash/\widehat{h}^{m'},g_2)=e((\frac{\hslash}{\widehat{h}^{m'}}),g_2)^{x\sum_{i=1}^{t}v(i)l_i}$

    * $\Leftrightarrow e(\hslash/\widehat{h}^{m'},g_2)=e((\frac{\hslash}{\widehat{h}^{m'}}),g_2^{x\sum_{i=1}^{t}v(i)l_i})$

    * $\Leftrightarrow x\sum_{i=1}^{t}v(i)l_i\equiv1\bmod{p}$

    * 又$xd\equiv 1\bmod{p}$ ？证明过程见下一部分。

  * 等式成立，返回$R'$，否则，返回$\bot$ 

### 证明

要证$x\sum_{i=1}^{t}v(i)\ell_i\equiv1\bmod{p}$

已知

* $\ell_i=\big[\Pi_{j=1,j\not=i}^{t}(0-j)\big]\big[\Pi_{j=1,j\not=i}^{t}(i-j)\big]^{-1}\bmod{p}$

* $xd\equiv1\bmod{p}$

有一系列点$(i,v(i)),i\in[1,t]$（$t$ 个取值点），其拉格朗日多项式为：

$L(x)=\sum_{i=1}^tv(i)l_i(x)$ （$t-1$ 次多项式）

$l_i(x):=\Pi_{j=1,j\not=i}^t\frac{x-x_j}{x_i-x_j}=\Pi_{j=1,j\not=i}^t\frac{x-j}{i-j}$

$l_i(0)=\Pi_{j=1,j\not=i}^t\frac{0-j}{i-j}=\ell_i$

$x=i$ 时，取值为1，否则，为0

故$L(0)=\sum_{i=1}^tv(i)l_i(0)=\sum_{i=1}^tv(i)\ell_i$

因为这 $t$ 个点是在原函数上的

因为拉格朗日多项式的存在性和唯一性，可以确定该多项式为KeyGen中的多项式。

* 存在性：对于给定的$t$个点，必存在拉格朗日多项式$l_i(x):=\Pi_{j=1,j\not=i}^t\frac{x-x_j}{x_i-x_j}$

* 唯一性：次数不超过$t-1$的拉格朗日多项式至多只有一个

故$L(0)=d$

故$x\sum_{i=1}^{t}v(i)\ell_i\equiv xL(0)\equiv xd\equiv 1\bmod{p}$

## 去中心化变色龙哈希

### 简介

去中心化变色龙哈希（Decentralized Chameleon Hash）\[4\]是一种完全去中心化的变色龙哈希。其基本思想如下：

* $t$ 个节点，每个节点都有一个 $t-1$ 次的多项式 $f_i$。

* 这 $t$ 个 $t-1$ 次的多项式的和是一个新的多项式 $f$。

* 每个节点的私钥为 $\sum f_i(i)=f(i)$。

* $t$ 个点 $(i,f(i))$ 可以推出原多项式。

* Trapdoor 就是这个新的多项式 $f$ 在 $0$ 点的值。

### 实现

设 $G$ 是一个素数 $p$ （取决于系统安全参数 $\lambda$）阶的 GDH 群

$g$ 是 $G$ 的生成元

$$ID:\{0,1\}^*\rightarrow Z_p^*$$

* Key generation

  * 输入安全参数 $\lambda$ 和参与者人数 $t$ 

  * 参与者 $P_i\ (i\in \{1,\dots,t\})$ 执行如下操作

    * 选择一个 $t-1$ 次的多项式 $f_i(x)=\sum_{j=0}^{t-1}a_{i,j}x^j$

      * 其中，$a_{i,0},\dots,a_{i,t-1}\in Z_p^*$ 是随机的系数

    * 将 $(f_i(ID(P_j)),(g^{f_i(ID(P_1))},\dots,g^{f_i(ID(P_t))}),g^{a_{i,0}})$ 发送到 $P_j\ (i\in\{1,\dots,t\}\backslash i)$

    * 当收到 $P_j$ 的消息 $(f_j(ID(P_i)),(g^{f_j(ID(P_1))},\dots,g^{f_j(ID(P_t))}),g^{a_{j,0}})$ 后

      * 检查 $(g,f_j(ID(P_i)),g^{f_j(ID(P_i))})$ 是否正确

      * 检查 $\Pi_{k=1}^t g^{\lambda_k\cdot f_j(ID(P_k))}=g^{a_j,0}$ 是否成立

        * 其中，$\lambda_k=\Pi_{j=1,j\not=k}^t\frac{ID(P_j)}{ID(P_j)-ID(P_k)}$ 
        * 拉格朗日多项式（Lagrange polynomial）在 $0$ 点的情况，用来保证 $t + 1$个点在一个 $t-1$ 次的多项式上，即后两个数据正确

    * 输出

      * 公钥 $g^s\leftarrow \Pi_{j=1}^tg^{a_j,0}$

        * 其中，$s=\sum_{j=1}^t a_{j,0}$

      * 私钥 $s_i\leftarrow \sum_{j=1}^t f_j(ID(P_i))=f(ID(P_i))$

        * 其中，$f(x)=\sum_{j=1}^tf_j(x)$
        * 点 $ID(P_i)$ 在 $t$ 个 $t-1$ 次多项式上的值的和，即点 $ID(P_i)$ 在新的多项式上的值

 * Hashing

   * 输入公钥 $g^s$ 和消息 $m\in\{0,1\}^*$

   * 先计算 $u\leftarrow H(g^s,m)$

     * 其中， $H:G\times\{0,1\}^*\rightarrow G$ 是一个加密哈希函数

   * 选择随机整数 $e\in Z_p^*$

   * 输出

     * 随机数 $r=(g^e,g^{se})$

     * 哈希 $h\leftarrow g^eu^m$

 * Rehashing

   * 输入公钥 $g^s$ 和原消息-随机数对 $(m,r=(g^e,g^{se}))$

   * 计算 $u\leftarrow H(g^s,m)$

   * 输出哈希 $h\leftarrow g^eu^m$

 * Adaptation

   * 输入私钥 $s_i$ 、公钥 $g^s$ 、消息-随机数对 $(m,r=(g^e,g^{se}))$ 和新消息$m'\in\{0,1\}^*$

   * 参与者 $P_i\ (i\in\{1,\dots,t\})$ 执行：

     * 计算 $g^{e'}\leftarrow g^eu^{m-m'}$

       * 其中， $u\leftarrow H(g^s,m)$

     * 计算 $\eta_i\leftarrow (g^{e'})^{\lambda_i\cdot s_i}$ 并发送到 $P_j\ (i\in\{1,\dots,t\}\backslash i)$

       * 其中， $\lambda_i=\Pi_{j=1,j\not=i}^t\frac{ID(P_j)}{ID(P_j)-ID(P_i)}$

     * 收到 $(\eta_1,\dots,\eta_{i-1},\eta_{i+1},\dots,\eta_t)$ 后，计算 $g^{se'}\leftarrow \Pi_{j=1}^t\eta_j$

     * 输出新的随机数$r'=(g^{e'},g^{se'})$

 * Verification

   * 输入公钥 $pk$ 、消息-随机数对 $(m,r=(g^e,g^{se}))$ 和新消息-新随机数对 $(m',r'=(g^{e'},g^{se'}))$

   * 计算  $u\leftarrow H(g^s,m)$

   * 如果 $g^eu^m=g^{e'}u^{m'}$ 且 $(g, g^s, g^{e'}, g^{se'} )$ 是 Diffie-Hellman tuple，输出1

## 参考

\[1\] [本体技术视点 | 什么是“变色龙哈希函数”？](https://mp.weixin.qq.com/s/7PQwD_Q0Knt4nQMnPnbJCw)

\[2\] M. Khalili, M. Dakhilalian, and W. Susilo, “Efficient chameleon hash functions in the enhanced collision resistant model,” *Information Sciences*, vol. 510, pp. 155–164, Feb. 2020, doi: [10.1016/j.ins.2019.09.001](https://doi.org/10.1016/j.ins.2019.09.001).

\[3\] J. Zhang *et al.*, “Serving at the edge: a redactable blockchain with fixed storage,” in *International Conference on Web Information Systems and Applications*, 2020, pp. 654–667.

\[4\] M. Jia *et al.*, “Redactable Blockchain From Decentralized Chameleon Hash Functions,” *IEEE Transactions on Information Forensics and Security*, vol. 17, pp. 2771–2783, 2022, doi: [10.1109/TIFS.2022.3192716](https://doi.org/10.1109/TIFS.2022.3192716).
