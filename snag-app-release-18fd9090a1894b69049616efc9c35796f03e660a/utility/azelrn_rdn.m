% azelrn_rdn  Make a structure with specification of azimuth (radians), elevation (radians), and range
function azelrn = azelrn_rdn (azimuth_rdn, elevation_rdn, range_m)
  azelrn = struct('azimuth_rdn', azimuth_rdn,...
		  'azimuth_deg', rad2deg(azimuth_rdn),...
		  'elevation_rdn', elevation_rdn,...
		  'elevation_deg', rad2deg(elevation_rdn),...
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
