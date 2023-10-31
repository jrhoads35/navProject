%% A location in geographic (lla) coordinates

% latitude_deg : Latitude of location in degrees
% longitude_deg : Longitude of location in degrees
% altitude_m : Altitude of location above mean sea level in meters
% epoch_or_name: If a name (string), site given in the TDM file or output of visibility
%                If a datetime, define location in time
% minimum_elevation_deg: The minimum elevation in degrees that the site can see
% To make an object without an epoch, pass [] in the fourth argument; epoch can be set later with setepoch().
% Example
%  oapchile = geoloc(-30.1428030000, -70.6945280000, 1500.000000, "OAP-Chile");
function lla = geoloc(latitude_deg, longitude_deg, altitude_m, epoch_or_name, minimum_elevation_deg)
  lla = struct('latitude_rdn', deg2rad(latitude_deg),...
	       'latitude_deg', latitude_deg,...
	       'longitude_rdn', deg2rad(longitude_deg),...
	       'longitude_deg', longitude_deg,...
	       'altitude_m', altitude_m);
  if isdatetime(epoch_or_name)
      lla.epoch = epoch_or_name;
  else
      lla.station = make_station(epoch_or_name, lla);
      if ~exist('minimum_elevation_deg','var')
          minimum_elevation_deg = 0.0;
      end
      lla.geo = observation_site(epoch_or_name, lla, minimum_elevation_deg);
  end
end

% Make station structure for orbit determination
function stat = make_station(name, lla)
  obsloc = geogr_s(lla);
  stat = struct('geographicPosition',obsloc.geographic);
  stat.name = char(strrep(name,"_"," ")); % Can't have underscores in station name
end

% Information about an observation site, used for visibility prediction
function site = observation_site(name, location_lla, minimum_elevation_deg)
  site = struct('name',name,...
		'position', ...
		struct('lat', location_lla.latitude_rdn,...
		       'lon', location_lla.longitude_rdn,...
		       'alt', location_lla.altitude_m), ...
		'minElevation', deg2rad(minimum_elevation_deg));
end

% geogr_s Make ORaaS structure giving geographic location (lat, lon, alt)
% Input
%  lla: A structure with latitude_deg, longitude_deg, and altitude_m slots

%%% A geographic location is specified by an topographic position
%%% (latitude, longitude, altitude) and an earth-centered earth-fixed
%%% (ECEF) coordinate frame.
function geo = geogr_s (lla)
  g = ori.itrf_s;
  g.lat = lla.latitude_rdn;
  g.lon = lla.longitude_rdn;
  g.alt = lla.altitude_m;
  geo = struct('geographic', g);
end



%%================================================================================
%% Copyright 2023 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
