#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

MAJOR=`grep "%global major_version" $DIR/tomcat.spec |sed 's/.* //g' `
MINOR=`grep "%global minor_version" $DIR/tomcat.spec |sed 's/.* //g' `
MICRO=`curl -s http://www.apache.org/dist/tomcat/tomcat-$MAJOR/ |grep -e "<a href=\"v[0-9]\.$MINOR" |sed "s#.*v$MAJOR\.$MINOR\.\([0-9]*\).*#\1#g" |head -n 1`

echo $MICRO
