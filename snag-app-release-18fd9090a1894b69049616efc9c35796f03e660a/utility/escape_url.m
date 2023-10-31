function cleanurl = escape_url(string)
  %% This is a necessary conversion of the URLs because a '+' is interpreted as a blank.
  cleanurl = strrep(string, '+', '%2B');
