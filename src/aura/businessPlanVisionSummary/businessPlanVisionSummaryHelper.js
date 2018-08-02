({
	createRecordView : function(component) {
        console.log('createRecordView called');
		var businessPlanId = component.get('v.businessPlanId');
        if (businessPlanId) {
            $A.createComponent('force:recordView', {
                recordId: businessPlanId,
                type: 'FULL'
            }, function(newComponent, status, errorMessage) {
                if (status === 'SUCCESS') {
                	component.find('recordViewContainer').set('v.body', [newComponent]);    
                }
            })
        }
	}
})