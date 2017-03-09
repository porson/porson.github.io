---
title: 一个Python调用Shell时遇到的问题
date: 2017-03-07 18:50:15
tags: 
      - Python
      - Shell
---

{% cq %}

​	关于Python调用Shell时的一些之前没有注意过得问题。问题很简单，但是比较容易忽略。

{% endcq%}

<!-- more -->

## 问题背景

前两天老大扔我一个脚本让我看一下这个脚本有没有什么bug，大体流程是这样的：

```python
import commands 
def exectue_shell(cmd,times = 1):
    result_code = commands.getoutput(cmd)
    if result_code !=0 and times > 0:
        result_code = commands.getoutput(cmd)
        times -= 1
        exectue_shell(cmd,times)
    else:
        return False
```

意思就是执行cmd命令，然后如果没有执行成功，就再执行一次，如果还是失败就退出。

我看了一下说，应该没什么问题吧。

老大说，不对，有BUG，执行的时候，一个单进程的脚本竟然开启了好几个子进程，这明显是不科学的。

## 问题溯源

听到这个问题我第一反应就是执行的线程没有结束，可是明明已经获取了返回值。

那这就说明了另一个问题，commands包的getoutput函数是不阻塞的。

然后，我就去看了getoutput的实现。

```python
def getoutput(cmd):
    """Return output (stdout or stderr) of executing cmd in a shell."""
    return getstatusoutput(cmd)[1]
```

```python
def getstatusoutput(cmd):
    """Return (status, output) of executing cmd in a shell."""
    import os
    pipe = os.popen('{ ' + cmd + '; } 2>&1', 'r')
    text = pipe.read()
    sts = pipe.close()
    if sts is None: sts = 0
    if text[-1:] == '\n': text = text[:-1]
    return sts, text
```

然后可以很清楚的看到，getoutput方法的背后调用的实际上是os模块的popen，开启了一个管道，然后单方面的关闭了。

所以结论就是：

> 子线程执行的任务需要的时间较长，父线程没有在超时时间内等待到子线程的返回值，既返回None，导致父线程认为子线程执行失败，重启子线程。然而子线程并没有失败，依然在内存中运行。所以导致出现非常多子线程的出现。

这个问题的原因就出现了。

## 问题解决

那么如何解决这个问题，思路就一个，保证父线程会等待子线程的执行结束，或者子线程会阻塞父线程。

Pyton执行Shell命令一般有以下这几种方法：

- commands.getoutput(command)
- os.system(command)
- os.popen(command,mode)
- subprocess模块

其中os.system可以做到线程阻塞，这个模块是用C实现的，先是fork了一个子线程，然后父线程回waitpid，缺点是返回值并不是真实的返回值（但0是0）。

subprocess模块的call()方法也可以打到线程阻塞的效果，但是调用的时候命令参数是以list的形式传入，对命令不是非常友好。

所以最后换成os.system去执行命令，就成功了。