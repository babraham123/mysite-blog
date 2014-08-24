title: Socket.io Setup
date: 2014-08-23 20:23:29
tags:
---

### Setting up the Nginx reverse proxy to run a node Socket.io server in parallel with Django. Using Forever and Upstart to manage the Node process.

Install packages (centos)
``` "bash"
sudo yum install npm
sudo npm install forever -g
```

Add all of application specific code. For beginners, use this [tutorial](http://www.nodebeginner.org/)
``` "bash"
mkdir mysocketio && cd mysocketio
```

Create the `package.json` file and locally install project packages
``` "bash"
npm install
```

Set file permissions
  Folders (0755 = User:rwx Group:r-x World:r-x)
  Files (0644 = User:rwx Group:r World:r)
``` "bash"
su
chmod 755 /home
chmod 755 /home/username
chmod 755 /home/username/mysocketio -R
chmod 644 /home/username/mysocketio/socketio_server.js
exit
```

Update Nginx configuration
`vi /etc/nginx/conf.d/mysite.conf`
``` "nginx" "Add the following snippet to the top of your port 80 listener"
    location /socket.io/public/ {
        root /home/babraham/mysocketio;
    }

    location /socket.io/ {
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 120s;
        proxy_pass http://127.0.0.1:8002;
    }
```

You may need to install a more recent version of Nginx [cite](https://webtatic.com/packages/nginx14/)
``` "bash"
sudo rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm
sudo yum install nginx16
```

Reload and restart
``` "bash"
sudo nginx -s reload
sudo service nginx restart
```

Create a new Upstart service
`vi /etc/init/mysocketio.conf`
``` "bash"
description "node server for socket.io connections - mysocketio"
start on runlevel [2345]
stop on runlevel [06]

expect fork
respawn
respawn limit 10 5
console output

script
        NAME=mysocketio
        PORT=8002
        USER=username
        GROUP=wheel
        MAINFILE=socketio_server.js
        LOGFILE=/var/log/forever/$NAME.log
        OUTFILE=/var/log/forever/$NAME_stdout.log
        ERRFILE=/var/log/forever/$NAME_stderr.log
        LOGDIR=$(dirname $LOGFILE)
        test -d $LOGDIR || mkdir -p $LOGDIR
        cd /home/$USER/$NAME

        exec forever start -a -l $LOGFILE -o $OUTFILE -e $ERRFILE $MAINFILE $PORT
end script

post-start script
   echo "mysocketio started through forever + upstart"
end script
```

Start the Node service
``` "bash"
sudo start mysocketio
```

View status of all services
``` "bash"
sudo initctl list
```

[Upstart + Forever](http://technosophos.com/2013/03/06/how-use-ubuntus-upstart-control-nodejs-forever.html)

[Nginx](http://blog.martinfjordvald.com/2013/02/websockets-in-nginx/)

