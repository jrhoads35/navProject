# Locations and conversion functions

## Specification of locations

Locations of observers and satellites are usually specified in one of three frames.

### Inertial (ECI)

See [State and ephemeris](ephemeris.md) for the use of `pvt()`, which optionally includes a velocity that is unneeded to specify a location.

### Geographic

A geographic (ECEF) position `lla` in earth-centered earth-fixed spherical polar coordinates is made with`geoloc()`. This is typically how geographic positions or "site vectors", such as the locations of telescopes and radars, are specified. See [Frame conversion](#frame-conversion) for creation of these vectors.

`geoloc(latitude_deg, longitude_deg, altitude_m, epoch_or_name, minimum_elevation_deg)`

| Argument name           | Description                                                                  |
|-------------------------|------------------------------------------------------------------------------|
| `latitude_deg`          | Latitude in degrees                                                          |
| `longitude_deg`         | Longitude in degrees                                                         |
| `altitude_m`            | Altitude above the earth ellipsoid (sea level) in meters                     |
| `epoch_or_name`         | If a [datetime](datetime.md), define the epoch time associated with the location; otherwise, the name of the site used for [observation stations](observations.md#observation-station) and [visibility](propagation.md#visibility)            |
| `minimum_elevation_deg` | The minimum elevation in degrees that the site can see (optional, default=0) |

To make an object without an epoch or name, pass `[]` in the fourth argument. If an epoch is not defined on a geoloc, it can be set later with [`setepoch()`](datetime.md#set-epoch).

Example: College Park, Maryland now

	umd_noname = geoloc(38.988933, -76.937115, 42, nowutc)

Alternatively, give the site a name and specify a minimum elevation angle

    umd = geoloc(38.988933, -76.937115, 42, "UMd", 10)
	umd = setepoch(nowutc, umd)

To show a geographic location on a map, use the function `showmap(`_lla_`)`; for example, `showmap(umd)`. This requires the GeoHack service and an internet connection.

### Observations

Topocentric horizon `aer`: Topocentric horizon spherical polar coordinates, a structure made with the function `azelrn_deg (azimuth_deg, elevation_deg, range_m)`

| Argument name   | Description                                     |
|-----------------|-------------------------------------------------|
| `azimuth_deg`   | Azimuth (angle clockwise from north) in degrees |
| `elevation_deg` | Elevation (angle above horizontal) in degrees   |
| `range_m`       | Distance from origin to point in meters         |

All functions involving topocentric horizon coordinates take an additional argument which specifies the geographic location representing the origin, as an [`lla`](#geographic-ecef).

## Frame conversion
### Location conversion
With (PVT) or without (PT) a velocity, the [location](location.md) can be expressed in several coordinate systems.
These functions convert locations from one reference frame to the one named in the function.

1. `eci(location, observer_lla)`
1. `lla(location, observer_lla)`
1. `aer(location, observer_lla)`

In each case, `location` can be any of the location forms. Since all the conversion functions involve a coordinate system that is time-dependent (only `eci` is time-independent), the `location` must have an `epoch` field, which is a Matlab `datetime`. If either the input or output form is `aer`, the second argument is the observer location `lla`; if not, the second argument should not be present.

To make site vectors, the first argument to `eci()` (or `lla()`) should be a [date and time](datetime.md) or a vector of them, rather than the location, and the second argument should be the location. For example, College Park every minute for the next 11 minutes,

    umd = geoloc(38.988933, -76.937115, 42, "UMd", 10)
	cpsite = eci(nowutc:minutes(1):nowutc+minutes(10),umd)

This will create a timetable of site vectors.

### Right ascension and declination

The spherical polar form of inertial coordinates, right ascension and declination, can be converted to and from the Cartesian form with the functions `eci()`  and `radec()`.

1. The function `radec()` will convert an ephemeris or position (PVT with or without velocity) to right ascension, declination, and geocentric radial distance.

1. The function `eci()` will convert directions or locations in azimuth, elevation, and optionally range (default is 1) to ECI. The range is given as a second value. Example converting angles to the sun line-of-sight vector,

		> sundir = body_radec(10, nowutc, nowutc+hours(3))
		sundir =
		  4x3 timetable
		              epoch               right_ascension_deg    declination_deg    solar_phase_deg
		    __________________________    ___________________    _______________    _______________
		    2022-12-26 17:03:00.000000         274.99076            -23.35718              0
		    2022-12-26 18:03:00.000000         275.03699            -23.35571              0
		    2022-12-26 19:03:00.000000         275.08321            -23.35422              0
		    2022-12-26 20:03:00.000000         275.12943            -23.35271              0
        > eci(sundir)
		  ans =
		    4x1 timetable
		                epoch                                         position_m
		      __________________________    ______________________________________________________________
		      2022-12-26 17:03:00.000000    0.0798659419637369    -0.914570607677516    -0.396461895882346
		      2022-12-26 18:03:00.000000    0.0806047445942082    -0.914516001065947    -0.396438341918704
		      2022-12-26 19:03:00.000000     0.081343363702286    -0.914460949059606    -0.396414467226667
		      2022-12-26 20:03:00.000000    0.0820819587586906    -0.914405437687387    -0.396390271795455

## Extraction from a timetable of locations

To extract a particular location from a timetable of locations, use the function

	loc1(table, select)

where `table` is the timetable, and `select` is either a datetime matching one epoch in the table, or a sequence number in the table. This will produce a structure with `epoch` and any fields related with a complete location specification.

## Examples
All examples are for August 1, 2020 at 00:30 UTC.

* Observation example 1 is an observation at azimuth 255 deg, elevation 45 deg, distance 1000km from the University of Maryland; convert to geographic coordinates (lla) and then convert back to topocentric horizon (aer) to check

		umd = geoloc(38.988933, -76.937115, 42, "UMd", 10)
		ob1xmpl.aer = setepoch(datetime(2020, 08, 01, 00, 30, 00, 000),azelrn_deg(255, 45, 1e6))
		ob1xmpl.eci = eci(ob1xmpl.aer, umd)
		ob1xmpl.aer_from_eci = aer(ob1xmpl.eci, umd)
		ob1xmpl.eci
		  struct with fields:
		     epoch: 01-Aug-2020 00:30:00
		     position_m: [-3367065.24660057 -4555956.54388823 4300666.48484924]
		ob1xmpl.aer_from_eci
		  struct with fields:
		     azimuth_rdn: 4.45058959258555
		     azimuth_deg: 255.000000000001
		   elevation_rdn: 0.785398163397443
		   elevation_deg: 44.9999999999997
		     range_m: 1000000
		     epoch: 01-Aug-2020 00:30:00

* Site vector of the University of Maryland, then compute the geographic location from the ECI coordinates

		sv1xmpl.lla.epoch = setepoch(datetime(2020, 08, 01, 00, 30, 00, 000),umd)
		sv1xmpl.eci = eci(sv1xmpl.lla.epoch)
		sv1xmpl.lla_from_eci = lla(sv1xmpl.eci)
		sv1xmpl.lla
		   struct with fields:
		      latitude_rdn: 0.68048525268947
		      latitude_deg: 38.988933
		     longitude_rdn: -1.34280597373552
		     longitude_deg: -76.937115
		        altitude_m: 42
		             epoch: 01-Aug-2020 00:30:00
		sv1xmpl.eci
		   struct with fields:
		     epoch: 01-Aug-2020 00:30:00
		     position_m: [-2445366.51501545 -4315586.72291133 3996209.92414163]
		sv1xmpl.lla_from_eci
		   struct with fields:
		    latitude_deg: 38.988933
		    latitude_rdn: 0.68048525268947
		   longitude_deg: -76.937115
		   longitude_rdn: -1.34280597373552
		      altitude_m: 42.000000003947
		           epoch: 01-Aug-2020 00:30:00
