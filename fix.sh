#!/bin/bash
instance_name=$(curl http://169.254.169.254/latest/meta-data/hostname)
HOSTNAME_MONITORING="HOSTNAMEMONITORING"
instance_name=${instance_name::-10}

# Local instance variables
sed -i -e "s/$HOSTNAME_MONITORING/$instance_name/g" /etc/collectd/collectd.conf
service collectd restart
sed -i -e "s/$HOSTNAME_MONITORING/$instance_name/g" /etc/logstash-forwarder.conf
service logstash-forwarder restart


# ENV vars that need to be updated
# All ENV Vars should be added to /opt/envvars by the USER DATA script
source /opt/envvars
export $(cut -d= -f1 /opt/envvars)

# Kurento Media Server Variables
NUBOMEDIA_STUN_SERVER_ADDRESS="NUBOMEDIASTUNSERVERADDRESS"
NUBOMEDIA_STUN_SERVER_PORT="NUBOMEDIASTUNSERVERPORT"
NUBOMEDIA_TURN_SERVER_ADDRESS="NUBOMEDIATRUNSERVERADDRESS"
NUBOMEDIA_TURN_SERVER_PORT="NUBOMEDIATURNSERVERPORT"
sed -i -e "s/$NUBOMEDIA_STUN_SERVER_ADDRESS/$NUBOMEDIASTUNSERVERADDRESS/g" /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini
sed -i -e "s/$NUBOMEDIA_STUN_SERVER_PORT/$NUBOMEDIASTUNSERVERPORT/g" /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini
sed -i -e "s/$NUBOMEDIA_TURN_SERVER_ADDRESS/$NUBOMEDIATURNSERVERADDRESS/g" /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini
sed -i -e "s/$NUBOMEDIA_TURN_SERVER_PORT/$NUBOMEDIATURNSERVERPORT/g" /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini


# Remove ipv6 local loop until ipv6 is supported
instance_name_nova=$(curl http://169.254.169.254/latest/meta-data/hostname)
instance_name_local=$("hostname")
echo "" > /etc/hosts
echo "127.0.0.1 localhost $instance_name $instance_name_local" > /etc/hosts
echo "nameserver 8.8.8.8" > /etc/resolv.conf

export INSTANCE_NAME=$instance_name
export DISPLAY=:0

# Restart kurento
service kurento-media-server-6.0 restart

# Start monitoring tools
service monit restart

# Xinit
cd ~/ && wget xpra.org/xorg.conf
Xorg -noreset +extension GLX +extension RANDR +extension RENDER -logfile /var/log/0.log -config ~/xorg.conf :0
