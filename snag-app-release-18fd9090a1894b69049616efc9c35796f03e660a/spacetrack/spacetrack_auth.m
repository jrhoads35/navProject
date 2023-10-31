%% spacetrack_auth  Set username and password space-track.org access
%%                  Each argument should be enclosed in single or double quotes.
%%                  To clear information, use any argument other than in single or double quotes
%% Example
%%  spacetrack_auth("spacetrackuser@example.com", "wlrjdls809w3r")
%%  st_userpass % check the results- not necessary
%%    ans =
%%      1x2 string array
%%      "spacetrackuser@example.com"    "wlrjdls809w3r"
%%  spacetrack_auth(false, false)
%%    Cleared space-track.org username and password
%%  st_userpass
%%    Error using st_userpass (line 5)
%%    Set space-track.org username and password
function spacetrack_auth(username, password)
  global stauth
  if ~(isstring(username) || ischar(username))
    disp("Cleared space-track.org username and password")
    clear global stauth;
    return
  end
  stauth.username = string(username);
  stauth.password = string(password);
end

%%================================================================================
%% Copyright 2020, 2021 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
