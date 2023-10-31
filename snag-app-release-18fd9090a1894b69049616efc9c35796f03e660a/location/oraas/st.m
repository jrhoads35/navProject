%%% Define specifications for orbital state used in the ORaaS calls
classdef    st
  properties ( Constant = true )
    %% Time element specification
    true_anomaly = "TRUE";
    mean_anomaly = "MEAN";
    eccentric_anomaly = "ECCENTRIC";
    %% Orbital state specification https://oraas.orekit.space/enums/orbit
    cartesian = "CARTESIAN";
    kepler = "KEPLERIAN";
    circular = "CIRCULAR";
    equinoctial = "EQUINOCTIAL";
  end
end

% This doesn't belong here; probably this should be in a new structure for propagation
%force_twobody = force_model(0, 0, 0, 0, 0, 0, 1000);


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
