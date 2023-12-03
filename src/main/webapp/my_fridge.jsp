<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page language="java"
	import="Phase3Package.Configure, Phase3Package.JDBCDriver, Phase3Package.OwnIngredient"%>
<%@ page language="java" import="java.sql.*"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<script src="https://kit.fontawesome.com/7b62cb3616.js" crossorigin="anonymous"></script>
<title>����� ��� ���</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
	<link rel="stylesheet" type="text/css" href="my_fridge.css">

</head>
<body>
	<!-- Page Top -->
	<div id="pagetop" style="border: 1px solid black;">
		<a id="wif-logo" href="/WIF/index.jsp" title="WIF Ȩ"
			style="text-decoration-line: none;"> <!-- �� �� �� �� --> <i
			class="fa-solid fa-plate-wheat fa-2x"
			style="margin: 10px 10px 10px 10px;"> What's in my Fridge?</i>
		</a>
		<form id="search-container" action="/WIF/search-result.jsp"
			style="border: 1px solid black; display: inline;">
			<input name="search-keyword" type="text" placeholder="�˻�â��"><input
				type="submit" value="�˻�">
		</form>
	</div>
	<nav></nav>





	<h1>����� ���� ���</h1>
	<ul id="ingredient-list">
		<!-- ������ ���⿡ �������� �߰��� ���� -->
	</ul>

	<%
	/* DB���� */
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
		
		<div class="btn-container">
        	<a href="/WIF/addIngredient.jsp" class="add-btn">����� ��� �߰��ϱ�</a>
        	<a href="/WIF/removeIngredient.jsp" class="remove-btn">����� ��� �߰��ϱ�</a>
    	</div>
		<%
	} else {
		out.println("�α����� �ʿ��մϴ�...");
		%>
	    <p>�α����� �ʿ��մϴ�. <a href="/WIF/login-form.html">�α���</a>�ϼ���.</p>
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
        ingredientList.innerHTML = ""; // ���� ��� �ʱ�ȭ

        ingredients.forEach((ingredient) => {
            const li = document.createElement("li");
			li.textContent = '���: ' + ingredient.ingredient_Name + ', ��: ' + ingredient.quantity + ', ����: ' + ingredient.unit;            
			ingredientList.appendChild(li);
        });
    }

    window.onload = () => {
        showIngredients();
    };
</script>



</body>
</html>