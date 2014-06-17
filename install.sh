#!/bin/bash

#apt-get update
apt-get install -qqy git
git clone https://github.com/openstack-dev/devstack.git ~/devstack
cd ~/devstack

# TODO(jorisroovers) (ask which version to install: havana, icehouse, trunk, etc)
#(git checkout stable/havana)

echo ADMIN_PASSWORD=password > localrc
echo MYSQL_PASSWORD=password >> localrc
echo RABBIT_PASSWORD=password >> localrc
echo SERVICE_PASSWORD=password >> localrc
echo SERVICE_TOKEN=tokentoken >> localrc
./stack.sh

