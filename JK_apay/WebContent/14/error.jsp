<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body>
数据有问题，请检查;<br>
<%
Object obj = request.getAttribute("msg");
if ( obj != null ) {
	out.println(obj.toString());
}else{
	out.println("无");
}
%>
</body>
</html>