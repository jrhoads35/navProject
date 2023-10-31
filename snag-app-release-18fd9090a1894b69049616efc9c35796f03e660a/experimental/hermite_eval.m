% hermite_eval Evaluate the Hermite interpolation polynomial at the points in x.
% For each column of x and coefs, returns [p(x(1)); p'(x(1));...,
% p(x(2)); p'(x(2)),...] for the polynomial p and derivative p'.
% x             = Points at which function and derivative should be approximated
% herm          = Output of hermite()
function pdv = hermite_eval(x, herm)
  coefs = herm.coefs;
  for j=1:size(coefs,2)
    xcolind = rem(j-1,size(x,2)) + 1;
    pdv(:,j) = hermev1(x(:,xcolind), coefs(:,j), herm.mdop1, 1+herm.maxexpon);
  end
end

function pdv = hermev1(x, coefs, mdop1, lenco)
  lenx = size(x,1);
  ders = zeros(lenco,mdop1);
  ders(:,1) = coefs;
  for j=1:mdop1-1
    ders(j+1:size(coefs,1),j+1) = polyder(ders(:,j))';
  end
  ind = 0;
  for i=1:lenx
    for j=0:mdop1-1
      ind = ind+1;
      pdv(ind,1) = polyval(ders(:,j+1)',x(i));
    end
  end
end

%%================================================================================
%% Copyright 2021 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
