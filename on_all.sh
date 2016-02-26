#!/bin/bash

set -ex

dockers=$(docker images wand/dbuilder | tail -n +2 | sort -k 3 | uniq -f 3 | awk '{print $1 ":" $2}' | sort)
build_cmd=

for docker in $dockers; do
  shortname=$(echo $docker | cut -d ':' -f 2)
  if [ $# -gt 0 ]; then
    docker run --rm -v `pwd`:/dbuilder/sources -e "DBUILDER_BUILD_CMD=${*}" $docker
  else
    docker run --rm -v `pwd`:/dbuilder/sources $docker
  fi
  mkdir -p dbuilder/${shortname}
  mv ./*.deb dbuilder/${shortname}
done
