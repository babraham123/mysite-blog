title: How to setup Django + mysql + Apache
date: 2014-08-23 14:21:36
tags:
---

### Below is a step by step account of how to set up a django (1.6) web application on a CentOS (6.4) server, running Apache (2.5) and python (2.6, 2.7)

1: **Login as root and set up a new user**

You probably want to eventually disable root login
``` "bash" 
ssh root@[ip address]
```

Create user
``` "bash"
useradd myuser
passwd myuser
```

Add user to a sudo enabled group
``` "bash" 
usermod -a -G wheel myuser
```

Allow the wheel group to use sudo by editing the shudders file
`visudo -f /etc/sudoers`
``` "AsciiDoc" "edit the following snippet"
## Allows people in group wheel to run all commands
# %wheel        ALL=(ALL)       ALL
```

`exit`

2: **Login without typing in your password (not strictly necessary)** [cite](http://wiki.centos.org/HowTos/Network/SecuringSSH)

On your local machine, generate public/private key
``` "bash" 
ssh-keygen -t rsa
```

Set permissions on your private key
``` "bash"
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
```

Copy your public key onto remote server
``` "bash"
scp ~/.ssh/id_rsa.pub myuser@[ip address]:/home/myuser
```

On remote machine
``` "bash"
ssh myuser@[ip address]
mkdir ~/.ssh
touch ~/.ssh/authorized_keys
```

Add public key to authorized list
``` "bash"
cat id_rsa.pub >> ~/.ssh/authorized_keys
rm id_rsa.pub
```

Set permissions
``` "bash"
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

3: **Install necessary packages. Since this is for CentOS, we yum.** [cite](http://itekblog.com/django-centos-6-4/)

Check centos version. These cmds are for centos 6.4
``` "bash"
cat /etc/redhat-release
```

`su`

Add the EPEL repositories to get Django
``` "bash"
cd /opt/
wget http://mirrors.nl.eu.kernel.org/fedora-epel/6/i386/epel-release-6-8.noarch.rpm
rpm -Uvh epel-release-6-8.noarch.rpm
rm epel-release-6-8.noarch.rpm -f
```

Install packages
``` "bash"
yum upgrade
yum install python
	(should be 2.6.6)
yum install sqlite
yum install mod_wsgi
yum install mysql mysql-server

yum install python-pip
pip install Django==1.6
	(1.6 or whatever version you want)
yum -y install mysql-devel
yum install MySQL-python
```

Check to see if django works
`python`
``` "python"
import django
print django.get_version()
quit()
```

`exit`

4: **Django**

``` "bash" 
django-admin.py startproject mysite
cd mysite
```

Add all of application specific code. For beginners, use this [tutorial](https://docs.djangoproject.com/en/1.6/intro/tutorial01/)


5: **Create a mysql database (or skip this and use mysqlite)**

`su`

Get mysql working, choose a password
``` "bash" 
chkconfig --levels 235 mysqld on
/etc/init.d/mysqld start
mysql_secure_installation
```

Create a new mysql user
`mysql -u root -p`
``` "sql" 
create database mysitedb;
GRANT ALL PRIVILEGES ON mysitedb.* To 'user'@'localhost' IDENTIFIED BY 'password';
quit;
```

`exit`

Add the details to your database to the django settings file
`vi ~/mysite/mysite/settings.py`
``` "python" "Add the following snippets"
ALLOWED_HOSTS = ['my.server.ip.address']

DATABASES = {
    'default': {
        # Add 'postgresql_psycopg2', 'postgresql', 'mysql', 'sqlite3' or 'oracle'.                                        
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'mysitedb',
        'USER': 'mysiteuser',
        'PASSWORD': 'password',
        'HOST': '',
        'PORT': '',
    }
}

TEMPLATE_DIRS = (
    os.path.join(BASE_DIR, "templates"),
)
```

Have python create mysql tables
``` "bash"
cd ~/mysite/
python manage.py syncdb
python manage.py sql [name of app]  # if you have any apps
python manage.py syncdb
```

6: **Set up mod_wsgi (A python library for Apache). For testing, you can skip this and just use the development server that comes with django (instead of Apache).**

Development server
``` "bash"
python manage.py runserver
```

`su`

Configure apache module for django
`vi /etc/httpd/conf.d/wsgi.conf`
``` "apache"
LoadModule wsgi_module modules/mod_wsgi.so

<VirtualHost *:80>
  ServerName www.mywebsite.com
  ServerAlias mywebsite.com
  ServerAdmin webmaster@mywebsite.com

  Alias /static/admin/ /usr/lib/python2.6/site-packages/django/contrib/admin/static/admin/
  Alias /robots.txt /home/username/mysite/static/robots.txt
  Alias /favicon.ico /home/username/mysite/static/favicon.ico
  AliasMatch ^/([^/]*\.css) /home/username/mysite/static/styles/$1

  Alias /media/ /home/username/mysite/media/
  <Directory /home/username/mysite/media>
    Order deny,allow
    Allow from all
  </Directory>

  Alias /static/ /home/username/mysite/static/
  <Directory /home/username/mysite/static>
    Order deny,allow
    Allow from all
  </Directory>

#  WSGIDaemonProcess mywebsite.com python-path=/home/username/mysite:/usr/lib/python2.6/
#  WSGIProcessGroup mywebsite.com

  WSGIScriptAlias / /home/username/mysite/mysite/wsgi.py

  <Directory /home/username/mysite/mysite>
    <Files wsgi.py>
#      WSGIProcessGroup mywebsite.com
      Order allow,deny
      Allow from all
    </Files>
  </Directory>

</VirtualHost>
```

Restart after changing config files
``` "bash"
sudo apachectl restart
# or, if that fails try this version
/sbin/service httpd restart
```

other commands 
``` "bash"
apachectl start
apachectl stop
apachectl status
httpd -v
```

Testing: `vi /var/www/html/index.html`


7: **Troubleshooting 403 permission denied errors. After every change, restart apache and check website.**

Set user permissions for project files
  Folders (0755 = User:rwx Group:r-x World:r-x)
  Files (0644 = User:rwx Group:r World:r)
``` "bash"
su
chmod 755 /home
chmod 755 /home/username
chmod 755 /home/username/mysite -R
chmod 644 /home/username/mysite/wsgi.py
exit
```

Add project folder to system path
`vi mysite/wsgi.py`
``` "python" "Add snippet to the top of the file"
import sys
sys.path.append('/home/username')
sys.path.append('/home/username/mysite')
```

[Problems with SELinux](http://blog.endpoint.com/2010/02/selinux-httpd-modwsgi-26-rhel-centos-5.html)
``` "bash"
su
setsebool -P httpd_can_network_connect on
setsebool -P httpd_enable_homedirs on
setsebool -P httpd_can_sendmail on
restorecon -vR /etc/httpd
exit
```

[Config problems on CentOS](http://code.google.com/p/modwsgi/wiki/WhereToGetHelp?tm=6#Conference_Presentations)


