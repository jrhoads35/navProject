% propagate_spacetrack_multi Propagate an orbit from multiple spacetrack records
function prop = propagate_spacetrack_multi(records, step_duration)
  sattable = struct2table(records);
  epochs = sattable{:,'epoch'};
  starttm = dateshift(epochs(1),'end','hour');
  cat.epoch = [];
  cat.position_m = [];
  cat.velocity_ms = [];
  numrec = size(epochs,1);
  for i=1:numrec
    if i<numrec
      endtm = epochs(i)+(epochs(i+1)-epochs(i))/2;
    else
      endtm = epochs(numrec);
    end
    prop1 = propagate(struct('tle',records(i).tle), ...
		   starttm, endtm, seconds(step_duration),...
		   constants.force_twobody); % Force model is ignored in TLE propagation
    %% What happens if propagate returns no results?
    if size(prop1.position_m,2)==1 % prop1 has one result, which Matlab then transposes
      prop1.position_m = prop1.position_m';
      prop1.velocity_ms = prop1.velocity_ms';
    end
    cat.epoch = [cat.epoch; prop1.epoch];
    cat.position_m = [cat.position_m; prop1.position_m];
    cat.velocity_ms = [cat.velocity_ms; prop1.velocity_ms];
    starttm = prop1.epoch(size(prop1.epoch,1)) + step_duration;
  end
  prop = cat;
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
