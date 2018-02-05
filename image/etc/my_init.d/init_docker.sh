#!/bin/bash

[[ -e /var/run/docker.sock ]] || exit 0

usermod -a -G docker $DOCKER_USER

GROUP=$(ls -l /var/run/docker.sock | cut -f4 -d" ")
NUMBER='^[0-9]+$'

if [[ $GROUP =~ $NUMBER ]] ; then
  groupmod -g $GROUP docker
elif [ "$GROUP" != "docker" ]; then
  chgrp docker /var/run/docker.sock
fi
