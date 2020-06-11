global with sharing class DataImport {
    
    
    global static void importData2(){
        Integer userNumber = 1;
        Map<String, Object> insertData = DataImportService.importUser(userNumber); 
        List<Object> postData = DataImportService.importPosts(userNumber); 
        Map<String, List<Object>> commentDataMap =  new Map<String, List<Object>>();
        for(Object tmpPost : postData){
            Map<String, Object> tmpDa = (Map<String, Object>)((Map<String, Object>)tmpPost);
             List<Object> commentData = DataImportService.importComments(integer.valueof(tmpDa.get('id'))); 
             commentDataMap.put(String.valueof(tmpDa.get('id')),commentData);          
      }
      addUsers(insertData);
      importPostData(postData);   
      importCommentData(commentDataMap);        
    }
    
    
    global static void addUsers(Map<String, Object> insertData){
        Account tmpAcc = new Account();
        tmpAcc.Name = String.valueof(insertData.get('name'));
        tmpAcc.Email__c = String.valueof(insertData.get('email'));  
        tmpAcc.Phone = String.valueof(insertData.get('phone'));
        tmpAcc.Website = String.valueof(insertData.get('website'));
        tmpAcc.External_Id__c = String.valueof(insertData.get('id'));
        Map<String, Object> dataAdress = (Map<String, Object>)((Map<String, Object>)insertData).get('address');  
        tmpAcc.BillingCity = String.valueof(dataAdress.get('city'));
        tmpAcc.BillingPostalCode = String.valueOf(dataAdress.get('zipcode'));
        tmpAcc.BillingState = String.valueof(dataAdress.get('street'));
        Map<String, Object> dataGeo = (Map<String, Object>)((Map<String, Object>)dataAdress).get('geo');
        tmpAcc.BillingLatitude = Double.valueof(dataGeo.get('lat'));
        tmpAcc.BillingLongitude = Double.valueof(dataGeo.get('lng'));
        insert tmpAcc;
    }
    
    global static void importPostData(List<Object> postData){
        for(Object tmpData : postData){
            Map<String, Object> tmpDa = (Map<String, Object>)((Map<String, Object>)tmpData);
            Account accountReference = new Account(External_Id__c=String.valueof(tmpDa.get('userId')));     
            Post__c tmpPost = new Post__c();
            tmpPost.Name = String.valueof(tmpDa.get('title'));
            tmpPost.Account__r = accountReference;
            tmpPost.Title__c = String.valueof(tmpDa.get('title'));
            tmpPost.Body__c = String.valueof(tmpDa.get('body'));
            tmpPost.External_Id__c =  String.valueof(tmpDa.get('id'));
            system.debug(tmpPost);
            insert tmpPost;
        }
    }
    
    global static void importCommentData(Map<String, List<Object>> commentData){
        for(String key : commentData.keyset()){
            system.debug(key);
            Map<String, Object> tmpDa = (Map<String, Object>)((Map<String, Object>)commentData.get(key)[0]);
            Post__c postReference = new Post__c(External_Id__c=key);     
            Comment__c tmpComment = new Comment__c();
            tmpComment.Name = String.valueof(tmpDa.get('title'));
            tmpComment.Post__r = postReference;
            tmpComment.Body__c = String.valueof(tmpDa.get('body'));
            insert tmpComment;
        }

    }
    
}