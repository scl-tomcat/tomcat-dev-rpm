#!/bin/bash -ex

echo "Build SRPM"
chown root. *
rpmbuild -bs *.spec

echo "Build RPM"
#set +e
#/usr/bin/mock /root/rpmbuild/SRPMS/*.src.rpm 
#if [ $? -ne 0 ]; then
#  echo
#  echo "mock failed, output below"
#  echo
#  ls /var/lib/mock/*/result
#  cat /var/lib/mock/*/result/*.log
#  exit -1
#fi
#set -e

 yum-builddep *.spec
rpmbuild -ba *.spec

echo "Install RPM"
#yum install -y /var/lib/mock/*/result/*.rpm
yum install -y *.rpm

echo "Start Tomcat"
/usr/libexec/tomcat/server start &

echo "Wait for Tomcat to be ready"
wait-for-it.sh localhost:8080 -- echo "Tomcat is up"

curl -s -I -L localhost:8080/examples/servlets |grep 200
curl -s -I -L localhost:8080/examples/jsp |grep 200
curl -s -I -L localhost:8080/examples/websocket |grep 200
