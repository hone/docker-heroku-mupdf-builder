#!/bin/sh

workspace_dir=$1
output_dir=$2

artifact_dir="$workspace_dir/mupdf-$VERSION"

curl https://mupdf.com/downloads/mupdf-$VERSION-source.tar.gz -s -o - | tar zxf -

cd mupdf-$VERSION-source
make prefix=$workspace_dir/release install
mkdir -p $artifact_dir
mv $workspace_dir/release/bin/mutool $artifact_dir
cd $artifact_dir
mkdir -p $output_dir/$STACK
tar czf $output_dir/$STACK/mupdf-$VERSION.tgz *
