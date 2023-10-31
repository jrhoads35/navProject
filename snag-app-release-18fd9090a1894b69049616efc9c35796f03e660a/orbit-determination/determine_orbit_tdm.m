% determine_orbit_tdm Submit the orbit determination job to ORaaS, with the data in a TDM file
% Input
%  initial_estimate  The initial estimate, expressed as a PVT
%  station           Observation station information; output of `geoloc()`
%  tdm_file          The observation data file in CCSDS TDM format
%  force_model       The force model to be used in estimation; output of `force_model`
function runnum = determine_orbit_tdm(initial_estimate, station, tdm_file, force_model)
  %% See documentation https://oraas.orekit.space/api-doc/json-skel?json=%7B%22serviceUrl%22%3A%22%2Fod%2Frun%22%2C%22className%22%3A%22org.orekit.web.json.od.OrbitDeterminationRequest%22%2C%22output%22%3A%22false%22%7D

  %% measurements (files and stations)
  measm.files = {struct('requestPartName','measurementsFile0','format','TDM_KVN')};
  angle_limit = 0.00872664625997165; % Default value in ORaaS web form
  angle_sigma = 0.000349065850398866; % Default value in ORaaS web form
  angle_bias = struct('value', 0, 'min', -angle_limit, 'max', angle_limit,...
		      'estimated', 'false');  % Iteration limit exceeded if 'true'
  angle_est = struct('sigma', angle_sigma, 'bias', angle_bias);
  sttn = station.station;
  sttn.azimuth = angle_est;
  sttn.elevation = angle_est;
  measm.stations = {sttn};
  params.measurements = measm;

  %% initialOrbit
  init_est_orbbull = pvt_to_orbbull(initial_estimate);
  params.initialOrbit = init_est_orbbull.orbitBulletin;

  %% estimator
  %% params.estimator.numericalPropagator.forceModel
  params.estimator.numericalPropagator = force_model;
  %%   params.estimator.numericalPropagator.integrator - use default

  %% stopIfParsingErrors - use default
  %% runId
  params.runId = "";

  %% Submit the data to the server
  import matlab.net.*
  import matlab.net.http.*
  import matlab.net.http.io.*
  rm = matlab.net.http.RequestMessage;
  rm = rm.addFields(matlab.net.http.field.CookieField(matlab.net.http.Cookie('gpdr','1')));
  global oraas_token
  if (size(oraas_token,2) ~= 36)
    %% If oraas_token does not exist or not a valid length, make a new one
    oraas_token = char(java.util.UUID.randomUUID);
  end
  rm = rm.addFields(matlab.net.http.field.CookieField...
			(matlab.net.http.Cookie('guid',oraas_token)));
  uri = URI([services.oraas_base_url '/od/run']);
  body = MultipartFormProvider('json', JSONProvider(params),...
			       'measurementsFile0', FileProvider(tdm_file));
  response = RequestMessage('post', rm.Header, body).send(uri.EncodedURI);
  rbd = response.Body.Data; % Run number, a natural number
  if isnumeric(rbd)
    runnum = rbd;
  else
    error(error_return(rbd));
  end
end

%%================================================================================
%% Copyright 2020, 2021, 2022 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
