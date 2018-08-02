({
    init : function(component, event, helper) {
        var action = component.get("c.getBusinessPlansforUser");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                
                if (result) {
                    component.set('v.bPlanId', result.currentBusinessPlanId);
                    component.set('v.bPlansforUser', result.bplans);
                   // if (result.bplans[0].Status__c === 'Submitted' || result.bplans[0].Status__c === 'Published' || result.bplans[0].Status__c === 'Under Review') {
                   	  if (result.bplans[0].cplan__Status__c !== 'Draft') {
                        component.set('v.isPlanSubmitted', true);
                        component.set('v.isPlanSubmitted', true);
                    } else {
                        component.set('v.isPlanSubmitted', false); 
                    }
                }
                
                component.set('v.pageLoadComplete', true);
                
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
    
    submitPlan : function(component, event, helper) {
        var action = component.get("c.submitBusinessPlan");
        action.setParams({ planId : component.get("v.bPlanId") });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                
                $A.get('e.force:refreshView').fire();
                component.set('v.isPlanSubmitted', true);
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
    
    
    showPreviousBusinessPlan : function(component, event, helper) {
        var curentCounter = component.get('v.planCounter') + 1;        
       // if (component.get('v.bPlansforUser')[curentCounter].Status__c === 'Submitted' || component.get('v.bPlansforUser')[curentCounter].Status__c === 'Published') {
      	  if (component.get('v.bPlansforUser')[curentCounter].cplan__Status__c !== 'Draft') {
            component.set('v.isPlanSubmitted', true);
        } else {
            component.set('v.isPlanSubmitted', false); 
        }
        
        component.set('v.bPlanId', component.get('v.bPlansforUser')[curentCounter].Id);
        component.set('v.planCounter', curentCounter);
    },
    
    refreshChild: function(component, event, helper) {
        component.set('v.refreshChild', !component.get('v.refreshChild'));
    },
    
    showNextBusinessPlan : function(component, event, helper) {
        var curentCounter = component.get('v.planCounter') - 1;
        
        //if (component.get('v.bPlansforUser')[curentCounter].Status__c === 'Submitted' || component.get('v.bPlansforUser')[curentCounter].Status__c === 'Published') {
          if (component.get('v.bPlansforUser')[curentCounter].cplan__Status__c !== 'Draft') {
            component.set('v.isPlanSubmitted', true);
        } else {
            component.set('v.isPlanSubmitted', false); 
        }
        
        component.set('v.bPlanId', component.get('v.bPlansforUser')[curentCounter].Id);
        component.set('v.planCounter', curentCounter);
    }
  
})