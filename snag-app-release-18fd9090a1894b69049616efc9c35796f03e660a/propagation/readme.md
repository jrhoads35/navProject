# Propagation

Orbit propagation gives the position and velocity of a satellite at any time (assuming no maneuvers) given information about its orbital [state](ephemeris.md) at a different time, the _epoch_ time. The epoch time usually earlier than the propagated time, but it is not required to be. The orbital [state](ephemeris.md) at epoch may be specified as Cartesian positions and velocities.

The function `propagate()` creates an [ephemeris](ephemeris.md) table from an initial state over a requested time span with fixed steps of time. For event-related ephemeris computation, see [eclipse](#eclipse) or [visibility](#visibility).

## Input

There are two required arguments, and four optional arguments.

| Argument name  | Description                                                                                        |
|----------------|----------------------------------------------------------------------------------------------------|
| `orbit`        | [initial (or final) state](#initial-state)                                                         |
| `tstart`       | starting time of propagation; see below for details                                                |
| `tend`         | ending time; see below for details (optional, defaults to 1 second after `tstart`)                 |
| `step_size`    | a duration (e.g., `minutes(1)`), or a number of seconds; defaults to 1 second                      |
| `force_model`  | force model parameters from [`force_model()`](#force-model), defaults to `constants.force_twobody` |
| `acceleration` | whether to include accelerations, boolean (`true` or `false`, default `false`)                     |

The times specified in the second, third, and fourth arguments are described in [the next section](#initial-state). The fifth argument is optional and defaults to the two-body force model. For orbits from [space-track.org](spacetrack.md) and other two-line elements, the SGP4 propagator is used and this argument is ignored. The last argument is optional and specifies whether accelerations should be included in the output (default is `false`).

## Initial state

The initial state is specified by creating an orbital state, as one of

1. [orbital element set](elements.md),
1. a Cartesian [state](ephemeris.md), or a
1. [space-track orbit](spacetrack.md).

This is specified in the `orbit` argument in the input to the propagation functions.

## Times

There are three times that are entered in each propagation function. If either or both of `tstart` and `tend` are a [datetime](datetime.md), then those values are used as the start or end of the propagation, respectively. If either is the logical value `true`, then the epoch is used -- obviously, it makes no sense to use `true` for both values. If a [duration](datetime.md) is used for either value, then that time interval is added to `tstart` (if specified for `tend`), or subtracted from `tend` (if specified for `tstart`). Thus `tstart = true`, `tend = hours(3)` will propagate from epoch to 3 hours after epoch, and `tstart = hours(3)`, `tend = true` will propagate from 3 hours before epoch to epoch.

As a substitute for `true`, either value may be specified as a [unit of time](https://www.mathworks.com/help/matlab/ref/datetime.dateshift.html#bugc7jv-1-unit), such as `'minute'`, and the time used will be the start of the next even amount of that unit after epoch. For example, if the epoch is `2021-12-24 09:09:59.999616`, specifying `'minute'` will give `2021-12-24 09:10:00.000000`. This can be useful when trying to synchronize orbits with different epoch times, as each step will be on the even minute or hour.

The third time is a [duration](datetime.md) and gives the time interval between steps of the ephemeris. Alternatively, a number will be interpreted as the step size in seconds.

## Force model

The forces acting on a satellite are specified using the function `force_model()` with the maximum degree and order in the gravitational model (maximum 20 for each), drag area of the spacecraft (square meters), coefficient of drag, solar radiation pressure area of the spacecraft (square meters), coefficient of reflectivity, and spacecraft mass (kg). If no perturbation is desired other than geopotential, then only the first two arguments are required.

| Argument name                 | Description                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------------|
| `central_body_gravity_degree` | Gravitational force degree for earth                                                            |
| `central_body_gravity_order`  | Gravitational force order for earth                                                             |
| `drag_area_m2`                | Area cross section to velocity relative to atmosphere, meter^2                                  |
| `drag_coef`                   | Drag coefficient                                                                                |
| `srp_area_m2`                 | Area cross section to sun direction, meter^2                                                    |
| `reflectivity_coef`           | Coefficient of reflectivity                                                                     |
| `spacecraft_mass_kg`          | Mass of spacecraft in kg                                                                        |
| `sun_gravity`                 | Include third body force of sun,`true` or `false` (optional, default `false`)                   |
| `moon_gravity`                | Include third body force of moon,`true` or `false` (optional, default `false`)                  |
| `ocean_tides`                 | Array [degree order] (or `false`) of ocean tide gravitational force (optional, default `false`) |
| `sun_solid_tides`             | Include sun solid tides, `true` or `false` (optional, default `false`)                          |
| `moon_solid_tides`            | Include moon solid tides, `true` or `false` (optional, default `false`)                         |
| `general_relativity`          | Include general relativity effects `true` or `false` (optional, default `false`)                |

For example, create 20 x 20 geopotential force model with no other perturbations
```` matlab
	force_20x20 = force_model(20, 20)
````
Create 20 x 20 geopotential force model with atmospheric drag perturbation
```` matlab
	force_20x20_cd22 = force_model(20, 20, 1.0, 2.2, 0, 0, 1000)
````
The two-body gravitational force for Keplerian motion is pre-defined as `constants.force_twobody`.

## Output

The output of the propagator is a timetable with five columns, each with the same number of rows, which correspond to timesteps. The output quantities are

| Variable name | Description                                                   |
| ------------- | -----------                                                   |
| `position_m`  | The ECI position 3-vectors in meters of the satellite.        |
| `velocity_ms` | The ECI velocity 3-vectors in meters/second of the satellite. |
| `time`        | The datetimes for each step.                                  |
| `elapsed_s`   | The time (seconds) elapsed from the initial step.             |
| `deltat_s`    | The time (seconds) elapsed from the previous step.            |


## Examples

### Kepler orbital elements

	kex1.els = kepler_oes(nowutc, 1.0e7, 0.1, 62.0, 82, 221, 45)
	kex1.twobody = propagate(kex1.els, true, hours(1), minutes(1))
	force_20x20_cd22 = force_model(20, 20, 1.0, 2.2, 0, 0, 1000)
	kex1.d20o20 = propagate(kex1.els, true, hours(1), minutes(1),force_20x20_cd22)
	force_20x20_cd22_lunisolar = force_model(20, 20, 1.0, 2.2, 0, 0, 1000, true, true)
	kex1.ls = propagate(kex1.els, true, hours(1), minutes(1),force_20x20_cd22_lunisolar)

Over the hour of the orbit, the difference in position between the position and velocity of the 20x20 model and two body may be compare [compared](ephemeris#ephemeris-functions)

	pvmag(pvdiff(kex1.d20o20, kex1.twobody))

and the difference between the 20x20 model with and without lunisolar perturbation may be compared

	pvmag(pvdiff(kex1.ls, kex1.d20o20))

### Spacetrack orbit

Propagation

	mms1.orbit = spacetrack_orbit(40482);
	mms1.ephem = propagate(mms1.orbit, true, days(2), minutes(30))

<!-- Recommend to use ephemeris_interp
### Propagation to a set of times
To propagate to a specific set of times that are not necessarily at regular intervals, use the function `propagate_to_times`. The inputs are

| Argument name | Description                             |
| ------------- | -----------                             |
| `orbit`       | A Cartesian [state](ephemeris.md)       |
| `times`       | An array of [datetimes](datetime.md)    |
| `force_model` | A structure with force model parameters |

The results is an [ephemeris](ephemeris.md) with the state at each of the times.
-->

## Eclipse
The function `eclipse()` will find transitions from full sunlight to partial shadow (penumbra), from partial shadow to full eclipse (umbra), and the opposite transitions.

### Input

There are four arguments.

| Argument name | Description                                                                                        |
|---------------|----------------------------------------------------------------------------------------------------|
| `orbit`       | An orbit specification.                                                                            |
| `start_dttm`  | A [datetime](datetime.md) with the starting time (= the epoch of the elements), made by `datetime` |
| `end_dttm`    | A [datetime](datetime.md) datetime with the ending time, made by `datetime`                        |
| `force_model` | A structure with force model parameters returned by `force_model()`                                |

There are two [times](#times); no step size is specified. The final argument is optional and defaults to the two-body force model. For two-line elements, the SGP4 propagator is used and this argument is ignored.

### Output

The Output is a structure with five fields; all are arrays with one rows for each event.

| Argument name | Description                                                    |
|---------------|----------------------------------------------------------------|
| `event`       | Name of the event, such as `'penumbra_in'`, `'umbra_in'`, etc. |
| `positions`   | ECI position (meters) of the satellite at the event.           |
| `velocities`  | ECI velocity (meters/second) of the satellite at the event.    |
| `times`       | Datetime (UTC) at which the event occured.                     |
| `elapsed`     | Elapsed time in seconds from the starting time `start_dttm`.   |

## Visibility

The `visibility()` function will find, for one or more observation sites, all the times within a specified range that the visibility of one object changes. To specify multiple sites, pass an array of sites as the `sites` argument, e.g. `[site1 site2]`.

### Input

There are five arguments.

| Argument name | Description                                                                                               |
|---------------|-----------------------------------------------------------------------------------------------------------|
| `orbit`       | An initial orbit specification.                                                                           |
| `start_dttm`  | A [datetime](datetime.md) with the starting time (= the epoch of the elements), made by `datetime`.       |
| `end_dttm`    | A [datetime](datetime.md) with the ending time, made by `datetime`.                                       |
| `sites`       | An observation site or array of sites, each generated by [`geoloc()`](location.md#geographic) `geoloc()`. |
| `force_model` | A structure with force model parameters returned by `force_model()`.                                      |

There are two [times](#times); no step size is specified. The final argument is optional and defaults to the two-body force model. For two-line elements, the SGP4 propagator is used and this argument is ignored.

See a space-track [example](#example).

### Output

The output is a structure array, one for each site, with three fields

| Argument name        | Description                                                                                              |
| -------------        | -----------                                                                                              |
| `name`               | The name given to the observation site.                                                                   |
| `always_visible`     | The object was visible for the entire time between `start_dttm` and `end_ddtm`. The `visibility_changes` array will be empty if this is `true`. |
| `never_visible`      | The object was never visible for the entire time between `start_dttm` and `end_ddtm`. The `visibility_changes` array will be empty if this is `true`. |
| `visibility_changes` | A structure with each visibility change, described next.                                                 |

The `visibility_changes` is a timetable with six columns describing the visibility change events; each row of the structure array corresponds to one event.

| Argument name | Description                                                                                      |
|---------------|--------------------------------------------------------------------------------------------------|
| `event`       | Name of the change, either `'aos'` if the object became visible, `'los'` if visibility was lost. |
| `position_m`  | ECI position (meters) of the satellite at the event.                                             |
| `velocity_ms` | ECI velocity (meters/second) of the satellite at the event.                                      |
| `times`       | Datetime (UTC) at which the event occured.                                                       |
| `elapsed_s`   | Elapsed time in seconds from the starting time `start_dttm`.                                     |
| `deltat_s`    | Elapsed time in seconds from the previous event, or `start_dttm` for the first event.            |

### Example

Visiblity calculation of Iridium 152 from Ohio State University with a minimum elevation angle of 5 degrees

    iridium152.orbit = spacetrack_orbit(43479);
	site_osu = geoloc(40.0000, -83.0219, 400, "OSU", 5);
	iridium152.vis_osu = visibility(iridium152.orbit, true, days(1), site_osu);
	% To see the visilibity changes with position and velocity at those times
	iridium152.vis_osu.visibility_changes
	% Just show times and events
	nopv(iridium152.vis_osu.visibility_changes)
	ans =
	9x3 timetable
              epoch               elapsed_s        deltat_s        event
    __________________________    _________    ________________    _____
    2022-09-29 13:05:52.427000            0                   0    "aos"
    2022-09-29 13:17:29.707000       697.28              697.28    "los"
    2022-09-30 00:21:01.725000    40509.298           39812.018    "aos"
    2022-09-30 00:33:19.820000    41247.393    738.094999999994    "los"
    2022-09-30 02:03:26.282000    46653.855    5406.46200000001    "aos"
    2022-09-30 02:13:05.266000    47232.839    578.983999999997    "los"
    2022-09-30 10:52:35.840000    78403.413           31170.574    "aos"
    2022-09-30 11:01:37.273000    78944.846    541.433000000005    "los"
    2022-09-30 12:32:05.148000    84372.721            5427.875    "aos"

## Syncronize

One or multiple orbits can be propagated to a common time with the function `sync()`.

| Argument name | Description                                                                           |
|---------------|---------------------------------------------------------------------------------------|
| `orbits`      | A single orbit or column vector of orbits                                             |
| `totime`      | A [datetime](datetime.md) to which all orbits will be propagated                      |
| `force_model` | force model parameters from [`force_model()`](#force-model), defaults to `constants.force_twobody`|
| `acceleration` | whether to include accelerations, boolean (`true` or `false`, default `false`)|

The orbit(s) may be specified in any form acceptable to [`propagate()`](propagation.md#initial-state). If any have an additional field `force_model` generated by [`force_model()`](#force-model), the propagation for that orbit will use that force model. Otherwise, the third argument `force_model` is used. For space-track orbits, the force model is always ignored.

Output is a single structure array of (PVTs)[ephemeris.md]. If any propagations resulted in error, for example, if an orbit initial epoch was later than `totime`, then both `position_m` and `velocity_ms` are at the origin, `[0 0 0]`.
If a single orbit is supplied, the function returns a single PVT at the requested time.

See [example](conjunction.md#example).


[//]: # (Copyright 2020, 2021, 2022 Liam M. Healy)
