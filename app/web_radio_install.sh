#!/usr/bin/env bash

# Configure your web radio station

# Create directory
mkdir -p /var/azuracast
cd /var/azuracast

# Install server
curl -fsSL https://raw.githubusercontent.com/AzuraCast/AzuraCast/master/docker.sh >docker.sh
chmod a+x docker.sh
./docker.sh install

https://github.com/J0hn-B/azuracast/tree/master/images/back.jpg
