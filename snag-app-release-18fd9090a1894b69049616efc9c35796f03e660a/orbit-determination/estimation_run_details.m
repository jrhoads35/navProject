% estimated_orbit  Returns the messages from the run submitted in
%                 `determine_orbit`, either a structure giving the
%                 Cartesian estimated orbit and epoch, along with the
%                 rejection rate, or an error message from the run.
function det = estimation_run_details(run_number)
  global oraas_token
  options = weboptions('KeyName','Cookie','KeyValue', strcat('guid=',oraas_token));
  url= [services.oraas_od_url '/' num2str(run_number) '/details'];
  oret = webread(escape_url(url),options);
  if isstruct(oret) && isfield(oret,'runId')
    det = oret.report.messages;
  else % There is an error or errors returned by ORaaS
    det = error_return(oret);
  end
end

%%================================================================================
%% Copyright 2020, 2021 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
