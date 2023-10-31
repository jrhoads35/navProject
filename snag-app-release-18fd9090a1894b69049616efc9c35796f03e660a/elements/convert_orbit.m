% convert_orbit Convert the orbit between different respresentations
%  orbit = an orbit represenation as an orbital element set or pvt
%  output_form = One of st.cartesian, st.kepler, st.circular, st.equinoctial
%  to_mean = true for the mean time element, false for the true time element (default)
function converted = convert_orbit(orbit, output_form, to_mean)
    conversion_s = orbbull(orbit);
    conversion_s.toType = output_form;
    if ~exist('to_mean','var')
        to_mean = false;
    end
    if to_mean
        conversion_s.positionAngleOut = st.mean_anomaly;
    else
        conversion_s.positionAngleOut = st.true_anomaly;
    end
    url = [services.oraas_base_url '/orbit/convert?json='...
	   escape_url(jsonencode(conversion_s))];
    orout = webread(url);
    converted = convels(orout, to_mean);
end

%%================================================================================
%% Copyright 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
