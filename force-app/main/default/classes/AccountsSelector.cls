public class AccountsSelector extends fflib_SObjectSelector {

    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }    

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Account.Name,
            Account.Id,
            Account.Description,
            Account.AnnualRevenue  };
    }    
    
    public List<Account> selectById(Set<Id> ids){
        return (List<Account>) Database.query(
         newQueryFactory().toSOQL()            
        );
    }
    
}