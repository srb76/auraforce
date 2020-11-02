({
	toggleNeedName : function(cmp) {
		let need = cmp.get('v.needName');
        cmp.set('v.needName', !need);
	},
    
    toggleNeedDb : function(cmp){
     	let need = cmp.get('v.needDb');
        cmp.set('v.needDb', !need);
    },
    
    toggleShowInfo : function(cmp) {
        let show = cmp.get('v.showInfo');
        cmp.set('v.showInfo', !show);
    },
    
    getInfo : function(cmp, help) {
        //get apex controller method and get callback
        let action = cmp.get('c.getMCAccount');
        action.setParams({name : cmp.get("v.username")});
        
        //assign form defaults to input username
        cmp.set('v.formUsername', cmp.get('v.username'));
        cmp.set('v.formAccName', cmp.get('v.username') + ' Minecraft Account');
        
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                let data = response.getReturnValue();
                if(data != null){
                    //Object already exists
                    //save data to view, show info card
                    cmp.set('v.mcId', data.Id);
                    help.toggleShowInfo(cmp);
                    help.getMcObject(cmp, help);
                }
                else{
                    //No results found, note that sharing may affect query returned
                    //show form card
                    console.log("Did not find mc account for name: " + cmp.get('v.username'));
                    help.toggleNeedDb(cmp);
                }
            } else{
                console.log(response.getState());
            }
        });
        $A.enqueueAction(action);
    },
    
    updateInfo : function(cmp, help){
        //first try to get uuid, then skin url from apex controller
        let id = cmp.get("v.mcId");
        help.getUUID(cmp, help);
        help.getSkinUrl(cmp, help);
        //try to reload form, need to use true to force serverside update instead of cache
        cmp.find("accData").reloadRecord(true);
    },
    
    getUUID : function(cmp, help){
        //call apex method
        let id = cmp.get("v.mcId");
        let action = cmp.get("c.updateUUID");
        //set param
        action.setParams({mcId : id});
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                //success
            }
        });
        $A.enqueueAction(action);
    },
    
    getSkinUrl : function(cmp, help){
        //call apex method
        let id = cmp.get("v.mcId");
        let action = cmp.get("c.updateSkinUrl");
        //set params
        action.setParams({mcId : id});
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                
            }
        });
        $A.enqueueAction(action);
    },
    
    getMcObject : function(cmp, help){
        //call apex method then save to view
        let id = cmp.get("v.mcId");
        let action = cmp.get("c.getMcObject");
        //set params
        action.setParams({mcId : id});
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                //save
                //console.log("MC object retrieved successfully.");
                let res = response.getReturnValue();
                cmp.set("v.mcObject", res);
            }
        });
        $A.enqueueAction(action);
    }
})