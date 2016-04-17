# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:latest
ENV DEBIAN_FRONTEND noninteractive

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install updates
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get install -y wget curl supervisor

# Install dependencies
RUN apt-get install -y git-core 
RUN apt-get install -y build-essential

#MQTT
RUN wget -q -O - http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add -
RUN wget -q -O /etc/apt/sources.list.d/mosquitto-jessie.list http://repo.mosquitto.org/debian/mosquitto-jessie.list
RUN apt-get update
RUN apt-get install -y mosquitto
COPY mqtt_port.conf /etc/mosquitto/conf.d/mqtt_port.conf
COPY websockets.conf /etc/mosquitto/conf.d/websockets.conf

EXPOSE 1883 9001
CMD /usr/sbin/mosquitto -c /etc/mosquitto/mosquitto.conf
# Setup services
COPY supervisord.conf /etc/supervisor/supervisord.conf
RUN mkdir -p /var/log/supervisord

CMD supervisord -c /etc/supervisor/supervisord.conf
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
