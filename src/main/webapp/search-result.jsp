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
		<a id="wif-logo" href="/WIF/index.jsp" title="WIF 홈" style="text-decoration-line: none;">
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
			<section style="display: inline; margin: 0px 30px 0px 0px; width: 62%">
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

				int arraySize;
				while (rs.next())
				{
					cuisineAL.add(new Cuisine(rs));
					searchedCount++;
				}

				// 요리 검색 결과 출력, 결과가 많으면 요리 더보기 같은 거 필요
				arraySize = cuisineAL.size();
				if (arraySize > 0)
				{
					out.println("<div>");
					out.println("<h3>" + "요리 " + arraySize + "건</h3>");
					out.println("<ul>");
				}
				for (int i = 0; i < arraySize; i++)
				{
					Cuisine cuisine = cuisineAL.get(i);
					String str = cuisine.getCuisine_Name() + " - " + cuisine.getCategory();
					out.println("<li style=\"margin: 0 0 20px 0; list-style-type : none;\">");

					while (str.indexOf(keyword) != -1)
					{
						int index_kw = str.indexOf(keyword);
						if (index_kw >= 1)
					out.print(str.substring(0, index_kw - 1));
						out.print("<b>" + keyword + "</b>");
						str = str.substring(index_kw + keyword.length());
					}
					out.println(str);
					out.println("</li>");
				}
				if (arraySize > 0)
				{
					out.println("</ul>");
					out.println("<hr>");
					out.println("</div>");
				}
				cuisineAL.clear();
				%>

				<!-- 레시피 - 제목, 내용 검색 결과 -->
				<%
				query = "SELECT R.* FROM RECIPE R WHERE R.Title Like ?";
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, "%" + keyword + "%");
				rs = pstmt.executeQuery();
				ArrayList<Recipe> recipeAL = new ArrayList<>();

				while (rs.next())
				{
					recipeAL.add(new Recipe(rs));
					searchedCount++;
				}

				// 요리 검색 결과 출력, 결과가 많으면 요리 더보기 같은 거 필요
				arraySize = recipeAL.size();
				if (arraySize > 0)
				{
					out.println("<div>");
					out.println("<h3>" + "레시피 " + arraySize + "건</h3>");
					out.println("<ul style=\"list-style: none;\">");
				}
				for (int i = 0; i < arraySize; i++)
				{
					Recipe recipe = recipeAL.get(i);
					String str = recipe.getTitle();

					out.println("<li style=\"margin: 0 0 20px 0\">");
					out.println("<a href=\"/WIF/view-recipe.jsp?recipe_id=" + recipe.getRecipe_ID()
					+ "\" target=\"_blank\" style=\"color: #4656c7\">");
					if (str.length() > 50)
						str = str.substring(0, 50 - 2) + "...";
					while (str.indexOf(keyword) != -1)
					{
						int index_kw = str.indexOf(keyword);
						if (index_kw >= 1)
					out.print(str.substring(0, index_kw - 1));
						out.print("<b>" + keyword + "</b>");
						str = str.substring(index_kw + keyword.length());
					}
					out.println(str);
					out.println("</a>");

					str = recipe.getContent();
					if (str.length() > 130)
						str = str.substring(0, 126) + "...";
					out.println("<p>");
					while (str.indexOf(keyword) != -1)
					{
						int index_kw = str.indexOf(keyword);
						if (index_kw >= 1)
					out.print(str.substring(0, index_kw - 1));
						out.print("<b>" + keyword + "</b>");
						str = str.substring(index_kw + keyword.length());
					}
					out.println(str);
					out.println("</p>");
					out.println("<p>");
					out.println("<span style=\"color: #009933; margin-right: 30px\">작성자: " + recipe.getWriter_ID() + "</span>");
					out.println("<span style=\"color: #999;\">" + recipe.getWrite_Time() + "</span>");
					out.println("</p>");
					out.println("</li>");
				}
				if (arraySize > 0)
				{
					out.println("</ul>");
					out.println("<hr>");
					out.println("</div>");
				}
				%>

				<%
				if (searchedCount == 0)
					out.println("검색 결과가 없어요.");
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