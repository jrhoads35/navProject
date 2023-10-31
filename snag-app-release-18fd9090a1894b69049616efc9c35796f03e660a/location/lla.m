% lla  Find the latitude-longitude-altitude (ECEF spherical polar coordinates)
% Input
%  location       The location in the form of eci or aer
%  reference_lla  The observation location for aer input location; leave off if eci
% Output
%  lla            Structure or table with `latitude_deg`, `longitude_deg`, `altitude_m`

function lla = lla(location, reference_lla)
%% ECI to lla
    if hasfields(location, aofld.pos) && hasepoch(location)
        switch class(location)
          case 'timetable'
	    lla = ephemeris_lla(location);
          case 'struct'
	    for i = 1:size(location,1)
	        epoch = getfield(location(i),aofld.epoch{1});
	        llast = eci_to_lla(epoch, getfield(location(i),aofld.pos{1}));
	        llast.epoch = epoch;
	        %%setfield(llast,'epoch',epoch); % does not work; epoch disappears
	        llasts(i) = llast;
	    end
	    lla = llasts';
        end
        %% lla to lla
    elseif hasfields(location, aofld.lladeg) && hasepoch(location)
        lla = location;
        %% aer to lla
    elseif hasfields(location, aofld.aerdeg) && hasepoch(location)
        switch class(location)
          case 'timetable'
	    for i = 1:size(location,1)
	        llavec = azelrn_to_lla(location.epoch(i), table2struct(location(i,:)), reference_lla);
	        llast(i) = llavec;
	        llast(i).epoch = location(i).epoch;
	    end
	    lla = epochtable(llast);
          case 'struct'
	    for i = 1:size(location,1)
	        llavec = azelrn_to_lla(location(i).epoch, location(i), reference_lla);
	        llast(i) = llavec;
	        llast(i).epoch = location(i).epoch;
	    end
	    lla = llast;
        end
    elseif strcmp(class(location),"datetime")
        % [nowutc:minutes(1):nowutc+minutes(10)]'
        vtimes(:,1) = location;
        lla = setepoch(vtimes,reference_lla);
    end
end

function lla = azelrn_to_lla(datetime, azelrn, obsloc_lla)
  observation_location = topocentric_frame_s(geographic_s(obsloc_lla), "none");
  geoout = struct('geographicOutput', ori.itrf_s);
  oraaslla = convert_location(datetime,...
			      struct('azEl', azelrn_s(observation_location, azelrn)),...
			      geoout).geographic;
  lla = latlonalt_rdn(oraaslla.lat, oraaslla.lon, oraaslla.alt);
end

function lla = latlonalt_rdn(latitude_rdn, longitude_rdn, altitude_m)
  lla = struct('latitude_deg', rad2deg(latitude_rdn),...
	       'latitude_rdn', latitude_rdn,...
	       'longitude_deg', rad2deg(longitude_rdn),...
	       'longitude_rdn', longitude_rdn,...
	       'altitude_m', altitude_m);
end

function lla = eci_to_lla(datetime, eci_m)
  cart_s = struct('frame', ori.gcrf_s);
  cart_s.x = eci_m(1);
  cart_s.y = eci_m(2);
  cart_s.z = eci_m(3);
  geoout = struct('geographicOutput', ori.itrf_s);
  oraaslla = convert_location(datetime, struct('cartesian', cart_s), geoout).geographic;
  lla = latlonalt_rdn(oraaslla.lat, oraaslla.lon, oraaslla.alt);
end

function llatt = ephemeris_lla(ephemeris_table)
  for i = 1:size(ephemeris_table,1)
    llastructs(i) = eci_to_lla(ephemeris_table.epoch(i),...
			       ephemeris_table.position_m(i,:));
  end
  llatbl = struct2table(llastructs);
  llatbl.epoch = ephemeris_table.epoch;
  llatbl = movevars(llatbl,'latitude_rdn','After','altitude_m');
  llatbl = movevars(llatbl,'longitude_rdn','After','latitude_rdn');
  llatt = table2timetable(llatbl);
end

%% iss.orbit = spacetrack_orbit(25544)
%% iss.ephem = propagate(iss.orbit, hours(2), minutes(10), true)
%% iss.lla = lla(iss.ephem)
%% iss.ephs = epochstruct(iss.ephem)
%% These will come out the same:
%%  iss.ephslla1 = lla(iss.ephs)
%%  iss.ephslla2 = epochstruct(iss.lla)

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
