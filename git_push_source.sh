#!/bin/bash

# 同步静态文件
hexo g && hexo g
# 同步源文件
nowTime=`date +%F_%H:%M:%S`
git add -Af *
git commit -m "Update:$nowTime"
git push origin source
