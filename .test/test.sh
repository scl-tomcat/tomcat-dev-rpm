#!/bin/bash
set -ex

sed -i "s/FROM .*/FROM $OS/g" .test/Dockerfile

if [[ "$OS" =~ ^fedora.* ]]; then
  sed -i "s/yum/dnf/g" .test/*
fi

docker build -t rpmbuilder .test/
docker run --privileged -w /root/rpmbuild/SOURCES/ -it -v `pwd`:/root/rpmbuild/SOURCES/ rpmbuilder
