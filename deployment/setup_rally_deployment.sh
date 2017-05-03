#!/bin/bash -x
#
# Examples:
# ./deployment/setup_rally_deployment.sh <tempest_source>:<version>
# ./deployment/setup_rally_deployment.sh /home/rally/devops-qa-tools/tempest/:14.0.0
# ./deployment/setup_rally_deployment.sh https://github.com/openstack/tempest.git:14.0.0

tempest_info=${1:-https://github.com/openstack/tempest.git:15.0.0}

get_parameters(){
    OLDIFS=$IFS
    IFS=':' read -ra DATA <<< "$tempest_info"
    IFS=$OLDIFS
    if [ "${DATA[0]}" == "http" -o "${DATA[0]}" == "https" ]; then
        tempest_source=$(echo $tempest_info|cut -d\: -f-2)
    else
        tempest_source=$(echo $tempest_info|cut -d\: -f1)
    fi
    tempest_version=${DATA[-1]}
}

create_rally_deployment() {
    rally deployment create --filename devops-qa-tools/deployment/deployment_configuration.json --name=tempest
}

create_verifier(){
    rally verify create-verifier --name tempest_tests --type tempest --source $tempest_source --version $tempest_version
}

combine_rally_scenarios(){
    pushd devops-qa-tools/rally-scenarios/
    ./combine_files.py --filename all_scenarios.yaml
    popd
    echo -e '\nFor more information on rally-scenarios check rally-scenarios/README.md'
}

get_parameters
create_rally_deployment
create_verifier
combine_rally_scenarios
