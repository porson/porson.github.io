---
title: HTTP协议详解（浏览器信息+服务器信息）
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

### HTTP响应包(服务器信息)

我们再来看看HTTP的response包，他的结构如下:

```
HTTP/1.1 200 OK
// 状态行
Server: nginx/1.0.8
// 服务器使用的 WEB 软件名及版本
Date:Date: Tue， 30 Oct 2012 04:14:25 GMT
// 发送时间
Content-Type: text/html
// 服务器发送信息的类型
Transfer-Encoding: chunked
// 表示发送 HTTP 包是分段发的
Connection: keep-alive
// 保持连接状态
Content-Length: 90
// 主体内容长度
// 空行 用来分割消息头和主体
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"... // 消息体
```

Response包中的第一行叫做状态行，由HTTP协议版本号， 状态码， 状态消息 三部分组成。
状态码用来告诉HTTP客户端，HTTP服务器是否产生了预期的Response。HTTP/1.1协议中定义了5类状态码， 状态码由三位数字组成，第一个数字定义了响应的类别。
```
1XX  //提示信息 - 表示请求已被成功接收，继续处理
2XX  //成功 - 表示请求已被成功接收，理解，接受
3XX  //重定向 - 要完成请求必须进行更进一步的处理
4XX  //客户端错误 - 请求有语法错误或请求无法实现
5XX  //服务器端错误 - 服务器未能实现合法的请求
```
我们看下面这个图展示了详细的返回信息，左边可以看到有很多的资源返回码，200是常用的，表示正常信息，302表示跳转。response header里面展示了详细的信息。
![response](/images/post/20170206/response.png)

### HTTP协议是无状态的和Connection: keep-alive的区别
无状态是指协议对于事务处理没有记忆能力,服务器不知道客户端是什么状态。从另一方面讲，**打开一个服务器上的网页和你之前打开这个服务器上的网页之间没有任何联系**。
HTTP是一个无状态的面向连接的协议，**无状态不代表HTTP不能保持TCP连接，更不能代表HTTP使用的是UDP协议(面对无连接)**。
从HTTP/1.1起，默认都开启了Keep-Alive保持连接特性，简单地说，当一个网页打开完成后，客户端和服务器之间用于传输HTTP数据的TCP连接不会关闭，如果客户端再次访问这个服务器上的网页，会继续使用这一条已经建立的TCP连接。
Keep-Alive不会永久保持连接，它有一个保持时间，可以在不同服务器软件(如Apache)中设置这个时间。