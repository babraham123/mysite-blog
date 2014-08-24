title: Install Pandoc
date: 2014-08-23 17:09:41
tags:
---

Pandoc is a requirement for Nbconvert, a useful iPython library that allows you to convert ipython notebooks into various formats. The formats include pdf, html, even latex. Pandoc is the core document converter library and is written in Haskell, so it's a bit difficult to install. 

[Docs](http://ipython.org/ipython-doc/rel-1.0.0/interactive/nbconvert.html)

``` "bash"
sudo yum install gcc
sudo wget http://sherkin.justhub.org/el6/RPMS/x86_64/justhub-release-2.0-4.0.el6.x86_64.rpm
sudo rpm -ivh --replacepkgs justhub-release-2.0-4.0.el6.x86_64.rpm
sudo yum install haskell
export PATH=/usr/hs/bin:~/.cabal/bin:$PATH
cabal update
cabal install cabal-dev
cabal install pandoc
```
