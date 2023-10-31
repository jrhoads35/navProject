% geographic_s Make ORaaS structure giving geographic location (lat, lon, alt)
% Input
%  lla: A structure with latitude_deg, longitude_deg, and altitude_m slots

%%% A geographic location is specified by an topographic position
%%% (latitude, longitude, altitude) and an earth-centered earth-fixed
%%% (ECEF) coordinate frame.
function geo = geographic_s (lla)
  g = ori.itrf_s;
  g.lat = deg2rad(lla.latitude_deg);
  g.lon = deg2rad(lla.longitude_deg);
  g.alt = lla.altitude_m;
  geo = struct('geographic', g);

%%================================================================================
%% Copyright 2020 Liam M. Healy
%% This file is part of SNaG-app.

%% SNaG-app is free software: you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published by
%% the Free Software Foundation, either version 3 of the License, or
%% (at your option) any later version.

%% SNaG-app is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.

%% You should have received a copy of the GNU General Public License
%% along with SNaG-app.  If not, see <https://www.gnu.org/licenses/>.
