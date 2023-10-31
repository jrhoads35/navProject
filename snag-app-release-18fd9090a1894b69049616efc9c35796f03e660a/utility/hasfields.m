% hasfields The argument represents a thing defined by a list of
%           fields/columns. See `aofld` for a definition of
%           astrodynamic quantities
%
% Input
% obj     The structure, table, or timetable
% fields  A cell array of the fields/columns
function bool = hasfields(obj, fields)
  if any(strcmp(class(obj),{'struct'; 'table'; 'timetable'}))
    intsec = intersect(fields, fieldnames(obj));
    bool = ~isempty(intsec) && size(fields,1) == size(intsec, 1);
  else
    bool = false;
  end
end

%%================================================================================
%% Copyright 2021 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
