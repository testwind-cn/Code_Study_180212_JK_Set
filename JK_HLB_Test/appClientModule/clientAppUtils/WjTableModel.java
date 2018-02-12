/**
 * 
 */
package clientAppUtils;

import javax.swing.table.AbstractTableModel;


/**
 * @author DEV
 *
 */
public class WjTableModel extends AbstractTableModel {

	
	private int column = 4;
    private String[] columnName = null;
    private java.util.ArrayList resultSet = null;   
    
    public WjTableModel() {
    }

    public WjTableModel(String sql)  throws Exception {
  //      if (DScolumnName.length != columnName.length) {
  //          throw new Exception("指定JTable列和指定数据库列数不一致，无法进行数据绑定");
  //      }
    	
    	java.util.ArrayList rs = clientTransport.RequstWjArrayList.getWjArrayList(sql);
    	
        if ( rs.size() < 1 )
        {
        	throw new Exception("指定JTable列和指定数据库列数不一致，无法进行数据绑定");
        }
        
        String[] row = (String[]) rs.get(0);
        
        this.columnName = row;
        column = row.length;
        resultSet = rs;
    }

    
	/* (non-Javadoc)
	 * @see javax.swing.table.TableModel#getColumnCount()
	 */
	@Override
	public int getColumnCount() {
		// TODO Auto-generated method stub
		return column;
	}

	/* (non-Javadoc)
	 * @see javax.swing.table.TableModel#getRowCount()
	 */
	@Override
	public int getRowCount() {
		// TODO Auto-generated method stub
		return resultSet.size() - 1;
	//	return 0;
	}

	/* (non-Javadoc)
	 * @see javax.swing.table.TableModel#getValueAt(int, int)
	 */
	@Override
	public Object getValueAt(int rowIndex, int columnIndex) {
		// TODO Auto-generated method stub
		
		String[] row = (String[]) resultSet.get(rowIndex+1);
        return row[columnIndex];
	}

	@Override
	public String getColumnName(int arg0) {
		// TODO Auto-generated method stub
		
		return columnName[arg0];
	//	return super.getColumnName(arg0);
	}

}
