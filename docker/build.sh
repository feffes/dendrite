#!/bin/bash

#Builds a target with a specified tag
a_flag=''
tags=''
targets=''
all_targets=''
print_usage() {
  printf "Usage: ./build.sh [options]
  A script to build docker images using buildkit.

  Options:

    -a               Build all targets.
    -t string        Tag to use on all built images
    -e string        Target.

  Example Usage:
    ./build.sh -a -t latest -t 1.0
"
}

build_image() {
  DOCKER_BUILDKIT=1 docker build --target $1 .
}

while getopts 'at:e:' flag; do
  case "${flag}" in
    a) a_flag='true' ;;
    t) tags="${OPTARG}" ;;
    e) targets="${OPTARG}" ;;
    *) print_usage
       exit 1 ;;
  esac
done
if [ $a_flag == 'true' ]; then
  echo "truelol"
else
  while
