function ret = pvtnormdiff(pvt1, pvt2, tf_max)
  if ispvt(pvt1) && ispvt(pvt2)
    vec = [seconds(pvt1.epoch - pvt2.epoch);...
	   norm(pvt1.position_m - pvt2.position_m);...
	   norm(pvt1.velocity_ms - pvt2.velocity_ms)];
    if exist('tf_max','var')
      ret = abs(vec(1)) <= tf_max(1) && vec(2) <= tf_max(2) && vec(3) <= tf_max(3);
    else
      ret = vec;
    end
  elseif ispt(pvt1) && ispt(pvt2)
    vec = [seconds(pvt1.epoch - pvt2.epoch);...
	   norm(pvt1.position_m - pvt2.position_m)];
    if exist('tf_max','var')
      ret = abs(vec(1)) <= tf_max(1) && vec(2) <= tf_max(2);
    else
      ret = vec;
    end
  end
end

%%================================================================================
%% Copyright 2021 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
