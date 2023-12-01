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
	String query = "DELETE FROM Comments WHERE Comment_ID = ?";
	PreparedStatement pstmt = conn.prepareStatement(query);
	int comment_id = Integer.parseInt(request.getParameter("comment-id"));
	pstmt.setInt(1, comment_id);
	int result = pstmt.executeUpdate();

	if (result > 0)
	{
		out.println("<script>location.href=\"/WIF/view-recipe.jsp?recipe-id=" + request.getParameter("recipe-id")
		+ "\"</script>");
	}
	else
	{
		out.println("<script>alert('댓글 삭제에 실패했습니다.');location.href=\"/WIF/view-recipe.jsp?recipe-id="
		+ request.getParameter("recipe-id") + "\"</script>");
	}
	%>

	<%
	pstmt.close();
	JDBCDriver.close(conn);
	%>
</body>
</html>