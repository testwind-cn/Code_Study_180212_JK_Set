import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 
 */

/**
 * @author DEV
 *
 */
public class test {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Date d = new Date();
		System.out.println(d);
		int x = -1;
//		SimpleDateFormat ft = new SimpleDateFormat ("yyyy-MM-dd");
		if ( x > 0 )
			System.out.println("x > 0");
		else if ( x == 0 )
			System.out.println("x == 0");
		else
			System.out.println("x < 0");
		
		System.out.println(d.getTime() / 1000 );
		System.out.println( (int)(1.0198*100) );
		
		
		System.out.println( getSha1("http://tool.oschina.net/encrypt?type=2") );
		
		
		
		
	}
	
	
	
	public static String getSha1(String str){
        if(str==null||str.length()==0){
            return null;
        }
        char hexDigits[] = {'0','1','2','3','4','5','6','7','8','9',
                'a','b','c','d','e','f'};
        try {
            MessageDigest mdTemp = MessageDigest.getInstance("SHA1");
            mdTemp.update(str.getBytes("UTF-8"));

            byte[] md = mdTemp.digest();
            int j = md.length;
            char buf[] = new char[j*2];
            int k = 0;
            for (int i = 0; i < j; i++) {
                byte byte0 = md[i];
                buf[k++] = hexDigits[byte0 >>> 4 & 0xf];
                buf[k++] = hexDigits[byte0 & 0xf];      
            }
            return new String(buf);
        } catch (Exception e) {
            // TODO: handle exception
            return null;
        }
    }

}
