global with sharing class DataImport {
   
    global static string importUser(Integer userNumber){
        TestDataImport__c apiUrl = TestDataImport__c.getOrgDefaults();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(apiUrl.url__c + '/users/' + userNumber);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(req);
        String userResult = response.getBody();
        return userResult;
    }  
    
    global static String importPosts(Integer userNumber){
        TestDataImport__c apiUrl = TestDataImport__c.getOrgDefaults();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(apiUrl.url__c + '/posts?userId=' + userNumber);
        req.setMethod('GET');
        req.setTimeout(60000);
        Http http = new Http();
        HttpResponse response = http.send(req);
        string userResult = response.getBody();
        return userResult;
    }  
    
    global static String importComments(Integer postNumber){
        TestDataImport__c apiUrl = TestDataImport__c.getOrgDefaults();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(apiUrl.url__c + '/comments?postId=' + postNumber);
        req.setMethod('GET');
        req.setTimeout(90000);
        Http http = new Http();
        HttpResponse response = http.send(req);     
        String comment = response.getBody();
        return comment;
    } 


    public static Map<String, String> retrieveComments(List<Post_JSON> commList){
        Map<String, String> tmpComments = new Map<String, String>();  
        for(Post_JSON tmp : commList){
            String commentResults = importComments(tmp.id); 
            tmpComments.put(String.valueof(tmp.id),commentResults);
        }  
        return tmpComments;
    }
    
// MAIN METHOD

    global static String importData(Integer userNumber){
        String usersRetrieved = importUser(userNumber);
        String postsRetrieved = importPosts(userNumber);
        List<Post_JSON> postJsons = Post_JSON.parsepost(postsRetrieved);
        Map<String,String> commentsRetrieved = retrieveComments(postJsons);
        String idReturned = DataImportService.uploadData(usersRetrieved,postsRetrieved,commentsRetrieved);
        system.debug(idReturned);
        return idReturned;
    }
    
}