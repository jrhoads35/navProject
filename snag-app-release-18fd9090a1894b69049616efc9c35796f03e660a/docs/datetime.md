# Date and time
## Absolute date and time
   A Matlab [_datetime_](https://www.mathworks.com/help/matlab/matlab_prog/represent-date-and-times-in-MATLAB.html) is a date and time combined. It is created with Matlab's `datetime` function, e.g.,

````
   aug1_dttm = datetime(2020, 08, 01, 00, 30, 00, 000)
   aug1_dttm =
     datetime
      01-Aug-2020 00:30:00
   class(aug1_dttm)
   ans =
       'datetime'
````

which represents August 1, 2020 at 12:30 AM, or by conversion from, for example, the [ISO8601 format](https://en.wikipedia.org/wiki/ISO_8601) (without timezone designators)

````
   datetime_iso8601("2020-08-01T00:30:00.000")
   ans =
     datetime
      01-Aug-2020 00:30:00
````

   The function `datetime_iso8601` is provided by this application. A point in time is specified by a datetime and a time scale, such as [coordinated universal time (UTC)](https://en.wikipedia.org/wiki/Coordinated_Universal_Time). In ORaaS, UTC is assumed. (In USNO, UT1 is assumed, which differs from UTC by less than a second.)

## Current datetime

The datetime for the present moment can be made with `nowutc`, which can take an argument (`'second'`, `'minute'`, `'hour'`, `'day'`) to round up to the next even unit of time. If the argument is `true`, use the exact time, if it is not specified, defaults to `'minute'`.

	nowutc(true)
	ans =
	  datetime
	   2022-08-22 02:04:40.804105

	nowutc
	ans =
	  datetime
       2022-08-22 02:05:00.000000

    nowutc('hour')
	ans =
	  datetime
       2022-08-22 03:00:00.000000

## Duration

The length of a time interval is specified as a [_duration_](https://www.mathworks.com/help/matlab/ref/duration.html)

## Set epoch

To set the epoch field in a structure, use the function `setepoch(epoch, object)`. This is useful for the geographic and observation [location specification functions](location.md).
