% https://www.mathworks.com/help/matlab/ref/matlab.net.http.statuscode-class.html
function available = checkserver()
  server = services.oraas_base_url;
  uri = matlab.net.URI(server);
  header = matlab.net.http.field.ContentTypeField('text/plain');
  req = matlab.net.http.RequestMessage('POST',header,'Data');
  resp = send(req, uri);
  sc = resp.StatusCode;
  if sc ~= matlab.net.http.StatusCode.OK
    disp(['Services for ', server, ' failed'])
    disp([getReasonPhrase(getClass(sc)),': ',getReasonPhrase(sc)])
    disp(resp.StatusLine.ReasonPhrase)
    available = false;
  else
    available = true;
  end
end
