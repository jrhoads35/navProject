 % or_propprop Internal function to marshal arguments for ORaaS propagate>propagate
function oraasreturn = or_propprop...
	(orbit, tstart, tend, step_size_s, force_model, output)

  %% Set starting and ending times
  initorb = orbbull(orbit);
  eporb = epoch(initorb);
  [atm btm] = interval_time(tstart, tend, eporb);
  if ~(isdatetime(atm) && isdatetime(btm))
    error('prop:bad_times',"Incorrect starting or ending time of the propagation");
  end

  %% ORaaS initial orbit must be one of orbitBulletin, tle or ephemeris.
  initorb = orbbull(orbit);
  call_arguments = struct('orbitalData', initorb,...
			  'numericalPropagator', force_model, ...
			  'from',datestr(atm, ori.iso8601_fmt_w),...
			  'to',datestr(btm, ori.iso8601_fmt_w),...
			  'timeScale', "UTC",...
			  'stepSize', step_size_s, ...
			  'outputFrame', ori.gcrf_s);
  if isstruct(output)
    fields = fieldnames(output);
    call_arguments = setfield(call_arguments, fields{1}, getfield(output, fields{1}));
  end
  url= [services.oraas_base_url '/propagation?json=' jsonencode(call_arguments)];
  if checkserver
    options = weboptions;
    options.Timeout = services.timeout;
    oraasreturn = webread(escape_url(url),options);
  else
    error("Error: server failure");
  end
end


%%================================================================================
%% Copyright 2020, 2021, 2022, 2023 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
