#!/bin/bash

# Debian and Ubuntu

export DEBIAN_FRONTEND=noninteractive
apt-get update
PACKAGES="nodejs npm git"

for i in $PACKAGES; do
    if dpkg -l | grep $i > /dev/null 2>&1; then
        echo "${i} package already installed"
    else
        apt-get install \
            -y $i \
            --no-install-recommends
    fi
done

if npm -g list express ; then
    echo "Express is already installed"
else
    npm install -g express
fi
