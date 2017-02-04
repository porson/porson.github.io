---
title: Go语言Web框架Revel初体验
date: 2017-02-04 17:01:30
tags: Golang

---

### 什么是Revel

Revel官网给予的说明是：一个高生产力的 Go 语言 Web 框架。

根据Web Framework Benchmarks测评显示，Revel目前性能排名第八的Web框架。注意，是**全语言全框架**性能排名第八。

[查看测试报告](http://www.techempower.com/benchmarks/#section=data-r8)

### Revel特性

#### 热编译

现在不能热编译的框架还叫框架？

> 编辑, 保存, 和 刷新时，Revel自动编译代码和模板，如果代码编译错误，会给出一个 [错误提示](http://www.gorevel.cn/docs/img/CompilationError.png)，同时捕捉 [运行期错误](http://www.gorevel.cn/docs/img/Panic.png)。

#### 全栈功能

~~特别适合我这种全栈工程师~~

> Revel 支持： [路由](http://www.gorevel.cn/docs/manual/routing.html), [参数解析](http://www.gorevel.cn/docs/manual/binding.html), [验证](http://www.gorevel.cn/docs/manual/validation.html),[session/flash](http://www.gorevel.cn/docs/manual/sessionflash.html), [模板](http://www.gorevel.cn/docs/manual/templates.html), [缓存](http://www.gorevel.cn/docs/manual/cache.html), [计划任务](http://www.gorevel.cn/docs/manual/jobs.html), [测试](http://www.gorevel.cn/docs/manual/testing.html), [国际化](http://www.gorevel.cn/docs/manual/i18n-messages.html) 等功能。

#### 框架设计

Revel秉持模块化无状态的同步设计，所以拓展性高，灵活性强。

熟悉Python的同学肯定使用过Django，就我目前的开发感觉来看，转过来用的非常舒服，理解起来没有障碍。



---

### 安装

说了这么多，到底怎么样使用呢？

Go与其他语言不同，Go语言本身就集成了相当多的工具，所以无论是第三方包的下载还是安装，都是非常灵活方便的。~~除了需要翻墙~~

#### 一、科学上网

是的，这是第一步，没有这一步你连包都下不全，有一部分的代码在google的服务器上。

但是你要是说就是不想翻墙，或者就是不会怎么办？

#### 二、第三方包下载工具

[Golang中国第三方包下载工具](http://www.golangtc.com/download/package)

上面的说明写的十分详细简单，我也就不赘述了。

#### 三、开始安装

安装Revel需要安装两个包

1. github.com/revel/revel
2. github.com/revel/cmd/revel

第一个是Revel本体，第二个是命令行工具。

不过这两个包只有第一个需要翻墙。



---

在第三方包下载工具当中输入包名

```shell
github.com/revel/revel
```

然后等工具下载完后下载到本地，解压所有文件到你的GOPATH路径下的src目录下。

然后在命令行中输入

```shell
go install github.com/revel/revel
```

等待成功后就可以安装命令行工具

```shell
go get github.com/revel/cmd/revel
```



### 完成

接下来就是按照官网上的指示创建Revel应用即可。

非常简单，初学者可能会卡在科学上网上。

[Revel中文站](http://www.gorevel.cn/)

