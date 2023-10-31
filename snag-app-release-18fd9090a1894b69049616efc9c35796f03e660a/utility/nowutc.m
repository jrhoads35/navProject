% The datetime nowish in UTC; if `even` is specified, round to the next even unit ('second', 'minute', 'hour', 'day') or if `true`, do not round, use the exact time. Default is `minute`.
function n = nowutc(even)
    n = datetime('now',TimeZone='Z');
    if ~exist('even','var')
        even = 'minute';
    end
    if even ~= true
        n = dateshift(n,'end',even);
    end
end

%%================================================================================
%% Copyright 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
