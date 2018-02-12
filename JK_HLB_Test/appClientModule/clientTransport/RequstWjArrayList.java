/**
 * 
 */
package clientTransport;

import java.sql.ResultSet;

/**
 * @author DEV
 *
 */
public class RequstWjArrayList {
	
	public static java.util.ArrayList getWjArrayList(String sql) {
		java.util.ArrayList theArrayList;
		theArrayList = serverTransport.RequstWjArrayList.getWjArrayList(sql);
		return theArrayList;
	}

}
