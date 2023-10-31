% setepoch Set the epoch(s) on the object
function withepoch = setepoch(epoch, object)
    if isstruct(object) && isdatetime(epoch)
        sz = height(epoch);
        if sz > 1
            for i=1:sz
                we(i) = setepoch(epoch(i),object);
            end
            withepoch = epochtable(we);
        else
            withepoch = setfield(object,'epoch',epoch);
        end
  else
    warning("Unable to set epoch");
    withepoch = object;
  end
end

%%================================================================================
%% Copyright 2021, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
