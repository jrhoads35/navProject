%% The object has position and time
function haspt = ispt(object)
  haspt = hasepoch(object) && (hasfields(object, aofld.pos) || hasfields(object, aofld.posdiff));
end


%%================================================================================
%% Copyright 2021, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
