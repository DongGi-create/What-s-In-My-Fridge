<%@page import="java.nio.channels.SelectableChannel"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Phase3Package.Configure"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*, java.sql.*"%>
<%@ page language="java" import="Phase3Package.Configure, Phase3Package.JDBCDriver, Phase3Package.Cuisine, Phase3Package.Recipe"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://kit.fontawesome.com/7b62cb3616.js" crossorigin="anonymous"></script>
<title>검색 결과</title>
</head>
<body>
	<!-- Page Top -->
	<div id="pagetop" style="border: 1px solid black;">
		<a id="wif-logo" href="/WIF_Web/index.jsp" title="WIF 홈" style="text-decoration-line: none;">
			<!-- 상 우 하 좌 -->
			<i class="fa-solid fa-plate-wheat fa-2x" style="margin: 10px 10px 10px 10px;"> What's in my Fridge?</i>
		</a>
		<form id="search-container" action="/WIF/search-result.jsp" style="border: 1px solid black; display: inline;">
			<input name="search-keyword" type="text" placeholder="검색창임"><input type="submit" value="검색">
		</form>
	</div>
	<nav></nav>

	<!-- 검색 결과 -->
	<main id="container">
		<div id="뭉탱이" style="display: flex;">
			<!-- 왼쪽 여백 -->
			<section id="left_blank" style="display: block; float: left; width: 15%;">왼쪽 공백</section>
			<!-- 중앙 메인 -->
			<section style="display: inline; margin: 0px 30px 0px 0px; width: 70%">
				<%
				String keyword = request.getParameter("search-keyword");
				out.println("<h2>" + keyword + "에 대한 검색 결과입니다." + "</h2>");
				%>
				<hr>
				<!-- DB 연결 -->
				<%
				String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
				String DB_ID = Configure.DB_ID;
				String DB_PW = "comp322";

				Connection conn = null;
				JDBCDriver.load();
				conn = JDBCDriver.getConnection(URL, DB_ID, DB_PW);
				%>

				<!-- 요리 검색 -->
				<%
				int searchedCount = 0;
				PreparedStatement pstmt = null;
				ResultSet rs = null;

				String query = "SELECT * FROM CUISINE C WHERE C.CUISINE_NAME LIKE ?";
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, "%" + keyword + "%");
				rs = pstmt.executeQuery();
				ArrayList<Cuisine> cuisineAL = new ArrayList<>();

				// 키워드 강조 어케 함
				int arraySize;
				while (rs.next())
				{
					cuisineAL.add(new Cuisine(rs));
					searchedCount++;
				}

				// 요리 검색 결과 출력, 결과가 많으면 요리 더보기 같은 거 필요
				arraySize = cuisineAL.size();
				if (arraySize > 0)
					out.println("<h3>" + "요리 " + arraySize + "건</h3>");
				for (int i = 0; i < arraySize; i++)
				{
					Cuisine cuisine = cuisineAL.get(i);
					out.println("<div style=\"margin: 0 0 20px 0\">");
					out.println(cuisine.getCuisine_Name() + " - " + cuisine.getCategory());
					out.println("</div>");
				}
				if (arraySize > 0)
					out.println("<hr>");
				cuisineAL.clear();
				%>



				<!-- 레시피 + 제목 검색 결과 -->
				<%
				query = "SELECT * FROM RECIPE R WHERE R.title Like ?";
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, "%" + keyword + "%");
				rs = pstmt.executeQuery();
				ArrayList<Recipe> recipeAL = new ArrayList<>();
				// 키워드 강조 어케 함
				while (rs.next())
				{
					recipeAL.add(new Recipe(rs));
					searchedCount++;
				}

				// 요리 검색 결과 출력, 결과가 많으면 요리 더보기 같은 거 필요
				arraySize = recipeAL.size();
				if (arraySize > 0)
					out.println("<h3>" + "레시피 " + arraySize + "건</h3>");
				for (int i = 0; i < arraySize; i++)
				{
					Recipe recipe = recipeAL.get(i);
					out.println("<div style=\"margin: 0 0 20px 0\">");

					out.println("</div>");
				}
				if (arraySize > 0)
					out.println("<hr>");
				%>

				<%
				if (searchedCount == 0)
					out.println("검색 결과가 읎어요.");
				%>

				<%
				rs.close();
				pstmt.close();
				JDBCDriver.close(conn);
				%>
			</section>
			<!-- 오른쪽 잡것들 -->
			<section style="display: inline;">오른쪽 예비용</section>
		</div>



	</main>



</body>
</html>