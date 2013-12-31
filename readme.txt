Sparkz, a player-created mod for Starbound.

Latest release: v2.1, for Starbound Beta v Angry Koala

This mod was created to add wiring and logic functionality above and beyond that which is available in the vanilla game, by adding a variety of wire-interactive sensors, logic blocks, and actuators.

Created by metadept. Please email any questions, suggestions or bug reports to cheswick13@hotmail.com.

FEATURES
-Data Wires! Use wire connections to transfer and manipulate numeric data
  -Displays: Linked Display and Small Linked Display can be used to display numeric data
  -Sensors: Light Sensor, Wind Sensor, Thermometer and Liquid Sensor can either trigger binary wires or send numeric data
  -Scanner: Reads information about a nearby entity. Interact to switch between Current HP and Max HP modes (more modes coming)
  -Counter: Uses binary signals to increment, decrement, and reset a stored value, which can then be sent to a display
  -Comparator: Compare two numeric values with >, <, and == (interact to switch modes)
  -Operator: Perform addition, subtraction, multiplication and division! (interact to switch modes)
  -Memory Cell: Store numeric data. The bottom nodes are for data input and output, the top nodes are used to lock input or output
  -Binarizer: A simple passthrough which strips numerical data from a binary signal. This can be useful when connecting devices that use both numeric and binary data (sensors, comparators, counters)
-Tile Manipulation!
  -Freeform Survey Markers define areas for Layer Swappers or Block Scanners
  -Layer Swapper switches background and foreground blocks in a defined area
  -Block Scanner reads blocks in a defined area
  -Block Printer prints scanned blocks
-Source Pipes: Used to create water, poison, or lava when powered
-Quick Wall Button: A version of the default Small Wall Button which can be pressed rapidly - useful for incrementing Counters
-Wired Target (experimental): Triggers wires and turns temporarily solid when hit by projectiles
-Improvements to a few of the vanilla wire objects

USAGE
-Sparkz recipes are crafted from the Wiring Station or a Tabula Rasa
-WIP documentation for individual Sparkz objects can be found at http://community.playstarbound.com/index.php?resources/sparkz.117/

SUGGESTED MODS (for Creative release only)
-Tabula Rasa http://community.playstarbound.com/index.php?resources/the-tabula-rasa.114/

INSTALLATION
Place the /sparkz/ folder in your starbound /mods/ folder. That is all.

CREDITS/ACKNOWLEDGEMENTS
-Many scripts and assets taken with or without modification from the Starbound base assets. Much of the credit for this mod goes to the excellent development team at Chucklefish
-Thanks to leosky for testing!

VERSION HISTORY

v2.1
-Added Freeform Survey Marker - define an arbitrary area of adjacent tiles for Block Scanners or Layer Swappers
    -can also store areas in Memory Cells
-Added Layer Swapper - set an area with Survey Markers, then activate to reverse the foreground and background tiles in that area. Make secret doors, trap platforms, or all kinds of things! This device should reliably conserve (not create or destroy) blocks for 'survival' play.
-Added Block Scanner - set an area with Survey Markers, then activate to scan the foreground and background tiles and send the data to a Block Printer for printing
    -can also store print data in Memory Cells
-Added Block Printer - use scanned data to reproduce structures! This device (obviously) creates blocks and is not balanced for 'survival' play.
-Removed traps - these are better implemented by other mods and didn't really fit the focus
-Made Creative release the default, with Survival release optional

v2.0
-Added "Data Wire" functionality - send numbers over wires!
    -Displays, Sensors (4 types), Scanner, Counter, Comparator, Operator, Memory Cell, Binarizer
-Added Traps (3 types)
-Added a Quick Wall Button
-Added Wired Target (WIP)
-Improvements to a few vanilla wired objects
-Removed a number of objects which have been added to the vanilla game
-Many small (and large) changes and reworks

v1.1
-Added .modinfo file
-Made Wiring Station also a wired object, with two inputs to turn on bulbs

v1.0
-New graphics for Wiring Station and Wire Tool
-Added Water, Lava, and Poison Source Pipes
-Added Drain
-Added Light Sensor

v0.9
-Added Alarm
-Created alternate Wire Tool to avoid overwriting default
-Included some content from Logic 101

LICENSE

Copyright (c) 2013 Alex Lawson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.