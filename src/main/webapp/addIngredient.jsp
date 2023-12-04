<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import ="Phase3Package.Configure, Phase3Package.JDBCDriver" %>
<%@ page language="java" import ="Phase3Package.Ingredient, Phase3Package.URIConvert, Phase3Package.Own" %>
<%@ page language="java" import ="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>재료 추가하기</title>
    <link rel="stylesheet" type="text/css" href="addIngredientStyle.css">
</head>
<body>
    <form method="post" action="">
        <h1>재료 추가하기</h1>
        <label for="ingredientName">추가할 재료를 입력해주세요:</label>
        <input type="text" id="ingredientName" name="ingredientName">
        
        <input type="submit" name="checkButton" value="Check">
    </form>
    
	<%
    String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
    String DB_ID = Configure.DB_ID;
    String DB_PW = "comp322";
    
    Connection conn = null;
    JDBCDriver.load();
    conn = JDBCDriver.getConnection(URL, DB_ID, DB_PW);
    
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    Ingredient insertIngredient = null;
    Own own = null;
    boolean isHaving = false;
    String userId = null;
    String enteredIngredientName = request.getParameter("ingredientName");
    String enteredQuantity = request.getParameter("quantity");
    String enteredUnit = request.getParameter("unit");
    
    session = request.getSession(false);
	if(session != null && session.getAttribute("user-id") != null){
		userId = (String) session.getAttribute("user-id");
		
		if (request.getParameter("checkButton") != null) {
			//재료 DB에 존재하는지 확인
	    	enteredIngredientName = new String(enteredIngredientName.getBytes("ISO-8859-1"), "UTF-8");
	        insertIngredient = isIngredientExisting(conn,enteredIngredientName);
	        
	        if(insertIngredient!= null){
	        	own = isOwnExisting(conn, userId, insertIngredient);
	        	String title = null;
	        	String subText = null;
	        	if(own == null){
	        		title = "추가할 재료: " + insertIngredient.getIngredient_Name();
	        		subText = "양과 단위를 입력해주세요";
	        		isHaving = false;
	        	}
	        	else{
	        		title = "재료: "+insertIngredient.getIngredient_Name()+"<br>양: "+own.getQuantity()+" 단위: "+own.getUnit();
	        		subText= "를 이미 가지고 있어요 <br>해당 부분을 수정하시겠어요? <br>입력하신 내용으로 수정됩니다.";
	        		isHaving = true;
	        	}
	        	
	            %>
	            <form method="post" action="insertIngredient.jsp?ingredient-id=<%out.print(insertIngredient.getIngredient_ID()); %>">
	                <h1><%=title%></h1>
	                <p><%=subText%></p>
	                <label for="quantity">재료의 양을 입력해주세요:</label>
	                <input type="text" id="quantity" name="quantity" pattern = "[0-9]{1,10}" required>
	                
	                <label for="unit">단위를 입력해주세요:</label>
	                <input type="text" id="unit" name="unit" required>
	                <button>Submit</button>
	            </form>
	            <%
	        }
	        else{
	        	out.println("DB에 존재하지 않는 재료입니다.. 있는 재료로 입력해주세요..");
	        }
	        
	        

	    }
			
	}
	else{
		out.println("<script>alert('로그인이 필요합니다.'); window.location.href='로그인페이지URL';</script>");
	}    
	%>
	
	<%!
    // 재료가 DB에 존재하는지 확인하는 함수
    Ingredient isIngredientExisting(Connection conn, String ingredientName) throws SQLException {
	    PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM INGREDIENT WHERE INGREDIENT_NAME = ?");
	    pstmt.setString(1, ingredientName);
	    ResultSet rs = pstmt.executeQuery();
	    Ingredient returnIngredient = null;
	
	    if(rs.next()) {
	        returnIngredient = new Ingredient(rs);
	    }
	    
	    rs.close();
	    pstmt.close();
	    return returnIngredient;
	}
	
	Own isOwnExisting(Connection conn, String userId, Ingredient insertIngredient) throws SQLException {
		PreparedStatement pstmt = conn.prepareStatement("SELECT O.* FROM USERS U, OWN O, INGREDIENT I WHERE U.USER_ID = O.USER_ID AND O.INGREDIENT_ID = I.INGREDIENT_ID AND U.USER_ID = ? AND O.INGREDIENT_ID = ?");
		pstmt.setString(1, userId);
    	pstmt.setInt(2, insertIngredient.getIngredient_ID());
        ResultSet rs = pstmt.executeQuery();
        
        Own returnOwn = null;
        if(rs.next()) {
        	returnOwn = new Own(rs);
        }
        
        rs.close();
        pstmt.close();
        return returnOwn;
    }
    %>
</body>
</html>
