#!/bin/bash

# Usage example:
# ./script/build.sh 0.1 new-site web

tag=$1
app=$2
target=$3
[[ -z "$tag" || -z "$app" || -z "$target" ]] && echo "vars not set! Aborting." && exit 1

push_user='repleadfy'

echo "GH login $user..."
pat_file=~/.github-pat
user=$(cat ~/.github-user)
echo -n `cat $pat_file` | docker login ghcr.io -u $user --password-stdin

echo "build... $push_user/$app $target"
docker build . -f Dockerfile -t $push_user/$app --target=$target

echo "tag $tag..."
id=$(docker images |grep ^"$push_user/$app" | awk '{print $3}' | head -1)
docker tag $id ghcr.io/$push_user/$app:$tag

echo "push to ghcr.io/$push_user/$app:$tag..."
docker push ghcr.io/$push_user/$app:$tag

echo "done."
