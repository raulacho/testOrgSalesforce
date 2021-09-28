global with sharing class DataImportService implements IDataImportService {
    
    
    global static String uploadData(String userinfo,String postInfo,Map<String,String> commentInfo){
        fflib_ISObjectUnitOfWork uow = Application.unitOfWork.newInstance();
        
        // PARSE DATA
        
        UserCustom cust = parseUser(userinfo);
        List<Post_JSON> postj = Post_JSON.parsepost(postinfo);
        
        
        // USER
        Account acc = new Account();
        
        acc.External_Id__c = String.valueof(cust.id);
        acc.Name = cust.name;
        acc.Email__c = cust.email;  
        acc.Phone = cust.phone;
        acc.Website = cust.website;
        acc.BillingCity = cust.address.street;
        acc.BillingPostalCode = cust.address.zipcode;
        uow.registerNew(acc);
        for(Post_JSON tmp : postj){
            Post__c tmpPost = new Post__c();
            tmpPost.Name = tmp.title;
            tmpPost.Title__c = tmp.title;
            tmpPost.Body__c = tmp.body;
            tmpPost.External_Id__c =  String.valueof(tmp.id);
            uow.registerNew(tmpPost,Post__c.Account__c,acc);
            List<comments_JSON> commentContents = comments_JSON.parseComment(commentinfo.get(String.valueof(tmp.id)));
            for(comments_JSON tmpC : commentContents){
                Comment__c tmpComm = new Comment__c();
                tmpComm.Email__c = tmpC.email;
                tmpComm.Name = tmpC.name;
                tmpComm.Body__c = tmpC.body;
                uow.registerNew(tmpComm, Comment__c.Post__c,tmpPost);
            }
            
        }
        uow.commitWork();       
        return acc.Id;
    }
    
    
    
    public static IDataImportService newInstance(){
        return (IDataImportService) Application.service.newInstance(IDataImportService.class);
    }     
    
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
    
    public static UserCustom parseUser(String json) {
        return (UserCustom) System.JSON.deserialize(json, UserCustom.class);
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
    
    
    
}