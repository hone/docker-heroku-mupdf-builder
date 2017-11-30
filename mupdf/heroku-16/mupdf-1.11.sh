#!/bin/sh

docker run -v `pwd`/builds:/tmp/output -e VERSION=1.11 -e STACK=heroku-16 hone/mupdf-builder:heroku-16
