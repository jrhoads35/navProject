% determine_orbit    Submit the orbit determination job to ORaaS, with the data in a TDM file
% Input
%  initial_estimate  The initial estimate, expressed as Cartesian state pvt
%  station           Observation station information; output of `geoloc()`
%  observations      A table of observations with columns "datetime" "azimuth_deg" "elevation_deg".
%  force_model       The force model to be used in estimation; output of `force_model`
% Example
%   oapchile = geoloc(-30.1428030000, -70.6945280000, 1500.000000, "OAP-Chile");
%   geo_opt_fm = force_model(4, 4, 0, 0, 1, 1, 1000);
%   initial_est_epoch = datetime_iso8601('2020-08-17T23:00:00.000')
%   initial_est = pvt(initial_est_epoch, [-14391381.6513341,-39634832.3165459, 47290.5689401401], [2889.70970098729, -1049.88980630422, -7.11093568783101]);
%   runnum = determine_orbit(initial_est, oapchile, opt2satAset1, geo_opt_fm);
function results = determine_orbit(initial_estimate, station, observations, force_model)
  tdm_file = tempname;
  write_tdm_file(tdm_file, observations, station.station.name);
  runnum = determine_orbit_tdm(initial_estimate, station, tdm_file, force_model);
  status = false;
  for n=1:20  % Wait for results, a maximum of 40s
    pause(2); % Check every 2s
    if strcmp(run_status(runnum),"DONE")
      status = true;
      break;
    end
  end
  if status
    results = determine_orbit_results(runnum);
    results.run_number = runnum;
    results.station = station;
    results.force_model = force_model;
    results.initial_estimate = initial_estimate;
    results.observations = observations;
  else
    results = sprintf('Run not completed; call determine_orbit_results(%d) when run_status(%d) returns "DONE"', runnum, runnum);
  end
end
