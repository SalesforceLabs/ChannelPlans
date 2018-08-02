({
	save : function(component, event, helper) {
		component.find("edit").get("e.recordSave").fire();
        component.set("v.id", "");
        var reqRefresh = $A.get("e.c:businessPlanRefreshRequestAppEvent");
        reqRefresh.setParams({
            "refresh" : true });
        reqRefresh.fire();
	},
    
    cancel: function(component, event, helper) {
        
        var deleteGoalEvt = $A.get("e.c:businessPlanDeleteGoalEvent");
        deleteGoalEvt.setParams({
            "goalId" : component.get("v.id") });
        deleteGoalEvt.fire();
	}
})