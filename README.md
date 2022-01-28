# Tracking Celestial Bodies with 8086 Microprocessor
(Project for the course CSE2006 Microprocessors and Interfacing)

## Abstract
The main application of this project is in a telescope. This project uses 2 stepper motors to change the azimuth and elevation values to locate the sun with a telescope. Stepper motor is a device used to obtain an accurate position control of rotating shafts.

The motor can be half stepped by turning on pair of magnets, followed by a single and so on.
The motor can be full stepped by turning on pair of magnets, followed by another pair of magnets and in the end followed by a single magnet and so on. The best way to make full step is to make two half steps.

An azimuth is an angular measurement in a spherical coordinate system.
These values will help to locate the sun at a particular time, year and latitude.
The horizontal coordinate varies by day, year and latitude so we need the coordinates in the equatorial system which tells us the exact position of the Sun in space. This position is independent of the point of observation.

## Proposed Model
Our model takes the Local Sidereal time of the observer’s location and calculates the azimuth and zenith values of the sun from the given equatorial coordinates. This way we can track sun precisely. We also proposed a second approach based on a graph derived from some research papers, this can be used in solar panels as they do not need precise coordinates of the sun to get maximum sun rays on their surfaces. This increases their efficiency.

## Block Diagram
![image](https://user-images.githubusercontent.com/67219127/151547770-1ef89b74-61a6-461b-ba31-324b27790d71.png)

## Implementation
### Calculations
Assumptions:

Observer’s latitude = φ (in degrees)

Local Sidereal Time = LST (hr, min, sec)

RA=α and declination=δ(of sun) (in hrs & degrees)

Azimuth=A and Altitude=a (in degrees)

Local Hour Angle H = LST - RA(sun), in hours

Altitude Calculation:    sin(a) = sin(δ) sin(φ) + cos(δ) cos(φ) cos(H)

Azimuth Calculation:    sin(A) = - sin(H) cos(δ) / cos(a)

Providing LST throughout the day we can track sun every time with the help of Azimuth and Altitude angle.

### Working
The equatorial coordinates of any celestial body are fixed. We propose to use these coordinates and the latitude value of observer’s location to find the precise azimuth and zenith values of the sun. This is calculated using a series of formulae.

Stepper motor is a device used to obtain an accurate position control of rotating shafts.
The motor can be half stepped by turning on pair of magnets, followed by a single and so on.
The motor can be full stepped by turning on pair of magnets, followed by another pair of magnets and in the end followed by a single magnet and so on. The best way to make full step is to make two half steps.

# Tables and Graphs
## Approach 1
Table for stepper motor angles:
![image](https://user-images.githubusercontent.com/67219127/151548167-1f79f9ba-2439-4445-bc67-7f6b4cb1bac4.png)

## Approach 2
![image](https://user-images.githubusercontent.com/67219127/151548243-bd6276eb-cabc-468a-a4bd-82b2184a2544.png)
This graph is fairly linear. This was derived from research papers. 
We referred to it for making the following table:
![image](https://user-images.githubusercontent.com/67219127/151548268-3c8b3163-cdf8-4585-bcf6-2ef590391b56.png)

# Conclusion
Working with floating points and trigonometric equations has been a major diffculty.
High approximations have been made at some points.
Satisfactory results are obtained.

Approach 1 can be used in telescopes since it includes astronomical calculations.
Approach 2 is simpler and based on conclusions from various research papers, this can be used in solar panels.


