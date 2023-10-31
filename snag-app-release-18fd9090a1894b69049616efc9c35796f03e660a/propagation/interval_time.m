% Set absolute times for an interval from absolute or relative
% terminal times.
function [adttm bdttm] = interval_time(timea, timeb, reference)
  addtm = false;
  bddtm = false;

  %% The starting time
  if isdatetime(timea)
    adttm = timea;
    adttm.TimeZone = 'Z';
  elseif islogical(timea) && timea
    %% If `true`, start at the reference
    adttm = reference;
  elseif ischar(timea)
    %% If the name of a unit of time, (e.g. 'minute'), start at the next even unit after reference
    adttm = dateshift(reference,'end',timea);
  else
    error('Cannot determine starting time');
  end

  %% The ending time
  if isdatetime(timeb)
    bdttm = timeb;
    bdttm.TimeZone = 'Z';
  elseif islogical(timeb) && timeb
    %% If `true`, start at the reference
    bdttm = reference;
  elseif ischar(timeb)
    %% If the name of a unit of time, (e.g. 'minute'), start at the next even unit after reference
    bdttm = dateshift(reference,'end',timeb);
  else
    bdttm = adttm + seconds(1);
  end

  if isduration(timea)
    adttm = bdttm - timea;
  elseif isduration(timeb)
    bdttm = adttm + timeb;
  end
end

%%================================================================================
%% Copyright 2021, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
