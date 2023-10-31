% two_line_elements Use two line elements for orbit propagation
function tle = two_line_elements(line1, line2)
  tle = struct('tle', struct('line1', line1, 'line2', line2));


%0 IRIDIUM 120
%1 42805U 17039C   20272.82969371 +.00000035 +00000-0 +54509-5 0  9993
%2 42805 086.3923 114.4509 0002156 074.8950 285.2484 14.34216925171990


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
