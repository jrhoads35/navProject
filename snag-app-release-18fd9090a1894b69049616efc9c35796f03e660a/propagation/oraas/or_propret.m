% or_propret Internal function to process return values from ORaaS propagate>propagate
% Returns an ephemeris as a Matlab timetable.
function ephemeris = or_propret(ephem_struct, ref_for_relative)
  if size(ephem_struct,1) > 1
    ephemt = struct2table(ephem_struct);
    timestamps = datetime_iso8601(cell2mat(ephemt.d));
    if exist('ref_for_relative','var') && isdatetime(ref_for_relative)
      refdttm = ref_for_relative;
    else
      refdttm = timestamps(1);
    end
    ephems = pvt(timestamps, mattimexvec(ephemt.p), mattimexvec(ephemt.v));
    if isfield(ephem_struct, 'a')
      ephems = setfield(ephems,'acceleration_mss', mattimexvec(ephemt.a));
    end
    elapsed_s = seconds(timestamps - refdttm);
    last_s = [0; elapsed_s(1:end-1)];
    for i=1:height(ephems)
      ephems(i,1).elapsed_s = elapsed_s(i);
      ephems(i,1).deltat_s = elapsed_s(i) - last_s(i);
    end
    if isfield(ephem_struct,'t')
      for i=1:size(ephem_struct,1)
	ephems(i,1).event = string(getfield(ephem_struct(i),'t'));
      end
    end
  elseif size(ephem_struct,1) == 1
      ephems = pvt(datetime_iso8601(ephem_struct.d), ephem_struct.p', ephem_struct.v');
  else
    ephems = pvt([],[],[]);
    ephems.elapsed_s = [];
    ephems.deltat_s = [];
  end
  ephemeris = epochtable(ephems);
  function v = mattimexvec(cellarray)
    v = cell2mat(cellarray')';
  end
end


%%================================================================================
%% Copyright 2020, 2021, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
