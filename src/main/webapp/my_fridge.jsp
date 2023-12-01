<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page language="java" import="Phase3Package.Configure, Phase3Package.JDBCDriver, Phase3Package.OwnIngredient"%>
<%@ page language="java" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>����� ��� ���</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        
        h1 {
            color: #333;
            text-align: center;
        }

        #ingredient-list {
            list-style: none;
            padding: 0;
            margin: 20px 0;
        }

        #ingredient-list li {
            background-color: #fff;
            padding: 10px;
            margin: 5px 0;
            border-radius: 5px;
            display: flex;
            align-items: center;
        }

        .ingredient-icon {
            margin-right: 10px;
            font-size: 20px;
        }
        
        .btn-container {
            text-align: center;
            margin-top: 20px;
        }

        .add-btn, .remove-btn {
            padding: 10px 20px;
            margin: 0 10px;
            background-color: #27ae60;
            border: none;
            border-radius: 5px;
            color: white;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .remove-btn {
            background-color: #e74c3c;
        }

        .add-btn:hover, .remove-btn:hover {
            background-color: #2ecc71;
        }
    </style>
</head>
<body>
	<!-- Page Top -->
	<div id="pagetop" style="border: 1px solid black;">
		<a id="wif-logo" href="/WIF/index.jsp" title="WIF Ȩ" style="text-decoration-line: none;">
			<!-- �� �� �� �� -->
			<i class="fa-solid fa-plate-wheat fa-2x" style="margin: 10px 10px 10px 10px;"> What's in my Fridge?</i>
		</a>
		<form id="search-container" action="/WIF/search-result.jsp" style="border: 1px solid black; display: inline;">
			<input name="search-keyword" type="text" placeholder="�˻�â��"><input type="submit" value="�˻�">
		</form>
	</div>
	<nav></nav>
	
	
	
	
	
    <h1>����� ���� ���</h1>
    <ul id="ingredient-list">
        <!-- ������ ���⿡ �������� �߰��� ���� -->
    </ul>

    <div class="btn-container">
        <button class="add-btn">����� ��� �߰��ϱ�</button>
        <button class="remove-btn">����� ��� ����</button>
    </div>

    <div class="btn-container">
        <a href="/WIF/your-test-page.jsp">
            <button>�ٸ� �׽�Ʈ �������� �̵�</button>
        </a>
    </div>

		
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
		String query = "SELECT I.INGREDIENT_NAME, O.QUANTITY, O.UNIT FROM USERS U,OWN O,INGREDIENT I WHERE U.USER_ID = O.USER_ID AND I.INGREDIENT_ID = O.INGREDIENT_ID AND U.User_ID = ? ORDER BY I.INGREDIENT_NAME";
		pstmt = conn.prepareStatement(query);
		
		
		%>
		
    	<script>
        const ingredients = ["����", "���", "ġ��", "��ä", "����"];

        function showIngredients() {
            const ingredientList = document.getElementById("ingredient-list");
            ingredientList.innerHTML = "";
            ingredients.forEach((ingredient) => {
                const li = document.createElement("li");
                li.textContent = ingredient;
                ingredientList.appendChild(li);
            });
        }

        window.onload = () => {
            showIngredients();

            document.querySelector('.add-btn').addEventListener('click', () => {
                const newIngredient = prompt('�߰��� ��Ḧ �Է��ϼ���.');
                if (newIngredient) {
                    ingredients.push(newIngredient);
                    showIngredients();
                }
            });

            document.querySelector('.remove-btn').addEventListener('click', () => {
                const ingredientToRemove = prompt('���� ��Ḧ �Է��ϼ���.');
                const index = ingredients.indexOf(ingredientToRemove);
                if (index !== -1) {
                    ingredients.splice(index, 1);
                    showIngredients();
                }
            });
        };
    </script>
</body>
</html>