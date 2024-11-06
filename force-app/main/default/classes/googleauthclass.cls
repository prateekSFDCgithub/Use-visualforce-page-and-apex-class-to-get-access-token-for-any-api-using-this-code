public class googleauthclass{

 
    private static final String CLIENT_ID = 'Your_Id';
    private static final String CLIENT_SECRET = 'Yoir_Key';
    private static final String REDIRECT_URI = 'https://rqapp--devamit--c.sandbox.vf.force.com/apex/googleWauth';
    private static final String AUTHORIZATION_URL = 'https://accounts.google.com/o/oauth2/v2/auth';
    private static final String TOKEN_URL = 'https://oauth2.googleapis.com/token';
    
    
    public String authCode { get; set; }
    public String accessToken { get; set; }
    public string contactId {get; set;}
  
    public PageReference redirectToGoogle() {
        String scope = 'https://www.googleapis.com/auth/admin.directory.user'; 
        String authUrl = AUTHORIZATION_URL + 
                         '?response_type=code' + 
                         '&client_id=' + CLIENT_ID + 
                         '&redirect_uri=' + REDIRECT_URI + 
                         '&scope=' + scope +
                         '&access_type=offline'; 
        return new PageReference(authUrl);
    }
    
  
    public googleauthclass(ApexPages.StandardController controller) {
        
        authCode = ApexPages.currentPage().getParameters().get('code');
          contactId = controller.getId();
    }

    public void getAccessToken() {
        if (authCode != null) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(TOKEN_URL);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            
            String body = 'code=' + authCode +
                          '&client_id=' + CLIENT_ID +
                          '&client_secret=' + CLIENT_SECRET +
                          '&redirect_uri=' + REDIRECT_URI +
                          '&grant_type=authorization_code';
            
            req.setBody(body);
            
            try {
                Http http = new Http();
                HttpResponse res = http.send(req);
                
                if (res.getStatusCode() == 200) {
                    // Parse JSON response to extract access token
                    Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    accessToken = (String) jsonResponse.get('access_token');
                    
                } else {
                    System.debug('Failed to get access token. Response: ' + res.getBody());
                }
            } catch (Exception e) {
                System.debug('Error: ' + e.getMessage());
            }
        }
    }
   
  
}