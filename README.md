# MegaMachine Tetris
Simple Tetris game written for the GameBoy MegaMachine by Look Mum No Computer.

- Code is written to run as a Processing sketch using the MidiBus library.
- Displays a debug screen on the computer of the expected midi matrix output.
- *Make sure to update the midi constants to whatever your midi output device is and the desired channel for the midi display matrix.*
- Midi 6x8 matrix ranges from the notes 36 to 60 on channel 16. _Note On_ (aka backlight on) commands are sent at 64 velocity and _Note Off_ (aka backlight off) commands are sent at 0 velocity.

## Controls
- Left and right arrow keys move your tetromino (tetris piece) left and right.
- The up arrow key rotates the tetromino 90 degrees clockwise.
- The down arrow key immediately drops the tetromino as far down as it can go.
- Press the enter key or space on the start screen to begin the game.

## Notes
There are a number of small bugs in the game, but it should play through either way. Also, because of how small the height of the MegaMachine matrix is, it's pretty damn hard to play. But hey, there's no score keeping, so who cares as long as you have fun!

## TODO

- Convert this code to run from an Arduino with hardware Midi implementation and a joystick controller.
