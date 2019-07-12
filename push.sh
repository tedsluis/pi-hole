sudo /usr/bin/git --git-dir=/home/pi/pi-hole/.git --work-tree=/home/pi/pi-hole status
sudo /usr/bin/git --git-dir=/home/pi/pi-hole/.git --work-tree=/home/pi/pi-hole add /home/pi/pi-hole/*
sudo /usr/bin/git --git-dir=/home/pi/pi-hole/.git --work-tree=/home/pi/pi-hole commit -m 'Update blocklists and blacklist.'
sudo /usr/bin/git --git-dir=/home/pi/pi-hole/.git --work-tree=/home/pi/pi-hole push
