% Magnitudes of position, velocity, and difference vectors
function mag = pvmag(ephem)
    rownorm = @(mat) vecnorm(mat,2,2);
    mags.epoch = ephem.epoch;
    if hasfields(ephem, aofld.pos)
        mags.mag_position_m = rownorm(getfield(ephem,aofld.pos{1}));
    end
    if hasfields(ephem, aofld.posdiff)
        mags.mag_diff_position_m = rownorm(getfield(ephem,aofld.posdiff{1}));
    end
    if hasfields(ephem, aofld.posvel{2})
        mags.mag_velocity_ms = rownorm(getfield(ephem,aofld.posvel{2}));
    end
    if hasfields(ephem, aofld.posveldiff{2})
        mags.mag_diff_velocity_ms = rownorm(getfield(ephem,aofld.posveldiff{2}));
    end
    if istimetable(ephem)
        mag = epochtable(mags);
    else
        mag = mags;
    end
end


%% Copyright 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
