({
	getSales : function(cmp) {
		//get apex method
		let action = cmp.get('c.getSalesInfo');
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                //set view attributes
                let data = response.getReturnValue();
                cmp.set("v.sales", data);
            }
        });
        $A.enqueueAction(action);
	}
})