% hasepoch  The object has an epoch field or is a datetime
function bool = hasepoch(obj)
  bool = isdatetime(obj) || hasfields(obj,aofld.epoch);
end

%%================================================================================
%% Copyright 2020, 2021 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
