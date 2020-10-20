# drone
Control a quadcopter robot

The request was made to write controlling software for a quadcopter drone.  This repo is not a fully functioning system, but more of a demonstration of how to approach this task.

## BACKGROUND
### How it moves
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

### Roll, Pitch and Yaw
Imagine three lines running through an airplane and intersecting at right angles at the airplane’s center of gravity.

- Rotation around the front-to-back axis is called roll.
- Rotation around the side-to-side axis is called pitch.
- Rotation around the vertical axis is called yaw.

## OUR DRONE
- 4 motors
- 1 Gyroscope (3 vectors x,y,z that provide velocity in each direction)
- 1 Orientation sensor (provides pitch and roll)
- Each motor has a power indicator from 0 to 100
- Motor status (on, off)
- drone status (off, hovering, moving)

### To Simplify
- Pitch is aligned to the x axis

### FUNCTIONS:

|  function    | Performed By                                                       |
| ----------   | ------------------------------------------------------------------ |
| take_off     | increase speed of all rotors while maintaining while staying level |
| rotate left  | increase speed of the two CW turning engines                       |
| rotate right | increase speed of the two CCW turning engines                      |
| move forward | increase speed of back motor and lower speed of front motor        |
| move left    | increase speed of two CW turning motors                            |
| move right   | increase speed of two CCW turning motors                           |
| move back    | increase speed of front motor, decrease speed of back motor        |
| move forward | increase speed of back motor and lower speed of front motor        |
| stabilize    | set all motors to same speed                                       |
| status       | return current roll, pitch and yaw                                 |
| land         | stabilize and slowly lower to ground                               |

## IMPLEMENTATION

The controller cannot blindly send commands to the drone.  Realworld external forces act upon the craft so it's not a perfect world.  As opposed to performing complicated calculations connecting power, weight, blade spin rates, gravity, etc, a feedback loop is implemented that compares the requested command (target) with the input from the sensors.  This is called the PID process (Proportional, Integral, Differential). It rapidly re-estimates the current best guess output.

### PID

The PID class is fed “target” value and an
“input” value. The difference between these is the
“error”. The PID processes this “error” and produces
an “output” which aims to shrink the difference
between the “target” and “input” to zero. It does this
repeatedly, constantly updating the “output”.

The “P” of PID stands for proportional – each time the
PID is called its “output” is just some factor times the
“error” – in a quadcopter context, this corrects
immediate problems and is the direct approach to
keeping the absolute “error” to zero.

The “I ” of PID stands for integral – each time the PID
is called the “error” is added to a grand total of errors
to produce an output with the intent that over time,
the total “error” remains at zero – in a quadcopter
context, this aims to produce long term stability by
dealing with problems like imbalance in the physical
frame, motor and blade power plus wind.

The “D” of PID stands for differential – each time the
PID is called the difference in error since last time is
used to generate the output – if the “error” is worse
than last time, the PID “D” output is higher. This aims
to produce a predictive approach to error correction.
The results of all three are added together to give an
overall output and then, depending on the purpose of
the PID, applied to each of the motors appropriately.
