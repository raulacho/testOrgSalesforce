public class DataTestLWC {
    @AuraEnabled
    public static AccountP getCreatedData(Integer userNumber){
        system.debug('usernumber ' + userNumber);
        try {
            String tmpId = DataImportService.importData(userNumber);
            Account tmpAccount = [SELECT Id, Name, Email__c, (SELECT Id, Name FROM Posts__r) FROM Account WHERE Id =:tmpId];
            AccountP returnData = new AccountP(tmpAccount.Id, tmpAccount, tmpAccount.Posts__r);
            return returnData;    
        } catch(Exception e){
            System.debug(Logginglevel.ERROR, e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }


    public class AccountP {
        @AuraEnabled
        public String accountId  { get; set; }
        @AuraEnabled
        public Account accountinfo  { get; set; }
        @AuraEnabled
        public List<Post__c> postinfo  { get; set; }
        
        public AccountP(String accountId, Account accountinfo, List<Post__c> postinfo){
            this.accountId = '/'+accountId;
            this.accountinfo = accountinfo;
            this.postinfo = postinfo;
        }
    }    
}