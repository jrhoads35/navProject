function tm = epoch(object)
    if hasepoch(object)
        tm = object.epoch;
    elseif isstruct(object) && isfield(object,"orbitBulletin")
        tm = datetime_iso8601(object.orbitBulletin.date);
    elseif isstruct(object) && isfield(object,"tle")
        tm = tle_epoch(object.tle.line1);
    else
        error('state:no_epoch',"Do not know how to find epoch of object");
    end
end

%%================================================================================
%% Copyright 2021, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
