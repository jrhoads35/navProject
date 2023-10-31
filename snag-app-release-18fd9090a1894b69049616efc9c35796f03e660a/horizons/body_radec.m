% Major body right ascension, declination, and solar phase angle, returns a timetable. Optionally, specify an observer site; in this case, the right ascension and declination are topocentric.
% object    = The ID# (code) for the object, or the name of the object;
%             if the name is ambiguous, all possible matches are listed and the function returns empty.
%             Using ID# (vs. a unique string) is faster.
% dt_begin  = Datetime at the beginning of the table; default is the next even minute
% dt_end    = Datetime at the end of the table, default gives the dt_begin time only, in which case a structure is returned with the information for that time only
% step_interval = Interval as a string, either as a Matlab duration or a number followed by unit "m"=minutes, "h"=hours, "d"=days, default "1h"
% site  = Observation site lla; default is earth center
function tbl = body_radec(object, dt_begin, dt_end, step_interval, site)
% Get the ID#
    bc=bodycode(object);
    if isempty(bc)
        tbl = [];
        return
    end
    if ~exist('dt_begin','var')
        dt_begin = nowutc;
    end
    if ~exist('step_interval','var')
        step_interval = "1h";
    elseif isduration(step_interval)
        step_interval = sprintf("%dm", round(minutes(step_interval)));
    end
    if ~exist('dt_end','var')
        dt_end = dt_begin + minutes(1);
        single = true;
    else
        single = false;
    end
    % Query the JPL Horizons server
    tstart = datestr(dt_begin, ori.iso8601_fmt_w);
    tstop  = datestr(dt_end, ori.iso8601_fmt_w);
    tstep = step_interval;
    if exist('site','var')
        % Given observer site, so compute topocentric values for that site
        if isstring(site)
            qstring = sprintf("&COMMAND='%d'&OBJ_DATA='YES'&MAKE_EPHEM='YES'&EPHEM_TYPE='OBSERVER'&ANG_FORMAT='DEG'&CENTER='%s@399'&START_TIME='%s'&STOP_TIME='%s'&STEP_SIZE='%s'&QUANTITIES='1,43'", ...
                             bc, site, tstart, tstop, tstep);
        else
               qstring = sprintf("&COMMAND='%d'&OBJ_DATA='YES'&MAKE_EPHEM='YES'&EPHEM_TYPE='OBSERVER'&ANG_FORMAT='DEG'&CENTER='coord@399'&COORD_TYPE=GEODETIC&SITE_COORD='%d,%d,%d'&START_TIME='%s'&STOP_TIME='%s'&STEP_SIZE='%s'&QUANTITIES='1,43'", ...
                             bc, site.longitude_deg, site.latitude_deg, site.altitude_m, ...
                                 tstart, tstop, tstep);
        end
    else
        % No observer site, so compute geocentric values
        qstring =    sprintf("&COMMAND='%d'&OBJ_DATA='YES'&MAKE_EPHEM='YES'&EPHEM_TYPE='OBSERVER'&ANG_FORMAT='DEG'&CENTER='500@399'&START_TIME='%s'&STOP_TIME='%s'&STEP_SIZE='%s'&QUANTITIES='1,43'", ...
                             bc, tstart, tstop, tstep);
    end
    query = char(escape_url(qstring));
    url = [services.horizons_base_url '?format=json' query];
    try
        res = webread(url).result;
    catch
        error("The Horizons server returned an error from the request %s", url);
    end

    % Check for valid results
    lines = split(extractBetween(res, ['$$SOE' newline], [newline '$$EOE']),newline);
    if isempty(lines)
        lines = split(res, newline);
        error(['Horizons server returned no usable ephemeris table' newline ...
               'Message from server: ' lines{end-1}])
    end

    % Extract the information and create a timetable
    for li=1:height(lines)
        line = lines{li};
        colons = find(ismember(line, ':'), 2);
        if size(colons,2) == 1
            endtime = 18;
            infmt = 'yyyy-MMM-dd HH:mm';
        else
            if strcmp(line(colons(2)+3), '.') % fractional seconds
                endtime = 24;
                infmt = 'yyyy-MMM-dd HH:mm:ss.SSS'; % Horizons truncates milliseconds, but uses 0.01s
            else
                endtime = 21;
                infmt = 'yyyy-MMM-dd HH:mm:ss';
            end
        end
        ca{li,1} = datetime(line(2:endtime),'InputFormat',infmt);                    % timestamp
        ca{li,2} = str2double(line(endtime+6:endtime+14)); % right ascension in degrees
        ca{li,3} = str2double(line(endtime+16:endtime+24)); % declination in degrees
        ca{li,4} = str2double(line(endtime+26:endtime+34)); % solar phase angle in degrees
    end
    tbl1=cell2table(ca);
    tbl1.Properties.VariableNames = {'epoch','right_ascension_deg','declination_deg', 'solar_phase_deg'};
    tbl = table2timetable(tbl1);
    if single
        tbl = epochstruct(tbl);
    end
end

%%================================================================================
%% Copyright 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
