% hermite Hermite interpolation of any number of points defined by
% values of those points and any number of derivatives.

% x = points at which the function and its derivatives have been evaluated
% fnvalder = value of function and derivatives at each of the points,
%            or a function handle that creates them for a scalar argument
% Returns the coefficients of x^0, x^1, ... of the polynomial that
% fits the function and derivatives, and the function and derivative
% values.

% Multiple functions can be fit simulataneously; the number of
% columns of x and fnvalder should match, and the returned value of
% coefs will have the same number of columns. If fnvalder is a
% function handle, then only the first column of x will be fit.

% For [co fdv] = hermite(x, fx), norm(fdv-hermite_eval(x, co)) should
% be very close to zero.
%
% Example
% fn = @(x)[sin(x);cos(x)]
% pts = [0.2; 0.4]
% [co fdv] = hermite(pts,fn)
% norm(fdv-hermite_eval(pts, co))
% ans = 2.7756e-17

%% Scaling is a failure - sincos test comes out substatially worse in accuracy.
%% It does create matrices that are solvable without RCOND warnings, however.
%%function interp = hermite(x, fnvalder, scale_ind_var)

function interp = hermite(x, fnvalder)
%  if exist('scale_ind_var','var')
%    scalex = scale_ind_var;
%  else
%    scalex = 1;
%  end
  if isa(fnvalder,'function_handle')
    % If a function is provided for fnvalder, only the first column of x
    % is fit.
    fx = reshape(fnvalder(x'),[],1);
    ncols = 1;
    savefx = true;
  else
    fx = fnvalder;
    ncols = size(fx,2);
    savefx = false;
  end

  interp.type = "hermite";
  interp.lenx = size(x,1);
  interp.mdop1 = size(fx,1)/interp.lenx; % 1 + maximum derivative order
  interp.maxexpon = interp.lenx * interp.mdop1 - 1;
  %%interp.scalex = scalex;

  %% Rescale the knot point values (fx) by the x scaling factor
  %% scalefx = repmat(scalex.^[0:interp.mdop1-1]',size(fx)./[interp.mdop1,1])
  scaledfx = fx;

  %% Find the generalized vandermonde matrix (monomials and
  %% derivatives) and solve the linear equation
  for j=1:size(x,2)
    %% hmat{j} = hermmat(x(:,j)/scalex, interp);
    hmat{j} = hermmat(x(:,j), interp);
    %% Save condition number; normally not calculated due to the
    %% computation time
    %% interp.condnum = cond(hmat{j});
  end
  for j=1:ncols
    xind = rem(j-1,size(x,2)) + 1; % cycle through columns of x
    coefs(:,j) = flip(hmat{xind}\scaledfx(:,j),1);
  end
  interp.coefs = coefs;
  if savefx
    interp.fx = fx;
  end
  %%interp.x = x;
end

function mat = hermmat(x, dims)
  for j=1:dims.lenx
    for i=0:dims.mdop1-1
      hmat(i+1+(j-1)*dims.mdop1,:) = monomialderiv(x(j), dims.maxexpon, i);
    end
  end
  mat = hmat;
end

function mdv = monomialderiv(x, exponent, derivorder)
  for j=0:exponent
    coef = 1;
    if derivorder > 0
      for i=1:derivorder
	coef = coef*max(0,(j-i+1));
      end
    end
    mdv(j+1) = coef*x^(max(j-derivorder,0));
  end
end

%%================================================================================
%% Copyright 2021 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
