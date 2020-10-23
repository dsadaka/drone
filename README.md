# Drone Control
#### Control a quadcopter robot


The request was made to write controlling software for a quadcopter drone.  Since this code was not written to control any specific hardware, it is not fully a functional system, but more of a demonstration of how to approach this task.  Further down, this README describes how a real controller could be implemented.

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
- roll is aligned to the y axis

### FUNCTIONS:

|  function    | Performed By                                                       |
| ----------   | ------------------------------------------------------------------ |
| take_off     | increase speed of all rotors while maintaining while staying level |
| rotate left  | increase speed of the two CW turning engines                       |
| rotate right | increase speed of the two CCW turning engines                      |
| move left    | increase speed of two CW turning motors                            |
| move right   | increase speed of two CCW turning motors                           |
| move back    | increase speed of front motor, decrease speed of back motor        |
| move forward | increase speed of back motor and lower speed of front motor        |
| stabilize    | set all motors to same speed                                       |
| status       | return current status off, hovering, moving, takeoff               |
| land         | stabilize and slowly lower to ground                               |
| tap          | simulates a hand tap.  The drone attempts to restabilize           |
| break_engine | simulates a failed engine.  Error prints on server and drone langs |

### USAGE

Dependencies:  ruby >= 2.5

Open first terminal window and enter the following commands

1. git@github.com:dsadaka/drone.git       # Clone this repo to a new directory
2. cd drone
3. gem install drone-0.1.0.gem
4. drone server                           # Start server (simulates drone)

Open second terminal window

1. cd <directory created above>
2. drone console
     You should see "Ready to receive drone commands. Type "exit" to quit.
     Enter connect to connect to server
     You should see Ready to fly!
     Now enter any of the functions listed above, starting with "take_off"
     
     Successful command will return a true status (in blue)
     Errors return a red message.  Ex:  Trying to take_off when you're already flying
     The current state of the drone is also displayed.
     
     You can also keep an eye on the server terminal window for log output and distress signals.

#### Have fun!
## IMPLEMENTATION

The controller cannot blindly send commands to the drone.  In the real world, external forces act upon the craft.  As opposed to performing complicated calculations connecting power, weight, blade spin rates, gravity, etc, a feedback loop is implemented that compares the requested command (target) with the input from the sensors.  This is called the PID process (Proportional, Integral, Differential). It rapidly re-estimates the current best guess output.

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

### SENSORS

The input referred to above comes from two sensors: gyroscope and accelerometer.  

#### Gyroscope
A gyroscope rotor spins and maintains it's position within a "cage", as the vehicle moves (rolls, pitches, yaws) around the cage, the gyro "senses" this movement.  It can then output the rate of rotation, degree of tilt, and angular velocity of the drone. Our simplifed gyroscope simply outputs 3 velocity vectors (x, y and z).  These vectors go to zero when the drone stops rotating.  Gyroscopes, however, cannot detect linear movement.

#### Orientation Sensor 
Most modern day drones use an inertial measurement unit (IMU) to provide orientation. It ensures that the drone maintains its orientation towards the ground by itself and does not drift.  This device combines a gyro, accelerometer and magnetometer (and/or GPS) to determine orientation and velocity vector relative to the earth.  Each of these components have the their strengths and weaknesses but the IMU is smart enough to use their respective strengths to overcome these weaknesses.
