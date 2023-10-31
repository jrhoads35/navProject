% Returns the local and Greenwich mean sidereal time
% st = siderealtime(nowutc, stddef.umd_lla)
function st = siderealtime(datetime, lla)
    if ~exist('lla','var')
        lla = geoloc(0, 0, 0, "");
    end
    [yr,mo,dy] = ymd(datetime);
    [hr,mn,sc] = hms(datetime);
    qstring = sprintf("/siderealtime?date=%d/%d/%d&coords=%f,%f&reps=1&intv_mag=1&intv_unit=seconds&time=%d:%d:%f", ...
                      mo, dy, yr, lla.latitude_deg, lla.longitude_deg, hr, mn, sc);
    url = [services.usno_base_url char(escape_url(qstring))];
    try
        resp = webread(url).properties.data;
        st = [rahms(resp.lmst) rahms(resp.gmst)];
    catch
        error("The USNO server returned an error from the request %s", url);
    end
end

% Read hr:mn:sc of right ascension angle in degrees
function deg = rahms(str)
    deg = 15*(str2num(str(1:2)) + str2num(str(4:5))/60 + str2double(str(7:13))/3600);
end

%%================================================================================
%% Copyright 2022, 2023 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
