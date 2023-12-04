<%@page import="Phase3Package.JDBCDriver"%>
<%@page import="java.sql.*"%>
<%@page import="Phase3Package.Configure"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="Phase3Package.URIConvert"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>


<%
	String selectedIngredients = URLDecoder.decode(request.getParameter("selectedIngredients"), "UTF-8");
    
	//Integer quantity = Integer.parseInt(new String(request.getParameter("selectedQuantity").getBytes("ISO-8859-1"), "UTF-8"));
	
	String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	String DB_ID = Configure.DB_ID;
	String DB_PW = "comp322";
	
	Connection conn = null;
	JDBCDriver.load();
	conn = JDBCDriver.getConnection(URL, DB_ID, DB_PW);
	
	PreparedStatement pstmt = null;
	
	String query = "DELETE FROM OWN WHERE USER_ID = ? AND INGREDIENT_ID = (SELECT INGREDIENT_ID FROM INGREDIENT WHERE INGREDIENT_NAME = ?)";
	String userId = (String)session.getAttribute("user-id");
	pstmt = conn.prepareStatement(query);
	
	pstmt.setString(1,userId);
	pstmt.setString(2,selectedIngredients);
	int result = pstmt.executeUpdate();
	/* if(result > 0){
		
	} */	
%>

<script>
	document.location.href = "my_fridge.jsp"
</script>

</body>
</html>