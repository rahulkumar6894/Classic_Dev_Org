({
	doInit : function(component, event) {
        var action = component.get("c.getToken");
        action.setCallback(this, function(a) {
               alert('CallMethod'+a.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})