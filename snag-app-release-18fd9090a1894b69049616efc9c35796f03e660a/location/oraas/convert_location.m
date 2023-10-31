% convert_location Convert the location from its defined frame to a new frame.
% Frames for input and output
%  azel_s           Topocentric azimuth, elevation, range
%  geographic_s     A geographic location latitude, longitude, altitude
%  cartesian_s      Cartesian reference frame, 3-vector in meters
% Input
%  datetime         A Matlab datetime defining the frame, time scale is UTC
%  location_s       One of azel_s, geographic_s, or cartesian_s structures
%  output_frame_s   The output frame desired
% Output
%  converted        The location converted to the requested output_frame_s

function converted = convert_location(datetime, location_s, output_frame_s)
  conversion_s = output_frame_s;
  conversion_s.date = datestr(datetime, ori.iso8601_fmt_w);
  conversion_s.timeScale = "UTC";
  conversion_s.location = location_s;
  url = [services.oraas_base_url '/location/convert?json='...
		  escape_url(jsonencode(conversion_s))];
  converted = webread(url);
end




%%================================================================================
%% Copyright 2020 Liam M. Healy
%% This file is part of SNaG-app.

%% SNaG-app is free software: you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published by
%% the Free Software Foundation, either version 3 of the License, or
%% (at your option) any later version.

%% SNaG-app is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.

%% You should have received a copy of the GNU General Public License
%% along with SNaG-app.  If not, see <https://www.gnu.org/licenses/>.
