#!/bin/bash

git pull
bundle install
bundle exec jekyll build
# bundle exec jekyll serve
git add .
#git commit -m "upload blog"
git commit -m $(date "+%Y%m%d")
git push origin master
