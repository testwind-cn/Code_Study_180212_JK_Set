/**
 * 
 */
package serverServicePkg;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;

/**
 * @author DEV
 *
 */
public class WjArrayList extends ArrayList<String[]> {

	
	public WjArrayList(ResultSet rs) throws Exception {

		
		// 获得数据结果集合
		ResultSetMetaData rmeta;		
		rmeta = rs.getMetaData();
		// 确定数据集的列数，亦字段数
		int column = rmeta.getColumnCount();
		
		
		
        try {
        	
        	String[] row;
        	
        	row = new String[column];
    		for (int i = 0; i < column; i++) {
                row[i] = rmeta.getColumnName(i+1);
            }
    		this.add(row); 
    		
            while (rs.next()) {
                row = new String[column];
                for (int i = 0; i < column; i++) {
                    row[i] = rs.getString(i+1);
                }
                this.add(row);              
            }
        } catch (Exception e) {
            //LoggerUtil.WriteErrLog(e);
            throw e;
            // System.out.println("err");
        }
	}
        
}
