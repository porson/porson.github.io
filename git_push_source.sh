#!/bin/bash

nowTime=`date +%F_%H:%M:%S`

git add -Af *
git commit -m "Update:$nowTime"
git push origin source
