<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*, java.sql.*"%>
<%@ page language="java" import="Phase3Package.Configure, Phase3Package.JDBCDriver, Phase3Package.Recipe, Phase3Package.Cuisine"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://kit.fontawesome.com/7b62cb3616.js" crossorigin="anonymous"></script>
<title>Insert title here</title>
</head>
<body>
	<!-- Page Top -->
	<div id="pagetop" style="border: 1px solid black;">
		<a id="wif-logo" href="/WIF/index.jsp" title="WIF 홈" style="text-decoration-line: none;">
			<!-- 상 우 하 좌 -->
			<i class="fa-solid fa-plate-wheat fa-2x" style="margin: 10px 10px 10px 10px;"> What's in my Fridge?</i>
		</a>
		<form id="search-container" action="/WIF/search-result.jsp" style="border: 1px solid black; display: inline;">
			<input name="search-keyword" type="text" placeholder="검색창임"><input type="submit" value="검색">
		</form>
	</div>
	<nav></nav>

	<!-- DB 연결 -->
	<%
	String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	String DB_ID = "knu";
	String DB_PW = "comp322";

	Connection conn = null;
	JDBCDriver.load();
	conn = JDBCDriver.getConnection(URL, DB_ID, DB_PW);
	%>

	<%
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	String query = "SELECT R.*, C.* FROM Recipe R, Cuisine C WHERE R.Recipe_ID = ? AND R.Cuisine_ID = C.Cuisine_ID";
	pstmt = conn.prepareStatement(query);
	pstmt.setInt(1, Integer.parseInt(request.getParameter("recipe_id")));
	rs = pstmt.executeQuery();
	rs.next();
	Recipe recipe = new Recipe(rs);
	Cuisine cuisine = new Cuisine(rs.getInt(11), rs.getString(12), rs.getString(13));
	%>
	<div style="border: 1px solid black;">
		<main id="recipe-container">
			<section>
				<!-- 레시피 헤더 -->
				<header>
					<%
					out.println("<p>");
					out.println("[" + cuisine.getCuisine_Name() + " - " + cuisine.getCategory() + "] " + recipe.getTitle());
					out.println("</p>");
					out.println("<p>");
					out.println("<span style=\"color: #009933; margin-right: 30px\">작성자: " + recipe.getWriter_ID() + "</span>");
					out.println("<span style=\"color: #999;\">작성 시간: " + recipe.getWrite_Time() + "</span>");
					out.println("</p>");
					out.println("<p>");
					out.println("<span style=\"color: #999; margin-right: 30px\">요리 시간: " + recipe.getCooking_Time() + "</span>");
					out.println("<span style=\"color: #999; margin-right: 30px\">양: " + recipe.getQnt() + "</span>");
					out.println("<span style=\"color: #999;\">난이도: " + recipe.getLevel_NM() + "</span>");
					out.println("</p>");
					%>

				</header>
				<!-- 본문 -->
				<article>
					<%
					out.println("<p>");
					out.println(recipe.getContent());
					out.println("</p>");

					out.println("<p>");
					out.println("<span style=\"color: #999;\">참고 링크: " + recipe.getLink() + "</span>");
					out.println("</p>");
					%>
				</article>
			</section>
		</main>
	</div>
	<%
	rs.close();
	pstmt.close();
	JDBCDriver.close(conn);
	%>
</body>
</html>