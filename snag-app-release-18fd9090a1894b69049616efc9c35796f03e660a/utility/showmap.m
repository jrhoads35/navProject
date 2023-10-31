%%% Show the geographic location on a map in a web browser
function showmap(lla)
    url = sprintf("%s%f;%f",...
		  services.geohack_url, lla.latitude_deg, lla.longitude_deg);
    web(url);
end

%%================================================================================
%% Copyright 2020, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
