global with sharing class DataImportService {
    
    global static Map<String, Object> importUser(Integer userNumber){
        TestDataImport__c apiUrl = TestDataImport__c.getOrgDefaults();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(apiUrl.url__c + '/users/' + userNumber);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(req);
        Map<String, Object> userResult = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
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
    
    
    // NEW VERSION
    
    global static String importData(Integer userNumber){
        TestDataImport__c apiUrl = TestDataImport__c.getOrgDefaults();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(apiUrl.url__c + '/users/' + userNumber);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(req);
        JSONParser parser = JSON.createParser(response.getBody());
        String posts = importPosts(userNumber);
        
        // USER
        UserCustom cust;
        while (parser.nextToken() != null) {            
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                cust = (UserCustom)parser.readValueAs(UserCustom.class);
                String s = JSON.serialize(cust);
                system.debug('Serialized user: ' + s);
                
            }     
        }  
        
        // POSTS
        // 
        List<Posts_JSON> postList = parsePost(posts);
        List<List<comments_JSON>> allcomments = retrieveComments(postList);
        Account userExtId = createUser(cust);  
        createPosts(postList, userExtId.External_Id__c); 
        createComments(allcomments);
        return userExtId.Id;
        
    }
    
    //CLASSES
    public static Account createUser(UserCustom cust){
        String externalId = getUUID();
        Account tmpAcc = new Account();
        tmpAcc.Name = cust.name;
        tmpAcc.Email__c = cust.email;  
        tmpAcc.Phone = cust.phone;
        tmpAcc.Website = cust.website;
        tmpAcc.External_Id__c = externalId;
        tmpAcc.BillingCity = cust.address.street;
        insert tmpAcc;
        system.debug(cust.id);
        return tmpAcc;
    }
    
    public static List<List<comments_JSON>> retrieveComments(List<Posts_JSON> commList){
        List<List<comments_JSON>> result = new List<List<comments_JSON>>();
        
        // GET SEPARATE COMMENTS
        List<String> tmpComments = new List<String>();  
        for(Posts_JSON tmp : commList){
            String commentResults = importComments(tmp.id); 
            List<comments_JSON> postList = parseComment(commentResults); 
            result.add(postList);
        }  
        return result;
    }
    
    public static void createPosts(List<Posts_JSON> commList, String userExtId){    
        
        List<Post__c> tmpPosts = new List<Post__c>();        
        for(Posts_JSON tmp : commList){            
            Post__c tmpPost = new Post__c();
            Account accountReference = new Account(External_Id__c=userExtId); 
            tmpPost.Name = tmp.title;
            tmpPost.Account__r = accountReference;
            tmpPost.Title__c = tmp.title;
            tmpPost.Body__c = tmp.body;
            tmpPost.External_Id__c =  String.valueof(tmp.id);
            tmpPosts.add(tmpPost);
            
        }  
        insert tmpPosts;
        
    }
    
    public static void createComments(List<List<comments_JSON>> allcomments){
        List<Comment__c> uploadComments = new List<Comment__c>();
        for(List<comments_JSON> level1 : allcomments){
            system.debug(level1);
            for(comments_JSON level2 : level1){
                system.debug(level2);
                Comment__c tmpComm = new Comment__c();
                Post__c postReference = new Post__c(External_Id__c=String.valueof(level2.postId));   
                tmpComm.Name = level2.name;
                tmpComm.Post__r = postReference;
                tmpComm.Body__c = level2.body;
                uploadComments.add(tmpComm);
            }            
        }
        insert uploadComments;        
    }
    
    // OBJECTS
    // 

    public class UserCustom {
        public String name;
        public String email;
        public String phone;
        public String website;
        public Address address;
        public String id;
        
        
        public UserCustom(string name, string email, string phone, string website, Address address, string extid) {
            name = name;
            email = email;
            phone = phone;
            website = website;
            address = address;
            id = extid;
        }
    }  
    
    public class Address {
        public String street;
        public String suite;
        public String city;
        public String zipcode;
        public Geo geo;
    }
    
    public class Geo {
        public String lat;
        public String lng;
    }  
 

    public class Posts_JSON {
        public Integer userId;
        public Integer id;
        public String title;
        public String body;
    }
    
    
    public static List<Posts_JSON> parsePost(String json) {
        return (List<Posts_JSON>) System.JSON.deserialize(json, List<Posts_JSON>.class);
    }
    
    // COMMENTS
    public class comments_JSON {
        public Integer postId;
        public Integer id;
        public String name;
        public String body;
        public String email;
    }
    
    
    public static List<comments_JSON> parseComment(String json) {
        return (List<comments_JSON>) System.JSON.deserialize(json, List<comments_JSON>.class);
    }
    
    
    
    public static String getUUID()
    {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        system.debug(guid);
        return guid;
    }


    //
    
}