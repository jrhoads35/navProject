%% The object has position, velocity and epoch time
function haspvt = ispvt(object)
  haspvt = hasepoch(object) && (hasfields(object, aofld.posvel) || hasfields(object, aofld.posveldiff));
end


%%================================================================================
%% Copyright 2021, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
