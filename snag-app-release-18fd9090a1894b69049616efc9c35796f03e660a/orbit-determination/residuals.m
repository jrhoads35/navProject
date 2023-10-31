% estimated_orbit  Returns the result of the run submitted in
%                 `determine_orbit`, either a structure giving the
%                 Cartesian estimated orbit and epoch, along with the
%                 rejection rate, or an error message from the run.
function resid = residuals(run_number)
  global oraas_token
  options = weboptions('KeyName','Cookie','KeyValue', strcat('guid=',oraas_token));
  url= [services.oraas_od_url '/' num2str(run_number) '/residuals'];
  oret = webread(escape_url(url),options);
  if isstruct(oret) && isfield(oret,'type')
    if strcmp(oret.type, 'azel')
      oresids = oret.stations.residuals;
      resid.datetime = arrayfun(@(p) datetime_iso8601(p.date), oresids);
      resid.azimuth_rdn = arrayfun(@(p) p.angle1, oresids);
      resid.elevation_rdn = arrayfun(@(p) p.angle2, oresids);
      resid.rejected = arrayfun(@(p) p.rejected, oresids);
    else
      resid = oret;
    end
  else % Nothing returned
    resid = 'No residuals computed';
  end
end

%%================================================================================
%% Copyright 2020, 2021 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
