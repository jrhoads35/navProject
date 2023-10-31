# State and Ephemeris

## Creation of a position-velocity-time (PVT)

A (Cartesian) _orbital state_ (or simply _state_, also sometimes known as "PVT" for position, velocity and time) is an epoch time, position 3-vector, and velocity 3-vector. It is made by the function

   `pvt(epoch, position_or_posvel, velocity_ms)`

   where

   * `epoch` is a [datetime](datetime.md)
   * `position_or_posvel` is a 3-vector or a 6-vector. If a 3-vector `[x; y; z]`, it is the position Cartesian coordinates in meters; the first is the component in the direction of the vernal equinox and the third is the north pole direction. The magnitude of this vector is checked and an error will result if it is less than the radius of the earth. The most common cause of this error is the use of kilometers instead of meters. If a 6-vector, the first three components are the position as described, and the second three components are as described for the third argument.
   * `velocity_ms` is the velocity in meters/second in the same coordinate frame as the position. The magnitude of this vector is checked and an error will result if it is less than 100 meters/second. The most common cause of this error is the use of kilometers/second instead of meters/second. This argument need not be specified if `position_or_posvel` is a 6-vector, or if the velocity is unneeded (and then the result represents only a [location](location.md) and not a state).

An _ephemeris_ is a [timetable](timetable.md) of orbital states.

## Definitions and representation in Matlab

A collection of states referring to one satellite, in time order, is an _ephemeris_. These are represented as Matlab timetables that have colums `epoch` (a [datetime](datetime.md)), `position_m` with position in meters, and `velocity_ms` with velocity in meters/second; it may have other fields as well. They can be converted to a structure with the three fields, each an array with the same number of rows, using the function `epochstruct`.

An example showing the International Space Station ephemeris as a timetable `iss.ephem` and as a structure array `iss.ephst`
```
     iss.orbit = spacetrack_orbit(25544)
     iss.ephem = propagate(iss.orbit, hours(2), minutes(10), true)
     iss.ephst = epochstruct(iss.ephem)
```

## Ephemeris functions
### Position and velocity from a PVT or ephemeris

1. `pos()` finds the position vector(s) from the argument.
1. `vel()` finds the velocity vector(s) from the argument, if they exist.


### General

1. `pvt1(ephemeris, select)`  Select a single PVT (row) from an ephemeris timetable by epoch or index sequence; `select` is a [datetime](datetime.md) that occurs in one row, or an index (row number)
1. `join_ephemeris(ephem1, ephem2)` Create a single ephemeris table for two ephemeris tables with common times
1. `pvdiff(ephem1, ephem2)` Make a timetable of position and (if present) velocity vector differences from  two ephemerides; also works on a single PVT. For example, see [Kepler propagation](propagation.md#kepler-orbital-elements).
1. `pvmag(ephem)` Make a timetable of the magnitudes of position and velocity vectors or their vector differences; also works on a single PVT. For example, see [Kepler propagation](propagation.md#kepler-orbital-elements).
1. `ephemeris_interp(ephemeris, times)` Interpolate an ephemeris to the array of times specified in the second argument. The `times` may come, for example, from the `.epoch` variable of an [observations](observations.md#format) [timetable](timetable.md#select-column).



## Generate or use state or epehemeris

The following functions generate or use a state or ephemeris. This table lists only the inputs and outputs that are related to state or ephemeris; there will generally be others.

| Function                  | Input                    | Output            |
|---------------------------|--------------------------|-------------------|
| `propagate`               | `orbit` state            | ephemeris         |
| `visibility`              | `orbit` state            | ephemeris         |
| `eclipse`                 | `orbit` state            | ephemeris         |
| `determine_orbit`         | `initial_estimate` state | `estimated` state |
| `determine_orbit_results` |                          | `estimated` state |

<!-- | `propagate_to_times`      | `orbit` state            | ephemeris         | -->
