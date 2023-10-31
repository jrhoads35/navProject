% to_tle Convert to a two-line element set from another orbit representation
%  orbit = an orbit represenation as an orbital element set or pvt
function converted = to_tle(orbit, force_model)
    if ~exist('force_model','var') % Default force model is two-body
        force_model = constants.force_twobody;
    end
    conversion_s = orbbull(orbit);
    conversion_s.orbitBulletin;
    conversion_s.numericalPropagator = force_model;
    url = [services.oraas_base_url '/tle/generate?json='...
	   escape_url(jsonencode(conversion_s))];
    orout = webread(url);
    msg = error_return(orout);
    if contains(msg,"Server returned")
        disp("Possibly singular element set")
        error(msg);
    else
        converted.tle = orout;
    end
end

%%================================================================================
%% Copyright 2022, 2023 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
