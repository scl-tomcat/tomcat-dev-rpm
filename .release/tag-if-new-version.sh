#!/bin/bash
set -ex

# MUST only be executed on branch MASTER

if [ -z "$AUTHOR" ]; then
    echo "Env var AUTHOR not defined and needed to git commit the new version."
fi

if [ -z "$GITHUB_USER" ]; then
    echo "Env var GITHUB_USER not defined and needed to git push the new version."
fi

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Env var GITHUB_TOKEN not defined and needed to git push the new version."
fi

echo "Check if last commit is done by tito"
git log HEAD^..HEAD | grep "Automatic commit" && exit 0

echo "Install tito"
docker build -t rpmbuilder .release/

echo "Tag the git repository and commit changelog"
git config user.name $(echo $AUTHOR|sed "s/\(.*\) <\(.*\)>.*/\1/g")
git config user.email $(echo $AUTHOR|sed "s/\(.*\) <\(.*\)>.*/\2/g")
docker run -w /mnt -it -v `pwd`:/mnt rpmbuilder tito tag --accept-auto-changelog --keep-version

echo "Push branch master and tags"
NAME=`git remote -v |sed 's#.*/##'|sed 's/ .*//g'|sed 's/\.git//g'|head -n1` 
git remote set-url origin https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$TRAVIS_REPO_SLUG.git
git push --tags origin HEAD:$TRAVIS_BRANCH
