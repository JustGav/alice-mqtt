# Docker container for simple MQTT

This docker image contains
MQTT

Interactive running command
docker run --rm -t -i docker-openhab /sbin/my_init -- bash -l

Background running command
docker run --restart=always --name=alice-mqtt -p 1883:1883 -p 9001:9001 -t -d docker-mqtt
