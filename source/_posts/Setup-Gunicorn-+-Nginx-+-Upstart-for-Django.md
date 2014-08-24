title: Setup Gunicorn + Nginx + Upstart for Django
date: 2014-08-23 17:11:29
tags:
---

### Nginx is a high-performance HTTP server and reverse proxy. I use it to serve static files and route incoming requests among multiple web applications. Gunicorn is a Python WSGI HTTP Server for UNIX that I use to serve Django. Together, they form a more flexible and robust solution than Apache. 
### Upstart is a great utility for starting, stopping, and supervising tasks as if they were services.

Install
``` "bash"
sudo pip install gunicorn
sudo yum install nginx
sudo yum install upstart
```

Record the number of CPUs, use that next for the number of `worker_processes`
``` "bash"
lscpu | grep '^CPU(s)'
```

`vi /etc/nginx/nginx.conf`
``` "nginx" "Insert the following snippet"
user              nginx;
worker_processes  1;
```

Nginx configuration
`vi /etc/nginx/conf.d/mysite.conf`
``` "nginx"
# virtual host using mix of IP-, name-, and port-based configuration
# from the django app, mysite, running on gunicorn

server {
    listen       80;
#    listen       someip:8080;
    server_name  sitename.com;

    access_log  /var/log/nginx/mysite.log;

    location / {
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Host $server_name;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_pass http://127.0.0.1:8001;
    }

    location /media/ {
        root /home/username/mysite/media;
    }

    location /static/ {
        root /home/username/mysite/static;
    }

    location /admin/media/ {
        # this changes depending on your python version
        root /usr/lib/python2.6/site-packages/django/contrib;
    }

    error_page   500 502 503 504  /home/username/mysite/static/50x.html;
}
```

Reload after configuration changes
``` "bash"
sudo nginx -s reload
sudo service nginx restart
```

Upstart Configuration
`vi /etc/init/mysite.conf`
``` "bash"
description "My website - mysite"
start on runlevel [2345]
stop on runlevel [06]
respawn
respawn limit 10 5

script
                NAME=mysite
                PORT=8001
                NUM_WORKERS=2
                TIMEOUT=120
                USER=username
                GROUP=wheel
                LOGFILE=/var/log/gunicorn/$NAME.log
                LOGDIR=$(dirname $LOGFILE)
                test -d $LOGDIR || mkdir -p $LOGDIR
                cd /home/$USER/$NAME
                exec gunicorn_django \
                         -w $NUM_WORKERS -t $TIMEOUT \
                        --user=$USER --group=$GROUP --log-level=debug \
                        --name=$NAME -b 127.0.0.1:$PORT \
                        --log-file=$LOGFILE 2>>$LOGFILE
end script
```

Start the gunicorn/django service
``` "bash"
sudo start mysite
```
