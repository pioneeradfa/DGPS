#!/bin/bash

sudo chmod 666 /dev/ttyACM0
lab



echo "Launching dgps ublox..."
roslaunch ublox_gps ublox_zed-f9p.launch &
pid="$pid $!"


trap "echo Killing all processes.; kill -2 TERM $pid; exit" SIGINT SIGTERM

sleep 24h
