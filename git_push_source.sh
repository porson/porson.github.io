#!/bin/bash

$now = `date +%F_%H:%M:%S`

git add -Af *
git commit -m "Update:$now"
git push origin source
