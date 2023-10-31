function tests = testprop
    tests = functiontests(localfunctions);
end

function setupOnce(testcase)
  testcase.TestData.forcemodel.force_20x20_cd22 = force_model(20, 20, 1.0, 2.2, 0, 0, 1000);
  %% Circular orbital elements
  %% coe1 = Geosync inclined near-circular
  testcase.TestData.coe1 = stddef.coe1;
  %% coe2 = LEO inclined circular
  %% Test spacetrack orbit without connection to space-track.org
  %% sto1 = ISS (25544)
end

%% Circular orbital elements creation

function test_prop_circ_inside_earth(testcase)
  verifyError(testcase, @()circular_oes...
			 (testcase.TestData.coe1.epoch,...
			  testcase.TestData.coe1.sma/1e3,... % Oops, used km
			  testcase.TestData.coe1.eccx, testcase.TestData.coe1.eccy,...
			  testcase.TestData.coe1.inc, testcase.TestData.coe1.raan,...
			  testcase.TestData.coe1.te,...
			  false),...
	      'state:perigee_inside_earth')
end

%% Circular orbital elements propagation forces

function test_prop_circ_from_epoch_to_relative_twobody(testcase)
  prop = propagate(stddef.cleo2, true, hours(5), minutes(10), constants.force_twobody);
  pvtend = pvt1(prop,size(prop,1));
  expected = pvt(datetime('2020-10-01 05:30:00.000000'),...
		 [377641.169558612; 4785420.63069065; 4785420.63069065],...
		 [-7656.64799622866; 302.111948702103; 302.111948702103]);
  verifyTrue(testcase, pvtnormdiff(pvtend, expected, [0.5, 1.0, 1e-3]))
end

function test_prop_circ_from_epoch_to_relative_20x20_cd22(testcase)
  prop = propagate(stddef.cleo2, true, hours(5), minutes(10), testcase.TestData.forcemodel.force_20x20_cd22);
  pvtend = pvt1(prop,size(prop,1));
  expected = pvt(datetime('2020-10-01 05:30:00.000000'),...
		 [140720.40627311; 4789307.56485758; 4783350.88668578],...
		 [-7669.56835477629; 187.454955782446; 27.4643177339631]);
  verifyTrue(testcase, pvtnormdiff(pvtend, expected, [0.5, 1.0, 1e-3]))
end

%% Eclipse
function test_eclipse_circ_20x20_cd22(testcase)
  prop = eclipse(stddef.cleo2, true, hours(5), testcase.TestData.forcemodel.force_20x20_cd22);
  verifyEqual(testcase, size(prop,1), 14)
end

%% Visiblity

function test_vis_circ_1site(testcase)
  site_umd = geoloc(38.988933, -76.937115, 42, "UMd",10);
  prop = visibility(stddef.cleo2, true, hours(12), site_umd, constants.force_twobody);
  verifyEqual(testcase, size(prop.visibility_changes,1), 8)
end

function test_vis_circ_2site(testcase)
  site_osu = geoloc(40.0000, -83.0219, 400, "OSU", 5);
  site_umd = geoloc(38.988933, -76.937115, 42, "UMd",10);
  prop = visibility(stddef.cleo2, true, hours(12), [site_umd site_osu], constants.force_twobody);
  verifyEqual(testcase, size(prop(1).visibility_changes,1) + size(prop(2).visibility_changes,1), 16)
end

%% Spacetrack orbits

function test_prop_st_from_epoch(testcase)
  prop = propagate(stddef.sto1, true, datetime('2021-12-27 00:01:00'), minutes(10));
  pvtend = pvt1(prop,size(prop,1));
  expected = pvt(datetime('2021-12-26 23:55:30.000000'),...
		 [3762735.81975723; 1949084.7918016; -5315466.54316049],...
		 [-2889.12950190652; 7065.2413146977; 549.60154418925]);
  verifyTrue(testcase, pvtnormdiff(pvtend, expected, [0.5, 1.0, 1e-3]))
end

function test_prop_st_from_epoch_plus15min(testcase)
  prop = propagate(stddef.sto1, ...
		   stddef.sto1.epoch + minutes(15),...
		   datetime('2021-12-27 00:01:00'), minutes(10));
  pvtend = pvt1(prop,size(prop,1));
  expected = pvt(datetime('2021-12-27 00:00:30.000000'),...
		 [2700106.46598044; 3918688.32344082; -4853009.35515433],...
		 [-4127.94042150677; 5940.37596328588; 2504.41508705556]);
  verifyTrue(testcase, pvtnormdiff(pvtend, expected, [0.5, 1.0, 1e-3]))
end

function test_prop_st_toend(testcase)
  prop = propagate(stddef.sto1, ...
		   hours(1), datetime('2021-12-27 00:01:00'), minutes(10));
  pvtbeg = pvt1(prop,1);
  expected = pvt(datetime('2021-12-26 23:01:00.000000'),...
		 [-4546988.1975087; 1571743.04395389; 4790735.12208269],...
		 [298.511237099142; -7188.3011788343; 2640.26509651464]);
  verifyTrue(testcase, pvtnormdiff(pvtbeg, expected, [0.5, 1.0, 1e-3]))
end

%% Spacetrack eclipse
function test_eclipse_st(testcase)
  prop = eclipse(stddef.sto1, true, hours(5));
  verifyEqual(testcase, size(prop,1), 12)
end

%% Spacetrack visiblity

function test_vis_st_1site(testcase)
  site_umd = geoloc(38.988933, -76.937115, 42, "UMd",10);
  prop = visibility(stddef.sto1, true, hours(12), site_umd);
  verifyEqual(testcase, size(prop.visibility_changes,1), 2)
end



%%================================================================================
%% Copyright 2021, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
