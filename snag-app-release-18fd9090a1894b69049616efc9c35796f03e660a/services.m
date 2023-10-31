%%% Define URLs for various services
%% See https://www.mathworks.com/matlabcentral/answers/71834-how-to-call-include-load-one-m-file-in-another-m-file
classdef    services
  properties ( Constant = true )
    timeout = 30
    oraas_base_url = 'https://oraas.orekit.space';
    oraas_od_url = [services.oraas_base_url '/od/runs'];
    spacetrack_auth_url = 'https://www.space-track.org/ajaxauth/login';
    spacetrack_base_url = 'https://www.space-track.org/basicspacedata/query/class';
    horizons_base_url = 'https://ssd.jpl.nasa.gov/api/horizons.api';
    geohack_url = 'https://geohack.toolforge.org/geohack.php?params=';
    usno_base_url = 'https://aa.usno.navy.mil/api';
  end
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
