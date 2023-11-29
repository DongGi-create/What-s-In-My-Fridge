<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<script src="https://kit.fontawesome.com/7b62cb3616.js" crossorigin="anonymous"></script>
<title>우왕</title>
</head>

<body>
	<!-- 프로젝트 properties - project facets에서 dynamic web module 3.0 체크, java 1.8 변경, runtimes에 톰캣 추가-->
	<!-- Page Top -->
	<div id="pagetop" style="border: 1px solid black;">
		<a id="wif-logo" href="/WIF/index.jsp" title="WIF 홈" style="text-decoration-line: none;">
			<!-- 상 우 하 좌 -->
			<i class="fa-solid fa-plate-wheat fa-2x" style="margin: 10px 10px 10px 10px;"> What's in my Fridge?</i>
		</a>
		<form id="search-container" action="/WIF/search-result.jsp" style="border: 1px solid black; display: inline;">
			<input name="search-keyword" type="text" placeholder="검색창임" required><input type="submit" value="검색">
		</form>
		<jsp:include page="./login-include.jsp"/>
	</div>

	<nav></nav>

	<hr>

	<div>
		<a href="/WIF/my_fridge.jsp" style="text-decoration: none;">
			<button style="padding: 10px 20px; background-color: #f0f0f0; border: 1px solid #ccc; cursor: pointer;">다른 테스트 페이지로 이동</button>
		</a>
	</div>
</body>

</html>