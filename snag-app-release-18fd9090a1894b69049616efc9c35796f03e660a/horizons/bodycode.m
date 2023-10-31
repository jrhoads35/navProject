% Find the Horizons major body code by name or number
function bc=bodycode(object)
    if isnumeric(object)
        bc = object;
    else
        codes = webread([services.horizons_base_url '?format=json&COMMAND=' char(object)]).result;
        if contains(codes,"Multiple")
            disp(['Ambiguous specification of object; use one of the following ID#' newline codes]);
            bc=[];
            return
        else
            line2=extractBetween(codes,"Revised:",newline);
            bc=str2double(line2{1}(end-5:end));
            disp(['Body code is ' num2str(bc)]);
        end
    end
end

%%================================================================================
%% Copyright 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
