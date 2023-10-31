% sync Synchornize the orbit(s) to a single time
% Input
%  orbits: initial orbital state(s), as a struct array or structure. Optionally each orbit can specify a `force_model` field.
%  totime: the time to synchronize the orbits to
%  force_model: a structure with force model parameters returned by `force_model()`
%               This is an optional argument and defaults to two-body propagation.
%               It does not matter what the force_model is when spacetrack orbits are being propagated.
%  accleration Whether to include acceleration; true or false (optional; default false)
% Output is a structure array of PVTs;
% if there was an error from `propagate` (e.g., totime < epoch), the position and velocity with both be [0 0 0].
function pvts = sync(orbits, totime, force_model, acceleration)
    if ~exist('force_model','var')
        force_model_all = constants.force_twobody;
    end
    if ~exist('acceleration','var')
        acceleration = false;
    end

    totime.TimeZone = 'Z';
    zeropvt.epoch = totime;
    zeropvt.velocity_ms = [0 0 0];
    zeropvt.position_m = [0 0 0];

    num = size(orbits,1);

    if num == 1
        pvts = prop1(orbits, totime, force_model, acceleration);
    else
        for i=1:num
            orb = orbits(i);
            if isfield(orb,'force_model')
                fm = orb.force_model;
            else
                fm = force_model_all;
            end
            try
                pvts(i,:) = prop1(orb, totime, fm, acceleration);
            catch
                pvts(i,:) = zeropvt;
            end
        end
    end
end

function orbst = prop1(orbit, totime, force_model, acceleration)
    stept = minutes(1);
    tt = dateshift(totime,'end','minute') + stept;
    tbl = propagate(orbit, true, tt, stept, force_model, acceleration);
    orbst = pvt1(ephemeris_interp(tbl, totime),totime);
end

%%================================================================================
%% Copyright 2020, 2021, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
