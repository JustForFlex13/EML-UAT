@isTest
global class Convsta_WSHelperCursus_CalloutMockImpl implements HttpCalloutMock {
  // Implement this interface method
  global HTTPResponse respond(HTTPRequest req) {
    // Create a fake response
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    // simulate Callout like heroku app
    if (req.getEndpoint().contains('/Api/v1/Auth')) {
        res.setBody('{"accessToken":"1234"}');
        res.setStatusCode(200);
    }
    if (req.getEndpoint().contains('/phase')) {
      if (req.getMethod().contains('GET')) {
        res.setBody('{"codePhase":"1234"}');
        res.setStatusCode(200);
      } else {
        res.setBody('{"status":"success212"}');
        res.setStatusCode(212);
      }
    }
    return res;
  }
}