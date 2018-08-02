@isTest
public class BusinessPlanUtilitiesTest {
    
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
    
    public static testmethod void getBusinessPlanId_forTheLatestPlan_setAsDefault() {
        
        User partnerUser = createPartnerUser();
        System.debug('*********The Partners account is*' + partnerUser.AccountId);
        
        //Test setup
        
        Business_Plan__c samplePlan = new Business_Plan__c(PartnerAccount__c = partnerUser.AccountId, Status__c = 'Published', ownerid = partnerUser.Id);
        insert samplePlan;
        
        // Run Test
        Test.startTest();
        Id myPlanId;
        
        System.runAs(partnerUser) {
            myPlanId = BusinessPlanUtilities.getBusinessPlanId();
        }
        
        Test.stopTest();
        
        //Assert 
        
        System.assertNotEquals(null, myPlanId);
    }
    
        public static testmethod void getBusinessPlanId_whenNoPlanExists() {
        
        User partnerUser = createPartnerUser();
        
        //Test setup
        
        // Run Test
        Test.startTest();
        Id myPlanId;
        
        System.runAs(partnerUser) {
            myPlanId = BusinessPlanUtilities.getBusinessPlanId();
        }
        
        Test.stopTest();
        
        //Assert 
        System.assertEquals(null, myPlanId);
    }
    
    public static testmethod void getBusinessPlansforUser_getsAllPlantoNavigateThrough() {
        User partnerUser = createPartnerUser();
        //Test setup
        
        Business_Plan__c samplePlan1 = new Business_Plan__c(PartnerAccount__c = partnerUser.AccountId, Status__c = 'Published', ownerid = partnerUser.Id);
        insert samplePlan1;
        
        Business_Plan__c samplePlan2 = new Business_Plan__c(PartnerAccount__c = partnerUser.AccountId, Status__c = 'Published', ownerid = partnerUser.Id);
        insert samplePlan2;
        
        // Run Test
        Test.startTest();
        BusinessPlanUtilities.BusinessPlanData b;
        System.runAs(partnerUser) {
          b = BusinessPlanUtilities.getBusinessPlansforUser();
        }
        
        Test.stopTest();
        
        //Assert
        System.assertNotEquals(null, b);
        System.assertEquals(samplePlan1.Id, b.currentBusinessPlanId);

    }
    
        public static testmethod void getBusinessPlansforUser_whenNoPlansExist() {
        User partnerUser = createPartnerUser();
        //Test setup
  
        // Run Test
        Test.startTest();
        BusinessPlanUtilities.BusinessPlanData b;
        System.runAs(partnerUser) {
          b = BusinessPlanUtilities.getBusinessPlansforUser();
        }
        
        Test.stopTest();
        
        //Assert
      
        System.assertEquals(null, b); 
    
    } 
    
    public static testmethod void createNewGoal_forABusinessId() {
        
        User partnerUser = createPartnerUser();
        
        //Test setup
        
        Business_Plan__c samplePlan = new Business_Plan__c(PartnerAccount__c = partnerUser.AccountId, Status__c = 'Published', ownerid = partnerUser.Id);
        insert samplePlan;
        
        // Run Test
        Test.startTest();
        Id goalId ;
        System.runAs(partnerUser) {
          goalId = BusinessPlanUtilities.createNewGoal(samplePlan.Id);
        }
        
        Test.stopTest();
        
        //Assert 
        System.assertNotEquals(null, goalId);
        
    }
    
    public static testmethod void getAllGoals_sortedByPriority_forABusinessId() {
        
        User partnerUser = createPartnerUser();
        
        //Test setup
        
        Business_Plan__c samplePlan = new Business_Plan__c(PartnerAccount__c = partnerUser.AccountId, Status__c = 'Published', ownerid = partnerUser.Id);
        insert samplePlan;
        
        Goals__c newGoal1 = new Goals__c(BusinessPlan__c = samplePlan.Id, Priority__c = '1');
        insert newGoal1;
        
        Goals__c newGoal2 = new Goals__c(BusinessPlan__c = samplePlan.Id, Priority__c = '2');
        insert newGoal2;
        
        // Run Test
        Test.startTest();
        List<Goals__c> allGoals;
        String sortOrder = 'By Priority ASC';
        
        System.runAs(partnerUser) {
          allGoals = BusinessPlanUtilities.getAllGoals(samplePlan.Id, sortOrder);
        }
        
        Test.stopTest();
        
        //Assert
        allGoals = [SELECT ID, PRIORITY__C FROM GOALS__C WHERE BusinessPlan__c = :samplePlan.Id ];
        System.assertEquals(2, allGoals.size());
        System.assertEquals('1', allGoals[0].priority__c);
   
    }
    
    public static testmethod void getAllGoals_sortedBypercentage_forABusinessId() {
        
        User partnerUser = createPartnerUser();
        
        //Test setup
        
        Business_Plan__c samplePlan = new Business_Plan__c(PartnerAccount__c = partnerUser.AccountId, Status__c = 'Published', ownerid = partnerUser.Id);
        insert samplePlan;
        
        Goals__c newGoal1 = new Goals__c(BusinessPlan__c = samplePlan.Id, Initial_Value__c = 3, Target_Value__c = 6, Current_Value__c = 3);
        insert newGoal1;
        
        Goals__c newGoal2 = new Goals__c(BusinessPlan__c = samplePlan.Id, Initial_Value__c = 3, Target_Value__c = 6, Current_Value__c = 5);
        insert newGoal2;
        
        // Run Test
        Test.startTest();
        List<Goals__c> allGoals;
        String sortOrder = 'By % completion ASC';
        
        System.runAs(partnerUser) {
          allGoals = BusinessPlanUtilities.getAllGoals(samplePlan.Id, sortOrder);
        }
        
        Test.stopTest();
        
        //Assert
        allGoals = [SELECT ID, PERCENT_COMPLETE__C FROM GOALS__C WHERE BusinessPlan__c = :samplePlan.Id ];
        System.assertEquals(2, allGoals.size());
        System.assertEquals(0, allGoals[0].percent_complete__c);
   
    }
    
