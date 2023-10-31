%%% Define fields/columns used for astrodynamics objects
%% See https://www.mathworks.com/matlabcentral/answers/71834-how-to-call-include-load-one-m-file-in-another-m-file
classdef    aofld
  properties ( Constant = true )
    epoch = {'epoch'};
    aerdeg = {'azimuth_deg'; 'elevation_deg'; 'range_m'};
    aedeg = aofld.aerdeg(1:2);
    aerrdn = {'azimuth_rdn'; 'elevation_rdn'; 'range_m'};
    lladeg = {'latitude_deg'; 'longitude_deg'; 'altitude_m'};
    lldeg = aofld.lladeg(1:2);
    pos = {'position_m'};
    posdiff =  {'diff_position_m'};
    posvel = {aofld.pos{1}; 'velocity_ms'};
    posveldiff = {aofld.posdiff{1}; 'diff_velocity_ms'};
  end
end


%%================================================================================
%% Copyright 2021, 2022 Liam M. Healy
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
