% or_pvt The epoch, position, and velocity vectors from ORaaS JSON
function posvel = or_pvt(iso8601_date, cartesian)
  posvel = pvt(datetime_iso8601(iso8601_date),...
      [cartesian.px; cartesian.py; cartesian.pz]',...
      [cartesian.vx; cartesian.vy; cartesian.vz]');
end

%%================================================================================
%% Copyright 2020, 2021, 2022 Liam M. Healy
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
