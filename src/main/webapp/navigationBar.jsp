<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<script src="https://kit.fontawesome.com/7b62cb3616.js"
	crossorigin="anonymous"></script>
<title>What's in my Fridge?</title>
<style>
nav {
	background-color: #57cc99;
	overflow: hidden;
}

nav a {
	float: left;
	display: block;
	color: white;
	text-align: center;
	padding: 14px 16px;
	text-decoration: none;
}

nav a:hover {
	background-color: #ddd;
	color: black;
}

.styled-button {
	display: inline-block;
	padding: 10px 20px;
	font-size: 16px;
	font-weight: bold;
	text-align: center;
	text-decoration: none;
	cursor: pointer;
	border: none;
	border-radius: 5px;
	color: #fff;
	margin: 0 auto;
	background-color: #57cc99;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	transition: background 0.3s ease;
	background-color: #57cc99;
}
</style>
</head>

<body>
	<div id="pagetop">
		<a id="wif-logo" href="/WIF/index.jsp" title="WIF 홈"
			style="text-decoration-line: none;"> <!-- 상 우 하 좌 --> <i
			class="fa-solid fa-plate-wheat fa-2x"
			style="margin: 10px 10px 0px 10px; color: #57cc99;"> What's in my
				Fridge?</i>
		</a>
		<form id="search-container" action="/WIF/search-result.jsp"
			style="display: inline;">
			<input
				style="width: 40%; height: 30px; box-sizing: border-box; margin-bottom: 10px"
				name="search-keyword" type="text" placeholder="검색창임" required>
			<input type="submit" value="검색" style="width: 60px; height: 30px;">
		</form>
		<div
			style="float: right; height: 50px; padding-top: 7px; align-items: center; margin: 0 auto; padding: 0 auto;">
			<span id="loginButton" class="styled-button"><jsp:include
					page="./login-include.jsp" /></span>
		</div>
	</div>

	<nav>
		<a href="index.jsp">홈</a> <a href="all_cuisine.jsp">요리</a> <a
			href="recipe-tab.jsp">레시피</a> <a href="my_fridge.jsp">냉장고</a>
	</nav>

	<hr>
	<script>
		document.getElementById('loginButton').addEventListener('click',
				function() {
					// 클릭 시 이동할 페이지의 URL을 설정
					var newPageURL = ''; // 여기에 이동하고 싶은 페이지의 URL을 입력하세요
					if (document.getElementById('loginNeeded') != null) {
						newPageURL = '/WIF/login-form.jsp';
					} else {
						newPageURL = '/WIF/logout.jsp';
					}

					// 새로운 페이지로 이동
					window.location.href = newPageURL;
				});
	</script>
</body>
</html>