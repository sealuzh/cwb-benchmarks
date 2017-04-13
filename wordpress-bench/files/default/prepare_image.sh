#!/usr/bin/env sh

# This script prepares a CWB `wordpress-bench` instance for taking an AMI snapshot.


# Remove the already registered chef client
sudo rm -rf /etc/chef

# Cleanup `/usr/local/cloud-benchmark` logs
rm -rf /usr/local/cloud-benchmark/*.log
