public class MojangController {
	@AuraEnabled
    public static List<Integer> getSalesInfo(){
        //Retrieves an integer list with total minecraft copies sold
        // and daily minecraft copies sold
        return MojangApiCallout.getSalesInfo();
    }
    
    @AuraEnabled
    public static String getUUID(String name){
        //Retrieves the uuid for a given minecraft username
        return MojangApiCallout.getUUID(name);
    }
    
    @AuraEnabled
    public static String getSkin(String uuid){
        //Retrieves a url to a user's current minecraft skin
        return MojangApiCallout.getSkinUrl(uuid);
    }
    
    @AuraEnabled
    public static Minecraft_Account__c getMCAccount(String name){
        //Get a Minecraft Account object for the given name, if it exists
        List<Minecraft_Account__c> accs = [SELECT Id, Username__c, UUID__c, Skin_URL__c FROM Minecraft_Account__c WHERE Username__c = :name];
        if(accs.isEmpty()){
            System.debug('No Minecraft Account found.');
            return null;
        }
        else
            return accs[0];
    }
    
    @AuraEnabled
    public static void updateUUID(Id mcId){
        Minecraft_Account__c mc = [SELECT Id, UUID__c, Username__c FROM Minecraft_Account__c WHERE Id = :mcId];
        mc.UUID__c = getUUID(mc.Username__c);
        update mc;
    }
    
    @AuraEnabled
    public static void updateSkinUrl(Id mcId){
        Minecraft_Account__c mc = [SELECT Id, UUID__c, Username__c, Skin_Url__c FROM Minecraft_Account__c WHERE Id = :mcId];
        mc.Skin_URL__c = getSkin(mc.UUID__c);
        update mc;
    }
    
    @AuraEnabled
    public static Minecraft_Account__c getMcObject(Id mcId){
        return [SELECT Id, UUID__c, Username__c, Skin_Url__c FROM Minecraft_Account__c WHERE Id = :mcId];
    }
}