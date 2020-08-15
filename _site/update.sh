#!/bin/bash

git pull
bundle install
bundle exec jekyll build
# bundle exec jekyll serve
git add .
ls_date=`date +%Y%m%d`
#git commit -m "upload blog"
git commit -m ls_date
git push origin master
