public class decode64 {   
    public static String decode64(String encode){
        Blob raw = System.EncodingUtil.base64Decode(encode);
        return raw.toString();
    }
}