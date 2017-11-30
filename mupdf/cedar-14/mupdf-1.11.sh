#!/bin/sh

docker run -v `pwd`/builds:/tmp/output -e VERSION=1.11 -e STACK=cedar-14 hone/mupdf-builder:cedar-14
