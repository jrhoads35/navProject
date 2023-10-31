% Create a Kepler (classic) orbital element set
% Input
%  epoch                 Epoch as a datetime
%  semimajor_axis_m      Semimajor axis in meters
%  eccentricity          Eccentricity
%  inclination_deg       Inclination in degrees
%  raan_deg              Right ascension of the ascending node in degrees
%  arugment_perigee_deg  Argument of perigee in degrees
%  time_element_deg      Time element value in degrees
%  is_mean (optional)    Element is mean anomaly (true) or true anomaly (false, default)
%
% Example
%   kepler_oes(nowutc, 1.0e7, 0.1, 62.0, 82, 221, 45)
function orbels = kepler_oes(epoch, semimajor_axis_m,...
					     eccentricity,...
					     inclination_deg,...
					     raan_deg,...
					     argument_perigee_deg,...
					     time_element_deg, is_mean)
  if ~exist('is_mean','var')
    is_mean = false;
  end
  rp = (1-eccentricity)*semimajor_axis_m;
  if rp < constants.earth_radius_m
      error('state:perigee_inside_earth',...
            'Radius of perigee %d meters is less than the radius of the earth', rp);
  end
  orbels.epoch = epoch;
  orbels.semimajor_axis_m = semimajor_axis_m;
  orbels.eccentricity = eccentricity;
  orbels.inclination_deg = inclination_deg;
  orbels.raan_deg = raan_deg;
  orbels.argument_perigee_deg = argument_perigee_deg;
  if is_mean
      orbels.mean_anomaly_deg = time_element_deg;
  else
      orbels.true_anomaly_deg = time_element_deg;
  end
end

%%================================================================================
%% Copyright 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
