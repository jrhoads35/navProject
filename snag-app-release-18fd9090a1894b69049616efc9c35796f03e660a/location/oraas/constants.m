%%% Define constants used in the ORaaS calls
%% See https://www.mathworks.com/matlabcentral/answers/71834-how-to-call-include-load-one-m-file-in-another-m-file
classdef    constants
  properties ( Constant = true )
    appversion_semester = '2023b'
    appversion = 16 % When changing, also change the "Troubleshooting" section of index.md
    secperday = 86400;
    earth_radius_m = 6378.135e3;
    earth_grav_const_km3s2 = 3.986004415e14;
    timescale = "UTC"
    force_twobody = force_model(0, 0, 0, 0, 0, 0, 1000);
  end
end


%%================================================================================
%% Copyright 2020, 2021, 2022, 2023 Liam M. Healy
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
