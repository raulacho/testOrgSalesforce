public class Accounts extends fflib_SObjectDomain{
    public Accounts(List<Account> sObjectList) {
        super(sObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<sObject> sObjectList) {
            return new Accounts(sObjectList);
        }
    }
    
    public override void onApplyDefaults() {
        // Apply defaults to Opportunities
        for(Account account : (List<Account>) Records) {
            account.Description = 'Domain classes rock!';            
        }
    }
    
    public override void onBeforeUpdate(Map<Id,sObject> existingRecords) {        

        List<Account> updatedAccounts = new List<Account>();
        for(Account acc : (List<Account>) Records) {    

            Account oldAcc = (Account)existingRecords.get(acc.Id);
            if(acc.Description != oldAcc.Description){
                system.debug('Description has changed');
                String textRock = 'Domain classes rock!';
                acc.AnnualRevenue = textRock.getLevenshteinDistance(acc.Description);
                updatedAccounts.add(acc);}
        }
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { Account.SObjectType });
        uow.registerDirty(updatedAccounts);
    }
    
}