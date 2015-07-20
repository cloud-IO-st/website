#!/bin/bash
WKDIR=$(dirname $0)
path=$WKDIR/project-descriptors
if [[ ! -d "$WKDIR/project-descriptors" ]]; then
  echo "Cannot find descriptors $WKDIR/project-descriptors"
  echo "Input a path to descriptors"

  read path

  if [[ ! -d "$path" ]]; then
    echo "Folder doesn't exist"
    exit
  fi
fi

git checkout master && git pull
git bin --init=s3://subutai-website

pushd $path
  git checkout master && git pull
popd

bash devops/scripts/import_content.sh -w $WKDIR -p $path

echo Choose the following:
echo [1] Jekyll serve
echo [2] Jekyll build

read chose

if [[ $chose == 1 ]]; then
  jekyll s --source ssf/
fi
if [[ $chose == 2 ]]; then
  echo Destination path:
  read $dest
  jekyll b --source $WKDIR/ssf/ --destination $dest
fi