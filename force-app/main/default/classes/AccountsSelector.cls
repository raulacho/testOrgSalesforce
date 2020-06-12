public class AccountsSelector extends fflib_SObjectSelector {
    
    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }    
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Account.Name,
                Account.Id,
                Account.Email__c };
                    }    
    
    public List<Account> selectById(Set<Id> ids){
        return (List<Account>) Database.query(
            newQueryFactory().toSOQL()            
        );
    }
    
    public Account selectbyIdwithPosts(String ids){
        // QUERY ACCOUNT
        fflib_QueryFactory query = newQueryFactory();
        query.setCondition('Id = :recordIds');
        new PostsSelector().addQueryFactorySubselect(query,'Posts__r');    
        return (Account) Database.query(
            query.toSOQL()            
        );
    }
    
}