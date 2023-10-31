% join_ephemeris Create a single ephemeris table for two ephemerides with common times; may be states or locations
function j = join_ephemeris(ephem1, ephem2)
    if ismember("velocity_ms", ephem1.Properties.VariableNames)
        t1 = renamevars(ephem1, ["position_m", "velocity_ms"],["pos1", "vel1"]);
    else
        t1 = renamevars(ephem1, ["position_m"],["pos1"]);
    end
    if ismember("velocity_ms", ephem2.Properties.VariableNames)
        t2 = renamevars(ephem2, ["position_m", "velocity_ms"],["pos2", "vel2"]);
    else
        t2 = renamevars(ephem2, ["position_m"],["pos2"]);
    end
  j = innerjoin(t1,t2);
  j.Properties.DimensionNames{1}='epoch';
end



%%================================================================================
%% Copyright 2020, 2022 Liam M. Healy
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
