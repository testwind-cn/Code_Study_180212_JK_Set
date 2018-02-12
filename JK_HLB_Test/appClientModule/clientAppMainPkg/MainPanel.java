/**
 * 
 */
package clientAppMainPkg;

import javax.swing.JPanel;
import javax.swing.JSplitPane;
import java.awt.BorderLayout;
import javax.swing.JScrollPane;
import javax.swing.JButton;
import javax.swing.JTable;
import javax.swing.JFormattedTextField;
import javax.swing.BoxLayout;
import javax.swing.JSeparator;
import java.awt.Component;
import javax.swing.Box;

/**
 * @author DEV
 *
 */
public class MainPanel extends JPanel {
	private JTable table;

	/**
	 * Create the panel.
	 */
	public MainPanel() {
		setLayout(new BorderLayout(0, 0));
		
		JSplitPane splitPane = new JSplitPane();
		add(splitPane);
		
		JScrollPane scrollPane = new JScrollPane();
		splitPane.setRightComponent(scrollPane);
		
		
		String[] columnNames = {"Product","Number of Boxes","Price"};
		
		Object[][] data =
			{
			{"Apples", new Integer(5),"5.00"},
			         {"Oranges", new Integer(3),"6.00"},
			         {"Pears", new Integer(2),"4.00"},
			         {"Grapes", new Integer(3),"2.00"},
			};
		
		clientAppUtils.WjTableModel dm=null;
		try {
			dm = new clientAppUtils.WjTableModel("select * from users");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		table = new JTable(dm);
		
//		table = new JTable(data, columnNames);
		table.setFillsViewportHeight(true);
		scrollPane.setViewportView(table);
	//	scrollPane.setRowHeaderView(table);
		
		javax.swing.table.TableColumn tc = new javax.swing.table.TableColumn();
	

		//table.addColumn(arg0);
		
		JPanel panel = new JPanel();
		splitPane.setLeftComponent(panel);
		panel.setLayout( new BoxLayout(panel, BoxLayout.Y_AXIS) );
		
		panel.add(javax.swing.Box.createVerticalStrut(10));
		
		JButton btnNewButton_1 = new JButton("\u67E5\u8BE2\u5546\u6237");
		btnNewButton_1.setAlignmentX(Component.CENTER_ALIGNMENT);
		panel.add(btnNewButton_1);
		
		panel.add(javax.swing.Box.createVerticalStrut(10));
		
		JSeparator separator = new JSeparator();		
		panel.add(separator);
		
		clientAppUtils.DateChooser date1  = new clientAppUtils.DateChooser();
		panel.add(date1);
		panel.add(javax.swing.Box.createVerticalStrut(10)); 
		
		clientAppUtils.DateChooser date2  = new clientAppUtils.DateChooser();
		panel.add(date2);
		
		panel.add(javax.swing.Box.createVerticalStrut(10)); 
		
		JFormattedTextField formattedTextField = new JFormattedTextField();
		panel.add(formattedTextField);
		
		
		panel.add(javax.swing.Box.createVerticalStrut(10)); 

	}
}
