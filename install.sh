#!/bin/bash

# array contains
array_contains() {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}


# TODO(jroovers): modify this to pass array along (now it comes from the global scope)
ask_question_options(){
    question=$1
    PS3=$1 # PS3 is used by the select command to show question below the options
    select opt in "${options[@]}"
    do
        if array_contains "$opt" "${options[@]}"; then
           echo $opt
           return;
        fi
    done
}  

# Prompts a given yes/no question. 
# Returns 0 if user answers yes, 1 if no
# Reprompts if different answer
ask_yes_no(){
    question=$1
    while true; do
        read -e -p "$question" -i "Y" yn
        case $yn in
             [Yy]* ) return 0;;
             [Nn]* ) return 1;;
        esac 
    done
}  

## BEGIN SCRIPT ##

options=("stable/havana" "stable/icehouse" "master")
branch=$(ask_question_options "Select a devstack branch: ")
echo "Chosen branch: $branch"

ENABLED_SERVICES=""
DISABLED_SERVICES=""
if ask_yes_no "Install neutron? [Y/n] ";             
then
    ENABLED_SERVICES+=,q-svc,q-agt,q-dhcp,q-l3,q-meta,neutron
    DISABLED_SERVICES+="disable_service n-net"
    if ask_yes_no "Install FWaaS? [Y/n] "; then
        ENABLED_SERVICES+=,q-fwaas
    fi
    if ask_yes_no "Install LBaaS? [Y/n] "; then
        ENABLED_SERVICES+=,q-lbaas
    fi
    if ask_yes_no "Install VPNaaS? [Y/n] "; then
        ENABLED_SERVICES+=,q-vpn
    fi   
fi

# First updated setuptools to deal with 
# https://bugs.launchpad.net/python-openstackclient/+bug/1326811
sudo pip install --upgrade setuptools


#apt-get update
#apt-get install -qqy git
git clone https://github.com/openstack-dev/devstack.git ~/devstack
cd ~/devstack


git checkout $branch

echo ADMIN_PASSWORD=password > localrc
echo MYSQL_PASSWORD=password >> localrc
echo RABBIT_PASSWORD=password >> localrc
echo SERVICE_PASSWORD=password >> localrc
echo SERVICE_TOKEN=tokentoken >> localrc
echo $DISABLED_SERVICES >> localrc
echo "ENABLED_SERVICES+=$ENABLED_SERVICES" >> localrc


# Run stack.sh

./stack.sh

