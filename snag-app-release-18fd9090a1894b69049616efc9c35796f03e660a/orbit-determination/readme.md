# Orbit determination

Orbit determination finds an estimated orbit, in the form of an orbital [state](ephemeris.md), from an initial orbit determination and a set of azimuth-elevation [observations](observations.md).

## Computation

The primary function for determining an orbit is `determine_orbit()`. Some orbit determinations can take a long time, so it is structured as a batch job; if the answer is not returned within a specified time, it must be retrieved later from the server.

`determine_orbit(initial_estimate, station, observations, force_model)`

| Argument name      | Description                                                                                      |
|--------------------|--------------------------------------------------------------------------------------------------|
| `initial_estimate` | The initial estimate, expressed as Cartesian state PVT (created with [`pvt()`](ephemeris.md#creation-of-a-position-velocity-time-pvt))|
| `station`          | Observation station information; output of [`geoloc()`](location.md#geographic) |
| `observations`     | A table of [observations](observations.md) with columns `datetime` `azimuth_deg` `elevation_deg` |
| `force_model`      | The force model to be used in estimation; output of [`force_model`](propagation.md#force-model)  |

The output of `determine_orbit()` is a structure with all the input as fields, and the following additional fields

| Argument name | Description                                                                    |
| ------------- | -----------                                                                    |
| `run_number`  | An identification number for the run                                           |
| `details`     | A summary of the least squares iteration steps (from `estimation_run_details`) |
| `residuals`   | A structure with the residual values (from `residuals`)                        |
| `estimated`   | The estimated state (from `estimated_orbit`)                                   |

Each of the functions indicated in parentheses will separately give that part of the results with the run number as input. The set of observations may be [reduced](observations.md) in order to study the effects of different time spans of observations on the computed solution.

Under normal circumstances with fewer than 1000 observations, the results are produced in a few seconds. However, the ORaaS server structures orbit determination as a separate submission and retrieval of result. In the event that the solution is not available within about 40 seconds, a message will be returned on how to check the status using `run_status` and retrieve results with `determine_orbit_results`. It is also possible to list all runs with `list_od_runs`, and from the run number, retrieve any of the results.

Results may be retrieved from the server in a new Matlab session if the function `save_oraas_token`, which takes a `.mat` file name (e.g., `save_oraas_token("token.mat")`) as its only argument, is called before the session is terminated (or variables cleared). On restarting Matlab, [load](https://www.mathworks.com/help/matlab/ref/load.html) this file before proceeding, e.g. `load("token.mat")`. The tokens are valid for about seven days from the _first_ run; after that, the results are no longer available on the server.

## Prediction from solution

The estimated state may be propagated using the [`propagate()`](propagation.md) function. The resultant ephemeris may be interpolated to any set of observation times, whether in the original estimation set or not, with the function [`ephemeris_interp()`](ephemeris.md#ephemeris-functions). The resulting ephemeris table can be converted to azimuth-elevation-range coordinates with the function [`aer()`](location.md#frame-conversion). This is useful for validating the estimate obtained by computing prediction residuals.
