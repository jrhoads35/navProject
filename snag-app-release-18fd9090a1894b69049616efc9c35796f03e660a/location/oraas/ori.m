classdef    ori
  properties ( Constant = true )
  iso8601_fmt_w = 'yyyy-mm-ddTHH:MM:ss.FFF'; % Write ISO8601 datetime https://stackoverflow.com/a/46999168
  itrf_s = struct('ecefFrameName', "CIO/2010-based ITRF simple EOP"); % "CIO/2010-based%20ITRF%20simple%20EOP"
  gcrf_s = struct('frameName', "GCRF");
  end
end
