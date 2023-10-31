% eci  Find the earth-centered inertial coordinates
% Input
%  location      The location in the form of aer or lla
%  observer_lla  The observer location lla corresponding to input aer observation, leave off if converting from lla
% Output
%  eci            A timetable or structure (depending on input) of epoch and position_m

function reteci = eci(location, observer_lla)
    if hasfields(location, aofld.lladeg) && hasepoch(location) % lla to eci
        switch class(location)
          case 'timetable'
	    for i = 1:size(location,1)
	        ecivec = lla_to_eci(location.epoch(i), table2struct(location(i,:)));
                ecist(i) = pvt(location.epoch(i), ecivec);
	    end
	    reteci = epochtable(ecist);
          case 'struct'
	    for i = 1:size(location,1)
	        ecivec = lla_to_eci(location(i).epoch, location(i));
                ecist(i) = pvt(location(i).epoch, ecivec);
	    end
	    reteci = ecist;
        end
    elseif hasfields(location, aofld.aerdeg) && hasepoch(location) % aer to eci
        switch class(location)
	  case 'timetable'
	    for i = 1:size(location,1)
	        ecivec = azelrn_to_eci(location.epoch(i), table2struct(location(i,:)), observer_lla);
                ecist(i) = pvt(location.epoch(i), ecivec);
	    end
	    reteci = epochtable(ecist);
	  case 'struct'
	    for i = 1:size(location,1)
	        ecivec = azelrn_to_eci(location(i).epoch, location(i), observer_lla);
                ecist(i) = pvt(location(i).epoch, ecivec);
	    end
	    reteci = ecist;
        end
    elseif hasfields(location, 'right_ascension_deg') && hasepoch(location) % radec to eci
        if ~exist('observer_lla','var')
            rad = 1.0;
        else
            rad = observer_lla;
        end
        numpts = size(location,1);
        if numel(rad) == numpts
            rad = observer_lla(:);
        else
            rad = rad(1) * ones(numpts,1);
        end
	for i = 1:numpts
	    ecist(i) = fromradec(location.epoch(i), location.right_ascension_deg(i), location.declination_deg(i), rad(i,1));
	end
        switch class(location)
	  case 'timetable'
	    reteci = epochtable(ecist);
	  case 'struct'
	    reteci = ecist;
        end
    elseif strcmp(class(location),"datetime")
        % Convert a vector of datetimes from a fixed site to a sequence of site vectors
        ecist = 0;
        reteci = eci(lla(location, observer_lla));
    end
    if ~exist('ecist','var')
        error('Cannot convert location to ECI');
    end
end

function eci_m = lla_to_eci(datetime, lla)
  oraaslla = geographic_s(lla);
  out_s  = convert_location(datetime, oraaslla,...
			    struct('cartesianOutputFrame',ori.gcrf_s));
  eci_m = [out_s.cartesian.x; out_s.cartesian.y; out_s.cartesian.z];
end

function eci_m = azelrn_to_eci(datetime, azelrn, obsloc_lla)
  observation_location = topocentric_frame_s(geographic_s(obsloc_lla), "none");
  out_s  = convert_location(datetime,...
			    struct('azEl',...
				   azelrn_s(observation_location, azelrn)),...
			    struct('cartesianOutputFrame',ori.gcrf_s));
  eci_m = [out_s.cartesian.x; out_s.cartesian.y; out_s.cartesian.z];
end

function eci_m = fromradec(datetime, ra_deg, dec_deg, radius_m)
    % Convert from polar to rectangular coordinates
    if ~exist('radius_m','var')
        radius_m = 1.0;
    end
    [vec(1) vec(2) vec(3)] = sph2cart(deg2rad(ra_deg), deg2rad(dec_deg), radius_m);
    eci_m = pvt(datetime, vec);
end


%% iss.orbit = spacetrack_orbit(25544)
%% iss.ephem = propagate(iss.orbit, hours(2), minutes(10), true)
%% Convert lla
%% iss.lla = lla(iss.ephem)
%% iss.llast = epochstruct(iss.lla)
%% These will come out the same, as position-only ephemeris timetables:
%%  iss.eci1 = eci(iss.lla)
%%  iss.eci2 = epochtable(eci(iss.llast))
%% Convert aer
%% iss.umd_aer = aer(iss.ephem, stddef.umd_lla)
%% iss.umd_aerst = epochstruct(iss.umd_aer)
%% These are almost exactly the same, as position-only ephemeris timetables:
%%  iss.eci3 = eci(iss.umd_aer, stddef.umd_lla)
%%  iss.eci4 = epochtable(eci(iss.llast))
%% They are almost exactly the same as iss.eci1 and iss.eci2 as well.

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
