title: "LED Table, Part 2"
date: 2014-08-24 03:55:23
tags:
---
*Please read part 1 for the full story.*

## Hardware

The table construction was definitely the most fun part. The steps were basically measure, cut, sand, stain, screw together, stain, stain, and stain. I made a few mistakes but they were easily covered up using glue and wood filler. I used pegs to join the boards and help hide most of the screws. 

![Table Construction](table.png "Table Construction")

Next came the grid to house each individual LED. The grid is needed to prevent different colors from blending together and to help reflect the light upward. Finding the right material was actually pretty hard. I tried thin plywood but it was impossible to cut the precise notches. Judging from the pictures, the Wisconsin student used laser cut balsa wood, but that was too expensive for me. I ended up taking stiff cardboard and cutting out shapes with a box cutter (with plywood sides for support). A professional build would probably use injection-molded plastic, which becomes very cheap at high volumes. Another neat thing I did was make the grid housing removable, so that I can hang it on the wall as a standalone art piece. 

![Grid](grid.png "Grid")

## Software, part 2

The next major component was the website’s user interface. The first thing I wrote was a simple textbox for testing. I knew the real UI would probably need a color picker and an animation of the table. The first iteration used the canvas element in HTML5 to draw shapes java-style. However, it was really hard to set the event listeners so I switched to a great JavaScript library called FabricJS. It lets you create shapes as objects, so you can then naturally add listeners, set values, and create custom methods. 
The next iteration will use the length of time a cell was pressed to help set the color / brightness. 

![LED UI](ui.png "LED UI")

Extensions

Now that the table is mostly functional I can start thinking about extensions and add-ons. The most popular (and complicated) extension would be touch interactivity on the glass surface. Most DIY solutions involve building a grid of IR emitters and receivers. The chief advantages are simplicity and the ability to detect inanimate objects. However, I feel that they are outweighed by many disadvantages; for example, IR sensors can be washed out by house lights and the sun, wiring each emitter-receiver pair is difficult and error prone, and individual sensors results in very low resolution. Luckily, the popularity of touch screen devices has created a number of capacitive touch technologies to choose from. One solution was to place very cheap capacitive touch switches under the glass by each light cell. The switches are robust but face the same wiring and resolution problems as the IR detectors. Another solution was to use a special capacitive touch controller to monitor the entire surface at once (up to a certain size). The controller measures slight variations in the electrical field to pinpoint the exact location of a finger touch.

Another possible extension would be audio output based on the current light configuration. This [web app](http://tonematrix.audiotool.com) is a pretty neat example of what you can do. Also, I could wire up a circuit to detect and process audio input, and create a music visualizer.

