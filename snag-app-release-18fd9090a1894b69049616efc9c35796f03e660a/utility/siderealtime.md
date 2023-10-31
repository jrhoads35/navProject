# Sidereal time
Compute the sidereal time (right ascension angle of a meridian). The function `siderealtime(datetime,lla)` takes two arguments, the [datetime](datetime.md) and an optional [geographic location](location.md#geographic-ecef), and returns an array with two numbers, the local mean sidereal time, or right ascension of the local meridian, and the Greenwhich mean sidereal time [GMST](https://aa.usno.navy.mil/faq/asa_glossary#Greenwich-Mean-Sidereal-Time-(GMST)), or right ascension of the prime meridian.

If the second argument is missing, the array has the GMST twice.

Example for the current moment

    umd = geoloc(38.988933, -76.937115, 42, "UMd", 10)
	st = siderealtime(nowutc, umd)
	st =
          280.220371666667          357.157486666667

The US Naval Observatory (USNO) supplies this data.
