% propagate_to_times Propagate the Cartesian state from the starting time (as a datetime) to the ending time.
% Input
%  orbit: Cartesian orbital state at epoch
%  times: an array of times to propagate to
%  force_model: a structure with force model parameters, typically returned by `force_model()`
%               It does not matter what the force_model is when TLEs are being propagated.
% Output
%  ephemeris: an array of structures epoch times, positions, velocities.
% Example, where orbest is the output of determine_orbit.
% propagate_to_times(orbest.estimated, orbest.observations.datetime, orbest.force_model)
function ephemeris = propagate_to_times(posvel, times, force_model)
  cart = pvt_to_orbbull(posvel);
  epoch = posvel.epoch;
  for i=1:size(times,1)
    end_time = times(i);
    step_size = 5; % Actual integration step and not ephemeris frequency? seconds(time(between(epoch, end_time)));
    prop = propagate(cart, epoch, end_time, step_size, force_model);
    sizepos = size(prop.position_m,2);
    if sizepos == 1
      pos = prop.position_m;
      vel = prop.velocity_ms;
    else
      pos = prop.position_m(size(prop.position_m,1),:)';
      vel = prop.velocity_ms(size(prop.velocity_ms,1),:)';
    end
    epoch = end_time;
    poss(i,:) = pos';
    vels(i,:) = vel';
    cart = pvt_to_orbbull(pvt(epoch, pos, vel));
  end
  ephemeris.epoch = times;
  ephemeris.position_m = poss;
  ephemeris.velocity_ms = vels;
end


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
