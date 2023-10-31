% Create a Cartesian location (with two arguments, the second being a 3-vector) or state (with three arguments), or a structure array of Cartesian locations
function state = pvt(epoch, position_or_posvel, velocity_ms)
  switch height(epoch)
    case 0
      % Create an empty pvt structure
      % state = struct('epoch',{},'position_m',{},'velocity_ms',{});
      state = struct('epoch',[],'position_m',[],'velocity_ms',[]);
    case 1
      if exist('velocity_ms','var')
          state = pvt_single(epoch, position_or_posvel, velocity_ms);
      else
          state = pvt_single(epoch, position_or_posvel);
      end
    otherwise
      state = ephemeris_structarray(epoch, position_or_posvel, velocity_ms);
  end
end

function state = pvt_single(epoch, position_or_posvel, velocity_ms)
  state.epoch = epoch;
  state.position_m(1,:) = position_or_posvel(1:3);
  if exist('velocity_ms','var')
    state.velocity_ms(1,:) = velocity_ms;
    inside_earth_check(state.position_m); % Site vector can be "inside earth", won't have velocity
  else
    if (numel(position_or_posvel) == 6)
      state.velocity_ms(1,:) = position_or_posvel(4:6);
    end
  end
  if isfield(state,'velocity_ms') && norm(state.velocity_ms) < 100
    error('state:velocity_too_low',"Satellite inertial speed too low, %d < 100 meters/second", norm(state.velocity_ms));
  end
end

function st = ephemeris_structarray(timestamps, positions, velocities)
  for i = 1:min(size(timestamps,1),size(positions,1))
    stt(i) = pvt_single(timestamps(i), positions(i,:), velocities(i,:));
  end
  st = stt';
end

%% Copyright 2021, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
