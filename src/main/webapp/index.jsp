<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<script src="https://kit.fontawesome.com/7b62cb3616.js" crossorigin="anonymous"></script>
<title>우왕</title>
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
</style>
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

	<nav>
	  <a href="index.jsp">홈</a>
	  <a href="all_cuisine.jsp">요리</a>
	  <a>레시피</a>
	  <a>냉장고</a>
	</nav>

	<hr>

	<div>
		<a href="/WIF/my_fridge.jsp" style="text-decoration: none;">
			<button style="padding: 10px 20px; background-color: #f0f0f0; border: 1px solid #ccc; cursor: pointer;">다른 테스트 페이지로 이동</button>
		</a>
	</div>
</body>

</html>