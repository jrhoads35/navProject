% azelrn_s  Create an azimuth, elevation, range structure from a
%           topocentric frame structure and either spherical_s structure
%           or azimuth (deg), elevation (deg), and range.
function azelrn = azelrn_s(topofr_s, spherical_s, varargin)
  %%function azel = azel_s(topofr_s, azimuth_deg, elevation_deg, distance)
  if nargin == 4
    azimuth_deg = spherical_s;
    elevation_deg = cell2mat(varargin(1));
    range_m = cell2mat(varargin(2));
  else
    azimuth_deg = spherical_s.azimuth_deg;
    elevation_deg = spherical_s.elevation_deg;
    range_m = spherical_s.range_m;
  end
  topofr_s.azimuth = deg2rad(azimuth_deg);
  topofr_s.elevation = deg2rad(elevation_deg);
  topofr_s.distance = range_m;
  azelrn = topofr_s;
end

%% 		struct('azimuth', deg2rad(azimuth_deg),...
%% 		       'elevation', deg2rad(elevation_deg),...
%% 		       'distance', distance,...
%% 		       'topocentricFrame', topofr_s.topocentricFrame));




%%==============================================================================
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
