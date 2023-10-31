% force_model Create the force model to be used by propagate; if called with two arguments, only the gravitational perturbation is included
% Input
%   central_body_gravity_degree: Degree of the central body gravity (max 20)
%   central_body_gravity_order:  Order of the central body gravity (max central_body_gravity_degree)
%   drag_area_m2:                Cross-section area of the object perpendicular
%                                 to atmospheric relative velocity direction in square meters
%   drag_coef:                   Drag coefficient, dimensionless
%   srp_area:                    Cross-section area of the object
%                                 perpendicular to sun direction, square meters
%   reflectivity_coef:           Coefficient of reflectivity
%   spacecraft_mass_kg:          Mass of the spacecraft, kg
%   sun_gravity                  Include sun gravity, `true` or `false` (optional, default `false`)
%   moon_gravity                 Include moon gravity, `true` or `false` (optional, default `false`)
%   ocean_tides                  An array [degree order] (or `false`) of ocean tide gravitational force (optional, default `false`)
%   sun_solid_tides              Include sun solid tides `true` or `false` (optional, default `false`)
%   moon_solid_tides             Include moon solid tides `true` or `false` (optional, default `false`)
%   general_relativity           Include general relativity effects `true` or `false` (optional, default `false`)
% Output
%   fm: structure to be passed to `propagate`

function fm = force_model(central_body_gravity_degree,...
			  central_body_gravity_order,...
			  drag_area_m2, drag_coef,...
			  srp_area_m2, reflectivity_coef,...
			  spacecraft_mass_kg, sun_gravity, moon_gravity, ...
                          ocean_tides, sun_solid_tides, moon_solid_tides, general_relativity)
    if ~exist('drag_area_m2','var') % no atmospheric drag or solar radiation pressure.
        drag_area_m2 = 0.0;
        drag_coef = 0.0;
        srp_area_m2 = 0.0;
        reflectivity_coef = 0.0;
        spacecraft_mass_kg = 1000.0;
    end
    if ~exist('sun_gravity','var')
        sun_gravity = false;
    end
    if ~exist('moon_gravity','var')
        moon_gravity = false;
    end
    fm = struct('forceModel',...
	        struct('centralBodyGravity', ...
		       struct('degree', central_body_gravity_degree,...
			      'order', central_body_gravity_order),...
		       'drag', struct('area', drag_area_m2, 'cd', drag_coef),...
		       'solarRadiationPressure',...
		       struct('area', srp_area_m2, 'cr', reflectivity_coef),...
		       'thirdBodySun', sun_gravity,...
		       'thirdBodyMoon', moon_gravity),...
	        'spacecraftMass', spacecraft_mass_kg);
    if exist('ocean_tides','var') && isnumeric(ocean_tides)
        fm.forceModel.oceanTides.degree = ocean_tides(1);
        fm.forceModel.oceanTides.order = ocean_tides(2);
    end
    if exist('sun_solid_tides','var')
        fm.forceModel.solidTidesSun = sun_solid_tides;
    end
    if exist('moon_solid_tides','var')
        fm.forceModel.solidTidesMoon = moon_solid_tides;
    end
    if exist('general_relativity','var')
        fm.forceModel.generalRelativity = general_relativity;
    end
end

%%================================================================================
%% Copyright 2020, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
