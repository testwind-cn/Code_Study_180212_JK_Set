/**
 * 
 */
package clientAppMainPkg;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.BoxLayout;
import java.awt.Component;
import java.awt.GridLayout;
import javax.swing.JTextArea;

/**
 * @author DEV
 *
 */
public class ShowMessage extends JDialog implements ActionListener {

	private final JPanel contentPanel = new JPanel();
	private final JTextArea textArea = new JTextArea();
	private final JPanel buttonPane = new JPanel();

	/**
	 * Create the dialog.
	 */
	public ShowMessage() {
		setResizable(false);
		setBounds(100, 100, 317, 177);
		getContentPane().setLayout(null);
		contentPanel.setBounds(0, 0, 309, 89);
		getContentPane().add(contentPanel);
		contentPanel.setAlignmentX(Component.LEFT_ALIGNMENT);
		contentPanel.setAlignmentY(Component.BOTTOM_ALIGNMENT);
		contentPanel.setBorder(new EmptyBorder(5, 5, 5, 5));
		contentPanel.setLayout(null);
		
		
		textArea.setBounds(69, 20, 172, 65);
		contentPanel.add(textArea);
		{
			
			buttonPane.setBounds(10, 99, 313, 81);
			getContentPane().add(buttonPane);
			{
				buttonPane.setLayout(null);
			}
			{
				JButton cancelButton = new JButton("Cancel");
				cancelButton.setBounds(148, 22, 100, 25);
				cancelButton.setActionCommand("Cancel");
				cancelButton.addActionListener(this);
				buttonPane.add(cancelButton);
			}
			JButton okButton = new JButton("OK");
			okButton.setBounds(45, 22, 77, 25);
			buttonPane.add(okButton);
			okButton.setActionCommand("OK");
			okButton.addActionListener(this);
			getRootPane().setDefaultButton(okButton);
		}
	}
	
	public void SetShowText(String msg) {
		textArea.setText(msg);
	}


	/* (non-Javadoc)
	 * @see java.awt.event.ActionListener#actionPerformed(java.awt.event.ActionEvent)
	 */
	@Override
	public void actionPerformed(ActionEvent arg0) {
		// TODO Auto-generated method stub
		if ( arg0.getActionCommand().equals("Cancel")){
			this.setVisible(false);
		}
		if ( arg0.getActionCommand().equals("OK")){
			this.setVisible(false);
		}
		
	}
}
