% Return the position(s) as column vector(s)
function vec = pos(object)
    if ispt(object)
        vec = object.position_m';
    else
        error('Unable to find position(s) from the object');
    end
end

%%================================================================================
%% Copyright 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
