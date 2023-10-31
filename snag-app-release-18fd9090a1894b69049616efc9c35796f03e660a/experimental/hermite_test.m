function tests = hermite_test
    tests = functiontests(localfunctions);
end

function test_herm_univariate(testcase)
  x2 = [0, 1; 1, 2];
  fx2 = [7, 8; 1, 2; 2, 3; 3, 4];
  verifyTrue(testcase, norm(fx2-hermite_eval(x2,hermite(x2,fx2))) <= 1e-10)
end

function test_herm_sincos_ftpts(testcase)
  fn = @(x)[sin(x);cos(x)];
  pts = [0.2; 0.4];
  herm = hermite(pts,fn);
  verifyTrue(testcase, norm(herm.fx-hermite_eval(pts, herm)) <= 1e-10)
end

function test_herm_sincos_large(testcase)
  fn1 = @(x)[sin(x);cos(x)];
  ptstest = [0:0.05:1]';
  ptseval = [ptstest(7); ptstest(15)];
  co = hermite(ptseval,fn1);
  interp = hermite_eval(ptstest,co);
  check = reshape(reshape(fn1(ptstest),[],2)',[],1);
  verifyTrue(testcase, norm(interp-check)/sqrt(height(interp)) <= 0.01)
end

function test_herm_sincos_multi(testcase)
  % 2 functions, 1 derivative each, 2 points: 1/3, 2/3
  fn2 = @(x)[sin(x), sin(2*x); cos(x), 2*cos(2*x)]; % sin(x), sin(2x) and their first derivatives
  fneval = @(func, points)cell2mat(arrayfun(func, points, 'UniformOutput', false));
  ptstest = [0:0.05:1]';  % Test the interpolations for the two functions on 21 points
  ptseval = [ptstest(7); ptstest(15)]; % Compute interpolations from two of those points
  fx2 = fneval(fn2, ptseval);
  co = hermite(ptseval,fx2); % Compute Hermite coefficients for both functions
  interp = hermite_eval(ptstest,co); % Evaluate interpolation at all test points
  actual = fneval(fn2, ptstest);  % Actual values of the functions at all test points
  verifyTrue(testcase, norm(interp-actual)/sqrt(2*height(interp)) <= 0.05)
end

function test_herm_sincos_2der_2pt(testcase)
  % 2 functions, 2 derivatives each, 2 points: 1/3, 2/3
  fn2 = @(x)[sin(x), sin(2*x); cos(x), 2*cos(2*x); -sin(x), -4*sin(2*x)]; % sin(x), sin(2x) and two derivatives
  fneval = @(func, points)cell2mat(arrayfun(func, points, 'UniformOutput', false));
  ptstest = [0:0.05:1]';  % Test the interpolations for the two functions on 21 points
  ptseval = [ptstest(7); ptstest(15)]; % Compute interpolations from two of those points
  fx2 = fneval(fn2, ptseval);
  co = hermite(ptseval,fx2); % Compute Hermite coefficients for both functions
  interp = hermite_eval(ptstest,co); % Evaluate interpolation at all test points
  actual = fneval(fn2, ptstest);  % Actual values of the functions at all test points
  verifyTrue(testcase, norm(interp-actual)/sqrt(2*height(interp)) <= 0.02)
end

function test_herm_sincos_2der_3pt(testcase)
  % 2 functions, 2 derivatives each, 3 points: 1/3, middle, 2/3
  fn2 = @(x)[sin(x), sin(2*x); cos(x), 2*cos(2*x); -sin(x), -4*sin(2*x)]; % sin(x), sin(2x) and two derivatives
  fneval = @(func, points)cell2mat(arrayfun(func, points, 'UniformOutput', false));
  ptstest = [0:0.05:1]';  % Test the interpolations for the two functions on 21 points
  ptseval = [ptstest(7); ptstest(11); ptstest(15)]; % Compute interpolations from three of those points
  fx2 = fneval(fn2, ptseval);
  co = hermite(ptseval,fx2); % Compute Hermite coefficients for both functions
  interp = hermite_eval(ptstest,co); % Evaluate interpolation at all test points
  actual = fneval(fn2, ptstest);  % Actual values of the functions at all test points
  verifyTrue(testcase, norm(interp-actual)/sqrt(2*height(interp)) <= 1e-4)
end

function test_herm_sincos_2der_3pt_spread(testcase)
  % 2 functions, 2 derivatives each, 3 points: first, middle, last
  fn2 = @(x)[sin(x), sin(2*x); cos(x), 2*cos(2*x); -sin(x), -4*sin(2*x)]; % sin(x), sin(2x) and two derivatives
  fneval = @(func, points)cell2mat(arrayfun(func, points, 'UniformOutput', false));
  ptstest = [0:0.05:1]';  % Test the interpolations for the two functions on 21 points
  ptseval = [ptstest(1); ptstest(11); ptstest(21)]; % Compute interpolations from three of those points
  fx2 = fneval(fn2, ptseval);
  co = hermite(ptseval,fx2); % Compute Hermite coefficients for both functions
  interp = hermite_eval(ptstest,co); % Evaluate interpolation at all test points
  actual = fneval(fn2, ptstest);  % Actual values of the functions at all test points
  verifyTrue(testcase, norm(interp-actual)/sqrt(2*height(interp)) <= 5e-6)
end
