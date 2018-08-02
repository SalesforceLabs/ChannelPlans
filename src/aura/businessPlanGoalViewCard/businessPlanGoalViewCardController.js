({
    editGoal : function(component, event, helper) {
        component.set('v.editMode', true);
        var modalBody;
        
        $A.createComponent("c:businessPlanGoalEditWhenUnpublished", {id: component.get('v.gId')},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   console.log(content)
                                   component.find('overlayLib').showCustomModal({
                                       header: "Goal Detail",
                                       body: modalBody, 
                                       showCloseButton: true,
                                       cssClass: "mymodal",
                                       closeCallback: function() {
                                           console.log('In closeCallback completed');
                                       }
                                   })
                               }                               
                           });
    },
    
    deleteGoal : function(component, event, helper) {
        
        var action = component.get("c.deleteUnPublishedBPlanGoal");
        action.setParams({ goalId : component.get("v.gId") });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var reqRefresh = $A.get("e.c:businessPlanRefreshRequestAppEvent");
                reqRefresh.setParams({
                    "refresh" : true });
                reqRefresh.fire();
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
    
    markComplete: function(component, event, helper) {
        var action = component.get("c.setGoalComplete");
        action.setParams({ goalId : component.get("v.gId") });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var reqRefresh = $A.get("e.c:businessPlanRefreshRequestAppEvent");
                reqRefresh.setParams({
                    "refresh" : true });
                reqRefresh.fire();
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