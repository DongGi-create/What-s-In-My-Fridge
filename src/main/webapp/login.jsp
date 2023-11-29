<%@page import="Phase3Package.Users"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="Phase3Package.JDBCDriver"%>
<%@page import="java.sql.Connection"%>
<%@page import="Phase3Package.Configure"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>WIF 로그인</title>
</head>
<body>
	<!-- DB 연결 -->
	<%
	String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	String DB_ID = Configure.DB_ID;
	String DB_PW = "comp322";

	Connection conn = null;
	JDBCDriver.load();
	conn = JDBCDriver.getConnection(URL, DB_ID, DB_PW);
	%>

	<%
	String query = "SELECT * FROM USERS U WHERE U.user_ID = ? AND U.password = ?";
	PreparedStatement pstmt = conn.prepareStatement(query);
	String user_id = request.getParameter("user-id");
	String user_pw = request.getParameter("user-pw");
	pstmt.setString(1, user_id);
	pstmt.setString(2, user_pw);
	ResultSet rs = pstmt.executeQuery();
	boolean existing_User = false;
	while (rs.next())
	{
		existing_User = true;
	}
	if (existing_User)
	{
		session.setAttribute("user-id", user_id);
		out.println("<script>alert('로그인 성공');document.location.href='/WIF/index.jsp';</script>");
	}
	else
		out.println("<script>alert('로그인 실패');document.location.href='/WIF/login-form.html';</script>");
	%>

	<%
	rs.close();
	pstmt.close();
	JDBCDriver.close(conn);
	%>
</body>
</html>