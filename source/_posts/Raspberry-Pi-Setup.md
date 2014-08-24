title: Raspberry Pi Setup
date: 2014-08-23 17:41:18
tags:
---

**How to setup a Raspberry Pi** (assuming you've already bought the supporting components, like a power supply, wiki dongle, and ethernet cable.)

Plug SD card into your computer to format

Open disk utility and erase card. Set the name and the format to "MS-DOS (FAT)"
``` "bash" "on computer"
diskutil list
# find your card, example /dev/disk38
diskutil unmountdisk /dev/disk38
```

Download your pi OS image and cd to folder. [Download](http://www.raspberrypi.org/downloads/)
``` "bash"
sudo dd if=2014-06-20-wheezy-raspbian.img of=/dev/disk38 bs=2m
# (flash OS image onto card, if=source, of=target, bs=size)
```

Plug in peripherals, like keyboard, ethernet cable, and power

In order to locate your pi on the wifi network, install mmap, run it, and ssh into your pi
``` "bash"
ifconfig (get local ip address)
nmap -sn 192.168.1.0/24
ssh pi@192.168.1.88
# username= pi
# password= raspberry
```

``` "bash" "on pi"
sudo raspi-config
(set password, OS size, locale, )
username= pi
password= typical
```

Set up environment
``` "bash" "on pi"
sudo apt-get update
sudo apt-get upgrade
sudo apt-get autoremove
```

Wifi dongle setup
``` "bash" "on pi"
sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.bak
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
```
Change your ssid/password
``` "nginx"
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
        ssid="your_ssid"
        psk="your_pass"
}
```

Reboot and log back in
`sudo reboot`
``` "bash" "on computer"
nmap -sn 192.168.1.0/24
# find ip address again
ssh pi@192.168.1.56
```

**Extra:**
for GUI, after you plugin a monitor
`startx` 

Shutdown command
`sudo shutdown -h now`

