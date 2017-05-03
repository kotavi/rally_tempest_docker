#!/bin/bash -x
#
# To run script you can specify optional parameters: image_name and image_version
# Examples:
# ./deployment/docker_run_script.sh <image_name>:<image_version> <tempest_source>:<tempest_version>
# ./deployment/docker_run_script.sh rallyforge/rally:latest /home/rally/devops-qa-tools/tempest/:14.0.0
# ./deployment/docker_run_script.sh rallyforge/rally:latest https://github.com/openstack/tempest.git:14.0.0

fuel_dir=$(pwd)
docker_dir=/home/rally/devops-qa-tools

image_info=${1:-rallyforge/rally:0.9.0}
image_name=$(echo $image_info|cut -d\: -f1)
image_version=$(echo $image_info|cut -d\: -f2)

tempest_info=${2:-https://github.com/openstack/tempest.git:15.0.0}

docker pull $image_name:$image_version

image_id=$(docker images -q $image_name:$image_version)

container_id=$(docker run -d -ti -v $fuel_dir:$docker_dir --net host --pid host $image_id)

docker exec -ti $container_id bash -c "sudo chown rally:rally -R $docker_dir/"
docker exec -ti $container_id bash -c "$docker_dir/deployment/setup_rally_deployment.sh $tempest_info"
docker exec -ti $container_id bash
