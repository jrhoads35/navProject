<!-- Copyright 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later -->
# Horizons

[Horizons](https://ssd.jpl.nasa.gov/horizons/) provides solar system data and ephemeris computation service. Access in SNaG-app is through a web API; no username or password is required.

## Ephemeris

The function `body_radec` provides an ephemeris of right ascension, declination and solar phase angle for major bodies, such as the sun, moon, and planets, as well as some major satellites. If an observer site is specified, the right ascension and declination are topocentric; if not, they are geocentric.

	body_radec(object, dt_begin, dt_end, step_interval, site)

| Argument name   | Description                                                                               |
|-----------------|-------------------------------------------------------------------------------------------|
| `object`        | Name or code of body                                                                      |
| `dt_begin`      | A [datetime](datetime.md) for the start of the ephemeris; optional, default is the next even minute                                  |
| `dt_end`        | A [datetime](datetime.md) for the end of the ephemeris; optional                                    |
| `step_interval` | Interval as a string, either as a Matlab duration or integer followed by unit "m"=minutes, "h"=hours, "d"=days; optional, default "1h"|
| `site`          | Site lla or string with name [_does not work_] or code; optional, default is earth center |

If the `object` is a string, and it is unique in the list of available objects, that will be used, and the identification code will be printed so it can be used in future calls (this will save time). If it is not unique, a list of possible matches is printed and the function returns empty. Use the identification code for the object desired. If it is a number, it is interpreted as a identification code.

If only two arguments are supplied, then the direction to the object is supplied for the single time `dt_begin`

## Examples

### Sun

The sun is id 10,

	>> body_radec("sun", datetime(2022,8,4,12,0,0), datetime(2022,8,4,20,0,0), hours(1))
	Body code is 10
	ans =
	  9x2 timetable
	             datetime             right_ascension_deg    declination_deg
	    __________________________    ___________________    _______________
	    2022-08-04 12:00:00.000000          134.2608            17.24748
	    2022-08-04 13:00:00.000000         134.30092             17.2364
	    2022-08-04 14:00:00.000000         134.34104            17.22531
	    2022-08-04 15:00:00.000000         134.38116            17.21422
	    2022-08-04 16:00:00.000000         134.42127            17.20312
	    2022-08-04 17:00:00.000000         134.46138            17.19201
	    2022-08-04 18:00:00.000000         134.50148            17.18089
	    2022-08-04 19:00:00.000000         134.54158            17.16976
	    2022-08-04 20:00:00.000000         134.58167            17.15863

This worked because "sun" is unique. Next time, use `10` to save time

    body_radec(10,datetime(2022,8,4,12,0,0), datetime(2022,8,4,20,0,0), hours(1))

To get just a single time as a structure, supply only the first two arguments

    body_radec(10,datetime(2022,8,4,12,0,0))
	ans =
               datetime: 2022-08-04 12:00:00.000000
    right_ascension_deg: 134.2608
        declination_deg: 17.24748
        solar_phase_deg: 0

### Moon

The name "moon" is not unique

	>> body_radec("moon", datetime(2022,8,4,12,0,0), datetime(2022,8,4,20,0,0), hours(1))
	Ambiguous specification of object; use one of the following ID#
	*******************************************************************************
	 Multiple major-bodies match string "MOON*"

	  ID#      Name                               Designation  IAU/aliases/other
	  -------  ---------------------------------- -----------  -------------------
	        3  Earth-Moon Barycenter                           EMB
	      301  Moon                                            Luna

	   Number of matches =  2. Use ID# to make unique selection.
	*******************************************************************************

	ans =
	     []

	>> body_radec(301, datetime(2022,8,4,12,0,0), datetime(2022,8,4,20,0,0), hours(1))
	ans =
	  9x3 timetable
	             datetime             right_ascension_deg    declination_deg    solar_phase_deg
	    __________________________    ___________________    _______________    _______________
	    2022-08-04 12:00:00.000000         208.29483             -9.92262          101.8395
	    2022-08-04 13:00:00.000000         208.80373            -10.15893          101.3274
	    2022-08-04 14:00:00.000000         209.31391            -10.39469          100.8147
	    2022-08-04 15:00:00.000000         209.82538            -10.62989          100.3015
	    2022-08-04 16:00:00.000000         210.33816             -10.8645           99.7876
	    2022-08-04 17:00:00.000000         210.85229             -11.0985           99.2732
	    2022-08-04 18:00:00.000000         211.36776            -11.33187           98.7583
	    2022-08-04 19:00:00.000000         211.88462            -11.56459           98.2428
	    2022-08-04 20:00:00.000000         212.40288            -11.79664           97.7267

The moon as viewed from College Park, MD

	>> umd = geoloc(38.988933, -76.937115, 42, "UMd", 10)
	>> body_radec(301, datetime(2022,8,4,12,0,0), datetime(2022,8,4,20,0,0), hours(1), umd)
	ans =
	  9x3 timetable
	             datetime             right_ascension_deg    declination_deg    solar_phase_deg
	    __________________________    ___________________    _______________    _______________
	    2022-08-04 12:00:00.000000         208.64183            -10.39442          101.3562
	    2022-08-04 13:00:00.000000         209.30862            -10.64774          100.6932
	    2022-08-04 14:00:00.000000         209.94562            -10.90817          100.0558
	    2022-08-04 15:00:00.000000         210.54461            -11.17446           99.4521
	    2022-08-04 16:00:00.000000         211.09966            -11.44488           98.8882
	    2022-08-04 17:00:00.000000         211.60753            -11.71725           98.3677
	    2022-08-04 18:00:00.000000         212.06805            -11.98908           97.8916
	    2022-08-04 19:00:00.000000         212.48424            -12.25768           97.4581
	    2022-08-04 20:00:00.000000         212.86219             -12.5204           97.0623
