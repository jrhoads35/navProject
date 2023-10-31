% Interpolate the ephemeris table to the times requested
function interp = ephemeris_interp(ephemeris, times)
    epoch = times;
    interp = ...
        timetable(epoch,...
                  interp1(ephemeris.epoch, ephemeris.position_m, epoch, 'spline'),...
                  interp1(ephemeris.epoch, ephemeris.velocity_ms, epoch, 'spline'),...
                  'VariableNames', ["position_m","velocity_ms"]);
end

%%================================================================================
%% Copyright 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
