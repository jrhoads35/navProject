function orbels = equinoctial_oes(epoch, semimajor_axis_m,...
				  eccentricity_x,...
				  eccentricity_y,...
				  inclination_x,...
				  inclination_y,...
			          time_element_deg, is_mean)
    if ~exist('is_mean','var')
        is_mean = false;
    end
    rp = (1 - sqrt(eccentricity_x^2 + eccentricity_y^2)) * semimajor_axis_m;
    if rp < constants.earth_radius_m
        error('state:perigee_inside_earth',...
              'Radius of perigee %d meters is less than the radius of the earth', rp);
    end
    orbels.epoch = epoch;
    orbels.semimajor_axis_m = semimajor_axis_m;
    orbels.eccentricity_x = eccentricity_x;
    orbels.eccentricity_y = eccentricity_y;
    orbels.inclination_x = inclination_x;
    orbels.inclination_y = inclination_y;
    if is_mean
        orbels.mean_longitude_deg = time_element_deg;
    else
        orbels.true_longitude_deg = time_element_deg;
    end
end

%%================================================================================
%% Copyright 2020, 2021, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
