({
	clickmeInjs : function(component,event) {
       var btnclcik = event.getSource();
         var btnmsg = btnclcik.get("v.value");
         component.set("v.message", btnmsg);  
         
		
	}
})