#!/bin/bash

get_management_network_info(){
    fuel_net_grp=$(fuel network-group | grep management | awk '{ if ($5 ~ /^[0-9]+$/) print $0;}')
    vlan_tag=$(fuel network-group | grep management | awk '{if ($5 ~ /^[0-9]+$/) print $5}')
    cidr=$(fuel network-group | grep management | awk '{if ($5 ~ /^[0-9]+$/) print $7}')
    echo "Management network information: "
    echo "$fuel_net_grp"
    echo
    net_interface_status=$(ip l)
    echo "Display the status of all network interfaces: "
    echo "$net_interface_status"
    echo
}

enter_interface_info(){
    echo "Enter ip address (e.q. 10.109.6.233/24): "
    read ip_addr_drg
    echo "Enter broadcast address: "
    read brd
    echo "Enter ethernet interface: "
    read eth_interface
    ip_address=$(echo $ip_addr_drg | cut -d\/ -f1)
    available_ip_a=$(ip a | grep $ip_address | wc -l)
    available_postgres=$(sudo -u postgres psql -d nailgun -c "select * from ip_addrs" | grep $ip_address | wc -l)
}

check_availability_ip_addr(){
    while [ $available_postgres -eq 1 ] || [ $available_ip_a -eq 1 ]
        do
            echo
            echo "IP ADDRESS IS NOT AVAILABLE"
            enter_interface_info
        done
}

check_information(){
    echo
    echo "The next COMMANDS will be executed, please CHECK them:"
    echo
    echo "ip link add link $eth_interface name $eth_interface.$vlan_tag type vlan id $vlan_tag"
    echo "ip addr add $ip_addr_drg brd $brd dev $eth_interface.$vlan_tag"
    echo "ip link set dev $eth_interface.$vlan_tag up"
    echo
    echo "Proceed (Y/N): "; read reply
    if [ $reply == 'N' ]; then
        echo 'Exiting the script'
        exit 0
    fi
}

bring_interface_up(){
    if [ $reply == 'Y' ]; then
        # Create interface (add vlan interface):
        ip link add link $eth_interface name $eth_interface.$vlan_tag type vlan id $vlan_tag
        # Provide interface with an address:
        ip addr add $ip_addr_drg brd $brd dev $eth_interface.$vlan_tag
        # Bring interface up:
        ip link set dev $eth_interface.$vlan_tag up
    fi
}

get_management_network_info
enter_interface_info
check_availability_ip_addr
check_information
bring_interface_up