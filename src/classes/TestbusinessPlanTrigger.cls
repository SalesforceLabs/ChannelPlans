@isTest
public class TestbusinessPlanTrigger {
    
     public static User createPartnerUser() {
        
        Account a = new Account(name = 'Partner Account', Type = 'Technology Partner');
        insert a;
        
        Contact c = new Contact(LastName = 'PartnerTest', AccountId = a.Id);
        insert c;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Custom Partner Community Login User'].Id,
            LastName = 'Test',
            Email = 'test@partneraccount.com',
            Username = 'test@partneraccount.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'Plan Mgr',
            Alias = 'Planmgr',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ContactId = c.Id
            
        );
        
        insert u;
        
        return [SELECT ID, CONTACTID, ACCOUNTID FROM USER WHERE ID = :U.Id LIMIT 1];
    }
    
    
   
    public static testmethod void updateGoalsRecordType_forPublishedPlans() {
        User partnerUser = createPartnerUser();
        
        //Test setup
        
        Business_Plan__c samplePlan = new Business_Plan__c(PartnerAccount__c = partnerUser.AccountId, Status__c = 'Draft', ownerid = partnerUser.Id);
        insert samplePlan;
        
        
        Schema.DescribeSObjectResult R = Goals__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> goalRecordTypeInfo = R.getRecordTypeInfosByName();
        
        Id unpublishedplan_rt = goalRecordTypeInfo.get('Unpublished Plan').getRecordTypeId();
        Id publishedplan_rt = goalRecordTypeInfo.get('Published Plan').getRecordTypeId();
 
        Goals__c newGoal = new Goals__c(BusinessPlan__c = samplePlan.Id, Priority__c = '1', recordtypeid = unpublishedplan_rt);
        insert newGoal;
        
        Test.startTest();

          samplePlan.cplan__Status__c = 'Published';
          update samplePlan;

        
        Test.stopTest();
        
        //Assertion
  
        List<Goals__c> allGoals = [SELECT ID, RECORDTYPEID FROM GOALS__C WHERE BusinessPlan__c = :samplePlan.Id ];
        System.assertEquals(publishedplan_rt, allGoals[0].recordtypeid);
        
    }
}