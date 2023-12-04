<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*, java.sql.*"%>
<%@ page language="java"
	import="Phase3Package.Configure, Phase3Package.JDBCDriver, Phase3Package.Recipe, Phase3Package.Require, Phase3Package.Cuisine, Phase3Package.Comments"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://kit.fontawesome.com/7b62cb3616.js"
	crossorigin="anonymous"></script>
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
PreparedStatement pstmt = null;
ResultSet rs = null;
int recipe_id = Integer.parseInt(request.getParameter("recipe-id"));

String query = "SELECT R.*, C.* FROM Recipe R, Cuisine C WHERE R.Recipe_ID = ? AND R.Cuisine_ID = C.Cuisine_ID";
pstmt = conn.prepareStatement(query);
pstmt.setInt(1, recipe_id);
rs = pstmt.executeQuery();
rs.next();
Recipe recipe = new Recipe(rs);
Cuisine cuisine = new Cuisine(rs.getInt(11), rs.getString(12), rs.getString(13));

out.println(
		"<title>[" + cuisine.getCuisine_Name() + " - " + cuisine.getCategory() + "] " + recipe.getTitle() + "</title>");
%>


</head>
<body>
	<!-- Page Top -->
	<%@ include file="navigationBar.jsp" %>

	<div style="border: 1px solid black;">
		<main id="recipe-container" id="뭉탱이" style="display: flex;">
			<section id="left_blank"
				style="display: block; float: left; width: 15%;"></section>
			<section
				style="display: inline; margin: 0px 30px 0px 0px; width: 70%">
				<!-- 레시피 헤더 -->
				<header>
					<%
					out.println("<p>");
					out.println("<h3>[" + cuisine.getCuisine_Name() + " - " + cuisine.getCategory() + "] " + recipe.getTitle() + "</h3>");
					out.println("</p>");
					out.println("<p>");
					out.println("<span style=\"color: #009933; margin-right: 30px\">작성자: " + recipe.getWriter_ID() + "</span>");
					out.println("<span style=\"color: #999;\">작성 시간: " + recipe.getWrite_Time() + "</span>");
					out.println("</p>");
					out.println("<p>");
					out.println("<span style=\"color: #999; margin-right: 30px\">요리 시간: " + recipe.getCooking_Time() + "</span>");
					out.println("<span style=\"color: #999; margin-right: 30px\">양: " + recipe.getQnt() + "</span>");
					out.println("<span style=\"color: #999;\">난이도: " + recipe.getLevel_NM() + "</span>");
					out.println("</p><hr>");
					%>

				</header>
				<!-- 본문 -->
				<article>
					<%
					// Require
					HashMap<Integer, String> requireMap = new HashMap<>();
					HashMap<Integer, Require> requireMap2 = new HashMap<>();
					query = "SELECT I.Ingredient_ID, I.Ingredient_Name, R.quantity, R.unit FROM Require R, Ingredient I WHERE R.Recipe_ID = ? AND R.Ingredient_ID = I.Ingredient_ID";
					pstmt = conn.prepareStatement(query);
					pstmt.setInt(1, recipe.getRecipe_ID());
					rs = pstmt.executeQuery();
					while (rs.next()) {
						requireMap.put(rs.getInt(1), rs.getString(2));
						requireMap2.put(rs.getInt(1), new Require(recipe.getRecipe_ID(), rs.getInt(1), rs.getFloat(3), rs.getString(4)));
					}

					// Own
					ArrayList<Integer> ownAL = new ArrayList<>();
					if (session.getAttribute("user-id") != null) {
						query = "SELECT O.Ingredient_ID FROM Own O WHERE O.User_ID = ?";
						pstmt = conn.prepareStatement(query);
						pstmt.setString(1, (String) session.getAttribute("user-id"));

						rs = pstmt.executeQuery();
						while (rs.next()) {
							ownAL.add(rs.getInt(1));
						}
					}

					out.println("<p>필요 재료: ");
					if (session.getAttribute("user-id") == null)
						for (Entry<Integer, String> entry : requireMap.entrySet())
							out.print(entry.getValue() + " ");
					else {
						for (Entry<Integer, String> entry : requireMap.entrySet()) {
							Require req = requireMap2.get(entry.getKey());
							if (ownAL.contains(entry.getKey()))
						out.print("<span style=\"color: #57cc99;\"><b>" + entry.getValue() + " " + req.getQuantity() + "(" + req.getUnit() + ")" + " </b></span>");
							else
						out.print("<span>" + entry.getValue() + " " + req.getQuantity() + "(" + req.getUnit() + ")" + " </span>");
						}
					}
					out.println("</p>");

					out.println("<p>");
					out.println(recipe.getContent());
					out.println("</p>");

					out.println("<p>");
					out.println("<span style=\"color: #999;\">참고 링크: " + recipe.getLink() + "</span>");
					out.println("</p><hr>");
					%>
				</article>
				<br>
				<%
				int like_cnt = 0;
				query = "SELECT Count(*) FROM Favorite F, Recipe R WHERE R.Recipe_ID = F.Like_Recipe_ID AND R.Recipe_ID = ?";
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, recipe_id);
				rs = pstmt.executeQuery();
				rs.next();
				like_cnt = rs.getInt(1);
				%>
				<div id="like-box" style="text-align: center;">
					<button type="button"
						onClick="location.href='/WIF/like.jsp?recipe-id=<%out.print(request.getParameter("recipe-id"));%>'"
						style="width: 105px; height: 40px; margin: auto;">
						<i class="fa-solid fa-thumbs-up"> 따봉 <%
						out.println(like_cnt + " ");
						%>
						</i>
					</button>
				</div>
				<br>
				<%
				int comment_cnt = 0;
				ArrayList<Comments> commentAL = new ArrayList<>();

				query = "SELECT C.* FROM Comments C, Recipe R WHERE R.Recipe_ID = C.Recipe_ID AND R.Recipe_ID = ?";
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, recipe_id);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					commentAL.add(new Comments(rs));
					comment_cnt++;
				}
				%>
				<div id="comment-container">
					<%
					out.println("<p>전체 댓글 <b style=\"color: red;\">" + comment_cnt + "</b>개</p>");
					%>
					<div id="comment-input">
						<%
						out.println("<form action=\"/WIF/comment.jsp?recipe-id=" + recipe_id + "\" method=\"post\" style=\"display: flex;\">");

						if (session.getAttribute("user-id") == null) {
							out.println(
							"<textarea id=\"comment\" cols=\"115\" rows=\"3\" placeholder=\"댓글은 로그인 한 후에 가능합니다.\" readonly></textarea>");
							out.println("<button id=\"comment-submit\" style=\"width: 15%; height: auto;\" disabled>등록</button>");
						} else {
							out.println(
							"<textarea name=\"comment-content\" cols=\"115\" rows=\"3\" placeholder=\"레시피에 대해 댓글을 남겨주세요.\" maxlength=\"500\" required>우와~ 정말 맛있어 보여요~</textarea>");
							out.println(
							"<input type=\"submit\" id=\"comment-submit\" value=\"등록\"style=\"width: 15%; height: auto;\"></input>");
						}
						out.println("</form>");
						%>

					</div>
					<div id="user-comments">
						<ul style="list-style: none; padding-left: 0px;">
							<%
							for (Comments comment : commentAL) {
								String currentTimestampToString = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(comment.getComment_time());
								out.println("<li style=\"margin:0; display: list-item;\"><div style=\"display: flex;\">");
								out.println(
								"<div class=\"comment_nickbox\" style=\"color: #999; float: left; width: 13%; margin-top:15px; flex: 13;\">"
										+ comment.getUser_ID() + "</div>");
								out.println("<div class=\"comment_content\" style=\"float: left; width: 60%; flex: 60;\"><p>"
								+ comment.getComment_content() + "</p></div>");
								out.println(
								"<div class=\"comment_time\" style=\"color: #999; padding: 0; float: right; margin-top:15px; text-align: right; flex: 17;\">"
										+ currentTimestampToString + "</div>");
								out.println(
								"<div class=\"comment-del-bnt\" style=\"float: right; flex: 3; margin-top:15px; margin-left: 5px; color: #999;\">");
								if (session.getAttribute("user-id") != null
								&& ((String) session.getAttribute("user-id")).equals(comment.getUser_ID()))
									out.println("<a href=\"/WIF/comment-del.jsp?recipe-id=" + comment.getRecipe_ID() + "&comment-id="
									+ comment.getComment_ID()
									+ "\"><i class=\"fa-solid fa-x\" style=\"border: 1px solid #999; color: #999;\"></i></a>");
								out.println("</div>");
								out.println("</div></li><br>");
							}
							%>
						</ul>
					</div>
				</div>
			</section>
			<section style="display: inline;"></section>
		</main>
	</div>

	<%
	rs.close();
	pstmt.close();
	JDBCDriver.close(conn);
	%>
</body>
</html>