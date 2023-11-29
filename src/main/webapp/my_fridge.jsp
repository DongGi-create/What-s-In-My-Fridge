<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>냉장고 재료 목록</title>
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
		<a id="wif-logo" href="/WIF/index.jsp" title="WIF 홈" style="text-decoration-line: none;">
			<!-- 상 우 하 좌 -->
			<i class="fa-solid fa-plate-wheat fa-2x" style="margin: 10px 10px 10px 10px;"> What's in my Fridge?</i>
		</a>
		<form id="search-container" action="/WIF/search-result.jsp" style="border: 1px solid black; display: inline;">
			<input name="search-keyword" type="text" placeholder="검색창임"><input type="submit" value="검색">
		</form>
	</div>
	<nav></nav>
	
    <h1>냉장고 안의 재료</h1>
    <ul id="ingredient-list">
        <!-- 재료들을 여기에 동적으로 추가할 예정 -->
    </ul>



    <div class="btn-container">
        <button class="add-btn">냉장고 재료 추가하기</button>
        <button class="remove-btn">냉장고 재료 빼기</button>
    </div>

    <div class="btn-container">
        <a href="/WIF/your-test-page.jsp">
            <button>다른 테스트 페이지로 이동</button>
        </a>
    </div>

    	<script>
        const ingredients = ["우유", "계란", "치즈", "야채", "과일"];

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
                const newIngredient = prompt('추가할 재료를 입력하세요.');
                if (newIngredient) {
                    ingredients.push(newIngredient);
                    showIngredients();
                }
            });

            document.querySelector('.remove-btn').addEventListener('click', () => {
                const ingredientToRemove = prompt('빼낼 재료를 입력하세요.');
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