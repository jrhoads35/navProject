% write_tdm_file  Write a CCSDS TDM file for observations from a single site
function write_tdm_file(filename, observations, site_name)
  id = fopen(filename, "wt");
  fprintf(id,"CCSDS_TDM_VERS = 1.0\n");
  fprintf(id,"CREATION_DATE = %s\n",datestr(now,ori.iso8601_fmt_w));
  fprintf(id,"ORIGINATOR = SNaG-app\n\n");
  fprintf(id,"META_START\n");
  fprintf(id,"TIME_SYSTEM = UTC\n");
  fprintf(id,"PARTICIPANT_1 = %s\n", site_name);
  fprintf(id,"MODE = SEQUENTIAL\n");
  fprintf(id,"PATH = 1,2,1\n");
  fprintf(id,"ANGLE_TYPE = AZEL\n");
  fprintf(id,"DATA_QUALITY = VALIDATED\n");
  fprintf(id,"META_STOP\n\n");
  fprintf(id,"DATA_START\n");
  for i=1:size(observations,1)
    fprintf(id, "ANGLE_1 = %s  %8.4f\n",...
	    datestr(observations{i,"datetime"}, ori.iso8601_fmt_w),...
	    observations{i,"azimuth_deg"});
    fprintf(id, "ANGLE_2 = %s  %8.4f\n",...
	    datestr(observations{i,"datetime"}, ori.iso8601_fmt_w),...
	    observations{i,"elevation_deg"});
  end
  fprintf(id,"DATA_STOP\n");
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
