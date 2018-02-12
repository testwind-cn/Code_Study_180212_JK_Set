/**
 * 
 */
package serverTransport;

import java.sql.ResultSet;

/**
 * @author DEV
 *
 */
public class RequstWjArrayList {
	
	
	
	public static serverServicePkg.WjArrayList getWjArrayList(String sql) {
		serverServicePkg.WjArrayList theArrayList;
		
		ResultSet rs = serverServicePkg.ServerApp.getResultSet(sql);
		
		try {
			theArrayList = new serverServicePkg.WjArrayList(rs);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			theArrayList = null;
		}
		return theArrayList;
	}
}
