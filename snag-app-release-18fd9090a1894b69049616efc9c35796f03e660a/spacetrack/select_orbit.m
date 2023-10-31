% select_orbit   Find the orbit information set whose epoch meets the desired criterion.
% Input
%   orbit_information_sets  Orbit information sorted by increasing epoch as returned by `spacetrack_orbit`
%   datetime                Earliest acceptable epoch
%   lastbefore              `true` if `datetime` is an upper bound on the epoch, `false` if lower bound.
% Example
%  iss_oct15_18 = spacetrack_orbit(25544,datetime(2020,10,15),datetime(2020,10,18))
%  select_orbit(iss_oct15_18, datetime(2020,10,15,18,0,0), false) % First orbit on or after 2020-10-15T18:00:00 UTC
%  satA_st = select_orbit(satA_stset, exo2A1{1,"datetime"}, true) % Last epoch before the start of the obs data
function orbinfo = select_orbit(orbit_information_sets, datetime, lastbefore)
  epochs = [orbit_information_sets.epoch]';
  if lastbefore
    indices = find(epochs < datetime);
    if ~isempty(indices)
      index = indices(size(indices,1));
    end
  else % firstafter
    indices = find(epochs >= datetime);
    if ~isempty(indices)
      index = indices(1);
    end
  end
  if ~isempty(indices)
    orbinfo = orbit_information_sets(index);
  else
    disp 'No orbital information sets meet the specified criterion';
    orbinfo = false';
  end
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
