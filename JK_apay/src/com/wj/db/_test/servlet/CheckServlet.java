package com.wj.db._test.servlet;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.wj.db.dao.entity.User;
import com.wj.db.dao.service.UserService;
import com.wj.db.dao.util.ConnectionFactory;

import java.sql.Connection;

public class CheckServlet extends HttpServlet {
	
	private UserService cku = new UserService();

//	@Override
	protected void doPost1(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	super.doPost(req, resp);
		String forward = null;
		String uname = req.getParameter("uname");
		String passwd = req.getParameter("upwd");
		
		RequestDispatcher rd = null;
		
		
		/*		forward = "/14/success.jsp";
		rd = req.getRequestDispatcher(forward);
		rd.forward(req, resp);
		return;*/
				
	
		
		if (uname == null || passwd == null){
			req.setAttribute("msg", "用户名为空");
			forward = "/14/success.jsp";
	
		}else{
			 User user = new User();
			 user.setName(uname);
			 user.setPassword(passwd);
			 if ( cku.check(user) ) {
				 forward = "/14/success.jsp";
			 } else {
				 req.setAttribute("msg", "用户名密码错误");
				 forward = "/14/error.jsp";
			 }
			 
		} 
		
		rd = req.getRequestDispatcher(forward);
		rd.forward(req, resp);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String sql  = "SELECT * from user";
		Connection conn = ConnectionFactory.getInstance().makeConnection();
		Statement st = null;
		ResultSet rs = null;
		
		String aa;

		if ( conn != null ) 
		{
			try {
				st = conn.createStatement();
				rs = st.executeQuery(sql);
				aa = "ok";
				while ( rs.next() ){
					aa = aa.concat(rs.getString("name")).concat(rs.getString("passwd"));
					aa = aa.concat(" ");
					aa = aa.concat(rs.getString("name"));
					aa = aa.concat(" ");
					aa = aa.concat(rs.getString("passwd"));
				}
				
			}catch(Exception e){
				aa = e.toString();
			}finally {
				
			}
			
			resp.getWriter().append("Served at: ").append(req.getContextPath()).append(aa);
		} else
		{
			aa = "No Link";
		}
		
		resp.getWriter().append("Served at: ").append(req.getContextPath()).append("  ").append(aa);
	}


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public CheckServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
//		super.doGet(req, resp);
		doPost(req,resp);
	}

}
