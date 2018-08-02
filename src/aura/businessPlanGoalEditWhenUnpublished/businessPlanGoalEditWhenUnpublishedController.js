({
    save : function(component, event, helper) {
        console.log('In save')
        component.find("edit").get("e.recordSave").fire();
        var reqRefresh = $A.get("e.c:businessPlanRefreshRequestAppEvent");
        reqRefresh.setParams({
            "refresh" : true });
        reqRefresh.fire();
        console.log('Refresh event fired in the Save method');
        component.find("overlayLib").notifyClose(); //Should this not be called only when using the X button?
    }
})