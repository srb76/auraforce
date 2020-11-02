public class MojangApiCallout {
    static String api = 'https://api.mojang.com/users/profiles/minecraft/';
    static String orders = 'https://api.mojang.com/orders/statistics';
    static String session = 'https://sessionserver.mojang.com/session/minecraft/profile/';
    static String user = 'graescale'; //use for testing
    static String uuid = null;
	
    //returns a uuid for a given minecraft.net username
    public static String getUUID(String username){
        String userId = null;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        //Set up request
        req.setMethod('GET');
        req.setEndpoint(api + username);
        
        //Response
        HttpResponse res = http.send(req);
        
        if(res.getStatusCode() == 200){
            String body = res.getBody();
            Map<String,Object> resMap = (Map<String,Object>)JSON.deserializeUntyped(body);
            
            userId = String.valueOf(resMap.get('id'));
        }
        
        return userId;
    }
    
    //Returns a url to a minecraft skin image, given a uuid
    public static String getSkinUrl(String userId){
        String skinUrl = null;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        //Set up request
        req.setMethod('GET');
        req.setEndpoint(session + userId);
        
        //Response
        HttpResponse res = http.send(req);
        
        if(res.getStatusCode() == 200){
            String body = res.getBody();
            Map<String,Object> resMap = (Map<String,Object>)JSON.deserializeUntyped(body);
            List<Object> valueMap = (List<Object>)resMap.get('properties');
            
            //parentheses in the returned json cause difficulty
			skinUrl = valueMap[0].toString();
            skinUrl = skinUrl.substringBetween('value=', '}');
            
            //decode the returned base64
            skinUrl = System.EncodingUtil.base64Decode(skinUrl).toString();
			//decoded info contains more json...
            
            //get textures property
            resMap = (Map<String,Object>)JSON.deserializeUntyped(skinUrl);
            Map<String,Object> textureMap = (Map<String,Object>)resMap.get('textures');

            skinUrl = textureMap.get('SKIN').toString();
            skinUrl = skinUrl.substringBetween('url=', '}');

            //System.Debug(skinUrl);
        }
        
        return skinUrl;
    }
    
    //method to get token?
    
    //method to reset or upload skin
    
    //method to get sales info
    public static List<Integer> getSalesInfo(){
        List<Integer> salesInfo = new List<Integer>();
        
        //make post request to mojang api
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        //Set up request
        req.setMethod('POST');
        req.setEndpoint(orders);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        //Build json request
        List<String> jsonList = new List<String>();
        jsonList.add('item_sold_minecraft');
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeObjectField('metricKeys', jsonList);
        gen.writeEndObject();
        String reqBody = gen.getAsString();
        
        req.setBody(reqBody);
        
        //Send request
        HttpResponse res = http.send(req);
        
        if(res.getStatusCode() == 200){
            String body = res.getBody();
            
            //parse json
            Map<String,Object> resMap = (Map<String,Object>)JSON.deserializeUntyped(body);
            String val = resMap.toString();
            
            //get total copies sold integer and save to result list
            String total = val.substringBetween('total=', '}');
            salesInfo.add( Integer.valueOf(total) );
            
            //get 24 hours copies sold
            String daySales = val.substringBetween('last24h=', ',');
            salesInfo.add( Integer.valueOf(daySales) );
            
            //System.debug(salesInfo);
        }
        else{
            System.debug('Bad Request for sales info.');
            System.debug(res.getStatusCode());
        }
        
        return salesInfo;
    }
    
    public void setUser(String newUser){
        user = newUser;
    }
}