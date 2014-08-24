title: "LED Table, Part 1"
date: 2014-08-23 22:04:00
tags:
---

## The idea

A few months ago, I decided it was time to start a new side project. I really enjoyed using Arduinos in my senior thesis, so I decided that my next project would be centered around them. Just like before, I started searching websites like hackaday.com and instructables.com for inspiration. Eventually, I stumbled upon the idea of a LED enabled coffee table. A lot of people had tried it before with varying degrees of success. However, I believed that there were still serious engineering challenges that could be solved or simplified, as well as significant areas to reduce cost.

Here is a pretty neat example by a mechanical engineering student in Wisconsin ([images](http://imgur.com/a/CGV17)). Underneath the glass top was about 100 individually addressable LEDs. Each LED could change color and brightness, and they were all connected to the same SPI bus. In addition, the builder had wired each light cell with an IR detector and emitter to sense touches and objects on the glass surface. The end result was a beautiful frosted glass table that could create an instant dance party. 

I started the project with an intense research and design phase. I immediately decided that touch control was a secondary goal of the project, due to the cost and complexity of wiring each individual light cell. Next came determining the dimensions, material, costs, suppliers, etc. 

![Google Sketch Up](model.png "Google Sketch Up")

## Software

While waiting for all of my part to be delivered, I started working on the Arduino code. Controlling the lights was easy, using the very convenient FastSPI library. The next step was creating a website to control the light values (using the Ethernet shield to connect to the internet). A table is an inherently social object, so I knew I had to architect in multiuser support from the beginning. My first thought was use the Arduino as a webserver and create an API for the table. My actual server (cloud-hosting Linux server) would serve the UI, with the IP address of my Arduino hardcoded into the client code. The client could then query the status of each LED and set individual values. I succeeded in building a prototype but there were two crucial problems. First, I was running it off of my home network so I had to track my IP address and use port forwarding to expose my device to the Internet. Second, and more worrisome, the Arduino was incredibly slow. My solution to these challenges was to put a Raspberry Pi in front of the Arduino and to build out a socket.io server on my remote Linux instance. Socket.io wraps several technologies like long polling and websockets to allow the client and server to both push and pull commands. Now, my table is simply a client receiving commands from a set of other “user” clients. The Raspberry Pi (a headless Linux computer) manages the connection and forwards new commands to the Arduino over serial. 

![System Architecture](diagram.png "System Architecture")

One might wonder why I needed both an Arduino and a Raspberry Pi. I needed the Arduino because the RPi didn’t have a high enough clock speed for the WS2811 LED controllers. Also, the RPi was faster and cheaper than the Arduino WiFi shield. More generally, it was nice to have a dedicated component for each function, networking and hardware control, rather than one that could only sort of do both.

![Electronics](electronics.png "Electronics")

