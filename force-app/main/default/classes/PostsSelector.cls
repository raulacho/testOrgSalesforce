public class PostsSelector extends fflib_SObjectSelector {

    public Schema.SObjectType getSObjectType() {
        return Post__c.sObjectType;
    }    

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Post__c.Id,
            Post__c.Name };
    }    

    
}