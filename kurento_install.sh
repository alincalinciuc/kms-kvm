#!/bin/bash

# add google dns
echo "nameserver 8.8.8.8" > /etc/resolv.conf

apt-get update -y

# Install needed packages
apt-get install -q -y zip unzip default-jdk git maven apache2

# Add Kurento Media Server repository and make sure the package repository is up to date
echo "deb http://ubuntu.kurento.org trusty kms6" | sudo tee /etc/apt/sources.list.d/kurento.list
wget -O - http://ubuntu.kurento.org/kurento.gpg.key | sudo apt-key add -
apt-get update -y
apt-get install kurento-media-server-6.0 -y

ENV NOTVISIBLE "in users profile"
echo "export VISIBLE=now" >> /etc/profile

# Add KMS config file
rm -rf /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini
mv WebRtcEndpoint.conf.ini /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini

# Install KMS capabilities
apt-get install kms-chroma-6.0 -y
apt-get install kms-crowddetector-6.0 -y
apt-get install kms-platedetector-6.0 -y
apt-get install kms-pointerdetector-6.0 -y 
apt-get install software-properties-common -y

# Install VTools Software
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F04B5A6F
add-apt-repository "deb http://repository.nubomedia.eu/ trusty main"
apt-get update -y

# Add KMS6 Apt repository - not needed anyomre
# echo "deb http://ubuntuci.kurento.org/6.4.0 trusty kms6" > /etc/apt/sources.list.d/kurento.list
# apt-get update -y

apt-get install nubo-ear-detector nubo-ear-detector-dev nubo-eye-detector nubo-eye-detector-dev nubo-face-detector nubo-face-detector-dev nubo-mouth-detector nubo-mouth-detector-dev nubo-nose-detector nubo-nose-detector-dev nubo-tracker nubo-tracker-dev nubo-vfence nubo-vfence-dev -y --force-yes

# Install VTT Software
echo "deb [arch=amd64] http://ssi.vtt.fi/ubuntu trusty main" | tee -a /etc/apt/sources.list
echo "from here"
apt-get update -y
apt-get install ar-markerdetector -y --force-yes
apt-get install msdata -y --force-yes
ldconfig

# Fix some issues
mkdir -p /usr/local/bin/
mv fix.sh /usr/local/bin/
chmod +x /usr/local/bin/fix.sh
mv fix.conf /etc/init/

# Add monitoring for media elements and pipelines
echo "from here now to have the latest version of monitoring"
rm -rf ~/kms-monitoring-java
cd ~/ && git clone -b 6.5.0 --single-branch https://github.com/usv-public/kms-monitoring-java.git

# copy sendstats to init scripts
cp ~/kms-monitoring-java/scripts/sendstats /etc/init.d/sendstats
chmod +x /etc/init.d/sendstats

apt-get install monit -y
#ADD monitrc /etc/monit/conf.d/monitrc

apt-get install xinit -y
apt-get install libsoup2.4-dev -y
apt-get install xserver-xorg-video-dummy -y
echo "export DISPLAY=:0" >> /etc/default/kurento-media-server-6.0

rm -f /etc/logstash-forwarder.conf
mv logstash-forwarder.conf /etc/logstash-forwarder.conf

rm -f /etc/collectd/collectd.conf
mv collectd.conf /etc/collectd/collectd.conf

#apt-get install kms-datachannelexample -y
apt-get update -y
apt-get install openssl -y
add-apt-repository ppa:openjdk-r/ppa -y
apt-get update -y
apt-get install openjdk-8-jdk -y
