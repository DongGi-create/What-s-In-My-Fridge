<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*, java.sql.*" %>
<%@ page language="java" import="Phase3Package.Configure, Phase3Package.JDBCDriver, Phase3Package.Cuisine, Phase3Package.Recipe, Phase3Package.URIConvert"%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <script src="https://kit.fontawesome.com/7b62cb3616.js" crossorigin="anonymous"></script>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>요리</title>
  <style>
    .recipe-container {
      display: grid;
      grid-template-columns: repeat(5, 1fr);
      grid-auto-rows: minmax(110px, auto); /* 조정된 행의 높이 */
      gap: 40px;
      padding: 20px;
      max-width: 1500px;
      margin: 0 auto;
    }

    .recipe {
      background-color: #fff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      text-align: center;
    }

    .recipe h3 {
      margin-top: 20px;
      color: #333;
    }
    .recipe h4 {
      margin-top: 5px;
      color: #333;
    }
  </style>
</head>
<body>
	<%@ include file="navigationBar.jsp" %>

	<div class="recipe-container" style="background-color: #f2f2f2">
	  <!-- Recipe Template -->
<!--  <div class="recipe">
	    <img src="recipe1.jpg" alt="Recipe 1">
	    <h3>Recipe 1 Name</h3>
	  </div>										 -->

	  <% 
	  	String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
		String DB_ID = Configure.DB_ID;
		String DB_PW = "comp322";

		Connection conn = null;
		JDBCDriver.load();
		conn = JDBCDriver.getConnection(URL, DB_ID, DB_PW);
	  %>
	  
	  <%
	  	Statement stmt = conn.createStatement();
	  	ResultSet rs = null;
	  	
	  	String query = "SELECT * FROM CUISINE";
	  	rs = stmt.executeQuery(query);
	  	
	  	while(rs.next()) {
	  		String name = rs.getString(2);
	  		String encoded = URIConvert.encodeURIComponent(name);
	  		String category = rs.getString(3);
	  		
	  		String html = "<a href=\"search-result.jsp?search-keyword=" + encoded + "\" class=\"recipe\">\r\n" +
		    			  "  <h3>" + name + "</h3>\r\n" +
	  			    	  "  <h4>" + category + "</h4>\r\n" +
		  				  "</a>";
	  		
	  		out.println(html);
	  	}
	  %>

	</div>

</body>
</html>