% eclipse Determine eclipse times for the orbit
% Input
%  orbit: orbit specification
%  start_dttm: a datetime with the starting time (= the epoch of the elements), made by `datetime`
%  end_dttm: a datetime with the ending time, made by `datetime`
%  force_model: a structure with force model parameters returned by `force_model()`
%               This is an optional argument and defaults to two-body propagation.
%               It does not matter what the force_model is when TLEs are being propagated.
% Output is a structure with five fields; all are arrays with one rows for each event.
%  event:      Name of the event, such as `'penumbra_in'`, `'umbra_in'`, etc.
%  position_m:  ECI position (meters) of the satellite at the event.
%  velocity_ms: ECI velocity (meters/second) of the satellite at the event.
%  times:      Datetime (UTC) at which the event occured.
%  elapsed:    Elapsed time in seconds from the starting time `start_dttm`.
function eclipse = eclipse(orbit, start_dttm, end_dttm, force_model)
  if ~exist('force_model','var')
    force_model = constants.force_twobody;
  end
  output = struct('events', struct('sunEclipse', true));
  oraasreturn = or_propprop(orbit, start_dttm, end_dttm, 1, force_model, output);
  if isstruct(oraasreturn) && isfield(oraasreturn,'sunEclipse')
    ephem_struct = oraasreturn.sunEclipse;
    eclipse = or_propret(ephem_struct, start_dttm);
  else % There is an error or errors returned by ORaaS
    eclipse = error_return(oraasreturn);
  end
end





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
