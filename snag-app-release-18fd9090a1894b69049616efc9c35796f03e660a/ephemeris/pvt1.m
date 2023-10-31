% Select a single point from an ephemeris by epoch or index sequence
% Input
%  ephemeris  An ephemeris, a structure array with (at least) three fields: epoch, position_m, velocity_ms.
%  select     Either a datetime or a sequence number
function state = pvt1(ephemeris, select)
    if ~ispt(ephemeris)
        error('pvt:not_ephemeris',"Not a PT or PVT ephemeris");
    end
    if isdatetime(select)
        select.TimeZone='Z';
        allind = find(ephemeris.epoch >= select);
        if size(allind,1) > 0
            index = allind(1);
        else
            error('No epoch found greater than or equal to the requested datetime %s',select);
        end
    else
        index = select;
    end
    if ~isempty(index)
        if ispvt(ephemeris)
            if ismember(aofld.posdiff{1}, ephemeris.Properties.VariableNames)
                state = pvt(ephemeris.epoch(index),...
		            ephemeris.diff_position_m(index,:),...
		            ephemeris.diff_velocity_ms(index,:));
            else
                state = pvt(ephemeris.epoch(index),...
		            ephemeris.position_m(index,:),...
		            ephemeris.velocity_ms(index,:));
            end
        else
            if ismember(aofld.posdiff{1}, ephemeris.Properties.VariableNames)
                state = pvt(ephemeris.epoch(index), ephemeris.diff_position_m(index,:));
            else
                state = pvt(ephemeris.epoch(index), ephemeris.position_m(index,:));
            end
        end
    else
        state = false;
    end
end

%%================================================================================
%% Copyright 2020, 2021, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
