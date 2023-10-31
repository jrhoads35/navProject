% Make an ephemeris timetable of the vector differences in position and optionally velocity, ephem1-ephem2
function difs = pvdiff(ephem1, ephem2)
    joined = join_ephemeris(ephem1, ephem2);
    posdifs = rowfun(@minus, joined,...
                     'InputVariables', ["pos1", "pos2"], 'OutputVariableNames', aofld.posdiff{1});
    if ismember("vel1", joined.Properties.VariableNames) && ismember("vel2", joined.Properties.VariableNames)
        veldifs = rowfun(@minus, joined,...
                         'InputVariables', ["vel1", "vel2"], 'OutputVariableNames', aofld.posveldiff{2});
        difs = innerjoin(posdifs, veldifs);
    else
        difs = posdifs;
    end
end


%% Copyright 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
