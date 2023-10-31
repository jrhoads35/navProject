% Return the velocity as column vector(s)
function vec = vel(object)
    if ispvt(object)
        vec = object.velocity_ms';
    else
        error('Unable to find velocity(ies) from the object');
    end
end

%%================================================================================
%% Copyright 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
