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
<title>댓글</title>
</head>
<body>
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
	String query = "INSERT INTO Comments(Recipe_ID, User_ID, Comment_Content) VALUES(?, ?, ?)";
	PreparedStatement pstmt = conn.prepareStatement(query);
	String user_id = (String) session.getAttribute("user-id");
	int recipe_id = Integer.parseInt(request.getParameter("recipe-id"));
	pstmt.setInt(1, recipe_id);
	pstmt.setString(2, user_id);
	pstmt.setString(3, request.getParameter("comment-content"));
	int result = pstmt.executeUpdate();

	if (result > 0)
	{
		out.println("<script>document.location.href='/WIF/view-recipe.jsp?recipe-id=" + recipe_id + "';</script>");
	}
	else
	{
		out.println("<script>alert('댓글 등록에 실패했습니다.');document.location.href='/WIF/view-recipe.jsp?recipe-id=" + recipe_id
		+ "';</script>");
	}
	%>

	<%
	pstmt.close();
	JDBCDriver.close(conn);
	%>
</body>
</html>