% orbbull  Create the orbit bulletin from the PVT
function orbbull = pvt_to_orbbull(pvt)
 orbbull = ...
 struct('orbitBulletin', ...
	struct('date', datestr(pvt.epoch, ori.iso8601_fmt_w), ...
	       'timeScale', "UTC", ...
	       'eciFrameName', ori.gcrf_s.frameName, ...
	       'cartesian', struct('px',pvt.position_m(1),...
				   'py',pvt.position_m(2),...
				   'pz',pvt.position_m(3),...
				   'vx',pvt.velocity_ms(1),...
				   'vy',pvt.velocity_ms(2),...
				   'vz',pvt.velocity_ms(3))));

%%================================================================================
%% Copyright 2020, 2021 Liam M. Healy
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
