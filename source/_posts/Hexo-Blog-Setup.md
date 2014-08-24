title: Hexo Blog Setup
date: 2014-08-23 21:27:53
tags:
---

### Hexo is a Node module for generating html files from Markdown, and is great for making blog posts. The best method seems to be writing/generating your posts on a local computer, then deploying your project to the remote server.

Installs
``` "bash"
sudo yum install npm
sudo npm install -g hexo
```

Start a new Hexo project
``` "bash"
hexo init myblog
cd myblog
sudo npm install
```

Download the phase theme (optional)
``` "bash"
git clone git://github.com/tommy351/hexo-theme-phase.git themes/phase
```

Configure your git repo, port #, etc
`vi _config.yaml`
``` "asciidoc"
# Hexo Configuration
## Docs: http://hexo.io/docs/configuration.html
## Source: https://github.com/hexojs/hexo/

# Site
title: Greasy Keys
subtitle: hardware meets software
description:
author: Bereket Abraham
email: babraham42@gmail.com
language: en-US

# URL
## If your site is put in a subdirectory, set url as 'http://yoursite.com/child' and root as '/child/'
url: http://bereketabraham.com/blog
root: /blog/
permalink: :year/:month/:day/:title/
tag_dir: tags
archive_dir: archives
category_dir: categories
code_dir: downloads/code
permalink_defaults:

# Directory
source_dir: source
public_dir: public

# Writing
new_post_name: :year-:month-:day-:title.md
default_layout: post
titlecase: false # Transform title into titlecase
external_link: true # Open external links in new tab
filename_case: 0
render_drafts: false
post_asset_folder: false
relative_link: false
highlight:
  enable: true
  line_number: true
  tab_replace:

# Category & Tag
default_category: uncategorized
category_map:
tag_map:

# Archives
## 2: Enable pagination
## 1: Disable pagination
## 0: Fully Disable
archive: 2
category: 2
tag: 2

# Server
## Hexo uses Connect as a server
## You can customize the logger format as defined in
## http://www.senchalabs.org/connect/logger.html
port: 8008
server_ip: localhost
logger: false
logger_format: dev

# Date / Time format
## Hexo uses Moment.js to parse and display date
## You can customize the date format as defined in
## http://momentjs.com/docs/#/displaying/format/
date_format: MMM D YYYY
time_format: H:mm:ss

# Pagination
## Set per_page to 0 to disable pagination
per_page: 3
pagination_dir: page

# Disqus
disqus_shortname:

# Extensions
## Plugins: https://github.com/hexojs/hexo/wiki/Plugins
## Themes: https://github.com/hexojs/hexo/wiki/Themes
theme: phase
exclude_generator:

# Deployment
## Docs: http://hexo.io/docs/deployment.html
deploy:
  type: github
  repo: https://github.com/babraham123/mysite-blog.git
```

Create a new post. Images also go in the source folder.
``` "bash"
hexo new post "Title" 
vi source/_posts/Title.md
```
``` "markdown"
# Post title
## subtitle

**by Bereket Abraham**

[Visit GitHub!](www.github.com)

Filler paragraph.

![](test.png)
```

Generate html files and deploy to git
``` "bash"
hexo generate --deploy
```

Start a test server to check your post. [http://localhost:4000/blog/](http://localhost:4000/blog/)
``` "bash"
hexo server
```

---

**How to run server on remote server in production environment.**
On remote server:

Installs
``` "bash"
sudo yum install node
sudo yum install upstart
sudo npm install -g forever
```

Clone git repo and create application file
`vi blog_server.js`
``` "javascript"
require('hexo').init({command: 'server'});
```

Add Hexo to the package config and install locally
`vi package.json`
``` "json"
{
  "name": "hexo-site",
  "version": "2.8.2",
  "private": true,
  "dependencies": {
    "hexo": "2.8.2",
    "hexo-renderer-ejs": "*",
    "hexo-renderer-stylus": "*",
    "hexo-renderer-marked": "*"
  }
}
```
``` "bash"
sudo npm install
```

Create new Upstart service
`vi /etc/init/myblog.conf`
``` "bash"
description "node hexo server for my blog - myblog”
start on runlevel [2345]
stop on runlevel [06]

expect fork
respond
respawn limit 10 5
console output

script
        NAME=myblog
        USER=username
        GROUP=wheel
        MAINFILE=blog_server.js
        LOGFILE=/var/log/forever/$NAME.log
        OUTFILE=/var/log/forever/$NAME_stdout.log
        ERRFILE=/var/log/forever/$NAME_stderr.log
        LOGDIR=$(dirname $LOGFILE)
        test -d $LOGDIR || mkdir -p $LOGDIR
        cd /home/$USER/$NAME

        exec forever start -a -l $LOGFILE -o $OUTFILE -e $ERRFILE $MAINFILE
end script

post-start script
   echo "myblog started through forever + upstart”
end script
```

Start the Node service
``` "bash"
sudo start myblog
```

View status of all services
``` "bash"
sudo initctl list
```

