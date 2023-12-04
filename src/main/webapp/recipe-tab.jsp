<%@page import="java.util.ArrayList"%>
<%@page import="java.lang.Math"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="Phase3Package.JDBCDriver"%>
<%@page import="java.sql.Connection"%>
<%@page import="Phase3Package.Configure"%>
<%@page import="Phase3Package.Recipe"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<script src="https://kit.fontawesome.com/7b62cb3616.js" crossorigin="anonymous"></script>
<title>What's in my Fridge?</title>
<style>

.recipe-rank, .recipe-today {
	max-width: 1200px;
	margin: 0 auto;
	padding: 10px;
	display: flex;
	justify-content: space-between;
}

.post {
	width: 30%;
	box-sizing: border-box;
	border: 1px solid #ddd;
	padding: 20px;
	margin-bottom: 20px;
}

.styled-button {
	display: inline-block;
	padding: 10px 20px;
	font-size: 16px;
	font-weight: bold;
	text-align: center;
	text-decoration: none;
	cursor: pointer;
	border: none;
	border-radius: 5px;
	color: #fff;
	margin: 0 auto;
	background-color: #57cc99;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	transition: background 0.3s ease;
	background-color: #57cc99;
}
</style>
</head>

<body>
	<!-- 프로젝트 properties - project facets에서 dynamic web module 3.0 체크, java 1.8 변경, runtimes에 톰캣 추가-->
	<!-- Page Top -->
	<%@ include file="navigationBar.jsp" %>


	<main id="container">
		<div id="뭉탱이" style="display: flex; height: 100%;"></div>
		<!-- 왼쪽-->
		<section id="main-content" style="display: block; float: left; width: 70%">
			<div class="recipe-today">
				<p>
					<i class="fa-solid fa-crown fa-2x" style="color: #d4cf25;"> 추천 레시피</i>
				</p>
			</div>
			<%
			String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
			String DB_ID = Configure.DB_ID;
			String DB_PW = "comp322";

			Connection conn = null;
			JDBCDriver.load();
			conn = JDBCDriver.getConnection(URL, DB_ID, DB_PW);
			%>

			<%
			String query = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String user_id = (String) session.getAttribute("user-id");
			if (user_id != null) {
				query = "select R.recipe_ID, R.Title, R.writer_ID, C.Cuisine_Name, C.Category FROM Recipe R, CUISINE C WHERE R.Cuisine_ID = C.Cuisine_ID AND NOT EXISTS ((SELECT Require.Ingredient_ID FROM Require WHERE Require.Recipe_id = R.Recipe_ID) MINUS (SELECT Own.ingredient_ID FROM Own WHERE Own.user_id = ?))";
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, user_id);
				rs = pstmt.executeQuery();
				ArrayList<String> titles = new ArrayList<>();
				ArrayList<String> writers = new ArrayList<>();
				ArrayList<String> cuisines = new ArrayList<>();
				ArrayList<String> categories = new ArrayList<>();
				ArrayList<Integer> ids = new ArrayList<>();

				while (rs.next()) {
					String raw_title = rs.getString(2);
					String title = raw_title.substring(0, Math.min(30, raw_title.length()));
					if (raw_title.length() > 30)
				title = title + "...";
					ids.add(rs.getInt(1));
					titles.add(title);
					writers.add(rs.getString(3));
					cuisines.add(rs.getString(4));
					categories.add(rs.getString(5));
				}
				if (ids.size() > 0) {
					for (int j = 0; j < Math.ceil((ids.size() / 3.0)); j++) {
				out.println("<div class=\"recipe-rank\">");
				for (int i = 0; i < 3; i++) {
					int idx = j * 3 + i;
					if (idx >= ids.size())
						break;
					out.println("<div class=\"post\">");
					out.println(
							"<div style=\"margin-bottom: 15px\"><a style=\"text-decoration-line: none; color: black;\" href=\"/WIF/view-recipe.jsp?recipe-id="
									+ ids.get(idx) + "\">" + titles.get(idx) + "</a></div>");
					out.println("<div><span style=\"float: left; color: #999;\">" + cuisines.get(idx) + " | "
							+ categories.get(idx) + "</span><span style=\"float: right; color: #009933;\">"
							+ writers.get(idx) + "</span></div>");
					out.println("</div>");
				}
				out.println("</div>");
					}
				} else {
					out.println("<p>만들 수 있는 레시피가 없습니다.</p><p>냉장고에 재료를 더 추가해보세요!</p>");
				}
			} else {
				out.println("<div class=\"recipe-rank\">로그인해야 추천 레시피를 볼 수 있습니다.</div>");
			}
			%>
			<br>
			<div class="recipe-today">
				<p>
					<i class="fa-solid fa-pen fa-2x" style="color: #d4cf25;"> 최근 올라온 레시피</i>
				</p>
			</div>
			<%
			String query2 = "SELECT * \r\n"
					+ "FROM (SELECT R.recipe_id, R.title, R.writer_id, CU.cuisine_name, CU.category, R.write_time \r\n"
					+ "      FROM RECIPE R, CUISINE CU \r\n" + "      WHERE R.cuisine_id = CU.cuisine_id \r\n"
					+ "      ORDER BY R.write_time DESC) \r\n" + "WHERE ROWNUM <= 6";
			pstmt = conn.prepareStatement(query2);
			rs = pstmt.executeQuery();
			ArrayList<String> titles = new ArrayList<>();
			ArrayList<String> writers = new ArrayList<>();
			ArrayList<String> cuisines = new ArrayList<>();
			ArrayList<String> categories = new ArrayList<>();
			ArrayList<Integer> ids = new ArrayList<>();

			while (rs.next()) {
				ids.add(rs.getInt(1));
				String raw_title = rs.getString(2);
				String title = raw_title.substring(0, Math.min(30, raw_title.length()));
				if (raw_title.length() > 30)
					title = title + "...";
				titles.add(title);
				writers.add(rs.getString(3));
				cuisines.add(rs.getString(4));
				categories.add(rs.getString(5));
			}

			for (int j = 0; j < 2; j++) {

				out.println("<div class=\"recipe-rank\">");
				for (int i = 0; i < 3; i++) {
					int idx = j * 3 + i;
					out.println("<div class=\"post\">");
					//					out.println("<div style=\"font-size: 25px; color: #57cc99; margin-bottom: 15px;\">" + rank++ + "위</div>");/*  */
					out.println(
					"<div style=\"margin-bottom: 15px\"><a style=\"text-decoration-line: none; color: black;\" href=\"/WIF/view-recipe.jsp?recipe-id="
							+ ids.get(idx) + "\">" + titles.get(idx) + "</a></div>");
					out.println("<div><span style=\"float: left; color: #999;\">" + cuisines.get(idx) + " | " + categories.get(idx)
					+ "</span><span style=\"float: right; color: #009933;\">" + writers.get(idx) + "</span></div>");
					out.println("</div>");
				}
				out.println("</div>");
			}
			%>
			<%
			rs.close();
			pstmt.close();
			JDBCDriver.close(conn);
			%>
		</section>
		<!-- 오른쪽 -->
		<section id="login-box" style="display: block; float: right; width: 30%">
			<div class="styled-button" id="loginButton2" style="width: 90%;">
				<jsp:include page="./login-include.jsp" />
			</div>
		</section>
	</main>

	<script>
		// JavaScript 코드
		document.getElementById('loginButton').addEventListener('click',
				function() {
					// 클릭 시 이동할 페이지의 URL을 설정
					var newPageURL = ''; // 여기에 이동하고 싶은 페이지의 URL을 입력하세요
					if (document.getElementById('loginNeeded') != null) {
						newPageURL = '/WIF/login-form.html';
					} else {
						newPageURL = '/WIF/logout.jsp';
					}

					// 새로운 페이지로 이동
					window.location.href = newPageURL;
				});
		document.getElementById('loginButton2').addEventListener('click',
				function() {
					// 클릭 시 이동할 페이지의 URL을 설정
					var newPageURL = ''; // 여기에 이동하고 싶은 페이지의 URL을 입력하세요
					if (document.getElementById('loginNeeded') != null) {
						newPageURL = '/WIF/login-form.html';
					} else {
						newPageURL = '/WIF/logout.jsp';
					}

					// 새로운 페이지로 이동
					window.location.href = newPageURL;
				});
	</script>
</body>

</html>