title: Decoupled Web Apps
date: 2014-08-24 03:59:23
tags:
---

# Decoupling web applications

This article outlines a few best practices for developing multiple, independent web applications within the same website or even the same webpage. During my experiments, I used python and nodejs for my server-side software. My research into web apps was motived by my recent expansion of my personal website. In order to showcase my web development skills, I added on a section called Labs, where I prototype interesting web applications. Below are some of the lessons I learned.
 
#### Lesson 1, code management
Initially, I stored the code for my web apps in the same git repository as the code for my umbrella website, a django app. However, because they functioned independently, I often wanted to develop on and branch each web app differently. So I split the code into multiple repositories and reintroduced them as submodules into the main repo.
 
#### Lesson 2, libraries and dependencies
Personally, I like to save as many dependencies as I can locally in the git repo. That way on a fresh machine I can just git clone and be ready to go. For node that simply means removing `\node_modules` from the `.gitignore` file. For python you have to use the `virtualenv` library.

#### Lesson 3, routing
So I usually run each app on a random unused port on my server. However, keeping track of the port numbers in my main website was turning out to be a pain. So, I installed nginx and used it to reverse proxy to all of my apps, using human readable routes. For example, `/app1:80` would map to `/localhost:8080`. I also used it to serve all of my status content.

#### Lesson 4, deployment
There are a lot of great tools for automated deployment, like Puppet and Jenkins. However, that was total overkill for my website. Instead, I settled for a simple bash script that installs the right config files and restarts the upstart job. I use upstart to run my server as a system service and restart on boot. Each app has its own start script and upstart job.

