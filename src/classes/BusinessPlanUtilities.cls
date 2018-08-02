public with sharing class BusinessPlanUtilities {
    
    @auraEnabled
    public static Id createNewGoal(Id bPlanId) {
        Id partnerAccId = getAccountId();
        Integer currentYear = System.Today().year();
        
        Goals__c goal = new Goals__c(BusinessPlan__c = bPlanId);
        
        if(Schema.SObjectType.Goals__c.isCreateable()) {
        	insert goal;
        	return goal.Id;    
        } else {
            return null;    
        }
    }
    
    @AuraEnabled
    public static Id getAccountId() {
        
        if (Schema.SObjectType.User.isAccessible() && Schema.SObjectType.User.fields.AccountId.isAccessible()) {
         	List<User> u = [SELECT AccountId FROM User where Id = :UserInfo.getUserId()];
        
            if (u.size() > 0) {
                if (u[0].AccountId != null) {
                    return u[0].AccountId;
                }
            }   
        }
        
        return null;
    }
    
    @AuraEnabled
    public static Id getBusinessPlanId() {
        
        Id partnerAccId = getAccountId();
        Integer currentYear = System.Today().year();
        
        if (Schema.SObjectType.Business_Plan__c.isAccessible() && 
            Schema.SObjectType.Business_Plan__c.fields.Year__c.isAccessible() &&
           	Schema.SObjectType.Business_Plan__c.fields.Status__c.isAccessible() &&
           	Schema.SObjectType.Business_Plan__c.fields.PartnerAccount__c.isAccessible() &&
            Schema.SObjectType.Business_Plan__c.fields.end_date__c.isAccessible()) {
            List<Business_Plan__c> businessPlans = [
                SELECT ID 
                FROM Business_Plan__c
                WHERE (Year__c = :String.valueOf(currentYear) 
                       OR Status__c = 'Published')
                AND PartnerAccount__c = :partnerAccId
                ORDER BY end_date__c DESC
            ];
            
            if(businessPlans.size() > 0) {
                return businessPlans[0].Id;
            } else {
                return null;
            }
        } else {
            return null;
        }
    }
    
    @AuraEnabled
    public static businessPlanData getBusinessPlansforUser() {
        
        Id partnerAccId = getAccountId();
        Integer currentYear = System.Today().year();
        List<Business_Plan__c> businessPlans;
        
        if (Schema.SObjectType.Business_Plan__c.isAccessible() && 
            Schema.SObjectType.Business_Plan__c.fields.Current_Plan__c.isAccessible() &&
            Schema.SObjectType.Business_Plan__c.fields.Status__c.isAccessible() &&
            Schema.SObjectType.Business_Plan__c.fields.PartnerAccount__c.isAccessible() &&
           	Schema.SObjectType.Business_Plan__c.fields.end_date__c.isAccessible()) {
                businessPlans = [
                    SELECT ID, Status__c, Current_Plan__c
                    FROM Business_Plan__c
                    WHERE 
                    PartnerAccount__c = :partnerAccId
                    ORDER BY end_date__c DESC
                ];
            }
        
        if(businessPlans.size() > 0) {          
            BusinessPlanData b = new BusinessPlanData();
            b.currentBusinessPlanId = businessPlans[0].Id;
            b.bPlans = businessPlans;
            return b;
        } else {
            return null;
        }
    }
    
    @TestVisible
    public class BusinessPlanData {
        @AuraEnabled
        public Id currentBusinessPlanId;
        
        @AuraEnabled
        public Id previousBusinessPlanId;
        
        @AuraEnabled 
        public List<Business_Plan__c> bplans;
    }
    
    @AuraEnabled
    public static List<Goals__c> getAllGoals(Id bPlanId, String sortOrder) {
        Id partnerAccId = getAccountId();
        Integer currentYear = System.Today().year();
        
        String actualSortOrder;
        if (sortOrder == 'By Priority ASC') {
            actualSortOrder = 'Priority__c ASC';
        } else if (sortOrder == 'By % completion ASC') {
            actualSortOrder = 'percent_Complete__c ASC';        
        } else if (sortOrder == 'By Goal End Date ASC') {
            actualSortOrder = 'End_Date__c ASC'; 
        } else {
            actualSortOrder = 'Name ASC';
        }
                
        String query = '';
        query += 'SELECT ID,';
        query += '    Name,';
        query += '    BusinessPlan__c,';
        query += '    BusinessPlan__r.Status__c,';
        query += '    Title__c,';
        query += '    Summary__c,';
        query += '    Type__c,';
        query += '    Initial_Value__c,';
        query += '    Target_Value__c,';
        query += '    Current_Value__c,';
        query += '    Current_Attained__c,';
        query += '    Off_Track__c,';
        query += '    Start_Date__c,';
        query += '    End_Date__c,';
        query += '    Priority__c,';      
        query += '    percent_Complete__c';
        query += ' FROM GOALS__C';
        query += ' WHERE BusinessPlan__c= :bPlanId';
        query += ' ORDER BY ' + actualSortOrder;
        
        /*List<Goals__c> allGoalsForBusinessPlan = [
SELECT ID,
Name,
BusinessPlan__c,
BusinessPlan__r.Status__c,
Title__c,
Summary__c,
Type__c,
Initial_Value__c,
Target_Value__c,
Current_Value__c,
Current_Attained__c,
Off_Track__c,
Start_Date__c,
End_Date__c,
percent_Complete__c
FROM GOALS__C 
//WHERE BusinessPlan__c= :businessPlans[0].ID
WHERE BusinessPlan__c= :bPlanId
ORDER BY NAME ASC
];*/
        
        List<Goals__c> allGoalsForBusinessPlan;
            
        if (Schema.SObjectType.Goals__c.isAccessible() && 
            Schema.SObjectType.Business_Plan__c.isAccessible() && 
            Schema.SObjectType.Goals__c.fields.Name.isAccessible() &&
            Schema.SObjectType.Business_Plan__c.fields.Status__c.isAccessible() &&
           	Schema.SObjectType.Goals__c.fields.Title__c.isAccessible() &&
           	Schema.SObjectType.Goals__c.fields.Summary__c.isAccessible() &&
            Schema.SObjectType.Goals__c.fields.Type__c.isAccessible() &&
            Schema.SObjectType.Goals__c.fields.Initial_Value__c.isAccessible() &&
            Schema.SObjectType.Goals__c.fields.Target_Value__c.isAccessible() &&
            Schema.SObjectType.Goals__c.fields.Current_Value__c.isAccessible() &&
            Schema.SObjectType.Goals__c.fields.Current_Attained__c.isAccessible() &&
            Schema.SObjectType.Goals__c.fields.Off_Track__c.isAccessible() &&
            Schema.SObjectType.Goals__c.fields.Start_Date__c.isAccessible() &&
            Schema.SObjectType.Goals__c.fields.End_Date__c.isAccessible() &&
            Schema.SObjectType.Goals__c.fields.Priority__c.isAccessible() &&
            Schema.SObjectType.Goals__c.fields.percent_Complete__c.isAccessible()
           ) {
                allGoalsForBusinessPlan = Database.query(query);
            }
        
        if(allGoalsForBusinessPlan.size() > 0) {
            return allGoalsForBusinessPlan;
        } else {
            return null;
        }
        
        
    }
    
    @AuraEnabled
    public static void deleteUnPublishedBPlanGoal(Id goalId) {
        
        Goals__c[] goalToDelete;
        
        if (Schema.SObjectType.Goals__c.isAccessible() && 
            Schema.SObjectType.Business_Plan__c.isAccessible() && 
            Schema.SObjectType.Business_Plan__c.fields.Status__c.isAccessible()) {
                goalToDelete = [SELECT ID, BusinessPlan__R.Status__c FROM GOALS__C WHERE ID=:goalId];
            }
        
        if(goalToDelete.size() > 0 && Schema.SObjectType.Goals__c.isDeletable()) {
            if(goalToDelete[0].BusinessPlan__R.Status__c != 'Published') {
                try {
                    delete goalToDelete[0];
                } catch(DmlException e) {
                    System.debug('Error while deleting +e');
                }
            }
        }
    }
    
    @AuraEnabled
    public static void submitBusinessPlan(Id planId) {
        
        List<Business_Plan__c> businessPlans;
        
        if (Schema.SObjectType.Business_Plan__c.isAccessible() && 
            Schema.SObjectType.Business_Plan__c.fields.Status__c.isAccessible()) {
                businessPlans = [
                    SELECT STATUS__C 
                    FROM Business_Plan__c
                    WHERE ID = :planId
                ];
            }
        
        if(businessPlans.size() > 0 && 
           Schema.SObjectType.Business_Plan__c.isUpdateable() &&
           Schema.SObjectType.Business_Plan__c.fields.Status__c.isUpdateable()
          ) {
            try {
                businessPlans[0].status__c = 'Submitted';
                update businessPlans[0];
            } catch(DmlException e) {
                System.debug('Error while updating the business plan +e');
            }
        }
    } 
    
    @AuraEnabled 
    public static void setGoalComplete(Id goalId) {
        
        Goals__c[] goalToComplete;
        
        if (Schema.SObjectType.Goals__c.isAccessible() && 
            Schema.SObjectType.Goals__c.fields.Current_Value__c.isAccessible() && 
            Schema.SObjectType.Goals__c.fields.Target_Value__c.isAccessible()) {
                goalToComplete = [SELECT ID, Current_Value__c, Target_Value__c FROM GOALS__C WHERE ID=:goalId];
            }
        
        if(goalToComplete.size() > 0 && 
           Schema.SObjectType.Goals__c.isUpdateable() && 
           Schema.SObjectType.Goals__c.fields.Current_Value__c.isUpdateable()) {      
            try {
                goalToComplete[0].Current_Value__c = goalToComplete[0].Target_Value__c;
                update goalToComplete[0];
                
            } catch(DmlException e) {
                System.debug('Error updating goal +e');
            }
            
        }
        
    }
}