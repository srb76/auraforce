({
	getInfo : function(cmp, evt, help) {
        //query db to determine if account already exists in org db
        //if yes, show info page
        //if no, show form page
        help.getInfo(cmp, help);
		help.toggleNeedName(cmp);
	},
    
    handleSubmit : function(cmp, evt, help){
        //show info page
        //help.toggleShowInfo(cmp);
        help.toggleNeedDb(cmp);
        
        //assign id and clear view data
        cmp.set('v.username', cmp.get('v.formUsername'));
        cmp.set('v.mcRecord', null);
        cmp.set('v.mcId', null);
        
        //get new data
        help.getInfo(cmp, help);
        help.getMcObject(cmp, help);
        //reload record data
        cmp.find("accData").reloadRecord(true);
    },
    
    updateInfo : function(cmp, evt, help){
        //make api callout in apex controller
        help.updateInfo(cmp, help);
    },
    
    cancelHandler : function(cmp, evt, help){
        //hide form, show name page
        help.toggleNeedName(cmp);
        help.toggleNeedDb(cmp);
    },
    
    searchHandler : function(cmp, evt, help){
        //hide info, show name page
        help.toggleNeedName(cmp);
        help.toggleShowInfo(cmp);
    }
})