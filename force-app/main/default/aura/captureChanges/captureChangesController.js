({
	 handleValueChange:function(cmp)
    {
      
    console.log("value: " + cmp.get('v.myVal'));
        alert("old value: " + event.getParam("oldValue"));
        alert("current value: " + event.getParam("value"));
},
    changeValue : function (component, event, helper) {
      component.set("v.myBool", false);
    },

    handleValueChange : function (component, event, helper) {
        // handle value change
        alert("old value: " + event.getParam("oldValue"));
        alert("current value: " + event.getParam("value"));
    }
})