    public static testmethod void getAllGoals_whenNoneExist_forABusinessId() {
        
        User partnerUser = createPartnerUser();
        
        //Test setup
        
        Business_Plan__c samplePlan = new Business_Plan__c(PartnerAccount__c = partnerUser.AccountId, Status__c = 'Published', ownerid = partnerUser.Id);
        insert samplePlan;
        
        // Run Test
        Test.startTest();
        List<Goals__c> allGoals;
        String sortOrder;
        
        System.runAs(partnerUser) {
          allGoals = BusinessPlanUtilities.getAllGoals(samplePlan.Id, sortOrder);
        }
        
        Test.stopTest();
        
        //Assert
        allGoals = [SELECT ID FROM GOALS__C WHERE BusinessPlan__c = :samplePlan.Id];
        System.assertEquals(0, allGoals.size());
        
        
    }
    
    public static testmethod void deleteUnPublishedBPlanGoal_whenRequestedByUser() {
        
        User partnerUser = createPartnerUser();
        
        //Test setup
        
        Business_Plan__c samplePlan = new Business_Plan__c(PartnerAccount__c = partnerUser.AccountId, Status__c = 'Draft', ownerid = partnerUser.Id);
        insert samplePlan;
        
        Goals__c newGoal = new Goals__c(BusinessPlan__c = samplePlan.Id);
        insert newGoal;
        
        // Run Test
        Test.startTest();
        List<Goals__c> existingGoals;
        System.runAs(partnerUser) {
          BusinessPlanUtilities.deleteUnPublishedBPlanGoal(newGoal.Id);
          existingGoals = [SELECT ID FROM GOALS__C WHERE BusinessPlan__c = :samplePlan.Id];
        }
        
        Test.stopTest();
        //Assert
        System.assertEquals(0, existingGoals.size());      
        
    }
    
    //setGoalComplete
    
     public static testmethod void setGoalComplete_whenRequestedByUser() {
        
        User partnerUser = createPartnerUser();
        
        //Test setup
        
        Business_Plan__c samplePlan = new Business_Plan__c(PartnerAccount__c = partnerUser.AccountId, Status__c = 'Draft', ownerid = partnerUser.Id);
        insert samplePlan;
         
        Goals__c newGoal1 = new Goals__c(BusinessPlan__c = samplePlan.Id, Initial_Value__c = 3, Target_Value__c = 6, Current_Value__c = 3);
        insert newGoal1;
        
        // Run Test
        Test.startTest();
        List<Goals__c> existingGoals;
        System.runAs(partnerUser) {
          BusinessPlanUtilities.setGoalComplete(newGoal1.Id);
          existingGoals = [SELECT ID, Current_Value__c FROM GOALS__C WHERE BusinessPlan__c = :samplePlan.Id];
        }
        
        Test.stopTest();
        //Assert
        System.assertEquals(6, existingGoals[0].Current_Value__c);      
        
    }
    
    /*public static testmethod void submitBusinessPlan_forApproval_whenAlreadyPublished(){
        
        User partnerUser = createPartnerUser();
        
        //Test setup
        
        Business_Plan__c samplePlan = new Business_Plan__c(PartnerAccount__c = partnerUser.AccountId, Status__c = 'Published', Reviewer__c = partnerUser.Id, ownerid = partnerUser.Id);
        insert samplePlan;
        
        // Run Test
        List<Business_Plan__c> bplans;
        Test.startTest();
        System.runAs(partnerUser) {
          BusinessPlanUtilities.submitBusinessPlan(samplePlan.Id);
          //bplans = [SELECT ID, STATUS__C FROM BUSINESS_PLAN__C WHERE ID = :samplePlan.Id];
        }
        
        Test.stopTest();
        //Assert
        bplans = [SELECT ID, STATUS__C FROM BUSINESS_PLAN__C WHERE ID = :samplePlan.Id];
        System.assertEquals('Published', bplans[0].status__c);
        
    }*/
    
     public static testmethod void submitBusinessPlan_forApproval_whenUnPublished(){
        
        User partnerUser = createPartnerUser();
        
        //Test setup
        
        Business_Plan__c samplePlan = new Business_Plan__c(PartnerAccount__c = partnerUser.AccountId, Status__c = 'Draft', Reviewer__c = partnerUser.Id, ownerid = partnerUser.Id);
        insert samplePlan;

		samplePlan = [SELECT ID, OWNERID FROM BUSINESS_PLAN__C WHERE ID = :samplePlan.Id];
        samplePlan.OwnerId = partnerUser.Id;
		update samplePlan;

        // Run Test
        List<Business_Plan__c> bplans;
        Test.startTest();
        System.runAs(partnerUser) {
          BusinessPlanUtilities.submitBusinessPlan(samplePlan.Id);
        }
        
        Test.stopTest();
        //Assert
        bplans = [SELECT ID, STATUS__C FROM BUSINESS_PLAN__C WHERE ID = :samplePlan.Id];
        System.assertEquals('Under Review', bplans[0].status__c);
        
    }
 
}