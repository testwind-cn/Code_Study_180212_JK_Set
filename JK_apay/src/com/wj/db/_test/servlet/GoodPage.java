package com.wj.db._test.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 什么都没有，就一个空 servlet，打印和跳转
 */

public class GoodPage extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3553390690789621032L;

//	@Override
//	protected void service(HttpServletRequest req, HttpServletResponse resp)
//			throws ServletException, IOException {
//		// TODO Auto-generated method stub
//		//super.service(arg0, arg1);
//		String user = req.getParameter("uname");
//		String password = req.getParameter("upwd");
//		PrintWriter prt = resp.getWriter();
//		prt.println(user+"  "+password);
//		prt.close();
//	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
//		super.doGet(req, resp);
		System.out.println("==get==");
		String user = req.getParameter("uname");
		String password = req.getParameter("upwd");
		PrintWriter prt = resp.getWriter();
		prt.println(user+"  "+password);
		prt.close();
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
//		super.doPost(req, resp);
		System.out.println("==post==");
		String user = req.getParameter("uname");
		String password = req.getParameter("upwd");
//		PrintWriter prt = resp.getWriter();
//		prt.println(user+"  "+password);
//		prt.close(); 
		RequestDispatcher a = req.getRequestDispatcher("/14/success.jsp");
		a.forward(req, resp);
//		resp.sendRedirect(req.getContextPath()+"/14/success.jsp");
	}

}
