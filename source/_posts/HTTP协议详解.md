---
title: HTTP协议详解浏览器信息篇
date: 2017-02-06 01:07:41
tags: 
    - Http协议
    - 爬虫
---

{%cq%}HTTP协议是Web工作的核心，所以要了解清楚Web的工作方式就需要详细的了解清楚HTTP是怎么样工作的。{%endcq%}

<!-- more -->

## HTTP协议详解

HTTP协议是Web工作的核心，所以要了解清楚Web的工作方式就需要详细的了解清楚HTTP是怎么样工作的。

>HTTP是一种让Web服务器与浏览器(客户端)通过Internet发送与接收数据的协议，它建立在TCP协议之上，一般采用TCP的80端口。

它是一个请求、响应协议
>客户端发出一个请求，服务器响应这个请求。在HTTP中，客户端总是通过建立一个连接与发送一个HTTP请求来发起一个事务。服务器不能主动去与客户端联系，也不能给客户端发出一个回调连接。客户端与服务器端都可以提前中断一个连接。

例如，当浏览器下载一个文件时，你可以通过点击“停止”键来中断文件的下载，关闭与服务器的HTTP连接。

**HTTP协议是无状态的**，同一个客户端的这次请求和上次请求是没有对应关系，对HTTP服务器来说，它并不知道这两个请求是否来自同一个客户端。为了解决这个问题，**Web程序引入了Cookie机制来维护连接的可持续状态**。

HTTP协议是建立在TCP协议之上的，因此TCP攻击一样会影响HTTP的通讯，例如比较常见的一些攻击：SYN Flood是当前最流行的DoS(拒绝服务攻击)与DdoS(分布式拒绝服务攻击)的方式之一，这是一种利用TCP协议缺陷，发送大量伪造的TCP连接请求，从而使得被攻击方资源耗尽(CPU满负荷或内存不足)的攻击方式。

### HTTP请求包(浏览器信息)

我们先来看看Request包的结构，Request包分为3部分：

- 第一部分叫Request line(请求行)
- 第二部分叫Request header(请求头)
- 第三部分是body(主体)。

header和body之间有个空行，请求包的例子所示:

```
GET /domains/example/ HTTP/1.1
// 请求行 : 请求方法 请求 URI HTTP 协议 / 协议版本
Host : www.iana.org
// 服务端的主机名
User-Agent : Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94
Accept : text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
// 客户端能接收的 mine
Accept-Encoding : gzip,deflate,sdch
// 是否支持流压缩
Accept-Charset : UTF-8,*;q=0.5
// 客户端字符编码集
// 空行 , 用于分割请求头和消息体
// 消息体 , 请求资源参数 , 例如 POST 传递的参数
```
我们通过fiddler抓包可以看到如下请求信息

<center>

![get](/images/post/20170206/get.png)

抓取的Get信息

![post](/images/post/20170206/post.png)

抓取的Post信息</center>

我们可以看到GET请求消息体为空,POST请求带有消息体 。

HTTP协议定义了很多与服务器交互的请求方法，最基本的有4种：

- GET

- POST

- PUT

- DELETE

一个URL地址用于描述一个网络上的资源，而HTTP中的GET， POST， PUT， DELETE就对应着对这个资源的查，改，增，删4个操作。 

我们最常见的就是GET和POST了。GET一般用于获取/查询资源信息，而POST一般用于更新资源信息。

我们看看GET和POST的**区别**： 

1. GET提交的数据会放在URL之后,以?分割URL和传输数据,参数之间以&相连，

   如EditPosts.aspx?name=test1&id=123456。

   POST方法是把提交的数据放在HTTP包的Body中。 

2. GET提交的数据大小有限制（因为浏览器对URL的长度有限制），而POST方法提交的数据没有限制。

3. GET方式提交数据,会带来安全问题。

   比如一个登录页面，通过GET方式提交数据时，用户名和密码将出现在URL上，如果页面可以被缓存或者其他人可以访问这台机器，就可以从历史记录获得该用户的账号和密码。

