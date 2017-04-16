---
title: Django教程01-废话与基本安装与运行
date: 2017-04-15 18:35:22
tags: 
 - Django
 - python
 - GJY特别教程
---

{% cq %}

​	知识要传递给下一代，新手司机带个小胸弟一起上路。

{% endcq %}

<!-- more -->

## BEFORE ALL

> WARNING : 此系列教程的所有代码都要跟着敲，尽可能完成最后留下的习题作业。[敲黑板]G同学，就是在跟你说话。

开头的几章比较简单、漫长。然我们慢慢回忆起关于Python，关于Django的一切吧...

整个教程将会沿着Django这条路线，将Django的MTV三部分依次讲完，并会连带着介绍Django本身的一些特性或功能，比如Admin，比如Model。

讲解Templates的时候也会捎带着介绍一些前端知识，传授一个古老工具与框架JQuery、还有当前非常流行的Bootstarp等。

整个教程过程中会穿插Python基础语法的介绍，以及一些使用某些方法或函数的时候个人总结的一些小技巧，或者遇到的一些坑。

下面将正式开始这个系列的教程。

## WHAT IS DJANGO AND HOW SHOULD I USE IT?	

### Django Say Hello

正所谓“知其然，知其所以然”。想要了解一门技术并深入学习，了解起发展历史是一件非常有必要的事情。通过其发展历史可以看到这门技术的精神和灵魂，更利于我们去理解掌握它。

说出来你可能不信，这个目前风靡Python圈的框架，敏捷开发与模块化设计的代表，最初是由一个来自堪萨斯州的网络开发小组编写的，而这个开发小组是在一家新闻出版社里的...

> ​	它诞生于 2003 年秋天，那时 Lawrence Journal-World 报纸的程序员 Adrian Holovaty 和 Simon Willison 开始用 Python 来编写程序。
>
> ​	当时他们的 World Online 小组制作并维护当地的几个新闻站点, 并在以新闻界特有的快节奏开发环境中逐渐发展。 这些站点包括有 LJWorld.com、Lawrence.com 和 KUsports.com， 记者（或管理层） 要求增加的特征或整个程序都能在计划时间内快速的被建立，这些时间通常只有几天 或几个小时。 因此，Adrian 和 Simon 开发了一种节省时间的网络程序开发框架， 这是在截止时间前能完成程序的唯一途径。

而在这样的环境下出生的Django很自然的就被赋予了快速、简便的基因。所以这也是为什么Django提供了管理后台、动态模板、数据库驱动等一系列功能。这些功能的存在正是为了动态内容管理。

​	Django开源之后，经过~~GayHub~~众人调教之后，这个Python框架也越来越趋于成熟。其快速开发的理念也影响了相当一部分框架和设计模式。

### Django Install

Django的安装文档在网上有很多，这里就不赘述了，简便的安装命令如下：

```shell
sudo pip install django
```

当然你也可以去Django官网下载tar包，使用setup.py进行安装。

```shell
tar -xvf django.tar.gz
cd django.tar.gz
python setup.pyt install
```

### My First Django Project

在操作系统中安装了Django之后，你的**环境变量**当中会多出来下面这个命令：

```shell
django-admin
```

运行之后会看到这个：

```shell
$ django-admin

Type 'django-admin help <subcommand>' for help on a specific subcommand.

Available subcommands:

[django]
    check
    compilemessages
    createcachetable
    dbshell
    diffsettings
    dumpdata
    flush
    inspectdb
    loaddata
    makemessages
    makemigrations
    migrate
    runserver
    sendtestemail
    shell
    showmigrations
    sqlflush
    sqlmigrate
    sqlsequencereset
    squashmigrations
    startapp
    startproject
    test
    testserver
Note that only Django core commands are listed as settings are not properly conf  igured (error: Requested setting INSTALLED_APPS, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.).

```

这条命令的其他选项~~日后~~我们会慢慢一一介绍，最开始先讲开始一个Django项目的必须使用的命令。

```shell
startapp
startproject
```

#### A new Django project

```shell
django-admin startproject gjyPython
```

这条命令就是创建Python项目的命令了。创建之后会在当前路径下生成一个project路径。

然后执行下列命令，

```shell
cd gjyPython
ls
```

我们可以看到这样两个东西。

```shell
gjyPython/  manage.py
```

其中gjyPython就是我们这个项目的主体了，它本身是个App，也是整个Project基石，因为这个与项目同名的App里包含着整个Project的基础配置。

而manage.py文件是整个项目的

#### A new Django app

我们依然在刚才创建好的Project路径内，输入以下命令：

```shell
$ django-admin startapp newApp
```
然后我们再看一下当前路径下的内容，发现多了一个目录，而这个目录就是我们创建的App了。
```
$ ls
gjyPython/  manage.py  newApp/
```

### Hello World

安装好项目之后我们就可以尝试着启动项目了。

```shell
python manage.py runserver localhost:8000
```

然后我们在浏览器中输入`localhost:8000`之后，就可以看到我们的欢迎页面了。

![ItWork](/images/post/20170415/itwork.png)

## 最后

这就是基本的简单安装了。

其实本来想写更多，但是我困了...所以我们下期再见~

## 课后小练习

1. 创建一个自己的Django项目，然后让它成功的运行起来
2. 给自己的Project创建个App玩玩儿
3. 尝试创建一个欢迎页面