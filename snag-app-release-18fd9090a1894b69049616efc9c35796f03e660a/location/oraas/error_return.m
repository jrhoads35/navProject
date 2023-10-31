% error_return Construct a string from the error message returned by the server
function msg = error_return(oraasreturn)
  %% Some messages are not automatically decoded so check.
  try
    structret = jsondecode(oraasreturn);
  catch
    structret = oraasreturn;
  end
  if isfield(structret,'messages')
    msgs = structret.messages;
  elseif isfield(structret,'errorMessage')
    msgs = structret.errorMessage;
  elseif iscell(oraasreturn) && ~isempty(oraasreturn)
      msgs = oraasreturn;
  elseif ischar(structret) || isstring(structret)
      msgs = structret;
  else
      msg = "Could not interpret server message or no message";
      return
  end
  % msgs should be a column cell vector of strings or character arrays
  msgl = string([{'Server returned message: '}; msgs]);
  ind = 0;
  for ln = 1:numel(msgl)
      ind = ind+1;
      if ind > 1
          msgnl(ind) = newline;
          ind = ind+1;
      end
      msgnl(ind) = msgl(ln);
  end
  msg = join(msgnl);
end

%% oraret1 = '{"messages":["Unexpected error: No enum constant org.orekit.orbits.PositionAngle.true"]}'
%% oraret2 = '{"messages":["Unexpected error: No enum constant org.orekit.orbits.PositionAngle.true", "second message"]}'

%%================================================================================
%% Copyright 2020, 2021, 2022, 2023 Liam M. Healy
%% This file is part of SNaG-app.
%% SPDX-License-Identifier: GPL-3.0-or-later
