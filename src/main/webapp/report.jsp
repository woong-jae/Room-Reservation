<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의</title>
<link rel="icon" href="./image/favicon.png">
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
		margin-left: 50px;
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
		height: auto !important;
    	width: 55px !important;
	}
	#search button:hover {
		background: #353535;
	}
	#write {
	    position: relative;
	    left: 295px;
	    height: 30px;
	    background: #b41a1f;
	}
	#write:hover {
		background: #951418;
	}
</style>
</head>
<body>
<script type="text/javascript">
	function openModal(){
		var elems = document.getElementsByClassName("modal");
		for (var i=0;i<elems.length;i+=1){
			elems[i].style.display = 'block';
		}
	}
	function hideModalBtn(){
		document.getElementById("write").style.display = 'none';
	}
</script>
<%@ include file="./navbar.jsp" %>
<div id="title">문의사항</div>
<div style="display:flex;justify-content: center;align-items: flex-end;">
	<form method="get" action="./report.jsp" id="search">
		<input id="report-search" name="keyword" type="text" placeholder="검색어를 입력해주세요">
		<button type="submit">검색</button>
	</form>
	<button id="write" onclick="openModal();">문의</button>
	<jsp:include page="./reportWriteModal.jsp" />
</div>
<%@ include file="./reportList.jsp" %>
<%@ include file="./footer.jsp" %>
<%
	if(session.getAttribute("userid") == null) { 
		out.println("<script>hideModalBtn();</script>");
	}
%>
</body>
</html>