#!/usr/bin/env bash

#If broken put sodu command back into file copy actions

#Creating Stream.conf file to send to parent
echo "Creating stream.conf to send data to parent"
cat << 'EOF' >/usr/local/netdata/etc/netdata/stream.conf
[stream]
    enabled = yes
    destination = KRMAC01:19999
    api key = 4DC3A4ED-B8C4-4578-9A0A-9E2A2E631B5A
EOF


#Copy caching chart and notification config files
cp ./conf_files/caching.conf /usr/local/netdata/etc/netdata/python.d/
cp ./conf_files/caching.chart.py /usr/local/netdata/usr/libexec/netdata/python.d/
cp ./conf_files/health_alarm_notify.conf /usr/local/netdata/usr/lib/netdata/conf.d/
cp ./conf_files/python.d.conf /usr/local/netdata/usr/lib/netdata/conf.d/
cp ./conf_files/netdata.conf /usr/local/netdata/etc/netdata/

#Configure caching alerts
echo "Configuring caching alerts"
cat <<'EOF2' > /usr/local/netdata/etc/netdata/health.d/applecache.conf
 alarm: applecache_status
    on: caching.cache_status
lookup: sum -30m of RegistrationStatus
 units: On
 every: 10s
  warn: $this < 240
  crit: $this < 120
  info: The availability of the Apple Caching Service - data is updated every 10 seconds, warning if offline for 10 minutes, critical if offline for 20 of the last 30 minutes.
EOF2

#Restarting Netdata and health monitoring
sudo killall netdata
sleep 5
sudo /usr/local/netdata/usr/sbin/netdata
sleep 10
Sudo /usr/local/netdata/usr/sbin/netdatacli reload-health