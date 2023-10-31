% conjunction Times of closest approach, with separation distance,
% relative postion (secondary from primary reference frame) and relative velocity.
function tbl = conjunction(primary_orbit, secondary_orbit, tstart, tend, force_model)
    if ~exist('force_model','var')
        force_model_all = constants.force_twobody;
    else
        force_model_all = force_model;
    end

    %% Set starting and ending times
    [atm btm] = interval_time(tstart, tend, epoch(primary_orbit));
    if ~(isdatetime(atm) && isdatetime(btm))
        error('prop:bad_times',"Incorrect starting or ending time of the propagation");
    end

    %% ORaaS initial orbit must be one of orbitBulletin, tle or ephemeris.
    reforb = orbbull(primary_orbit);
    if isfield(primary_orbit,'force_model') && ~isempty(primary_orbit.force_model)
        reforb.numericalPropagator = primary_orbit.force_model;
    else
        reforb.numericalPropagator = force_model_all;
    end
    secorb = orbbull(secondary_orbit);
    if isfield(secondary_orbit,'force_model') && ~isempty(secondary_orbit.force_model)
        secorb.numericalPropagator = secondary_orbit.force_model;
    else
        secorb.numericalPropagator = force_model_all;
    end
    call_arguments = struct('primary', reforb, ...
                            'secondary', secorb, ...
			    'from',datestr(atm, ori.iso8601_fmt_w),...
			    'to',datestr(btm, ori.iso8601_fmt_w),...
			    'timeScale', constants.timescale);
    url= [services.oraas_base_url '/approach/tca?json=' jsonencode(call_arguments)];
    if checkserver
        options = weboptions;
        options.Timeout = services.timeout;
        structret = webread(escape_url(url),options);
        if isfield(structret,'messages')
            error(strcat('Message from server: ', structret.messages{1}))
        end
        stc = struct2cell(structret.tcaList);
        conjlist.epoch = datetime_iso8601(stc(1,:))';
        conjlist.distance_m = cell2mat(stc(2,:))';
        conjlist.rel_position_m = cell2mat(stc(3,:))';
        conjlist.rel_velocity_ms = cell2mat(stc(4,:))';
        tbl = epochtable(conjlist);
    else
        error("Error: server failure");
    end
end


%%================================================================================
%% Copyright 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
