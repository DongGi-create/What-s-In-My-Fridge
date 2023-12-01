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
<title>좋아요</title>
</head>
<body>

	<%
	if (session.getAttribute("user-id") == null)
	{
		out.println("<script>alert('따봉은 로그인 한 후에 가능합니다.');location.href='/WIF/view-recipe.jsp?recipe-id="
		+ request.getParameter("recipe-id") + "';</script>");
	}
	else
	{
		String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
		String DB_ID = Configure.DB_ID;
		String DB_PW = "comp322";

		Connection conn = null;
		JDBCDriver.load();
		conn = JDBCDriver.getConnection(URL, DB_ID, DB_PW);
	%>

	<%
	String query = "SELECT * FROM dual WHERE EXISTS (SELECT * FROM Favorite F WHERE F.Like_User_ID = ? AND F.Like_Recipe_Id = ?)";
	PreparedStatement pstmt = conn.prepareStatement(query);
	String user_id = (String) session.getAttribute("user-id");
	int recipe_id = Integer.parseInt(request.getParameter("recipe-id"));
	pstmt.setString(1, user_id);
	pstmt.setInt(2, recipe_id);
	ResultSet rs = pstmt.executeQuery();

	if (rs.next())
	{
		out.println("<script>alert('이미 따봉을 누르셨습니다.');document.location.href='/WIF/view-recipe.jsp?recipe-id=" + recipe_id
		+ "';</script>");
	}
	else
	{
		query = "INSERT INTO Favorite(Like_User_ID, Like_Recipe_ID) VALUES(?, ?)";
		pstmt = conn.prepareStatement(query);
		pstmt.setString(1, user_id);
		pstmt.setInt(2, recipe_id);
		int result = pstmt.executeUpdate();
		out.println("<script>document.location.href='/WIF/view-recipe.jsp?recipe-id=" + recipe_id + "';</script>");
	}
	%>

	<%
	rs.close();
	pstmt.close();
	JDBCDriver.close(conn);
	}
	%>
</body>
</html>