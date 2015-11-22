# Setup Hexo server

```bash
sudo apt-get install upstart
sudo cp myblog.conf-upstart /etc/init/myblog.conf
sudo start myblog

# add new system service
sudo initctl reload-configuration

# Make it starts at system boot
sudo update-rc.d myblog defaults

# view status of all services
sudo initctl list
```

