# Space Navigation and Guidance Application _SNaG-app_

Cloud application for space navigation and guidance exercises, problems, and projects.

## Overview

* SNaG-app uses [web APIs](https://en.wikipedia.org/wiki/Web_API) to do astrodynamics computations and to provide data on satellite orbits and the orbital environment.
* Computations are performed with [ORaaS](https://oraas.orekit.space/index.html), a web API for the space dynamics library [Orekit](https://www.orekit.org/).
* Orbital information is obtained from the US government official source [space-track](https://www.space-track.org/).
* Solar system information from [Horizons](https://ssd.jpl.nasa.gov/horizons/) and [USNO](https://aa.usno.navy.mil/data/index).
* User interaction is through Matlab.

## Examples

<!-- Can't convert from radec to Cartesian easily, esp. in a table; convert to radians and call sph2cart
1. Find the azimuth and elevation to the sun from College Park, Maryland three hours from now

		body_radec(10,datetime('today') + hours(8), datetime('today') + hours(16),"15m")
		AU = 149598e6
-->

1. Show on a map the subsatellite point of the ISS now (after logging in to `space-track.org`)

		showmap(lla(pvt1(propagate(spacetrack_orbit(25544),nowutc),1)))

	* `nowutc` generates a [datetime](datetime.md) for the current instant
	* `spacetrack_orbit()` connects to the [space-track.org](spacetrack.md) database and retrieves the latest elements sets; `25544` is the SDC (NORAD) identifier for the ISS
	* `propagate()` [propagates](propagation.md) the orbital element set
	* `pvt1()` gets a [position-velocity-time (PVT) state](ephemeris.md) from the ephemeris.
	* `lla()` [converts](location.md#frame-conversion) the Cartesian position to [latitude-longitude-altitude](location.md#geographic-ecef)
	* `showmap()` displays that location on a map in your browser

1. Find the differences in position and velocity over one hour from propagation with two-body forces and a 20x20 gravity model, with other perturbations

		kpex.els = kepler_oes(nowutc, 1.0e7, 0.1, 62.0, 82, 221, 45)
		kpex.twobody = propagate(kpex.els, true, hours(1), minutes(1))
		force_20x20_cd22 = force_model(20, 20, 1.0, 2.2, 0, 0, 1000)
		kpex.d20o20 = propagate(kpex.els, true, hours(1), minutes(1),force_20x20_cd22)
		pvmag(pvdiff(kpex.d20o20, kpex.twobody))

	* `kepler_oes` Creates a [Kepler orbital element set](elements.md#kepler) with a semimajor axis of 10000km, eccentricity 0.1, inclination 62 degrees, etc.
	* `nowutc` Gets the current [date and time](datetime.md#current-datetime)
	* `propagate` [propagates](propagation.md) that orbital element set for one hour in one minute steps using only the two-body force
	* `force_model` creates the perturbed [force model](propagation.md#force-model)
	* `pvmag` and `pvdiff` make a table of [position and velocity differences](ephemeris#ephemeris-functions) from the two propagated ephemerides

## Requirements

* Matlab R2020b or later
* Active internet connection
* To use the space-track functions, a username and password from `space-track.org`

## Download and install

* Download and extract [zip](https://gitlab.com/orbitdynamics/snag-app/-/archive/release/snag-app-master.zip) or
[tar.gz](https://gitlab.com/orbitdynamics/snag-app/-/archive/release/snag-app-master.tar.gz) of the latest release.
* Start Matlab where you extracted the files.
* If you want Matlab to start up with the app available regardless of where you start it, see the [savepath instructions](https://www.mathworks.com/help/matlab/ref/savepath.html), which requires you to start up where the app is once, then save the path for all future sessions.
<!--
Matlab instructions on [startup folder](https://www.mathworks.com/help/matlab/matlab_env/matlab-startup-folder.html)
* Verify that it is installed with `which startup`.
* If you want snag-app to load automatically every time you start Matlab, extract the _contents of the archive_ where [`userpath`](https://www.mathworks.com/help/matlab/ref/userpath.html) (with no arguments) says your startup folder is, or extract it anywhere you like and then use [`userpath`](https://www.mathworks.com/help/matlab/ref/userpath.html) with an argument to set that as the startup folder.
-->

## ORaaS status

Most of the computations are done with ORaaS; [check the server status](https://updown.io/wr10), or use the Matlab function `chksrv` to see a condensed form of the same information.

## Troubleshooting
If you are unable to use SNaG-app at all or use only parts of it, try these steps, in order

1. `count(path,'snag-app')` should return at least 11. If it does not, then the path is not set correctly, either due to incorrect or incomplete installation, or incorrect startup location.
1. `checkserver` should return `true` (logical 1). If it does not, it means the ORaaS server is not available.
    1. Go to the [ORaaS](https://oraas.orekit.space/index.html) homepage to see if it responds.
    1. If that gives an error, go to [downforeveryoneorjustme](https://downfor.io/oraas.orekit.space) to see if the problem is with your internet service or with the server.
	1. If your internet connection is working, other functions of the app will still be available.
1. If there is an error message about an undefined function you don't recognize (i.e., one used by the app and not your own code)
    1. `ver` will show the Matlab version, which should be R2020a or later.
    1. `constants.appversion` should show at least `16`, or whatever you have been told is the minimum version of the app needed.
1. If there is an error message about an invalid SSL certificate, it could be either a problem with the service, or your Matlab version is not new enough (it may require a version newer than R2020a, because certificates expire).

If SNaG-app has been working and suddenly gives you a message such as

	Services for https://oraas.orekit.space failed
	Server Error: Service Unavailable
	Service Temporarily Unavailable

then try the `checkserver` step. Sometimes recovery is almost immediate; other times it can take a day or more.

If you get an error such as "The connection to URL 'https://oraas.orekit.space....' timed out after 30.000 seconds" (or similar), the easiest solution is just try again, that sometimes fixes the problem. If it persists, go into the file `services.m` and try increasing the value of timeout to something larger. Note this has limits; there is a maximum time limit on the server that you cannot change.
