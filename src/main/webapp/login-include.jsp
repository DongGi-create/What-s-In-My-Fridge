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
		out.println("<a style=\"text-decoration-line: none; color: white;\" href=\"/WIF/login-form.jsp\" id=\"loginNeeded\">로그인</a>");
	else
		out.println("<a style=\"text-decoration-line: none; color: white;\" href=\"/WIF/logout.jsp\" id=\"logoutNeeded\">로그아웃</a>");
	%>
</body>
</html>