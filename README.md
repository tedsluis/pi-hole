# Pi-hole config

###
Clone this repo
```bash
~ $ git clone git@github.com:tedsluis/pi-hole.git
~ $ cd pi-hole
```

### Pi-hole systemd service
```bash
~ $ vi /etc/systemd/system/pi-hole.service 

Description=pi-hole
After=docker.service 
Requires=docker.service network.target

[Service]
TimeoutStartSec=300
RestartSec=3
Restart=always
ExecStartPre=-/usr/bin/docker stop -t 2 pi-hole
ExecStartPre=-/usr/bin/docker rm -f pi-hole
ExecStartPre=/usr/bin/docker pull pihole/pihole:latest 
ExecStart=/usr/bin/docker run \
                          --name pi-hole \
                          -p 53:53/tcp \
                          -p 53:53/udp \
                          -p 67:67 \
                          -p 80:80 \
                          -p 443:443 \
                          -e TZ="Europe/Amsterdam" \
                          -e WEBPASSWORD=pihole \
                          -e DNS1="8.8.8.8" \
                          -e DNS1="8.8.4.4" \
                          -e ServerIP=192.168.1.17 \
                          -v "/home/pi/pi-hole/etc-pihole/:/etc/pihole/" \
                          -v "/home/pi/pi-hole/etc-dnsmasq.d/:/etc/dnsmasq.d/" \
                          --dns=127.0.0.1 \
                          --dns=192.168.1.254 \
                          pihole/pihole:latest
ExecStop=-/usr/bin/docker stop -t 2 pi-hole
ExecStopPost=-/usr/bin/docker rm -f pi-hole
 
[Install]
WantedBy=multi-user.target 
```
### Start Pi-hole service
```bash
~ $ sudo systemctl start pi-hole.service
~ $ sudo systemctl enable pi-hole.service
``` 

### Crontab
```bash
~ $ sudo crontab -e

# m  h dom mon dow command
*    1 *   *   1   sudo /usr/bin/docker pull pihole/pihole:latest
*    2 *   *   1   sudo /bin/systemctl restart pi-hole.service
*    3 *   *   1   sudo /usr/bin/docker system prune --all --force
*    4 *   *   1   sudo docker exec $(sudo docker ps -q) /opt/pihole/update.sh
*    5 *   *   *   sudo docker exec $(sudo docker ps -q) /opt/pihole/gravity.sh
*/15 * *   *   *   CONTAINER=$(sudo docker ps -q); sudo docker cp /home/pi/pi-hole/youtube/. ${CONTAINER}:/ ; sudo docker exec $(sudo docker ps -q) ./ytblock-rpi.sh
```

### Logging
```bash
~ $ sudo docker exec $(sudo docker ps -q) ls -l /var/log/
total 5444
-rw-r--r-- 1 root     root        4678 Jul  2 05:53 alternatives.log
drwxr-xr-x 1 root     root        4096 Jul  2 05:53 apt
-rw-r--r-- 1 root     root       36141 Jun 21 11:47 bootstrap.log
-rw-rw---- 1 root     utmp           0 Jun 21 11:46 btmp
-rw-r--r-- 1 root     root      115336 Jul  2 05:53 dpkg.log
-rw-r--r-- 1 root     root       24000 Jul  2 05:53 faillog
-rw-rw-r-- 1 root     utmp      292000 Jul  2 05:53 lastlog
drwxr-x--- 1 www-data www-data    4096 Jul  2 09:55 lighttpd
drwxr-xr-x 2 pihole   pihole      4096 Jul  2 09:52 pihole
-rw-r--r-- 1 root     root       15681 Jul  2 21:44 pihole-FTL.log
-rw-r--r-- 1 pihole   pihole   5054567 Jul  2 21:45 pihole.log
-rw-rw-r-- 1 root     utmp           0 Jun 21 11:46 wtmp
```

### Block Youtube ads
See https://github.com/foae/pihole-youtube-block
```bash
~ $ sudo docker exec $(sudo docker ps -q)  ls -l /ytblock-rpi /ytblock-rpi.sh
-r-xr-xr-x 1 1000 1000 2792700 Jul  2 06:48 /ytblock-rpi
-r-xr-xr-x 1 1000 1000      32 Jul  2 17:32 /ytblock-rpi.sh
``

