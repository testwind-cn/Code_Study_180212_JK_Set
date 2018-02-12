

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import DefaultNamespace.CCCCServiceProxy;

/**
 * Servlet implementation class ZZZ
 */
@WebServlet("/ZZZ")
public class ZZZ extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ZZZ() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    public void myshow(HttpServletResponse response) {
    	  CCCCServiceProxy csp = new CCCCServiceProxy();

    	try {

    		System.out.println(csp.plus(100, 23));
    		java.io.PrintWriter out=response.getWriter();
    		out.println("<html>");//输出的内容要放在body中
    		out.println("<body>");
    		out.println(csp.plus(100, 23));
    		out.println("</body>");
    		out.println("</html>"); 

    	} catch (Exception e) {

    		// TODO: handle exception

    	}
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		myshow( response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		myshow( response);
	}

}
