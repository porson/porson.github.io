---
title: [Django教程]02-Settings.py详解
date: 2017-04-16 10:26:06
tags: 
 - Python
 - Django
 - GJY特别教程
---

## 上期回顾以及开篇

上一篇大概的介绍了一下Django是个什么东西，以及怎么安装怎么运行。

嗯...几乎等于什么都没讲。

主要的命令有两个

```shell
django-admin startproject
django-admin startapp
```

一个是用来创建项目的，一个是用来创建App的。

Django中的App可以理解为功能模块。每一个App都有自己独立的功能，App与App之间可以互相依赖也可以不依赖。一个完整的项目就是由多个这种App来组合的。

而不同的项目之间也可以痛快App的迁移来做到搭积木式的快速开发。

从这一期开始我们来研究一下，一个Django项目都是由什么组成的，每一个部分的作用是什么。

今天的主角是**settings.py**

## Project本身

```shell
$ ls
__init__.py   settings.py   urls.py   wsgi.py
```

在开始之前，有一个小点要提一下。

进入到上一期建立好的项目中的同名App里，我们可以看到这样几个文件。其它的或多或少你都知道是干啥用的，但是除了一个文件`__init__.py`。~~wsgi以后会说~~

### \_\_init\_\_.py

其中`__init__.py`是Python包内必须要有的文件，没有这个文件，Python不会将该路径认为是可引用包。也就是说，没有它，你的这个包（文件夹/目录）在Python当中import是会报错的。

通常没有特殊要求的时候，这个文件一般都是空的。如果你需要定义一些包函数或包属性。

就比如说我们平时使用的`import XX *`这个例子。如果我们并不想要把所有的文件都可以引用，但是在引用的时候又不想一个一个去输入import的文件名，那么就可以利用`__init__.py`文件中通过变量`__all__`来定义import *的时候会import哪些文件。

```python
__all__ = ["Module1", "Module2", "subPackage1", "subPackage2"]
```

以后无特殊情况，这个文件将不会过多描述。

### settings.py

今天这一篇的主角就厉害了。

这个.py文件可以说是整个Django Project的核心，DJango的配置就是从这里配置的。

去掉注释，我们一起来看一下这里面都是些什么玩意儿：

####  BASE_DIR

```python
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# 这个变量代表的是整个项目的根路径
```

\_\_file\_\_这个属性可以获取自身文件的文件名

os.path.abspath()这个函数可以获取文件的路径，而且是真实路径，而不是调用者的路径（不懂私聊我或者查一下）。

os.path.dirname可以获取上级路径，然后几经嵌套，就可以获取到项目的根路径了。

#### ALLOWED_HOSTS

> ALLOWED_HOSTS 允许你设置哪些域名可以访问，即使在 Apache 或 Nginx 等中绑定了，这里不允许的话，也是不能访问的。
>
> 当 **DEBUG=False **时，这个为必填项，如果不想输入，可以用 **ALLOW_HOSTS = ['\*']** 来允许所有的。

####  INSTALLED_APPS

接下来是一个比较常用的设置项

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]
```

有过使用经验的人都会知道，如果我们要创建一个App，要把App注册到这个里面。那么这是为什么呢？为什么有时候不注册也是可以使用的呢？下面我们来一个一个的回答：

1. 为什么要注册
   新建的 app 如果不加到 INSTALL_APPS 中的话，django 就不能自动找到app中的**模板文件**(app-name/templates/下的文件)和**静态文件**(app-name/static/中的文件)
   也就是说，如果你没有对它进行设置，你的App将无法提供访问。

2. 为什么不注册也可以使用
   我曾经就有过这种情况，创建了无数python包在一个项目下，也不注册app，直接互相import，并没有遇到什么问题。其实这个问题与App的理解有关，App是独立的，它拥有自己的urls，拥有自己的Templates和static文件，如果把所有的app的模板文件放到一个路径下，从app的概念来讲，这压根就是一个大app。
   也就是说，不注册就可以使用的，是因为你创建的不是app，根本就没用利用到app提供的特性。


#### MIDDLEWARE

接下来是高级的中间件，一般中小型项目对这个的使用率不高。可以理解为一个层级更底层的App，消息在到达views之前会先通过中间件。可以做一些低层次的消息转发处理。比如实现一个filter。

```shell
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]
```

具体详细用法可以参考：[自强学堂-Django中间件](http://www.ziqiangxuetang.com/django/django-middleware.html)

#### ROOT_URLCONF

```python
ROOT_URLCONF = 'gjyPython.urls'
```

在这里指定根路由文件。Django当中的路由是一层一层的，但是总要有一个根路由来做总分配。这里就是设置根路由文件名称的。

#### TEMPLATES

```python
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]
```

这个参数很重要，但是也基本不需要动。属于一次配置享受终身的那种。

关键点只有一个：DIRS

这个key的value是一个list，里面放的是所有templates的路径。如果不配置，**会默认的去每个注册了的App下的Templates路径里查找**。如果配置了，**就必须把每一个App都配全**。不然找不到。

还有一个需要注意的地方：

直接使用命令行django-admin starproject创建的项目，这个地方是空的，没设置的。

如果使用IDE比如Pycharm创建的，这里的value是`os.path.join(BASE_DIR, 'templates')`，意思就是你的项目根路径后面再跟了一个templates，也就是指向你项目根路径下的templates文件。

这个时候如果你还是把模板文件放到app下的templates里，那么是会找不到的。



#### 静态文件

Django的静态文件是一个比较复杂的东西。开发模式与生产部署的时候还不太一样。具体的设置也比较复杂，我也只研究过一点点皮毛。所以直接把高人教程拉过来给你参考一下。

[自强学堂-Django静态文件](http://www.ziqiangxuetang.com/django/django-static-files.html)

关于配置文件还有一些不常用的配置我没有讲到，如果有兴趣，可以看一下下面这个链接。我也是跟着这个学的+自己的一些东西。

[自强学堂-Django配置](http://www.ziqiangxuetang.com/django/django-settings.html)



### 课后练习

​	这章没什么好练习的。看明白，理解了就可以。



以上。