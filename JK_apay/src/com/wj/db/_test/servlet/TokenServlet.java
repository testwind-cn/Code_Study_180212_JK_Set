package com.wj.db._test.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.wj.db.dao.service.TokenService;


public class TokenServlet extends HttpServlet {
	


	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		// https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wx66dded684c14bfd1&secret=e5f1a2b154a810183f1e3032eb289c98
		
		TokenService ts = new TokenService();
		
		String aa = ts.RefreshToken();
		
		resp.getWriter().append("New Token is: ").append(req.getContextPath()).append(aa);
	}
	
	


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public TokenServlet() {
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
