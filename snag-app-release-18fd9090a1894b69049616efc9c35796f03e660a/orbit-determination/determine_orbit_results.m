% determine_orbit_results    Retrieve results from orbit determination run
function results = determine_orbit_results(run_number)
  results.details = estimation_run_details(run_number);
  results.estimated = estimated_orbit(run_number);
  results.residuals = epochtable(residuals(run_number));
end
