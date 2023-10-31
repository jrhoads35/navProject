% spacetrack_orbit Find orbit information from space-track.org by NORAD catalog id or other query.
% If tstart and tend are omitted, show the latest orbit for each object.
% If tstart is supplied and tend is omitted, show the last orbit prior to that datetime.
% If both tstart and tend are supplied, show all orbits between those two datetimes.
% Example: get the latest orbital information for the ISS.
%   spacetrack_auth("spacetrackuser@example.com", "wlrjdls809w3r")
%   iss.orbit = spacetrack_orbit(25544)
% Example: find the first 5 (by catalog id) geosynch satellites
%   geos = spacetrack_orbit('/period/1400--1500/limit/5')
% Example: find all low-inclination geosynch satellites currently on orbit
%   geos = spacetrack_orbit('/period/1400--1500/inclination/<5/')
%% See https://www.space-track.org/basicspacedata/modeldef/class/gp/format/html for possible queries, but note that units are not specified

function sat = spacetrack_orbit(query, tstart, tend)
  if isempty(char(query))
    error("Please restrict your query to avoid overload of the database.");
  end

  %% Check for authorization to use space-track.org
  if st_authorized()
    stauth = st_userpass();
  else
    sat = false;
    return
  end

  %% Determine if a date range is requested
  iso8601date_fmt_w = 'yyyy-mm-dd';
  picklast = false;
  if exist('tstart','var')
    if ~exist('tend','var')
        %tend = datetime('today') + days(1);
        tend = tstart;
        tstart = tstart - days(7);
        picklast = true;
    end
    %[start_dttm end_dttm] = interval_time(tstart, tend);
    tstart.TimeZone = 'Z';
    tend.TimeZone = 'Z';
    daterange = ['/EPOCH/' datestr(tstart,iso8601date_fmt_w) ...
			  '--' datestr(tend,iso8601date_fmt_w)];
  else
    daterange = [];
  end

  %% Create the query string
  if isnumeric(query)
    qstr = ['/norad_cat_id/' num2str(query)];
  else
    qstr = query;
  end
  if isempty(daterange)
    %% The recommended URL for gp queries, see https://www.space-track.org/documentation#/api.
    orderby = '/orderby/norad_cat_id asc/format/json';
    url= [services.spacetrack_base_url '/gp/decay_date/null-val/epoch/%3Enow-30' qstr orderby];
  else
    orderby = '/orderby/epoch asc';
    url= [services.spacetrack_base_url '/gp_history' qstr daterange orderby];
  end

  %% Query the server and parse the results
  response = webwrite(services.spacetrack_auth_url,...
		      'identity', char(stauth(1)),...
		      'password', char(stauth(2)),...
		      'query', url);
  parse = jsondecode(response);
  if isfield(parse,'error')
    error(['Error from space-track server: ' parse.error]);
  end
  if size(parse,1) == 1
    sat = parse_spacetrack_orbels(parse);
  else
    sat = arrayfun(@(p) parse_spacetrack_orbels(p), parse);
  end

  if picklast % Assumes only a single object
      lastone = 0;
      for i= 1:size(parse,1)
          if sat(i).epoch < tend
              lastone = i;
          end
      end
      if lastone > 0
          sat = sat(lastone);
      else
          error("No orbit found with epoch before specified time");
      end
  end
end

% url= [services.spacetrack_base_url  '/boxscore']

%%================================================================================
%% Copyright 2020, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
