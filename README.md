# WARNING

This is a bad code. Overall architecture is crafted in a messy way, that does not consider standard ruby gem organization patterns.
This means that you can still use this code, if you want to, but default conventions do not apply here, therefore you should understand the code layout first.
Do not depend on this code yet, since it's mostly a rough draft now.

# AI Framework

A simple set of classes to assist in implementing algorithms of the Artificial Intelligence course.
All this code does is simulates a robot that solves a maze.

## Status

This is a very badly organized project, for now.
Ideally, I should implement some generators to allow building custom stuff upon this project, add some modularity and the ability to reuse code (via gem plugins maybe).
But that's not gonna happen, as this is just a course project, and this won't probably be used elsewere.

## Axis

`X` goes right, `Y` goes down. Coordinates start at the top left corner of the world.
Left is negative `X`, right is positive `X`. Up is negative `Y`, down is poitive `Y`.

## Map formats

Strict JSON map format as well as ascii-graphics based map formats are supported.