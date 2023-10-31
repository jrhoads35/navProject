% aer  Find the azimuth-elevation-range
% Input
%  location      The location in the form of eci or lla
%  observer_lla  The observer location lla corresponding to input aer observation, leave off if converting from lla
% Output
%  aer            Structure or table with {'azimuth_deg'; 'elevation_deg'; 'range_m'}

function aer = aer(location, observer_lla)
  %% ECI to aer
  if hasfields(location, aofld.pos) && hasepoch(location)
    switch class(location)
    case 'timetable'
      aer = ephemeris_aer(location, observer_lla);
    case 'struct'
      for i = 1:size(location,1)
	epoch = getfield(location(i),aofld.epoch{1});
	aerst = eci_to_azelrn(epoch, getfield(location(i), aofld.pos{1}), observer_lla);
	aerst.epoch = epoch;
	%%setfield(aerst,'epoch',epoch); % does not work; epoch disappears
	aersts(i) = aerst;
      end
      aer = aersts';
    end
  else
    if hasfields(location, aofld.lladeg) && hasepoch(location)
      switch class(location)
	case 'timetable'
	  for i = 1:size(location,1)
	    aertbl = lla_to_azelrn(location.epoch(i), table2struct(location(i,:)));
	    aerst(i) = aertbl;
	    aerst(i).epoch = location(i).epoch;
	  end
	  aer = epochtable(aerst);
	case 'struct'
	  for i = 1:size(location,1)
	    aervec = lla_to_azelrn(location(i).epoch, location(i));
	    aerst(i) = aervec;
	    aerst(i).epoch = location(i).epoch;
	  end
	  aer = aerst;
      end
    else
      if hasfields(location, aofld.aerdeg) && hasepoch(location)
	aer = location;
      end
    end
  end
end

function azelrn = eci_to_azelrn(datetime, eci_m, obsloc_lla)
  cart_s = struct('frame', ori.gcrf_s);
  cart_s.x = eci_m(1);
  cart_s.y = eci_m(2);
  cart_s.z = eci_m(3);
  observation_location = topocentric_frame_s(geographic_s(obsloc_lla), "none");
  azelotf = struct('azElOutputTopocentricFrame', observation_location.topocentricFrame);
  azel_s  = convert_location(datetime, struct('cartesian', cart_s), azelotf);
  oraas_azelrn = azel_s.azEl;
  azelrn = azelrn_rdn(oraas_azelrn.azimuth, oraas_azelrn.elevation, oraas_azelrn.distance);
end

function aertt = ephemeris_aer(ephemeris_table, observation_location_lla)
  for i = 1:size(ephemeris_table,1)
    aerstructs(i) = eci_to_azelrn(ephemeris_table.epoch(i),...
				  ephemeris_table.position_m(i,:),...
				  observation_location_lla);
  end
  aertbl = struct2table(aerstructs);
  aertbl.epoch = ephemeris_table.epoch;
  aertbl = movevars(aertbl,'azimuth_rdn','After','range_m');
  aertbl = movevars(aertbl,'elevation_rdn','After','range_m');
  aertt = table2timetable(aertbl);
end

function azelrn = lla_to_azelrn(datetime, lla, obsloc_lla)
  observation_location = topocentric_frame_s(geographic_s(obsloc_lla), "none");
  azelotf = struct('azElOutputTopocentricFrame', observation_location.topocentricFrame);
  oraaslla = geographic_s(lla);
  azel_s  = convert_location(datetime, oraaslla, azelotf);
  oraas_azelrn = azel_s.azEl;
  azelrn = azelrn_rdn(oraas_azelrn.azimuth, oraas_azelrn.elevation, oraas_azelrn.distance);
end

%% iss.orbit = spacetrack_orbit(25544)
%% iss.ephem = propagate(iss.orbit, hours(2), minutes(10), true)
%% iss.umd_aer = aer(iss.ephem, stddef.umd_lla)
%% iss.ephs = epochstruct(iss.ephem)
%% These will come out the same:
%%  iss.ephs_umd_aer1 = aer(iss.ephs, stddef.umd_lla)
%%  iss.ephs_umd_aer2 = epochstruct(iss.umd_aer)

%%================================================================================
%% Copyright 2021, 2022 Liam M. Healy
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
