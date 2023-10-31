function sat = parse_spacetrack_orbels(parse)
  sat.epoch = datetime_iso8601(parse.EPOCH);
  sat.epoch_age = between(sat.epoch,nowutc);
  sat.semimajor_axis_km = str2num(parse.SEMIMAJOR_AXIS);
  sat.orbital_period = minutes(str2num(parse.PERIOD));
  sat.eccentricity = str2num(parse.ECCENTRICITY);
  sat.apogee_alt_km = str2num(parse.APOAPSIS);
  sat.perigee_alt_km = str2num(parse.PERIAPSIS);
  sat.mean_motion_rdnpersec = 2*pi*str2num(parse.MEAN_MOTION)/constants.secperday;
  sat.mean_motion_dot_rdnpersec2 = 2*pi*str2num(parse.MEAN_MOTION_DOT)/constants.secperday^2;
  sat.mean_anomaly_deg = str2num(parse.MEAN_ANOMALY);
  sat.inclination_deg = str2num(parse.INCLINATION);
  sat.raan_deg = str2num(parse.RA_OF_ASC_NODE);
  sat.arg_perigee_deg = str2num(parse.ARG_OF_PERICENTER);
  sat.ballistic_coeff_m2perkg = 12.7416*str2num(parse.BSTAR);
  sat.norad_cat_id = str2num(parse.NORAD_CAT_ID);
  sat.object_name = parse.OBJECT_NAME;
  sat.object_type = parse.OBJECT_TYPE;
  sat.object_id = parse.OBJECT_ID;
  if isempty(parse.LAUNCH_DATE)
    sat.launch_date = [];
    sat.on_orbit = [];
  else
    sat.launch_date = date_iso8601(parse.LAUNCH_DATE);
    sat.on_orbit = between(sat.launch_date, sat.epoch);
  end
  if isempty(parse.DECAY_DATE)
    sat.decay_date = [];
  else
    sat.decay_date = date_iso8601(parse.DECAY_DATE);
  end
  tle = two_line_elements(string(parse.TLE_LINE1), string(parse.TLE_LINE2));
  sat.tle = tle.tle;
end

%%================================================================================
%% Copyright 2020 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
