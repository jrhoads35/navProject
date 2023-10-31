% loc1  Select a single point from a table by epoch or index sequence
% Input
%  table  A timetable, a structure array with (at least) two fields: epoch, position_m.
%  select     Either a datetime or a sequence number
%
% Like pvt1, should be called/unified to pt1?
function state = loc1(table, select)
  if isdatetime(select)
    index = find(table.epoch == select);
  else
    index = select;
  end
  if ~isempty(index)
    state.epoch = table.epoch(index);
    if hasfields(table, aofld.pos)
      state.position_m = table.position_m(index,:);
    end
    if hasfields(table, aofld.aerdeg)
      state.azimuth_deg = table.azimuth_deg(index,:);
      state.elevation_deg = table.elevation_deg(index,:);
      state.range_m = table.range_m(index,:);
    end
    if hasfields(table, aofld.lladeg)
      state.latitude_deg = table.latitude_deg(index,:);
      state.longitude_deg = table.longitude_deg(index,:);
      state.altitude_m = table.altitude_m(index,:);
    end
  else
    state = false;
  end
end

%%================================================================================
%% Copyright 2021, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
