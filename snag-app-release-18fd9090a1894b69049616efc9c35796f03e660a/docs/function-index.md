# Functions

## Orbits

| Function                                    | Description                                                         | Example                                          |
|---------------------------------------------|---------------------------------------------------------------------|--------------------------------------------------|
| [`eclipse()`](propagation.md#eclipse)       | Table of satellite transitions in and out of penumbra and umbra     |                                                  |
| [`force_model()`](propagation.md#force-model)             | Define a force model to use in propagation | |
| [`propagate()`](propagation.md)             | Make an [ephemeris table](ephemeris.md) of time, position, velocity | [Kepler](propagation.md#kepler-orbital-elements), [space-track](propagation.md#spacetrack-orbit) |
| [`sync()`](propagation.md#synchronize)      | Synchronize one or multiple orbits to a common time                 | [Example](conjunction.md#example)                |
| [`visibility()`](propagation.md#visibility) | Table of one or more sites with line of sight to a satellite        |                                                  |

## Data

| Function                                              | Description                                                                           | Example                                          |
|-------------------------------------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------|
| [`body_radec()`](horizons.md#ephemeris)               | Solar system body directions from Horizons                                                     | [Sun](horizons.md#sun), [Moon](horizons.md#moon) |
| [`spacetrack_auth()`](spacetrack.md#user-credentials) | Authorize user with name and password                                                 | [Example](spacetrack.md#user-credentials)        |
| [`spacetrack_orbit()`](spacetrack.md)                 | Find an orbit or orbits from the [space-track](https://space-track.org) database from |                                                  |

## Utility

| Function                                                              | Description                                                         | Example                              |
|-----------------------------------------------------------------------|---------------------------------------------------------------------|--------------------------------------|
| [`aer()`](location.md#location-conversion)                            | Frame conversion to topocentric horizon azimuth-elevation-range     |                                      |
| [`convert_orbit()`](elements.md#orbital-elements-and-cartesian-eci)   | Convert orbital state between three kinds of elements and Cartesian | Same                                 |
| [`eci()`](location.md#location-conversion)                            | Frame conversion of location to earth-centered inertial             |                                      |
| [`from_tle()`](elements.md#spacetrack-or-two-line elements)           | Convert from spacetrack or two-line elements                        | Same                                 |
| [`geoloc()`](location.md#geographic)                                  | Create geographic location                                          | Same                                 |
| [`lla()`](location.md#location-conversion)                            | Frame conversion to geographic location                             |                                      |
| [`pos()`](ephemeris.md#position-and-velocity-from-a-pvt-or-ephemeris) | Position vector(s) from PVT or ephemeris                            |                                      |
| [`radec()`](location.md#right-ascension-and-declination)              | Find right ascension and declination angles from ECI Cartesian      |                                      |
| [`setepoch()`](datetime.md#set-epoch)                                 | Set or change the epoch                                             | [`geoloc()`](location.md#geographic) |
| [`to_tle()`](elements.md#spacetrack-or-two-line elements)             | Convert to spacetrack or two-line elements                          | Same                                 |
| [`vel()`](ephemeris.md#position-and-velocity-from-a-pvt-or-ephemeris) | Velocity vector(s) from PVT or ephemeris                            |                                      |
