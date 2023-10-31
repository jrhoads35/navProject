# Timetable

Sequences of satellite data are represented by Matlab [timetables](https://www.mathworks.com/help/matlab/timetables.html). Each row of the timetable has an `epoch` [datetime](datetime.md) which gives the time for which the data in that row. If the data in a row is the position or state (position and velocity) of a satellite, the table is called an [ephemeris](ephemeris.md).

It is also possible to represent a time sequence of data as a structure array, and conversion between the two representations is performed with `epochstruct()` and `epochtable()`.

## Select columns

1. To select or remove columns from a timetable (or any table), use the function `select_columns()`

	`select_columns(table, columns, allbut)`

	| Argument name | Description                                                                                      |
	|---------------|--------------------------------------------------------------------------------------------------|
	| `table`       | Table                                                                                            |
	| `columns`     | List of column names                                                                             |
	| `allbut`      | Boolean; if true, remove the named columns instead of selecting them (optional; default `false`) |

	Output is the same table with a subset of the original columns.

	For example,

		hst30days = epochtable(spacetrack_orbit(20580, 30))
		select_columns(hst30days,["perigee_alt_km", "apogee_alt_km", "orbital_period"])

1. To remove position and velocity columns, use the function `nopv(table)`; see an example in [visibility](propagation.md#visibility).

1. To extract an array of times from the table, see the table's `.epoch` variable; using the example in [visibility](propagation.md#visibility),

		iridium152.vis_osu.visibility_changes.epoch
		ans =
		  9x1 datetime array
		   2022-09-29 13:05:52.427000
		   2022-09-29 13:17:29.707000
		   2022-09-30 00:21:01.725000
		   2022-09-30 00:33:19.820000
		   2022-09-30 02:03:26.282000
		   2022-09-30 02:13:05.266000
		   2022-09-30 10:52:35.840000
		   2022-09-30 11:01:37.273000
		   2022-09-30 12:32:05.148000

## Select rows

A timetable can be reduced by selecting rows with [`find`](https://www.mathworks.com/help/matlab/ref/find.html), which will work on any column. For example, the following creates a table of observations from an original set `myobs` by taking every other observation between the observation numbers 321 and 1705 inclusive

```` matlab
startind = find(myobs.observation_number == 321);
stopind = find(myobs.observation_number == 1705);
smallset = myobs(startind:2:stopind,:)
````

Note that if the last observation may not be included of the step does not end with it (in this example, that there are an odd number of points in the range).

To select individual points, list the row numbers as computed by `find`. To continue the previous example, to make a table with just the first and last points,

```` matlab
twopts = myobs([startind stopind],:)
````

These techniques can be combined to make a table with combinations of ranges of rows and individual rows.

## Spreadsheet

A timetable can be loaded into a spreadsheet by creating a [CSV](https://en.wikipedia.org/wiki/Comma-separated_values) file using the Matlab function [`writetimetable()`](https://www.mathworks.com/help/matlab/ref/writetimetable.html), e.g.

	mms1.orbit = spacetrack_orbit(40482);
	mms1.ephem = propagate(mms1.orbit, true, days(2), minutes(30))
	writetimetable(mms1.ephem,"mms1.csv")
