package com.wj.wechat.servlet;  
  
import java.io.BufferedReader;  
import java.io.IOException;  
import java.io.InputStream;  
import java.io.InputStreamReader;  
import java.io.OutputStream;  
  
import javax.servlet.ServletException;  
import javax.servlet.http.HttpServlet;  
import javax.servlet.http.HttpServletRequest;  
import javax.servlet.http.HttpServletResponse;

import com.wj.wechat.process.WechatProcess;  
/** 
 * 微信服务端收发消息接口 
 *  
 * @author pamchen-1 
 *  
 */  
public class WechatServlet extends HttpServlet {  
  
    /** 
     * The doGet method of the servlet. <br> 
     *  
     * This method is called when a form has its tag value method equals to get. 
     *  
     * @param request 
     *            the request send by the client to the server 
     * @param response 
     *            the response send by the server to the client 
     * @throws ServletException 
     *             if an error occurred 
     * @throws IOException 
     *             if an error occurred 
     */  
    public void doGet(HttpServletRequest request, HttpServletResponse response)  
            throws ServletException, IOException {  
        request.setCharacterEncoding("UTF-8");  
        response.setCharacterEncoding("UTF-8");  
  
        /** 读取接收到的xml消息 */  
        StringBuffer strBuf = new StringBuffer();  
        InputStream inStr = request.getInputStream();  
        InputStreamReader inStrRd = new InputStreamReader(inStr, "UTF-8");  
        BufferedReader bufRd = new BufferedReader(inStrRd);  
        String str = "";  
        while ((str = bufRd.readLine()) != null) {  
            strBuf.append(str);  
        }  
        String xml = strBuf.toString(); //次即为接收到微信端发送过来的xml数据  

        if ( xml == null || xml.length()<=0 )
    		xml="<xml> <ToUserName>aaa</ToUserName> <FromUserName>aaa</FromUserName>  <CreateTime>1348831860</CreateTime> <MsgType>text</MsgType> <Content>天气怎样</Content> <MsgId>1234567890123456</MsgId> </xml>";
     // xml="<text>今天上海天气怎样"; //

        String result = "";  
        /** 判断是否是微信接入激活验证，只有首次接入验证时才会收到echostr参数，此时需要把它直接返回 */  
        String echostr = request.getParameter("echostr");  
        if (echostr != null && echostr.length() > 1) {  
            result = echostr;  
            System.out.println("first time============");
        } else {  
            //正常的微信处理流程  
            result = new WechatProcess().processWechatMag(xml);  
            System.out.println("home time============");
        }  
  
        try {  
            OutputStream outStr = response.getOutputStream();  
            outStr.write(result.getBytes("UTF-8"));  
            outStr.flush();  
            outStr.close();  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
    }  
  
    /** 
     * The doPost method of the servlet. <br> 
     *  
     * This method is called when a form has its tag value method equals to 
     * post. 
     *  
     * @param request 
     *            the request send by the client to the server 
     * @param response 
     *            the response send by the server to the client 
     * @throws ServletException 
     *             if an error occurred 
     * @throws IOException 
     *             if an error occurred 
     */  
    public void doPost(HttpServletRequest request, HttpServletResponse response)  
            throws ServletException, IOException {  
        doGet(request, response);  
    }  
  
}  