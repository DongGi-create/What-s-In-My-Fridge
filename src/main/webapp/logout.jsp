<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WIF 로그아웃</title>
</head>
<body>
	<%
	session.invalidate();
	out.println("<script>alert('성공적으로 로그아웃이 완료되었습니다.');document.location.href='/WIF/index.jsp';</script>");
	%>
</body>
</html>