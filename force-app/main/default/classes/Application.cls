public class Application {
    
    public static final fflib_Application.UnitOfWorkFactory unitOfWork =
        new fflib_Application.UnitOfWorkFactory(
            new List<SObjectType> {
                Account.sObjectType,
                    Post__c.sObjectType,
                    Comment__c.sObjectType
                    }
        ); 
    
    public static final fflib_Application.ServiceFactory service =
        new fflib_Application.ServiceFactory(
            new Map<Type, Type> {
                IDataImportService.class   =>   DataImportService.class
                    }
        );
    
    public static final fflib_Application.SelectorFactory selector =
        new fflib_Application.SelectorFactory(
            new Map<SObjectType, Type> {
                Account.sObjectType   =>   AccountsSelector.class
                    }
        );
    
    public static final fflib_Application.DomainFactory domain =
        new fflib_Application.DomainFactory(
            Application.Selector,
            new Map<SObjectType, Type> {
            }
        );
    
}