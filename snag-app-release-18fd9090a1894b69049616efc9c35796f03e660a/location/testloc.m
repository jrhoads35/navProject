function tests = testloc
    tests = functiontests(localfunctions);
end

function setupOnce(testcase)
  testcase.TestData.aer1...
  = setepoch(datetime_iso8601("2021-09-28T14:00:00.000"),azelrn_deg(349, 86, 735376));
  testcase.TestData.eci1...
  = pvt(datetime_iso8601("2021-09-28T14:00:00.000"),...
	[-4221321.05021323 3518657.06890759 4500825.96258412]);
end

function test_loc_single_aer_to_eci(testcase)
  loc = eci(testcase.TestData.aer1, stddef.umd_lla);
  verifyTrue(testcase, ispt(loc) && pvtnormdiff(loc, testcase.TestData.eci1, [1e-6, 1]))
end

function test_loc_single_eci_to_aer(testcase)
  ob = aer(testcase.TestData.eci1, stddef.umd_lla);
  verifyTrue(testcase, sqrt((ob.azimuth_deg-testcase.TestData.aer1.azimuth_deg)^2 + (ob.elevation_deg-testcase.TestData.aer1.elevation_deg)^2) <= 1e-3...
		       && abs(ob.range_m-testcase.TestData.aer1.range_m) <= 1e-3)
end

%%================================================================================
%% Copyright 2021 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
