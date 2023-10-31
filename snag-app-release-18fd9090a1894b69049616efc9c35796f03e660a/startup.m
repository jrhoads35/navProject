filepath = fileparts(mfilename('fullpath'));
%% https://www.mathworks.com/matlabcentral/answers/458252#answer_372051
%% https://www.mathworks.com/matlabcentral/answers/250997
addpath(filepath);
addpath(fullfile(filepath, 'ephemeris'));
addpath(genpath(fullfile(filepath, 'location')));
addpath(fullfile(filepath, 'elements'));
%addpath(fullfile(filepath, 'oraas'));
addpath(fullfile(filepath, 'horizons'));
addpath(fullfile(filepath, 'orbit-determination'));
addpath(genpath(fullfile(filepath, 'propagation')));
addpath(fullfile(filepath, 'spacetrack'));
addpath(fullfile(filepath, 'test'));
addpath(fullfile(filepath, 'utility'));

datetime.setDefaultFormats('default','yyyy-MM-dd HH:mm:ss.SSSSSS');
clear
