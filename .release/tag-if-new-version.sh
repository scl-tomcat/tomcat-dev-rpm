#!/bin/bash
set -ex

# MUST only be executed on branch MASTER

git log HEAD^..HEAD | grep "Automatic commit" && exit 0

echo Install tito
docker build -t tito .release/

echo Tag the git repository and commit changelog
docker run -w /mnt -it -v `pwd`:/mnt tito tag --accept-auto-changelog --keep-version

echo Push branch master and tags
NAME=`git remote -v |sed 's#.*/##'|sed 's/ .*//g'|sed 's/\.git//g'|head -n1` 
git remote set-url origin https://Filirom1-bot:$TOKEN@github.com/scl-tomcat/$NAME.git
git push --tags origin HEAD:master
