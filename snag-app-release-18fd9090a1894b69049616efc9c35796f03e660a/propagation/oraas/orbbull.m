%% Generate an orbitalData for ORaaS suitable for a propagator
%% "Initial orbit. Either orbitBulletin, tle or ephemeris have to be set."
%% To simplify terminology, we call all these "orbbull".
function orbl = orbbull(orbit)
    if ispvt(orbit)
        %% We convert a PVT to an orbitBulletin here
        orbl = pvt_to_orbbull(orbit);
    elseif isstruct(orbit) && isfield(orbit, 'tle')
        %% TLE strip all non-TLE fields
        orbl.tle = orbit.tle;
    elseif isstruct(orbit) && isfield(orbit, 'orbitBulletin')
        %% Pass orbitBulletin directly
        orbl = orbit;
    elseif isfield(orbit,'argument_perigee_deg') && hasepoch(orbit)
        orbl = kepler_to_orbbull(orbit);
    elseif isfield(orbit,'inclination_deg') && hasepoch(orbit)
        orbl = circular_to_orbbull(orbit);
    elseif isfield(orbit,'inclination_x') && hasepoch(orbit)
        orbl = equinoctial_to_orbbull(orbit);
    else
        error('prop:invalid_orbit',"Error: orbit must be a spacetrack orbit, pvt, or orbital element set");
    end
end

%%================================================================================
%% Copyright 2022, 2023 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
