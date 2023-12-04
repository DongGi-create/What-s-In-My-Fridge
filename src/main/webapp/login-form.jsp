<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<script src="https://kit.fontawesome.com/7b62cb3616.js" crossorigin="anonymous"></script>
<title>WIF 로그인</title>
<style>
.login-wrapper {
	width: 400px;
	height: 350px;
	padding: 40px;
	box-sizing: border-box;
	margin: auto;
}

.login-wrapper>h2 {
	font-size: 24px;
	color: #57cc99;
	margin-bottom: 20px;
}

#login-form>input {
	width: 100%;
	height: 48px;
	padding: 0 10px;
	box-sizing: border-box;
	margin-bottom: 16px;
	border-radius: 6px;
	background-color: #F8F8F8;
}

#login-form>input::placeholder {
	color: #D2D2D2;
}

#login-form>input[type="submit"] {
	color: #fff;
	font-size: 16px;
	background-color: #57cc99;
	margin-top: 20px;
}
</style>
</head>

<body>
	<!-- 프로젝트 properties - project facets에서 dynamic web module 3.0 체크, java 1.8 변경, runtimes에 톰캣 추가-->
	<!-- Page Top -->
	<%@ include file="navigationBar.jsp" %>

	<div class="login-wrapper">
		<h2>로그인</h2>
		<form method="post" action="/WIF/login.jsp" id="login-form">
			<input type="text" name="user-id" placeholder="ID"> <input type="password" name="user-pw" placeholder="Password">
			<a href="/WIF/signup-form.jsp" style="text-decoration-line: none;">회원 가입</a>
			<input type="submit" value="Login">
		</form>
	</div>
</body>
</html>