%%% Make a datetime from a ISO8601 string
function dt = date_iso8601(iso8601_string)
  iso8601_fmt_r = 'yyyy-MM-dd';
  dt = datetime(extractBetween(iso8601_string,1,10),'InputFormat',iso8601_fmt_r,TimeZone='Z');
