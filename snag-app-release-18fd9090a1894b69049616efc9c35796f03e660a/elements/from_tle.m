% from_tle Convert from a two-line element set to another orbit representation
%  tle = A two-line element set
%  output_form = One of st.cartesian (default), st.kepler, st.circular, st.equinoctial
%  to_mean = true for the mean time element, false for the true time element (default)
% Example: show where ISS location at spacetrack epoch
%  showmap(lla(from_tle(spacetrack_orbit(25544))))
function converted = from_tle(tle, output_form, to_mean)
    if ~exist('output_form','var')
        output_form = st.cartesian;
    end
    conversion_s.orbitTypeOut = output_form;
    conversion_s.tle = tle.tle;
    conversion_s.eciFrameNameOut = ori.gcrf_s.frameName;
    if ~exist('to_mean','var')
        to_mean = false;
    end
    if to_mean
        conversion_s.positionAngleOut = st.mean_anomaly;
    else
        conversion_s.positionAngleOut = st.true_anomaly;
    end
    url = [services.oraas_base_url '/tle/translate?json='...
	   escape_url(jsonencode(conversion_s))];
    orout = webread(url);
    converted = convels(orout.orbit, to_mean);
end

%%================================================================================
%% Copyright 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
