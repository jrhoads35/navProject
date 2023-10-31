function subtable = nopv(table)
    subtable = select_columns(table, ["position_m", "velocity_ms"], true);
end

%%================================================================================
%% Copyright 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
