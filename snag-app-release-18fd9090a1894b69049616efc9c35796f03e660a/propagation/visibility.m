% visibility Determine visibility events (transition in and out) for a particular earth location
% Input
%  orbit: orbit specification
%  tstart: Specification of time to start
%  tend:   Specification of time to end
%  sites:       The observation site as returned by the function `geoloc()`,
%               or an array of such sites.
%  force_model: a structure with force model parameters returned by `force_model()`
%               This is an optional argument and defaults to two-body propagation.
%               It does not matter what the force_model is when TLEs are being propagated.
% Output is a structure with three fields
%  name:               The name given to the site
%  always_visible:     True if visible for the whole time interval
%  visibility_changes: A structure with five fields; all are arrays with one row for each event.
%    event:      Name of the event, 'aos' for "acquisition of sight", 'los' for "loss of sight".
%    position_m:  ECI position (meters) of the satellite at the event.
%    velocity_ms: ECI velocity (meters/second) of the satellite at the event.
%    times:      Datetime (UTC) at which the event occured.
%    elapsed:    Elapsed time in seconds from the starting time `start_dttm`.
% Examples
%  osu = geoloc(40.0000, -83.0219, 400, "OSU", 5)
%  umd = geoloc(38.988933, -76.937115, 42, "UMd",10)
%  iss.orbit = spacetrack(25544)
%  iss.umdosu_vis24 = visibility(iss.orbit, true, hours(24), [umd osu])
%  iss.umdosu_vis4 = visibility(iss.orbit, true, hours(4), [umd osu])
%  iss.umd_vis24 = visibility(iss.orbit, true, hours(24), umd)
%  iss.umd_vis4 = visibility(iss.orbit, true, hours(4), umd)
function vis = visibility(orbit, tstart, tend, sites, force_model)
  if ~exist('force_model','var')
    force_model = constants.force_twobody;
  end
  sts = arrayfun(@(x) getfield(x,"geo"),sites);
  if size(sts,2) == 1
    output = struct('events', struct('visibilities', {{sts}}));
  else
    output = struct('events', struct('visibilities', sts));
  end
  oraasreturn = or_propprop(orbit, tstart, tend, 1, force_model, output);
  if isstruct(oraasreturn) && isfield(oraasreturn,'visibilities')
    for i=1:size(oraasreturn.visibilities,1)
      ephem_struct = oraasreturn.visibilities(i);
      vis(i).name = arrayfun(@(p) string(p.name), ephem_struct);
      vis(i).always_visible = arrayfun(@(p) p.alwaysVisible, ephem_struct);
      vis(i).visibility_changes = or_propret(ephem_struct.events);
      if isempty(ephem_struct.events)
	vis(i).never_visible = ~vis.always_visible;
      else
	vis(i).never_visible = false;
      end
    end
  else % There is an error or errors returned by ORaaS
    vis = error_return(oraasreturn);
  end
end


%%================================================================================
%% Copyright 2020, 2021, 2023 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
