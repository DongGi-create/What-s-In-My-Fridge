<%@page import="Phase3Package.Configure"%>
<%@page import="Phase3Package.Ingredient, Phase3Package.JDBCDriver"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="Phase3Package.Own"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<%
	String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	String DB_ID = Configure.DB_ID;
	String DB_PW = "comp322";

	Connection conn = null;
	JDBCDriver.load();
	conn = JDBCDriver.getConnection(URL, DB_ID, DB_PW);

	if (request.getParameter("quantity") != null) {
		Own insertOwn = new Own();
		insertOwn.setQuantity(Integer.parseInt(request.getParameter("quantity")));

		String unit = request.getParameter("unit");
		unit = new String(unit.getBytes("ISO-8859-1"), "UTF-8");
		insertOwn.setUnit(unit);

		String userId = (String) session.getAttribute("user-id");
		Integer ingredientId = Integer.parseInt(request.getParameter("ingredient-id"));
		insertOwn.setIngredient_ID(ingredientId);
		insertOwn.setUser_ID(userId);

		boolean isHaving = false;
		if(isOwnExisting(conn, userId, ingredientId)!=null) isHaving = true;
		
		InsertData(conn, isHaving, insertOwn);
	}
	%>
	<%!
	Own isOwnExisting(Connection conn, String userId, Integer insertIngredientId) throws SQLException {
		PreparedStatement pstmt = conn.prepareStatement(
				"SELECT O.* FROM USERS U, OWN O, INGREDIENT I WHERE U.USER_ID = O.USER_ID AND O.INGREDIENT_ID = I.INGREDIENT_ID AND U.USER_ID = ? AND O.INGREDIENT_ID = ?");
		pstmt.setString(1, userId);
		pstmt.setInt(2, insertIngredientId);
		ResultSet rs = pstmt.executeQuery();

		Own returnOwn = null;
		if (rs.next()) {
			returnOwn = new Own(rs);
		}

		rs.close();
		pstmt.close();
		return returnOwn;
	}

	boolean InsertData(Connection conn, boolean isHaving, Own insertOwn) {
		String query = null;
		PreparedStatement pstmt = null;
		boolean rt = false;
		try {
			if (isHaving) {
				query = "UPDATE OWN SET OWN.QUANTITY = ?, OWN.UNIT = ? WHERE OWN.USER_ID = ? AND OWN.INGREDIENT_ID = ?";
			} else {
				query = "INSERT INTO OWN(OWN.QUANTITY, OWN.UNIT, OWN.USER_ID, OWN.INGREDIENT_ID) VALUES(?, ?, ?, ?)";
			}
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, insertOwn.getQuantity());
			pstmt.setString(2, insertOwn.getUnit());
			pstmt.setString(3, insertOwn.getUser_ID());
			pstmt.setInt(4, insertOwn.getIngredient_ID());
			int result = pstmt.executeUpdate();

			insertOwn.Print();

			if (result > 0)
				rt = true;
			pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return rt;
	}%>
	<script>
		document.location.href = "my_fridge.jsp"
	</script>

</body>
</html>