%%% Make a datetime from a ISO8601 string
function dt = datetime_iso8601(iso8601_string)
  iso8601_fmt_r = 'yyyy-MM-dd''T''HH:mm:ss.SSS'; %% Read ISO8601 datetime
  dt = datetime(iso8601_string,'InputFormat',iso8601_fmt_r,TimeZone='Z');
end

%%================================================================================
%% Copyright 2020, 2021 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
