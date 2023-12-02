<%@page import="java.sql.SQLException"%>
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
<meta charset="UTF-8">
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
	request.setCharacterEncoding("utf-8");
	String query = "SELECT * FROM dual WHERE EXISTS (SELECT * FROM Users U WHERE User_ID = ?)";
	PreparedStatement pstmt = conn.prepareStatement(query);
	String user_id = request.getParameter("id");
	String user_pw = request.getParameter("pw");
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	String sex = request.getParameter("sex");
	pstmt.setString(1, user_id);
	ResultSet rs = pstmt.executeQuery();
	boolean existing_User = false;
	while (rs.next())
	{
		existing_User = true;
	}
	if (existing_User)
	{
		out.println("<script>alert('이미 존재하는 사용자입니다.');document.location.href='/WIF/signup-form.jsp';</script>");
	}

	query = "INSERT INTO Users(User_ID, Password, Name, Email, Sex) VALUES(?, ?, ?, ?, ?)";
	pstmt = conn.prepareStatement(query);
	pstmt.setString(1, user_id);
	pstmt.setString(2, user_pw);
	pstmt.setString(3, name);
	pstmt.setString(4, email);
	pstmt.setString(5, sex);
	try
	{
		int result = pstmt.executeUpdate();
		if (result > 0)
			out.println("<script>alert('회원가입에 성공했습니다.');document.location.href='/WIF/index.jsp';</script>");
	}
	catch (SQLException e)
	{
		out.println("<script>alert('회원가입에 실패했습니다.');document.location.href='/WIF/signup-form.jsp';</script>");
	}
	%>

	<%
	rs.close();
	pstmt.close();
	JDBCDriver.close(conn);
	%>
</body>
</html>