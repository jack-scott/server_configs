#!/bin/bash

CONFIG_LOCATION=/home/jack/Documents/software/home_assistant_config/home_asistant

docker run -d \    
    --name homeassistant \
    --privileged \ 
    --restart=unless-stopped \
    -e TZ=MY_TIME_ZONE\
    -v $CONFIG_LOCATION:/config \
    -v /run/dbus:/run/dbus:ro \
    --network=host \
    ghcr.io/home-assistant/home-assistant:stable
