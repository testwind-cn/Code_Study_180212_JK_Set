/**
 * 
 */
package clientAppMainPkg;

import javax.swing.JPanel;
import javax.swing.JButton;
import javax.swing.JTextField;
import javax.swing.JTextPane;
import javax.swing.JPasswordField;
import javax.swing.UIManager;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.JLabel;
import java.awt.Color;

/**
 * @author DEV
 *
 */
public class LoginPanel extends JPanel implements ActionListener {
	private JTextField nameField;
	private JPasswordField passwordField;
	
	/**
	 * Create the panel.
	 */
	public LoginPanel() {
		setBackground(Color.PINK);
		setLayout(null);
		
		JButton btnNewButton = new JButton("登录1234");
		btnNewButton.addActionListener(this);
		
		
		btnNewButton.setBounds(61, 10, 95, 25);
		add(btnNewButton);
		
		nameField = new JTextField();
		nameField.setText("100001");
		nameField.setBounds(116, 48, 95, 21);
		add(nameField);
		nameField.setColumns(10);
		
		passwordField = new JPasswordField();
		passwordField.setBounds(100, 106, 95, 21);
		passwordField.setText("123456");
		add(passwordField);
		
		JLabel lblNewLabel = new JLabel("\u7528\u6237\u540D");
		lblNewLabel.setBounds(36, 51, 54, 15);
		add(lblNewLabel);
		
		JLabel label = new JLabel("\u5BC6\u7801");
		label.setBounds(36, 109, 54, 15);
		add(label);

	}

	/* (non-Javadoc)
	 * @see java.awt.event.ActionListener#actionPerformed(java.awt.event.ActionEvent)
	 */
	@Override
	public void actionPerformed(ActionEvent e) {
		// TODO Auto-generated method stub
		if ( e.getActionCommand().equals("登录1234") ) {
			char [] temp_pwd = passwordField.getPassword();
			String passwd = new String(temp_pwd);
			MainFram mfrm = (MainFram) getRootPane().getParent();
			mfrm.Login(nameField.getText(),passwd);
		}
		
	}
}
