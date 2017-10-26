#!/bin/bash
set -ex

if [ -z "$AUTHOR" ]; then
    echo "Env var AUTHOR not defined and needed to git commit the new version."
fi

if [ -z "$GITHUB_USER" ]; then
    echo "Env var GITHUB_USER not defined and needed to git push the new version."
fi

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Env var GITHUB_TOKEN not defined and needed to git push the new version."
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."
MAJOR=`grep "%global major_version" $DIR/tomcat.spec |sed 's/.* //g' `
MINOR=`grep "%global minor_version" $DIR/tomcat.spec |sed 's/.* //g' `

echo "Scrap tomcat website and fetch the version"
MICRO=$(.release/fetch-version.sh)
VERSION="$MAJOR.$MINOR.$MICRO"

echo "Check if version $MICRO is already commited"
git branch -a |grep "r${VERSION}$" && exit 0
git tag |grep "\.${MICRO}$" && exit 0

echo "Update specfile with new version $MICRO"
.release/update-version.sh $MICRO
git diff --exit-code && exit 0

echo "Download new sources"
rm -f *.tar.gz
docker build -t rpmbuilder .release/
docker run -w /mnt -it -v `pwd`:/mnt rpmbuilder spectool -g *.spec
md5sum *.tar.gz > sources
git add -A

echo "Create branch r${VERSION}"
git checkout -b "r${VERSION}"
git config user.name $(echo $AUTHOR|sed "s/\(.*\) <\(.*\)>.*/\1/g")
git config user.email $(echo $AUTHOR|sed "s/\(.*\) <\(.*\)>.*/\2/g")
git commit -am "Update to $VERSION"

echo "Push branch r${VERSION}"
NAME=`git remote -v |sed 's#.*/##'|sed 's/ .*//g'|sed 's/\.git//g'|head -n1` 
git remote set-url origin "https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$TRAVIS_REPO_SLUG.git"
git push --set-upstream origin "r${VERSION}"

echo "Create new Merge Request"
curl -f --user "$GITHUB_USER:$GITHUB_TOKEN" --request POST --data "{ \"title\": \"New version $VERSION\", \"body\": \"A new release is available $VERSION\", \"head\": \"r${VERSION}\", \"base\": \"$TRAVIS_BRANCH\" }" https://api.github.com/repos/$TRAVIS_REPO_SLUG/pulls
