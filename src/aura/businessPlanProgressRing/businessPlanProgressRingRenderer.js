({
    render: function(component, helper) {
        var ret = this.superRender();
        
        var start = parseInt(component.get('v.start'));
        var current = parseInt(component.get('v.current'));
        var total = parseInt(component.get('v.total'));
        var color = component.get('v.color');
        
  		var rootElement = component.find('progressRingParent').getElement();
        
        var fillPercent = (current - start) / (total - start)
        var isLong = fillPercent <= 0.5 ? 0 : 1;
        component.set('v.fillPercentage', isNaN(fillPercent) ? 0 : Math.ceil(fillPercent * 100));
        
        var arcX = Math.cos(2 * Math.PI * (fillPercent > 1 ? 1 : fillPercent));
        var arcY = Math.sin(2 * Math.PI * (fillPercent > 1 ? 1 : fillPercent));

        var path = 'M 1 0 A 1 1 0 ' + isLong + ' 1 ' + arcX + ' ' + arcY + ' L 0 0';
        
        var genHTML  = '<svg viewBox="-1 -1 2 2">';
        genHTML += '	<path class="slds-progress-ring__path" d="' + path + '" style="fill:' + color +'" />';
        genHTML += '</svg>';

        rootElement.innerHTML = genHTML;
        
        return ret;
    }
})