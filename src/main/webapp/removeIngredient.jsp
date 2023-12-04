<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="Phase3Package.Configure, Phase3Package.JDBCDriver, Phase3Package.OwnIngredient"%>
<%@ page language="java" import="java.sql.*"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<script src="https://kit.fontawesome.com/7b62cb3616.js" crossorigin="anonymous"></script>
<title>냉장고 재료 목록</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
	<link rel="stylesheet" type="text/css" href="my_fridge.css">

</head>
<body>
	<!-- Page Top -->
	<div id="pagetop" style="border: 1px solid black;">
		<a id="wif-logo" href="/WIF/index.jsp" title="WIF 홈"
			style="text-decoration-line: none;"> <!-- 상 우 하 좌 --> <i
			class="fa-solid fa-plate-wheat fa-2x"
			style="margin: 10px 10px 10px 10px;"> What's in my Fridge?</i>
		</a>
		<form id="search-container" action="/WIF/search-result.jsp"
			style="border: 1px solid black; display: inline;">
			<input name="search-keyword" type="text" placeholder="검색창임"><input
				type="submit" value="검색">
		</form>
	</div>
	<nav></nav>


	<h1>냉장고 안의 재료</h1>
	<ul id="ingredient-list">
		<!-- 재료들을 여기에 동적으로 추가할 예정 -->
	</ul>

	<%
	/* DB연결 */
	String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	String DB_ID = Configure.DB_ID;
	String DB_PW = "comp322";

	Connection conn = null;
	JDBCDriver.load();
	conn = JDBCDriver.getConnection(URL, DB_ID, DB_PW);

	PreparedStatement pstmt = null;
	ResultSet rs = null;
	ArrayList<OwnIngredient> ownIngredients = new ArrayList<>();

	session = request.getSession(false);
	if (session != null && session.getAttribute("user-id") != null) {
		String userId = (String) session.getAttribute("user-id");
		String query = "SELECT I.INGREDIENT_NAME, O.QUANTITY, O.UNIT FROM USERS U,OWN O,INGREDIENT I WHERE U.USER_ID = O.USER_ID AND I.INGREDIENT_ID = O.INGREDIENT_ID AND U.User_ID = ? ORDER BY I.INGREDIENT_NAME";
		pstmt = conn.prepareStatement(query);
		pstmt.setString(1, userId);
		rs = pstmt.executeQuery();

		while (rs.next()) {
			ownIngredients.add(new OwnIngredient(rs));
		}
		%>
		
    	<form id="removeIngredientsForm" action="/WIF/deleteIngredient.jsp" method="post">
		    <input type="hidden"  name="selectedIngredients" value="">
		    <input type="hidden"  name="selectedQuantity" value="">
		    <input type="hidden"  name="selectedUnit" value="">
		    <div class="btn-container">
		        <button type="button" class="remove-btn" onclick="handleRemove()">선택한 재료 제거하기</button>
		    </div>
		</form>
		    	
		<%
	} else {
		out.println("로그인이 필요합니다...");
		%>
	    <p>로그인이 필요합니다. <a href="/WIF/login-form.html">로그인</a>하세요.</p>
		<%
	}
	%>
	<div id="output"></div>

	<script>
	    const ingredients = [
	        <% for (int i = 0; i < ownIngredients.size(); i++) {
	            OwnIngredient ingredient = ownIngredients.get(i);
	        %>
	        {
	            ingredient_Name: '<%= ingredient.getIngredient_Name() %>',
	            quantity: <%= ingredient.getQuantity() %>,
	            unit: '<%= ingredient.getUnit() %>'
	        }
	        <% if (i < ownIngredients.size() - 1) { %>, <% } %>
	        <% } %>
	    ];
	   
        function showIngredients() {
            const ingredientList = document.getElementById("ingredient-list");
            ingredientList.innerHTML = ""; // Clear the existing list

            ingredients.forEach((ingredient) => {
                const li = document.createElement("li");
                const radioBtn = document.createElement("input");
                radioBtn.type = "radio"; // Change to radio button type
                radioBtn.name = "ingredient"; // Use the same name for all radio buttons
                radioBtn.value = ingredient.ingredient_Name;

                const label = document.createElement("label");
                label.textContent = '재료: ' + ingredient.ingredient_Name + ', 양: ' + ingredient.quantity + ', 단위: ' + ingredient.unit;

                li.appendChild(radioBtn);
                li.appendChild(label);
                ingredientList.appendChild(li);
            });
        }

        function getSelectedIngredient() {
            const selectedRadio = document.querySelector('input[name="ingredient"]:checked');
            if (selectedRadio) {
                const selectedIngredient = ingredients.find(ingredient => ingredient.ingredient_Name  == selectedRadio.value);

                return selectedIngredient; // Return the selected ingredient object
            }
            return null; // No ingredient selected
        }

        function handleRemove() {
        	
            const selectedIngredient = getSelectedIngredient();

            if (selectedIngredient) {
                
                const selectedQuantityInput = document.querySelector('input[name="selectedQuantity"]');
                const selectedUnitInput = document.querySelector('input[name="selectedUnit"]');
                const selectedIngredientsInput = document.querySelector('input[name="selectedIngredients"]');
                
                selectedIngredientsInput.value = encodeURIComponent(selectedIngredient.ingredient_Name);
                selectedQuantityInput.value = selectedIngredient.quantity;
                selectedUnitInput.value = selectedIngredient.unit;

                // Submit the form for ingredient removal
                document.getElementById("removeIngredientsForm").submit();
            } else {
                // Handle case where no ingredient is selected
                alert("Please select an ingredient to remove.");
            }
        }

        window.onload = () => {
            showIngredients();
        };
    </script>
</body>
</html>