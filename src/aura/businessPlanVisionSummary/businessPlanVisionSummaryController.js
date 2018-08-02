({
	showInEditMode : function(component, event, helper) {
        component.set("v.editMode", true);
		
	},
    
    init: function(component, event, helper) {
 		helper.createRecordView(component);       
    },
    
    save: function(component, event, helper) {
        component.find("edit").get("e.recordSave").fire();
    },
    
    saveCompleted: function(component, event, helper) {
        component.set("v.editMode", false);
        helper.createRecordView(component);
    }
})