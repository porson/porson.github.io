---
title: Ubuntu16.04 安装hexo方法
date: 2017-02-23 11:32:48
tags: 
    - 博客相关
    - hexo
---
{%cq%}

Ubuntu16.04 安装nodejs的时候，在PATH当中的bin文件的名称是nodejs，而不是node，所以导致常规方法安装hexo失败。这里介绍一下具体的操作方法。
{%endcq%}

<!-- more -->

##  第一步：安装git

```shell
sudo apt install git
```

## 第二步：安装nodejs相关

```shell
sudo apt install nodejs npm
```

## 第三步：创建node软连接

```shell
sudo ln -s /usr/bin/nodejs /usr/bin/node
```

## 第四步：安装hexo

``` shell
sudo npm i -g hexo hexo-cli
```

## 第五步：验证

```shell
➜  ~ hexo
Usage: hexo <command>

Commands:
  help     Get help on a command.
  init     Create a new Hexo folder.
  version  Display version information.

Global Options:
  --config  Specify config file instead of using _config.yml
  --cwd     Specify the CWD
  --debug   Display all verbose messages in the terminal
  --draft   Display draft posts
  --safe    Disable all plugins and scripts
  --silent  Hide output on console

For more help, you can use 'hexo help [command]' for the detailed information
or you can check the docs: http://hexo.io/docs/

```



这样基本就安装成功了。
