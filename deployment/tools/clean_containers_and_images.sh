#!/bin/bash -x
#
# To run script you can specify optional parameters:
# image_name and image_version
# ./clean_containers_and_images.sh <image_name>:<image_version>
# ./clean_containers_and_images.sh rallyforge/rally:latest


image_info=${1:-rallyforge/rally:0.8.1}
image_name=`echo $1|cut -d\: -f1`
image_version=`echo $1|cut -d\: -f2`

stop_remove_rally_containers(){
    rally_containers_id=$(docker ps -a -q --filter=ancestor=$image_name:$image_version)
    docker stop $rally_containers_id
    docker rm $rally_containers_id
}

remove_images(){
    image_id=$(docker images $image_name:$image_version -q)
    docker rmi $image_id
}

stop_remove_rally_containers
remove_images