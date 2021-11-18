<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="./style/globalStyle.css">
<style>
	#title {
		display: flex;
	    align-items: center;
	    justify-content: center;
	    font-size: 1.5em;
	    font-weight: 500;
		height: 130px;
		background: #f0f0f0;
	}
	#search {
		margin-top: 20px;
		display: flex;
		width: 300px;
	    justify-content: space-around;
	}
	#search input {
		width: 200px;
	    height: 30px;
	    padding: 7px;
	    border-radius: 4px;
	}
	#search button {
		width: 50px;
		height: 48px;
		padding: 7px;
		background: #464646;
		color: white;
		cursor: pointer;
		border-radious: 4px;
		border-radius: 4px;
	    border: none;
	}
	#search button:hover {
		background: #353535;
	}
</style>
</head>
<body>
<%@ include file="./navbar.jsp" %>
<div id="title">문의사항</div>
<div style="display:flex;justify-content: center;">
	<form method="post" action="./report.jsp" id="search">
		<input name="keyword" type="text" placeholder="검색어를 입력해주세요">
		<button type="submit">검색</button>
	</form>
</div>
<%@ include file="./report/reportList.jsp" %>
<%@ include file="./footer.jsp" %>
</body>
</html>