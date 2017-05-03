## Prepare node for rally and tempest testing

### Description of scripts

- tools/setup_network_fuel_node.sh - setup management network so that tests will have access from fuel node to the services
- tools/clean_containers_and_images.sh - removes all containers and images
- docker_run_script.sh - pulls rally docker image and runs it
- setup_rally_deployment.sh - sets up rally deployment, installs tempest

#### Preconditions

Install `git` and `docker`
Update `deployment_configuration.json` file

#### Setup network for Fuel node.

Execute ``./tools/setup_network_fuel_node.sh``

```bash
Example of success
[root@ic4-fuel-scc docker_rally]# ./setup_network_fuel_node.sh
Management network information:
11 | management    | 301        | 10.31.0.0/24   \|             | 3
Enter ip address \(e.q. 10.109.6.233/24\):
10.31.0.253/24
Enter broadcast address:
10.31.0.255

The next COMMANDS will be executed, please CHECK them:

ip link add link eth1 name eth1.301 type vlan id 301
ip addr add 10.31.0.253/24 brd 10.31.0.255 dev eth1.301
ip link set dev eth1.301 up

Proceed \(Y/N\):
Y
ip link add link eth1 name eth1.301 type vlan id 301
ip addr add 10.31.0.253/24 brd 10.31.0.255 dev eth1.301
ip link set dev eth1.301 up
```

Example when ip address is already in use

```bash
./setup_network_fuel_node.sh
Management network information:
11 | management | 301 | 10.31.0.0/24 \| \| 3
Enter ip address \(e.q. 10.109.6.233/24\):
10.31.0.253/24
Enter broadcast address:
10.31.0.255
IP ADDRESS IS NOT AVAILABLE
Enter ip address \(e.q. 10.109.6.233/24\):
```

#### Pull rally docker image and start rally container

Execute ``./deployment/docker_run_script.sh``

To run script you can specify optional parameters:
image_name and image_version

``./deployment/docker_run_script.sh <image_name>:<image_version> <tempest_source>:<tempest_version>``
`` ./deployment/docker_run_script.sh  rallyforge/rally:latest /home/rally/devops-qa-tools/tempest/:14.0.0``
`` ./deployment/docker_run_script.sh  rallyforge/rally:latest https://github.com/openstack/tempest.git:14.0.0``

This script:
 - pulls rally image
 - runs image and mounts current directory with `/home/rally/devops-qa-tools` in container
 - sets up rally deployment
 - installs tempest
 - container starts with ``setup_rally_deployment.sh`` command
 - creates all_scenarios.yaml with rally scenarios