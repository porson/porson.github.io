#!/bin/bash

$now = `date +%F_%H:%M:%S`

git add -A *
git commit -m "Update:$now"
git push origin source
