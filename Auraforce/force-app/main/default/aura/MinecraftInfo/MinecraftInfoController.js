({
	doInit : function(component, event, helper) {
		//make api call to getSalesInfo method
		helper.getSales(component);
	},
    
    refresh : function(cmp, evt, help){
        //retrieve sales info from api again
        help.getSales(cmp);
    }
})