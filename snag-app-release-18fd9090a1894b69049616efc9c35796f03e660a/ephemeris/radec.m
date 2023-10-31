% Find the right ascension, declination, and radial distance for the ECI location
function pt = radec(pt)
    if ispt(pt)
        if istimetable(pt)
            for i=1:height(pt)
                row(i) = radec(pvt1(pt,i));
            end
            pt = epochtable(row);
        else
            [ra dec radius] = cart2sph(pt.position_m(1),pt.position_m(2),pt.position_m(3));
            pt.right_ascension_deg = rad2deg(ra);
            pt.declination_deg = rad2deg(dec);
            pt.geocentric_dist_m = radius;
        end
    else
        error("Argument must be a PT")
    end
end

%% Copyright 2021, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
