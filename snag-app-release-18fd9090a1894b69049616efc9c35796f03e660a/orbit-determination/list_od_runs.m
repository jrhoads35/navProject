% estimated_orbit  Returns a list of the runs and their status
%                  submitted in `determine_orbit`.
function list = list_od_runs()
  global oraas_token
  options = weboptions('KeyName','Cookie','KeyValue', strcat('guid=',oraas_token));
  url= [services.oraas_od_url '/status'];
  response = webread(escape_url(url),options);
  lst.id = arrayfun(@(p) str2num(p.id), response);
  lst.status = arrayfun(@(p) string(p.status), response);
  list = struct2table(lst);
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
