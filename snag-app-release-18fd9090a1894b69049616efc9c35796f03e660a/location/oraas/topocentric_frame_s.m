%%% East-north-zenith (ENZ) topocentric frame structure, which specifies
%%% a geographic location and an ECEF frame.
%%% See https://www.orekit.org/static/apidocs/org/orekit/frames/TopocentricFrame.html
%%% Liam Healy
%%% Time-stamp: <2020-09-10 23:29:08EDT topocentric_frame_s.m>

function tf = topocentric_frame_s(geoloc_s, name)
  tf = struct('topocentricFrame',...
	      struct('origin', geoloc_s.geographic,...
		     'name', name));


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
