# Observations

Observations of satellites can be made from a fixed location on the earth's surface, or from another spacecraft. Measurements in an observation may be of angles, such as from a telescope, or include range, such as a from a radar. These are observations of location; less commonly, rate of change, i.e., range rate, is observed, as from a Doppler radar.

Earth surface observations are given in topocentric coordinates, either topocentric horizon (east, north, up Cartesian coordinates or [azimuth, elevation, and range](location#observations) spherical polar coordinates), or topocentric equatorial, which are parallel to earth-centered inertial coordinates (topocentric right ascension and declination in spherical polar coordinates). The latter information typically comes from astronomical telescopes and therefore has no range.

SNaG-app is not capable of processing range rate or topocentric equatorial (right ascension and declination) coordinate observations.

## Observation station
Station locations from which observations are taken are made with [`geoloc()`](location.md#geographic). A name is required to identify the observation location in the output of [`determine_orbit()`](estimation.md#computation).

## Format
A set of observations are formatted as a [timetable](timetable.md) whose columns will depend on the type of observation; for example, azimuth and elevation observations will have columns `azimuth_deg` and `elevation_deg`. The time of the observation is a [`datetime`](datetime.md), and there may also be an `observation_number` column.

To get a set of times for observations, use the [`.epoch`](timetable.md#select-columns) timetable variable.

## Subsets of observations
It may be desirable to reduce an observation set to study the effect of certain observations on the estimate or to simplify the computational burden; see [how to select rows](timetable.md#select-rows).
