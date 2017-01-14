#!/bin/bash

#
#  Cleanup
#
apt-get autoremove -y
apt-get autoclean -y

echo -e "----------------------------------------"
echo -e "To edit this project:\n"
echo -e "----------------------------------------"
echo -e "$ cd /vagrant/source"
echo -e
echo -e "----------------------------------------"
echo -e "Default Site: http://192.168.70.70"
echo -e "----------------------------------------"

