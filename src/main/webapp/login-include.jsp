<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>음</title>
</head>
<body>
	<%
	if (session.getAttribute("user-id") == null)
		out.println("<a href=\"/WIF/login-form.html\">로그인</a>");
	else
		out.println("<a href=\"/WIF/logout.jsp\">로그아웃</a>");
	%>
</body>
</html>