% Select or eliminate the columns specified as a list,
function subtable = select_columns(table, columns, allbut)
    if ~exist('allbut','var')
        allbut = false;
    end
    if allbut
        subtable = removevars(table, columns);
    else
        subtable = table(:,find_column(table, columns));
    end
end

%%================================================================================
%% Copyright 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
