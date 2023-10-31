% propagate Propagate the orbital elements from the starting time (as a datetime) to the ending time.
% Input
%  orbit: initial orbital state
%  tstart: a datetime with the starting time, made by `datetime`, or
%          `true` to use the epoch to use the `day`, `hour`, `minute`
%  tend: a datetime with the ending time, made by `datetime`, or a
%        duration, meaning the length of the propagation interval, or a number, meaning a duration in seconds.
%        Defaults to 0, which is interpreted as 1 second after tstart.
%  step_size: A duration giving the step size, or if a number, a step size in seconds.
%             Optional, defaults to 1 (second).
%  force_model: a structure with force model parameters returned by `force_model()`
%               This is an optional argument and defaults to two-body propagation.
%               It does not matter what the force_model is when spacetrack orbits are being propagated.
%  accleration Whether to include acceleration; true or false (optional; default false)
% Output
%  ephemeris: a structure of four arrays with positions, velocities, (acceleration)
%             datetimes, and elapsed times (seconds) from the first
%             point and from the previous point.
function ephemeris = propagate...
		       (orbit, tstart, tend, step_size, force_model, acceleration)
  %% Default force model is two-body
  if ~exist('force_model','var')
    force_model = constants.force_twobody;
  end
  if ~exist('acceleration','var')
    acceleration = false;
  end

  %% The step size
  if ~exist('step_size','var')
      step_size = 1;
  end
  if ~exist('tend','var')
      tend = 0;
  end
  if isduration(step_size)
    step_size_s = seconds(step_size);
  elseif isnumeric(step_size)
    step_size_s = step_size;
  else
    error('prop:invalid_step_size', "Step size is not valid")
  end

  %% Call ORaaS
  output = struct('addAcceleration', acceleration);
  oraasreturn = or_propprop(orbit, tstart, tend, step_size_s, force_model, output);
  if isstruct(oraasreturn) && isfield(oraasreturn,'positions')...
     && ~isempty(oraasreturn.positions)
    ephemeris = or_propret(oraasreturn.positions, 0);
  else % There is an error or errors returned by ORaaS
    error('prop:server_returned_error',"Server returned the error message: %s",error_return(oraasreturn));
  end
end

%%================================================================================
%% Copyright 2020, 2021, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
