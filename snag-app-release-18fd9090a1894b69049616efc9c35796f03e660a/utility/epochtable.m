% epochtable  Convert a structure array to a time table
function tb = epochtable(struct)
  stb = struct2table(struct);
  if isempty(stb)
    %% Create an empty table
    fldnm = fieldnames(struct);
    tct = tablecolumntypes;
    for i=1:height(fldnm)
      names(i,1) = string(fldnm{i});
      types(i,1) = getfield(tct,fldnm{i});
    end
    tb = table2timetable(table('Size',[0,height(fldnm)],...
			       'VariableNames', names,	'VariableTypes', types));
  else
    tb = table2timetable(stb);
  end
end



%%================================================================================
%% Copyright 2020, 2021, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
