# Space-track

The web site [space-track.org](http://www.space-track.org) contains the orbital tracking information from the US Space Surveillance Network. Access to most data requires the [creation of an account](https://www.space-track.org/auth/createAccount).

## User credentials

Once an account has been established, you must specify your user name and password at each Matlab session using `spacetrack_auth`, which takes two arguments, the user name and password. Each should be enclosed in a pair of single or double quotes, for example

    spacetrack_auth("spacetrackuser@example.com", "wlrjdls809w3r")

To remove the credentials, specify `false` (or any non-string) for either or both arguments.

    spacetrack_auth(false, false)

## Latest orbital information

The function `spacetrack_orbit` will return orbital information about a satellite on orbit; it takes the NORAD catalog identifier (number of up to five digits) as an argument. For example, the International Space Station (ISS) has NORAD catalog identifier 25544,

	iss.orbit = spacetrack_orbit(25544)
	iss.orbit
	                  norad_cat_id: 25544
	                   object_name: 'ISS (ZARYA)'
	                   object_type: 'PAYLOAD'
	                     object_id: '1998-067A'
	                   launch_date: 20-Nov-1998
	                         epoch: 11-Oct-2020 12:49:59
	                      on_orbit: 21y 10mo 21d
	                  eccentricity: 0.000138
	                 apogee_alt_km: 419.727
	                perigee_alt_km: 417.851
	         mean_motion_rdnpersec: 0.00112667894067009
	    mean_motion_dot_rdnpersec2: 1.48979204090951e-15
	              mean_anomaly_deg: 64.6425
	               inclination_deg: 51.6442
	             semimajor_axis_km: 6796.924
	                orbital_period: 92.945 min
	                      raan_deg: 132.7847
	               arg_perigee_deg: 21.67
	       ballistic_coeff_m2perkg: 0.0001433939664
	                           tle: [1x1 struct]

The quantities are Matlab structure elements; for example the perigee altitude in kilometers can be obtained in this example with

	iss.orbit.perigee_alt_km
	ans =
	                   417.851

## Last orbit prior to a specified time
If a datetime is given as the second argument to `spacetrack_orbit()`, the last orbit available prior to that time is returned

	iss.orbit = spacetrack_orbit(25544,datetime(2022,7,1,0,0,0))
	iss.orbit
	  struct with fields:

	                         epoch: 2022-06-30 17:50:27.729600
	                     epoch_age: 5mo 4d 1h 28m 32.2704000000003s
	             semimajor_axis_km: 6795.508
	                orbital_period: 92.916 min
	                  eccentricity: 0.0004518
	                 apogee_alt_km: 420.443
	                perigee_alt_km: 414.303
	         mean_motion_rdnpersec: 0.00112703135609821
	    mean_motion_dot_rdnpersec2: 6.52057567283954e-14
	              mean_anomaly_deg: 147.9084
	               inclination_deg: 51.6441
	                      raan_deg: 269.4482
	               arg_perigee_deg: 317.1696
	       ballistic_coeff_m2perkg: 0.001843327272
	                  norad_cat_id: 25544
	                   object_name: 'ISS (ZARYA)'
	                   object_type: 'PAYLOAD'
	                     object_id: '1998-067A'
	                   launch_date: 20-Nov-1998
	                      on_orbit: 23y 7mo 10d 17h 50m 27.7295999999988s
	                    decay_date: []
	                           tle: [1x1 struct]


## Orbital information over a range times

To get mutiple sets of orbital information about a single satellite, use `spacetrack_orbit` with a specified date range. If the last argument, the end date, is omitted, it defaults to the current day. If the second argument is a duration, the starting date is that length of time prior to the end date. If the second argument is a number, the starting date is that number of days prior to the end date. For example, the following all return the same thing, the last thirty days of the Hubble Space Telescope orbit

    spacetrack_orbit(20580, datetime('today') - days(30), datetime('today'))
    spacetrack_orbit(20580, datetime('today') - days(30))
    spacetrack_orbit(20580, days(30), datetime('today'))
    spacetrack_orbit(20580, days(30))
    spacetrack_orbit(20580, 30, datetime('today'))
    spacetrack_orbit(20580, 30)

This will result in multiple sets. To select a particular orbital information set by epoch, use `select_orbit`, which returns the first set whose epoch is on or after the specified date.

	iss_oct15_18 = spacetrack_orbit(25544,datetime(2020,10,15),datetime(2020,10,18))
	select_orbit(iss_oct15_18, datetime(2020,10,15,18,0,0)) % First orbit on or after 2020-10-15T18:00:00 UTC

## Satellites with specified orbits

<!-- For example, to find all low-inclination satelllites with orbital periods near a day,
```` matlab
	geos = spacetrack_orbit('/period/1400--1500/inclination/<5')
````
A complete list of query terms are [available](https://www.space-track.org/basicspacedata/modeldef/class/gp/format/html), but unfortunately, units are not specified.
-->

It is possible to select multiple satellites with specified orbital parameters from the current catalog by calling the function with a string with forward slashes `/` and [names of orbital parameters](https://www.space-track.org/basicspacedata/modeldef/class/gp/format/html) and ranges or minimum/maximum values, instead of a number. Note that the query units are not specified in the space-track.org documentation. Typically, distances are in kilometers, angles in degrees, and time intervals in minutes. Possible comparison operators are given [here](https://www.space-track.org/documentation#api-restOperators).

For example, to find all satellites in low-inclination near-geosynchronous orbit,

	geos = spacetrack_orbit('/period/1400--1500/inclination/<5/')
	geos =
	  592x1 struct array with fields:
	    epoch
	    epoch_age
	    semimajor_axis_km
	    orbital_period
	    eccentricity
	    apogee_alt_km
	    perigee_alt_km
	    mean_motion_rdnpersec
	    mean_motion_dot_rdnpersec2
	    mean_anomaly_deg
	    inclination_deg
	    raan_deg
	    arg_perigee_deg
	    ballistic_coeff_m2perkg
	    norad_cat_id
	    object_name
	    object_type
	    object_id
	    launch_date
	    on_orbit
	    decay_date
	    tle

Sometimes it is helpful to see the results in a table,

	very_retro = struct2table(spacetrack_orbit('/inclination/>120/'));
	very_retro(:,["norad_cat_id","object_name","inclination_deg","semimajor_axis_km"])
	ans =
	32x4 table
	norad_cat_id          object_name          inclination_deg    semimajor_axis_km
	____________    _______________________    _______________    _________________
	    1613        {'OV1-2'              }       144.2317             7713.662
	    1616        {'ATLAS D R/B'        }       144.2362              7594.65
	    2121        {'OV1-4'              }       144.5041             7317.383
	    2122        {'OV1-5'              }       144.6339             7392.454
	    2123        {'OV1-5 R/B'          }       144.6399             7393.335
	    2124        {'OV1-4 R/B'          }       144.5088              7315.78
	    2327        {'ATLAS D DEB'        }       144.1971             7269.934
	    2328        {'ATLAS D R/B'        }       144.2339              7378.33
	    2329        {'ATLAS D DEB'        }       144.2819             7309.079
	    2337        {'ATLAS D DEB'        }       144.2301             7371.104
	    3307        {'EXPLORER 38 (RAE-A)'}       120.8353            12221.994
	    3315        {'DELTA 1 R/B'        }       120.6897             9583.577
	    3611        {'OV1-5 DEB'          }       144.5501             6931.442
	    3848        {'EXPLORER 38 DEB'    }       120.8351            12222.308
	    5361        {'OV1-5 DEB'          }       144.6181             7180.752
	    5599        {'OV1-5 DEB'          }       144.6244             7128.532
	    7369        {'OPS 7518 (NTS 1)'   }        125.011            19988.194
	    8599        {'NTS 1 AKM'          }        125.013            19989.694
	   25270        {'DELTA 1 DEB'        }       120.6503             9093.958
	   26410        {'CLUSTER II-FM7'     }       134.3893            72834.026
	   26411        {'CLUSTER II-FM6'     }       136.8999            72770.695
	   26463        {'CLUSTER II-FM5'     }       140.4104            72771.918
	   26464        {'CLUSTER II-FM8'     }       134.4222            72776.738
	   27480        {'DELTA 1 DEB'        }       121.2617             9467.893
	   27624        {'DELTA 1 DEB'        }       120.6315             8861.487
	   27880        {'OV1-5 DEB'          }       144.5855              7122.05
	   28266        {'DELTA 1 DEB'        }       120.6558             8686.595
	   28608        {'EXPLORER 38 DEB'    }       120.8422            12225.508
	   28671        {'DELTA 1 DEB'        }       120.6655               8243.9
	   39463        {'FIREBIRD A'         }       120.4416             6933.297
	   39465        {'AEROCUBE 5A'        }       120.4827             6947.989
	   39466        {'AEROCUBE 5B'        }       120.4569             6869.637
