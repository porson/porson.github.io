---
title: 解决Python在Windows环境运行时的编码问题
date: 2017-02-04 18:22:51
tags: Python
---

这是我之前在Python开发时候遇到的小问题，以前不太懂，后来想明白了。再后来发现好像也有很多人不知道，老说什么Windows环境Python开发非常不好用，麻烦。我跟你讲，不好用那都是骗人的，操作系统不背这个锅。~~虽然我现在还是放弃了windos~~

<!-- more -->

### 环境

- Windows 10
- Python 2.7



### 调教过程

良好的开发环境就跟养儿子一样，从出生的时候就是要开始好好调教了。

总结了一下以前在Windows环境下进行Python开发的时候常见体验不好的地方：

1. 汉字乱码
2. Django莫名其妙报错
3. 安装第三方包困难
4. ...

基本上这些问题可以分为两大类：

1. 权限问题
2. 编码问题

#### 权限问题解决

在使用命令行（cmd）安装东西的时候，一定要使用管理员身份打开cmd。

负责安装上也会由于各种问题无法正常运行（例如Django）

#### 编码问题解决

编码问题解决有两种办法：

一个解决的方案在程序中加入以下代码： Python代码

```python
import sys  
reload(sys)  
sys.setdefaultencoding('utf8')
```

另一个方案是我大力推荐，一劳永逸的办法：

在python的`Lib\site-packages`文件夹下新建一个`sitecustomize.py`，内容为：

```python
# encoding=utf8  
import sys  
  
reload(sys)  
sys.setdefaultencoding('utf8')
```

此时重启python解释器，执行sys.getdefaultencoding()，发现编码已经被设置为utf8的了，多次重启之后，效果相同，这是因为系统在python启动的时候，自行调用该文件，设置系统的默认编码，而不需要每次都手动的加上解决代码。



---

只要按照上面的方法进行设置，Windows环境下Python开发感受会提升非常的大。