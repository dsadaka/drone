# drone
Control a quadcopter robot

The request was made to write controlling software for a quadcopter drone.  This repo is not a fully functioning system, but more of a demonstration of how to approach this task.

## BACKGROUND
A Quadcopter employs 4 motors with propellers, 2 spinning clockwise (CW) and 2 spinning counter-clockwise (CCW).  Rotor pairs spinning in the same direction are at diagonals from each other.  Each motor has an Electronic Speed Control (ESC) pin.  Applying voltage to the pin changes the speed.
```
     Front
     
       O CCW
       |
 CW O--+--O CW
       |
       O CCW
 
      Back
```      

## WHAT ARE ROLL, PITCH, AND YAW?
Imagine three lines running through an airplane and intersecting at right angles at the airplane’s center of gravity.

- Rotation around the front-to-back axis is called roll.
- Rotation around the side-to-side axis is called pitch.
- Rotation around the vertical axis is called yaw.

## FUNCTIONS:

|  function    | Performed By                                                       |
| ----------   | ------------------------------------------------------------------ |
| take_off     | increase speed of all rotors while maintaining while staying level |
| move forward | increase speed of back motor and lower speed of front motor        |
| move left    | increase speed of two CW turning motors                            |
| move right   | increase speed of two CCW turning motors                           |
| move back    | increase speed of front motor, decrease speed of back motor        |
| move forward | increase speed of back motor and lower speed of front motor        |
| stabilize    | set all motors to same speed                                       |
| status       | return current roll, pitch and yaw                                 |
| land         | stabilize and slowly lower to ground                               |
