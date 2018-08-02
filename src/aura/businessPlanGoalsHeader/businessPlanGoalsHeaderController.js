({
    init : function(component, event, helper) {
        var action = component.get("c.getAllGoals");
        action.setParams({ 
            bPlanId : component.get("v.businessPlanId") ,
            sortOrder: component.get('v.goalSortOrder')
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('Goals list', result);
                component.set('v.goalsList', result);
                if(result != null) {
                    console.log(result[0].BusinessPlan__r.cplan__Status__c);
                }
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    createGoal : function(component, event, helper) {
        var action = component.get("c.createNewGoal");
        action.setParams({ bPlanId : component.get("v.businessPlanId") });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.newGoalId', result);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    deleteGoal : function(component, event, helper) {
        var action = component.get("c.deleteUnPublishedBPlanGoal");
        action.setParams({ goalId : event.getParam("goalId") });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('IN CALLBACK from Header');
                var result = response.getReturnValue();
                component.set('v.newGoalId', null);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
        
    }
})