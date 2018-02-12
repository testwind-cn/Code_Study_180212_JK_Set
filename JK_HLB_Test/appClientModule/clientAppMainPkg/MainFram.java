/**
 * 
 */
package clientAppMainPkg;

import java.awt.BorderLayout;
import java.awt.EventQueue;
import java.net.InetAddress;

import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import java.awt.Toolkit;





/**
 * @author DEV
 *
 */
public class MainFram extends JFrame {

	private JPanel contentPane;
	private LoginPanel thePanel;
	
	
	


	/**
	 * Create the frame.
	 */
	public MainFram() {
		setIconImage(Toolkit.getDefaultToolkit().getImage(MainFram.class.getResource("/clientAppMainPkg/icon.gif")));
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		contentPane = new LoginPanel(); // new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		contentPane.setLayout(new BorderLayout(0, 0));
		setContentPane(contentPane);
		
		
	}
	
	
	public void Login(String name,String passwd) {
		
		String localname,localip = "x.x.x.x";
		java.net.InetAddress ia=null;
        try {
            ia= java.net.InetAddress.getLocalHost();
             
            localname=ia.getHostName();
            localip=ia.getHostAddress();
            System.out.println("本机名称是："+ localname);
            System.out.println("本机的ip是 ："+localip);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        

        

        String login_token = 
        		serverServicePkg.ServerApp.Login( name, passwd, localip );
        
		try {
			ShowMessage dialog = new ShowMessage();
			
			if ( login_token != null )
				dialog.SetShowText("登录成功 UUID: \n"+ login_token);
			else
				dialog.SetShowText("登录失败");
			
			////1BEGIN	定位
			java.awt.Point p1 = getLocation();
			java.awt.Point p2 = new java.awt.Point(0,0);
			java.awt.Dimension size1 = getSize();
			java.awt.Dimension size2 = dialog.getSize();
			p2.setLocation(p1.x + ( size1.width - size2.width ) / 2,
					p1.y + ( size1.height- size2.height ) / 2 );
			dialog.setLocation(p2);
			////1END	定位
			
			dialog.setDefaultCloseOperation(JDialog.DISPOSE_ON_CLOSE);
			dialog.setModal(true);
			dialog.setVisible(true);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		if ( login_token != null ) {
			contentPane = new MainPanel();
			contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
//			contentPane.setLayout(new BorderLayout(0, 0));
			setContentPane(contentPane);
			contentPane.setVisible(true);
			
			this.invalidate();
			this.paintComponents(this.getGraphics());			
		}
		
	
	}
	



}
