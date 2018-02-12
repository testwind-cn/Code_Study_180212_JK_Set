<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>登录页面</title>

<script type="text/javascript">
 function check(form){
	 if ( document.forms.loginform.uname.value==""){
		 alert("请输入用户名");
		 document.forms.loginform.uname.focus();
		 return false;
	 }
	 if ( document.forms.loginform.upwd.value==""){
		 alert("请输入密码");
		 document.forms.loginform.upwd.focus();
		 return false;
	 }
	 return true;
 }
</script>

</head>
<body>
<%=request.getContextPath()%>
<br>
<form action="<%=request.getContextPath()%>/CheckServlet"   method = "post"  name="loginform"> 
userName名字: <input type="text" name="uname"/> <br/> 
password: <input type="text" name="upwd" /> <br/> 
<input type="submit" value="login" name="submit" onclick="return check(this);"/>

</form>

</body>
</html>