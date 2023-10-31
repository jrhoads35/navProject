% azelrn_deg  Make a structure with azimuth (degrees), elevation (degrees), and range
function azelrn = azelrn_deg (azimuth_deg, elevation_deg, range_m)
    azelrn = struct('azimuth_deg', azimuth_deg,...
	     'azimuth_rdn', deg2rad(azimuth_deg),...
	     'elevation_deg', elevation_deg,...
	     'elevation_rdn', deg2rad(elevation_deg),...
	     'range_m', range_m);
end











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
