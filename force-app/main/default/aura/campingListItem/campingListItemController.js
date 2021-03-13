({
	
    clickme:function(component,event, helper) {
         /* Method Call  direct in  class
          
         btnclcik = event.getSource();
         var btnmsg = btnclcik.get("v.value");
         component.set("v.message", btnmsg); */
         // Visa javaScript call function
		helper.clickmeInjs(component,event);
	}
})