function obull = circular_to_orbbull(circoes)
    if isfield(circoes, 'mean_argument_latitude_deg')
        time_element_deg = circoes.mean_argument_latitude_deg;
        time_element_type = st.mean_anomaly;
    else
        time_element_deg = circoes.argument_latitude_deg;
        time_element_type = st.true_anomaly;
    end
    obull = ...
        struct('orbitBulletin', ...
	       struct('date', datestr(circoes.epoch, ori.iso8601_fmt_w), ...
		      'timeScale', "UTC", ...
		      'eciFrameName', ori.gcrf_s.frameName, ...
		      'circular', struct('a', circoes.semimajor_axis_m,...
				         'ex', circoes.eccentricity_x,...
				         'ey', circoes.eccentricity_y,...
				         'i', deg2rad(circoes.inclination_deg),...
				         'raan', deg2rad(circoes.raan_deg),...
				         'alpha', deg2rad(time_element_deg),...
				         'positionAngle', time_element_type)));
end

%%================================================================================
%% Copyright 2022, 2023 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later