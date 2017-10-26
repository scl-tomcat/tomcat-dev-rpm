#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

MICRO=$1
sed -i "s/%global micro_version .*/%global micro_version $MICRO/g" $DIR/tomcat.spec
