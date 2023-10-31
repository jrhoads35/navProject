function tests = testpvt
    tests = functiontests(localfunctions);
end

function test_pvt_make_valid(testcase)
    valid = pvt(datetime(2020, 10, 01, 00, 30, 00, 000),...
                               [-14585092.13; -4705406.18; 3774382.80],...
                               [746.481; -2904.372; -2547.726]);
    actual = ispvt(valid);
    verifyTrue(testcase, actual)
end

function test_pvt_not_struct(testcase)
    verifyFalse(testcase, ispvt(12234))
end

function test_pvt_not_pvt(testcase)
    verifyFalse(testcase, ispvt(stddef.umd_lla))
end

function test_pvt_inside_earth(testcase)
  dt = datetime(2020, 10, 01, 00, 30, 00, 000);
  zero3 = [0.0; 0.0; 0.0];
  goodvel = [746.481; -2904.372; -2547.726];
  verifyError(testcase, @()pvt(dt,zero3,goodvel), 'state:position_inside_earth')
end

function test_pvt_too_slow(testcase)
  dt = datetime(2020, 10, 01, 00, 30, 00, 000);
  zero3 = [0.0; 0.0; 0.0];
  goodpos = [-14585092.13; -4705406.18; 3774382.80];
  verifyError(testcase, @()pvt(dt,goodpos,zero3), 'state:velocity_too_low')
end

%%================================================================================
%% Copyright 2021 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
